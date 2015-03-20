#include "push_connector.h"

#include <sys/types.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>

#include <netdb.h>
#include <sys/socket.h>
#include <netinet/tcp.h>

#include "crypto.h"

#include "didi_protocol_helper.h"

namespace DidiPush
{

	unsigned long long PushConnector::gullSeqID = 0llu;
	pthread_mutex_t PushConnector::gStaticMutex = PTHREAD_MUTEX_INITIALIZER;
	PushConnector* PushConnector::gPushConnectionInstance = NULL;

	enum TaskType
	{
		TaskType_CloseConnection = 1,
		TaskType_SendMessage = 2,
		TaskType_SendMessageWithoutCallback = 3,
	};

	struct Task
	{
		int iCmd;
		SendMessagePriority ePriority;
		char* sData;
		unsigned int uLength;
		unsigned long long ullSeqID;
		unsigned int uSentSize;
		Task()
		{
			iCmd = TaskType_SendMessage;
			sData = NULL;
			ePriority = SendMessagePriority_Normal;
			uLength = 0u;
			ullSeqID = 0ull;
			uSentSize = 0u;
		}
		~Task()
		{
			if (sData)
				delete []sData;
		}
	};

	PushConnector::PushConnector()
	{
		//ignore SIGPIPE
		signal(SIGPIPE, SIG_IGN);

		miSocket = -1;
		bConnected = ConnectionState_NotConnected;
		mpEvBase = event_base_new();
		memset(&mEvRead, 0, sizeof(mEvRead));
		memset(&mEvWrite, 0, sizeof(mEvWrite));
		memset(&mEvHeartBeat, 0, sizeof(mEvHeartBeat));
		mpSendMessageCallback = NULL;
		mpErrorMessageCallback = NULL;
		mpRecvMessageCallback = NULL;
		mpLogMessageCallback = NULL;

		miHeartBeatSec = 0;
		miHeartBeatRetrySec = 0;
		miHeartBeatRetryCount = 0;
		miHeartBeatHasRetryCount = 0;

		miLoop = 0;
		miRecvSize = 0;

		pthread_mutex_init(&mPipeMutex, NULL);
		socketpair(AF_UNIX, SOCK_STREAM, 0, mPipeFds);
		int n = 65536;
		setsockopt(mPipeFds[0], SOL_SOCKET, SO_RCVBUF, &n, sizeof(n));
		fcntl(mPipeFds[0], F_SETFL, O_RDWR | O_NONBLOCK);
		setsockopt(mPipeFds[1], SOL_SOCKET, SO_RCVBUF, &n, sizeof(n));
		fcntl(mPipeFds[1], F_SETFL, O_RDWR | O_NONBLOCK);
		miPipeEntryCount = 0;
		miPipeEntryHead = 0;
		miPipeEntryTail = 0;

		event_set(&mEvPipe, mPipeFds[1], EV_READ | EV_PERSIST, 
				PushConnector::PipeCallbackFunc, this);
		event_base_set(mpEvBase, &mEvPipe);
		event_add(&mEvPipe, NULL);

		miReadLastTime = 0;
		miWriteLastTime = 0;

		initCipher();
		srand(time(NULL) ^ getpid());
	}

	void PushConnector::LogMessage(const char* fmt, ...)
	{
		va_list ap;
		va_start(ap, fmt);
		if (mpLogMessageCallback)
			mpLogMessageCallback(fmt, ap);
		else
			vfprintf(stderr, fmt, ap);
		va_end(ap);
	}

	std::list<Task*>* PushConnector::GetTaskList(SendMessagePriority ePriority)
	{
		switch(ePriority) {
			case SendMessagePriority_Important:
				return &mlImportantTask;
			case SendMessagePriority_Normal:
				return &mlNormalTask;
			case SendMessagePriority_Low:
				return &mlLowTask;
			default:
				return NULL;
		}
	}

	void PushConnector::PipeCallbackFunc(int fd,
			short event,
			void* arg)
	{
		PushConnector* pushConnector = (PushConnector*) arg;
		if (!(event & EV_READ)) {
			pushConnector->LogMessage("ERR: PipeCallbackFunc wired event");
			return;
		}

		pushConnector->StatMemory(__func__);

		char buf[64];
		ssize_t size;
		bool bConnTask = false;
		bool bClose = false;
		pthread_mutex_lock(&pushConnector->mPipeMutex);
		while((size = recv(fd, buf, sizeof(buf), 0)) > 0);
		while(pushConnector->miPipeEntryCount) {
			Task* pTask = pushConnector->
				mTaskQueue[pushConnector->miPipeEntryTail++];
			pushConnector->miPipeEntryCount--;
			if (pushConnector->miPipeEntryTail 
					== DIDI_PUSH_TASK_QUEUE_LENGTH)
				pushConnector->miPipeEntryTail = 0;
			pthread_mutex_unlock(&pushConnector->mPipeMutex);

			if (pTask->iCmd == TaskType_CloseConnection) {
				pushConnector->InnerClose(PushRetCode_OK);
				delete pTask;
				bConnTask = false;
				bClose = true;
				continue;
			} 
			if (bClose) {
				pthread_mutex_lock(&pushConnector->mPipeMutex);
				delete pTask;
				continue;
			}

			pushConnector->GetTaskList(pTask->ePriority)->push_back(pTask);
			bConnTask = true;
			pthread_mutex_lock(&pushConnector->mPipeMutex);
		}
		pthread_mutex_unlock(&pushConnector->mPipeMutex);

		if (bConnTask)
			pushConnector->AddWriteEvent();

		pushConnector->StatMemory(__func__);
	}

	void PushConnector::AddWriteEvent()
	{
		event_del(&mEvWrite);
		event_set(&mEvWrite, miSocket, EV_WRITE, 
				PushConnector::OnWrite, this);
		event_base_set(mpEvBase, &mEvWrite);
		event_add(&mEvWrite, NULL);
	}

	PushConnector::~PushConnector()
	{
		if (IsConnected()) {
			close(miSocket);
			miSocket = -1;
			bConnected = ConnectionState_NotConnected;
		}
		event_del(&mEvRead);
		event_del(&mEvWrite);
		event_del(&mEvPipe);
		event_del(&mEvHeartBeat);
		close(mPipeFds[0]);
		close(mPipeFds[1]);
		event_base_free(mpEvBase);

		std::list<Task*>::iterator iter = mlImportantTask.begin();
		while(iter != mlImportantTask.end()) {
			delete *iter;
			iter++;
		}
		mlImportantTask.clear();
		iter = mlNormalTask.begin();
		while(iter != mlNormalTask.end()) {
			delete *iter;
			iter++;
		}
		mlNormalTask.clear();
		iter = mlLowTask.begin();
		while(iter != mlLowTask.end()) {
			delete *iter;
			iter++;
		}
		mlLowTask.clear();
		miLoop = 0;

		miPipeEntryCount = 0;
		miPipeEntryHead = 0;
		miPipeEntryTail = 0;

		pthread_mutex_destroy(&mPipeMutex);

		mpSendMessageCallback = NULL;
		mpErrorMessageCallback = NULL;
		mpLogMessageCallback = NULL;
		mpRecvMessageCallback = NULL;

		pthread_mutex_lock(&gStaticMutex);
		gPushConnectionInstance = NULL;
		gullSeqID = 0llu;
		pthread_mutex_unlock(&gStaticMutex);
	}

	PushConnector* PushConnector::GetInstance()
	{
		PushConnector* pInstance = NULL;
		pthread_mutex_lock(&gStaticMutex);
		if (!gPushConnectionInstance) {
			gPushConnectionInstance = new PushConnector();
		}
		pInstance = gPushConnectionInstance;
		pthread_mutex_unlock(&gStaticMutex);
		return pInstance;
	}

	void PushConnector::SetSendMessageCallbackFunc(SendMessageCallbackFunc pSendMessageCallback)
	{
		mpSendMessageCallback = pSendMessageCallback;
	}

	void PushConnector::SetErrorMessageCallbackFunc(ErrorMessageCallbackFunc pErrorMessageCallback)
	{
		mpErrorMessageCallback = pErrorMessageCallback;
	}

	void PushConnector::SetLogMessageCallbackFunc(LogMessageCallbackFunc pLogMessageCallback)
	{
		mpLogMessageCallback = pLogMessageCallback;
	}

	void PushConnector::SetRecvMessageCallbackFunc(RecvMessageCallbackFunc pRecvMessageCallback)
	{
		mpRecvMessageCallback = pRecvMessageCallback;
	}

	void PushConnector::SetHeartBeatSec(int iHeartBeatSec)
	{
		miHeartBeatSec = iHeartBeatSec;
	}

	void PushConnector::SetHeartBeatRetrySec(int iHeartBeatRetrySec)
	{
		miHeartBeatRetrySec = iHeartBeatRetrySec;
	}

	void PushConnector::SetHeartBeatRetryCount(int iHeartBeatRetryCount)
	{
		miHeartBeatRetryCount = iHeartBeatRetryCount;
	}

	void PushConnector::SetConnectTimeoutSec(int iConnectTimeoutSec)
	{
		miConnectTimeoutSec = iConnectTimeoutSec;
	}

	bool PushConnector::IsConnected()
	{
		bool ret;
		pthread_mutex_lock(&gStaticMutex);
		ret = bConnected == ConnectionState_Connected;
		pthread_mutex_unlock(&gStaticMutex);
		return ret;
	}

	bool PushConnector::IsNotConnected()
	{
		bool ret;
		pthread_mutex_lock(&gStaticMutex);
		ret = bConnected == ConnectionState_NotConnected;
		pthread_mutex_unlock(&gStaticMutex);
		return ret;
	}
	
	bool PushConnector::IsConnecting()
	{
		bool ret;
		pthread_mutex_lock(&gStaticMutex);
		ret = bConnected == ConnectionState_Connecting;
		pthread_mutex_unlock(&gStaticMutex);
		return ret;
	}

	bool PushConnector::AddTask(Task* pTask)
	{
		char buf[1] = {'z'};
		pthread_mutex_lock(&mPipeMutex);
		if (miPipeEntryCount == DIDI_PUSH_TASK_QUEUE_LENGTH) {
			pthread_mutex_unlock(&mPipeMutex);
			return false;
		}
		mTaskQueue[miPipeEntryHead++] = pTask;
		if (miPipeEntryHead == DIDI_PUSH_TASK_QUEUE_LENGTH)
			miPipeEntryHead = 0;
		miPipeEntryCount++;
		if (miPipeEntryCount == 1) {
			send(mPipeFds[0], buf, sizeof(buf), 0);
		}
		pthread_mutex_unlock(&mPipeMutex);
		return true;
	}

	PushRetCode PushConnector::Connect(const char* sIP,
			unsigned int uPort)
	{
		struct sockaddr_in svrAddr;
		memset(&svrAddr, 0, sizeof(struct sockaddr_in));
		svrAddr.sin_family = AF_INET;
		svrAddr.sin_port = htons(uPort);
		svrAddr.sin_addr.s_addr = inet_addr(sIP);
		int iRet = connect(miSocket, 
				(struct sockaddr *)&svrAddr, 
				sizeof(svrAddr));
		if (iRet && (errno != EISCONN)) {
			InnerClose(PushRetCode_ConnectFailed);
			return PushRetCode_ConnectFailed;
		}
		return PushRetCode_OK;
	}

	PushRetCode PushConnector::Login(DidiPush::Role eRole,
			const char* sPhoneNumber,
			const char* sToken,
			const char* sOsType,
			const char* sOsVer,
			const char* sModel,
			const char* sClientVer,
			const char* sNetWork,
			const bool bHasLocation,
			const CoordinateType eType,
			const double dLongitude,
			const double dLatitude,
			const char* sOperator)
	{
		ssize_t size;
		size = recv(miSocket, mRecvBuffer, sizeof(mRecvBuffer), 0);
		if (size <= 0) {
			LogMessage("ERR: Recv challenge failded, size %d sterrror %s", 
					size, strerror(errno));
			InnerClose(PushRetCode_RecvChallengeFailed);
			return PushRetCode_RecvChallengeFailed;
		}
		Header header;
		DidiPush::Decoder decoder;
		if (!decoder.DecodeHeader(mRecvBuffer, size, &header)) {
			LogMessage("ERR: Challenge decode failed");
			InnerClose(PushRetCode_ChallengeDecodeFailed);
			return PushRetCode_ChallengeDecodeFailed;
		}
		ConnSvrConnectChallenge challengeReq;
		if (!decoder.DecodePayload(&challengeReq)) {
			LogMessage("ERR: Challenge payload decode failed");
			InnerClose(PushRetCode_ChallengePayloadDecodeFailed);
			return PushRetCode_ChallengePayloadDecodeFailed;
		}

#define DIDI_PUSH_RANDOMSTR_LENGTH 256

		const std::string& sRandomMsg = challengeReq.random_msg();
		if (sRandomMsg.size() != DIDI_PUSH_RANDOMSTR_LENGTH) {
			LogMessage("ERR: Challenge random string length error");
			InnerClose(PushRetCode_InvalidRandomStringLength);
			return PushRetCode_InvalidRandomStringLength;
		}

		/* encrypted logic */

#define DIDI_PUSH_MESSAGE_BUFFER_LENGTH 1000
#define DIDI_PUSH_HASH_MAX_LENGTH 100

		unsigned char sKeyBuf[CIPHER_KEY_LEN + 1];
		unsigned char sCryptoBuf[DIDI_PUSH_MESSAGE_BUFFER_LENGTH];
		unsigned char sOrginalBuf[DIDI_PUSH_MESSAGE_BUFFER_LENGTH];
		unsigned char sHashBuf[DIDI_PUSH_HASH_MAX_LENGTH];
		int iKeyLen;
		int iCryptoLen;
		int iHashLen;

		memset(sKeyBuf, 0, sizeof(sKeyBuf));
		getKey((unsigned char*)sRandomMsg.c_str(), 
				sRandomMsg.size(), 
				sKeyBuf, 
				&iKeyLen);

		unsigned int uTokenLen = strlen(sToken);

		memcpy(sOrginalBuf, sToken, uTokenLen);
		memcpy(sOrginalBuf + uTokenLen, 
				sRandomMsg.c_str(),
				sRandomMsg.size());

		encryptData(CIPHER, 
				sKeyBuf, 
				sOrginalBuf, 
				(int)(uTokenLen + sRandomMsg.size()), 
				sCryptoBuf, &iCryptoLen);

		hashData(HASH_MD5, 
				sCryptoBuf, 
				iCryptoLen, 
				sHashBuf, 
				&iHashLen);

		/* LogMessage("token %s, randommsg %s, hashed %*s", 
		   sToken, sRandomMsg.c_str(), iHashLen, sHashBuf); */

		ConnSvrConnectReq connectReq;
		connectReq.set_phone_num(sPhoneNumber);
		connectReq.set_role(eRole);
		connectReq.set_secret_chap(sHashBuf, iHashLen);
		DidiPush::Encoder encoder(mRecvBuffer, sizeof(mRecvBuffer));
		header.set_type(DidiPush::kMsgTypeConnSvrConnectReq);

		{
			UserAgent userAgent;
			if (sOsType && *sOsType)
				userAgent.set_os_type(sOsType);
			if (sOsVer && *sOsVer)
				userAgent.set_os_ver(sOsVer);
			if (sModel && *sModel)
				userAgent.set_model(sModel);
			if (sClientVer && *sClientVer)
				userAgent.set_client_ver(sClientVer);
			if (sNetWork && *sNetWork)
				userAgent.set_network(sNetWork);
			if (bHasLocation) {
				char sTmp[64];
				snprintf(sTmp, sizeof(sTmp), "%d,%3.5lf,%3.5lf",
						eType, dLongitude, dLatitude);
				userAgent.set_location(sTmp);
			}
			if (sOperator && *sOperator) {
				userAgent.set_carrier_operator(sOperator);
			}
			unsigned char sUserAgentBuf[1024];
			if (!userAgent.SerializeToArray(sUserAgentBuf + 1,
						userAgent.ByteSize())) {
				InnerClose(PushRetCode_EncodeUserAgentFailed);
				return PushRetCode_EncodeUserAgentFailed;
			}
			if (userAgent.ByteSize()) {
				unsigned char inputKey = rand() & 0xff;
				sUserAgentBuf[0] = inputKey;
				for(int i = 0, n = userAgent.ByteSize(); i != n; i++) {
					sUserAgentBuf[i + 1] ^= inputKey;
					inputKey = sUserAgentBuf[i + 1];
				}
				connectReq.set_user_agent(sUserAgentBuf,
						userAgent.ByteSize() + 1);
			}
		}

		if (!encoder.EncodeHeader(header)) {
			LogMessage("ERR: Encode header failed");
			InnerClose(PushRetCode_EncodeHeaderFailed);
			return PushRetCode_EncodeHeaderFailed;
		}
		if (!encoder.Encode(connectReq)) {
			LogMessage("ERR: Encode connectreq failed");
			InnerClose(PushRetCode_EncodeConnectReqFailed);
			return PushRetCode_EncodeConnectReqFailed;
		}

		size = send(miSocket, encoder.Data(), encoder.DataLen(), 0);
		if (size != (ssize_t) encoder.DataLen()) {
			LogMessage("ERR: Send connectreq failed, size %d:%d, strerror %s",
					size, encoder.DataLen(), strerror(errno));
			InnerClose(PushRetCode_SendConnectReqFailed);
			return PushRetCode_SendConnectReqFailed;
		}

		size = recv(miSocket, mRecvBuffer, sizeof(mRecvBuffer), 0);
		if (size <= 0) {
			LogMessage("ERR: Recv connectrsp failded, size %d strerror %s", 
					size, strerror(errno));
			InnerClose(PushRetCode_RecvConnectRspFailed);
			return PushRetCode_RecvConnectRspFailed;
		}
		if (!decoder.DecodeHeader(mRecvBuffer, size, &header)) {
			LogMessage("ERR: Connectrsp decode failed");
			InnerClose(PushRetCode_ConnectRspDecodeFailed);
			return PushRetCode_ConnectRspDecodeFailed;
		}
		ConnSvrConnectRsp connectRsp;
		if (!decoder.DecodePayload(&connectRsp)) {
			LogMessage("ERR: Connectrsp payload decode failed");
			InnerClose(PushRetCode_ConnectRspPayloadDecodeFailed);
			return PushRetCode_ConnectRspPayloadDecodeFailed;
		}

		const DidiPush::RspMsg& rspMsg = connectRsp.rsp_msg();
		if (rspMsg.rsp_code() != 0) {
			LogMessage("ERR: Connectrsp msg %s, msgcode %d", 
					rspMsg.rsp_msg().c_str(), rspMsg.rsp_code());
			InnerClose(PushRetCode_ConnectRspMsgFailed);
			return PushRetCode_ConnectRspMsgFailed;
		}

		pthread_mutex_lock(&gStaticMutex);
		bConnected = ConnectionState_Connected;
		pthread_mutex_unlock(&gStaticMutex);

		return PushRetCode_OK;
	}

#define DIDI_PUSH_HEARTBEAT_SEC 30
#define DIDI_PUSH_HEARTBEAT_RETRY_SEC 5
#define DIDI_PUSH_HEARTBEAT_RETRY_COUNT 3
	void PushConnector::ResetHeartBeat(HeartBeatStat eStat)
	{
		switch (eStat) {
			case HeartBeatStat_Start: 
				{
					miReadLastTime = 0;
					miWriteLastTime = 0;
					miHeartBeatHasRetryCount = 0;
					event_del(&mEvHeartBeat);
					event_set(&mEvHeartBeat, -1, EV_TIMEOUT, 
							PushConnector::OnHeartBeat, this);
					event_base_set(mpEvBase, &mEvHeartBeat);
					struct timeval timeHeart;
					timeHeart.tv_sec = miHeartBeatSec ? 
						miHeartBeatSec : DIDI_PUSH_HEARTBEAT_SEC;
					timeHeart.tv_usec = 0;
					event_add(&mEvHeartBeat, &timeHeart);
					break;
				}
			case HeartBeatStat_Read:
				{
					int tNow = time(NULL);
					miReadLastTime = tNow;
					int iHeartBeatSec = miHeartBeatSec ?
						miHeartBeatSec : DIDI_PUSH_HEARTBEAT_SEC;
					if (tNow - miWriteLastTime < iHeartBeatSec) {
						miHeartBeatHasRetryCount = 0;
						event_del(&mEvHeartBeat);
						event_set(&mEvHeartBeat, -1, EV_TIMEOUT,
								PushConnector::OnHeartBeat, this);
						event_base_set(mpEvBase, &mEvHeartBeat);
						struct timeval timeHeart;
						timeHeart.tv_sec = miHeartBeatSec ?
							miHeartBeatSec : DIDI_PUSH_HEARTBEAT_SEC;
						timeHeart.tv_sec -= tNow - miWriteLastTime;
						timeHeart.tv_usec = 0;
						event_add(&mEvHeartBeat, &timeHeart);
					}
					break;
				}
			case HeartBeatStat_Write:
				{
					int tNow = time(NULL);
					miWriteLastTime = tNow;
					int iHeartBeatSec = miHeartBeatSec ?
						miHeartBeatSec : DIDI_PUSH_HEARTBEAT_SEC;
					if (tNow - miReadLastTime < iHeartBeatSec) {
						miHeartBeatHasRetryCount = 0;
						event_del(&mEvHeartBeat);
						event_set(&mEvHeartBeat, -1, EV_TIMEOUT,
								PushConnector::OnHeartBeat, this);
						event_base_set(mpEvBase, &mEvHeartBeat);
						struct timeval timeHeart;
						timeHeart.tv_sec = miHeartBeatSec ?
							miHeartBeatSec : DIDI_PUSH_HEARTBEAT_SEC;
						timeHeart.tv_sec -= tNow - miReadLastTime;
						timeHeart.tv_usec = 0;
						event_add(&mEvHeartBeat, &timeHeart);
					}
					break;
				}
			case HeartBeatStat_Retry:
				{
					miHeartBeatHasRetryCount++;
					int iHeartBeatRetryCount = miHeartBeatRetryCount ?
						miHeartBeatRetryCount : DIDI_PUSH_HEARTBEAT_RETRY_COUNT;
					if (miHeartBeatHasRetryCount > iHeartBeatRetryCount) {
						InnerClose(PushRetCode_HeartBeatFailed);
						return ;
					}
					event_del(&mEvHeartBeat);
					event_set(&mEvHeartBeat, -1, EV_TIMEOUT, 
							PushConnector::OnHeartBeat, this);
					event_base_set(mpEvBase, &mEvHeartBeat);
					struct timeval timeHeart;
					timeHeart.tv_sec = miHeartBeatRetrySec ? 
						miHeartBeatRetrySec : DIDI_PUSH_HEARTBEAT_RETRY_SEC;
					timeHeart.tv_usec = 0;
					event_add(&mEvHeartBeat, &timeHeart);
					break;
				}
		}
		// LogMessage("DBG: ResetHeartBeat");
	};

	PushRetCode PushConnector::StartConnectionByHost(const char* sHost,
			unsigned int uPort, 
			DidiPush::Role eRole,
			const char* sPhoneNumber,
			const char* sToken,
			const char* sOsType,
			const char* sOsVer,
			const char* sModel,
			const char* sClientVer,
			const char* sNetWork,
			const bool bHasLocation,
			const CoordinateType eType,
			const double dLongitude,
			const double dLatitude,
			const char* sOperator)
	{
		if (!sHost)
			return PushRetCode_InvalidHost;

		struct hostent* pHostent = gethostbyname(sHost);
		if (!pHostent)
			return PushRetCode_GetHostByNameFailed;

		char** pptr;
		switch(pHostent->h_addrtype)
		{
			case AF_INET:
				pptr = pHostent->h_addr_list;
				while(*pptr) {
					char sIP[64];
					if (inet_ntop(pHostent->h_addrtype, *pptr, sIP, sizeof(sIP))) {
						LogMessage("INFO: IP %s\n", sIP);
						return StartConnection(sIP, uPort, 
								eRole, sPhoneNumber, sToken,
								sOsType, sOsVer, sModel,
								sClientVer, sNetWork, bHasLocation,
								eType, dLongitude, dLatitude, sOperator);
					}
					pptr++;
				}
				break;
			default:
				break;
		}

		return PushRetCode_GetHostByNameNotFound;
	}

	PushRetCode PushConnector::StartConnection(const char* sIP, 
			unsigned int uPort, 
			DidiPush::Role eRole,
			const char* sPhoneNumber,
			const char* sToken,
			const char* sOsType,
			const char* sOsVer,
			const char* sModel,
			const char* sClientVer,
			const char* sNetWork,
			const bool bHasLocation,
			const CoordinateType eType,
			const double dLongitude,
			const double dLatitude,
			const char* sOperator)
	{
		if (!sIP)
			return PushRetCode_InvalidIP;

		if (!uPort)
			return PushRetCode_InvalidPort;

		if (!sPhoneNumber)
			return PushRetCode_InvalidPhoneNumber;

		if (!sToken)
			return PushRetCode_InvalidToken;

		StatMemory(__func__);

		pthread_mutex_lock(&gStaticMutex);
		if (bConnected != ConnectionState_NotConnected) {
			pthread_mutex_unlock(&gStaticMutex);
			return PushRetCode_ConnectionAlive;
		}

		miSocket = socket(AF_INET, SOCK_STREAM, 0);
		if (miSocket == -1) {
			pthread_mutex_unlock(&gStaticMutex);
			return PushRetCode_SocketCreateFailed;
		}
		bConnected = ConnectionState_Connecting;
		pthread_mutex_unlock(&gStaticMutex);

		pthread_mutex_lock(&mPipeMutex);
		miPipeEntryCount = 0;
		miPipeEntryHead = 0;
		miPipeEntryTail = 0;
		pthread_mutex_unlock(&mPipeMutex);

		PushRetCode retCode;
		retCode = Connect(sIP, uPort);
		if (retCode != PushRetCode_OK)
			return retCode;

		retCode = Login(eRole, sPhoneNumber, sToken,
				sOsType, sOsVer, sModel, sClientVer,
				sNetWork, bHasLocation, eType,
				dLongitude, dLatitude, sOperator);
		if (retCode != PushRetCode_OK)
			return retCode;

		int val = fcntl(miSocket, F_GETFL);
		val |= O_NONBLOCK;
		fcntl(miSocket, F_SETFL, val);

		miRecvSize = 0;
		event_del(&mEvRead);
		event_set(&mEvRead, miSocket, EV_READ | EV_PERSIST, 
				PushConnector::OnRead, this);
		event_base_set(mpEvBase, &mEvRead);
		event_add(&mEvRead, NULL);
		event_del(&mEvWrite);
		miLoop = 1;

		ResetHeartBeat(HeartBeatStat_Start);

		meFinalCode = retCode;

		if (mpSendMessageCallback)
			mpSendMessageCallback(PushRetCode_ConnectDone, 0llu);

		while(miLoop) {
			StatMemory(__func__);
			event_base_loop(mpEvBase, EVLOOP_ONCE);
		}

		return meFinalCode;
	}

	PushRetCode PushConnector::CloseConnection()
	{
		StatMemory(__func__);

		if (IsConnecting()) {
			pthread_mutex_lock(&gStaticMutex);
			if (miSocket != -1) {
				shutdown(miSocket, SHUT_RDWR);
				close(miSocket);
				miSocket = -1;
			}
			bConnected = ConnectionState_NotConnected;
			pthread_mutex_unlock(&gStaticMutex);
			return PushRetCode_OK;
		}

		if (IsNotConnected())
			return PushRetCode_ConnectionNotAlive;

		Task* pTask = new Task;
		pTask->iCmd = TaskType_CloseConnection;
		pTask->ePriority = SendMessagePriority_Important;
		if (!AddTask(pTask)) {
			delete pTask;
			return PushRetCode_TaskQueueFull;
		}
		return PushRetCode_OK;
	}

	unsigned long long PushConnector::GenerateSeqID()
	{
		unsigned long long ullRet;
		pthread_mutex_lock(&gStaticMutex);
		gullSeqID++;
		if (gullSeqID == 0ull)
			gullSeqID++;
		ullRet = gullSeqID;
		pthread_mutex_unlock(&gStaticMutex);
		return ullRet;
	}

#define DIDIPUSHENCODEREXTRABUFLENGTH 1024
	PushRetCode PushConnector::SendMessage(DidiPush::MsgType eType,
			const char* sData, 
			unsigned int uLength, 
			unsigned long long &ullSeqID,
			SendMessagePriority ePriority)
	{
		StatMemory(__func__);

		if (!IsConnected())
			return PushRetCode_ConnectionNotAlive;
		if (!sData)
			return PushRetCode_InvalidData;

		Task* pTask = new Task;
		pTask->iCmd = TaskType_SendMessage;
		pTask->ePriority = ePriority;
		pTask->sData = new char[uLength + DIDIPUSHENCODEREXTRABUFLENGTH];
		pTask->ullSeqID = GenerateSeqID();

		DidiPush::Encoder encoder = DidiPush::Encoder(pTask->sData,
				uLength + DIDIPUSHENCODEREXTRABUFLENGTH);

		DidiPush::Header header;
		header.set_type(eType);
		header.set_msg_id(pTask->ullSeqID);

		if (!encoder.EncodeHeader(header)) {
			delete pTask;
			return PushRetCode_EncodeError;
		}

		if (!encoder.Encode(sData, uLength)) {
			delete pTask;
			return PushRetCode_EncodeError;
		}

		pTask->uLength = encoder.DataLen();
		memmove(pTask->sData, encoder.Data(), pTask->uLength);
		ullSeqID = pTask->ullSeqID;

		if (!AddTask(pTask)) {
			delete pTask;
			return PushRetCode_TaskQueueFull;
		}

		return PushRetCode_OK;
	}

	PushRetCode PushConnector::ResponseMessage(DidiPush::MsgType eType,
			const char* sData, 
			unsigned int uLength, 
			unsigned long long ullSeqID,
			SendMessagePriority ePriority)
	{
		StatMemory(__func__);

		if (!IsConnected())
			return PushRetCode_ConnectionNotAlive;
		if (!sData)
			return PushRetCode_InvalidData;

		Task* pTask = new Task;
		pTask->iCmd = TaskType_SendMessage;
		pTask->ePriority = ePriority;
		pTask->sData = new char[uLength + DIDIPUSHENCODEREXTRABUFLENGTH];
		pTask->ullSeqID = ullSeqID;

		DidiPush::Encoder encoder = DidiPush::Encoder(pTask->sData,
				uLength + DIDIPUSHENCODEREXTRABUFLENGTH);

		DidiPush::Header header;
		header.set_type(eType);
		header.set_msg_id(pTask->ullSeqID);

		if (!encoder.EncodeHeader(header)) {
			delete pTask;
			return PushRetCode_EncodeError;
		}

		if (!encoder.Encode(sData, uLength)) {
			delete pTask;
			return PushRetCode_EncodeError;
		}

		pTask->uLength = encoder.DataLen();
		memmove(pTask->sData, encoder.Data(), pTask->uLength);

		if (!AddTask(pTask)) {
			delete pTask;
			return PushRetCode_TaskQueueFull;
		}

		return PushRetCode_OK;
	}

	void PushConnector::InnerClose(PushRetCode retCode)
	{
		StatMemory(__func__);

		event_del(&mEvRead);
		event_del(&mEvWrite);
		event_del(&mEvHeartBeat);

		pthread_mutex_lock(&gStaticMutex);
		if (miSocket != -1) {
			close(miSocket);
			miSocket = -1;
		}
		bConnected = ConnectionState_NotConnected;
		pthread_mutex_unlock(&gStaticMutex);
		std::list<Task*>::iterator iter = mlImportantTask.begin();
		while(iter != mlImportantTask.end()) {
			delete *iter;
			iter++;
		}
		mlImportantTask.clear();
		iter = mlNormalTask.begin();
		while(iter != mlNormalTask.end()) {
			delete *iter;
			iter++;
		}
		mlNormalTask.clear();
		iter = mlLowTask.begin();
		while(iter != mlLowTask.end()) {
			delete *iter;
			iter++;
		}
		mlLowTask.clear();
		miRecvSize = 0;
		miLoop = 0;

		pthread_mutex_lock(&mPipeMutex);
		miPipeEntryCount = 0;
		miPipeEntryHead = 0;
		miPipeEntryTail = 0;
		pthread_mutex_unlock(&mPipeMutex);

		meFinalCode = retCode;

		StatMemory(__func__);
	}

	/* Need to rewrite */
	void PushConnector::InnerRead()
	{
		StatMemory(__func__);

		ssize_t size;
		if (miRecvSize < DIDI_PUSH_RECV_BUFFER_LENGTH) {
			size = recv(miSocket, 
					mRecvBuffer + miRecvSize, 
					DIDI_PUSH_RECV_BUFFER_LENGTH - miRecvSize,
					0);
			if (size < 0) {
				int error = errno;
				LogMessage("WARN: recv ret %d, errstr %s", 
						size, strerror(error));
				if (error != EAGAIN && error != EWOULDBLOCK) {
					InnerClose(PushRetCode_RecvError);
					return;
				}
				StatMemory(__func__);
				return;
			} else if (size == 0) {
				InnerClose(PushRetCode_ConnectionCloseByPeer);
				return;
			} else {
				miRecvSize += size;
				ResetHeartBeat(HeartBeatStat_Read);
			}
		}

		NetHandler netHandler;
		int iLoop = 1;
		unsigned int uStart = 0u;
		while(iLoop) {
			StatMemory(__func__);
			int ret = netHandler.CheckComplete(mRecvBuffer + uStart, 
					miRecvSize - uStart);
			// LogMessage("DBG: uStart %u, miRecvSize %u, ret %d", uStart, miRecvSize, ret);
			if (ret == -1) {
				LogMessage("ERR: Bad package, clear all buffer");
				if (mpErrorMessageCallback)
					mpErrorMessageCallback(PushRetCode_BadPackage, 
							DidiPush::kMsgTypeMin, 
							0);
				miRecvSize = 0u;
				iLoop = 0;
			} else if (ret > 0) {
				Header header;
				DidiPush::Decoder decoder;
				if (!decoder.DecodeHeader(mRecvBuffer + uStart, ret, &header)) {
					LogMessage("ERR: Package decode failed, skip");
					if (mpErrorMessageCallback)
						mpErrorMessageCallback(PushRetCode_DecodeHeaderFailed, 
								DidiPush::kMsgTypeMin, 
								0);
				} else { 
					switch(header.type()) {
						case DidiPush::kMsgTypeConnSvrDisconnectReq:
							LogMessage("INFO: Svr disconnectreq");
							InnerClose(PushRetCode_ConnectionForceClose);
							return;
						case DidiPush::kMsgTypeConnSvrHeartbeatReq:
							// LogMessage("INFO: Svr Heartbeatreq");
							break;
						case DidiPush::kMsgTypeConnSvrHeartbeatRsp:
							// LogMessage("INFO: Svr Heartbeatrsp");
							break;
						case DidiPush::kMsgTypeAppHeartbeatReq:
							HeartbeatResponse(header.has_msg_id() ? header.msg_id() : 0);
							break;
						default: 
							{
								if (mpRecvMessageCallback) {
									mpRecvMessageCallback(header.type(),
											header.has_msg_id() ? header.msg_id() : 0,
											decoder.payload(),
											decoder.payload_length());
								}
								break;
							}
					}
				}
				uStart += ret;
			} else {
				iLoop = 0;
				if (uStart != miRecvSize) {
					memcpy(mRecvBuffer, 
							mRecvBuffer + uStart, 
							miRecvSize - uStart);
					miRecvSize -= uStart;
				} else {
					miRecvSize = 0;
				}
			}
		}

		if (miRecvSize == DIDI_PUSH_RECV_BUFFER_LENGTH) {
			if (mpErrorMessageCallback)
				mpErrorMessageCallback(PushRetCode_RecvBufferFull,
						DidiPush::kMsgTypeMin,
						0);
		}

		StatMemory(__func__);
	}

	void PushConnector::InnerWrite()
	{
		StatMemory(__func__);

		ssize_t size;
		while(!(mlImportantTask.empty() && mlNormalTask.empty() && mlLowTask.empty())) {
			StatMemory(__func__);
			Task* pTask;
			if (!mlImportantTask.empty()) {
				pTask = mlImportantTask.front();
				mlImportantTask.pop_front();
			} else if (!mlNormalTask.empty()) {
				pTask = mlNormalTask.front();
				mlNormalTask.pop_front();
			} else if (!mlLowTask.empty()) {
				pTask = mlLowTask.front();
				mlLowTask.pop_front();
			} else {
				continue;
			}
			size = send(miSocket,
					pTask->sData + pTask->uSentSize,
					pTask->uLength - pTask->uSentSize,
					0);
			if (size < 0) {
				int error = errno;
				LogMessage("WARN: send ret %d, errstr %s",
						size, strerror(error));
				if (error != EAGAIN && 
						error != EWOULDBLOCK) {
					InnerClose(PushRetCode_SendError);
					return;
				}
				if (pTask->uSentSize) {
					mlImportantTask.push_front(pTask);
				} else {
					switch(pTask->ePriority) {
						case SendMessagePriority_Important:
							mlImportantTask.push_front(pTask);
							break;
						case SendMessagePriority_Normal:
							mlNormalTask.push_front(pTask);
							break;
						case SendMessagePriority_Low:
							mlLowTask.push_front(pTask);
							break;
					}
				}
				return;
			}
			pTask->uSentSize += size;
			ResetHeartBeat(HeartBeatStat_Write);
			if (pTask->uSentSize == pTask->uLength) {
				if (mpSendMessageCallback && 
						pTask->iCmd == TaskType_SendMessage)
					mpSendMessageCallback(PushRetCode_SendDone, 
							pTask->ullSeqID);
				delete pTask;
			}
			else {
				mlImportantTask.push_front(pTask);
			}
		}
	}

	void PushConnector::OnRead(int fd, 
			short event, 
			void* arg)
	{
		(void) fd;
		PushConnector* pushConnector = (PushConnector*) arg;
		if (event & EV_READ)
			pushConnector->InnerRead();
		else {
			pushConnector->LogMessage(
					"ERR: weird event in OnRead %d", 
					event);
		}
	}

	void PushConnector::OnWrite(int fd, 
			short event, 
			void* arg)
	{
		(void) fd;
		PushConnector* pushConnector = (PushConnector*) arg;
		if (event & EV_WRITE)
			pushConnector->InnerWrite();
		else {
			pushConnector->LogMessage(
					"ERR: weird event in OnWrite %d", 
					event);
		}
	}

	void PushConnector::InnerHeartBeat()
	{
		char sBuf[1024];
		Task* pTask = new Task;
		pTask->iCmd = TaskType_SendMessageWithoutCallback;
		pTask->ePriority = SendMessagePriority_Important;
		pTask->ullSeqID = GenerateSeqID();

		ConnSvrHeartbeatReq heartBeatReq;
		DidiPush::Encoder encoder(sBuf, sizeof(sBuf));
		Header header;
		header.set_type(DidiPush::kMsgTypeConnSvrHeartbeatReq);
		header.set_msg_id(pTask->ullSeqID);
		if (!encoder.EncodeHeader(header)) {
			delete pTask;
			LogMessage("ERR: Encode HeartBeat header failed");
			InnerClose(PushRetCode_HeartBeatFailed);
			return;
		}
		if (!encoder.Encode(heartBeatReq)) {
			delete pTask;
			LogMessage("ERR: HeartBeat payload encode failed");
			InnerClose(PushRetCode_HeartBeatFailed);
			return;
		}

		pTask->sData = new char[encoder.DataLen()];
		pTask->uLength = encoder.DataLen();
		memmove(pTask->sData, encoder.Data(), pTask->uLength);

		if (!AddTask(pTask)) {
			delete pTask;
			LogMessage("ERR: HeartBeat add failed");
			InnerClose(PushRetCode_HeartBeatFailed);
			return;
		}
		ResetHeartBeat(HeartBeatStat_Retry);

		LogMessage("INFO: Add HeartBeat");
	}

	void PushConnector::OnHeartBeat(int fd, 
			short event, 
			void* arg)
	{
		(void) fd;
		(void) event;
		PushConnector* pushConnector = (PushConnector*) arg;
		pushConnector->InnerHeartBeat();
	}

	void PushConnector::HeartbeatResponse(unsigned long long ullSeqID)
	{
		char sBuf[1024];
		Task* pTask = new Task;
		pTask->iCmd = TaskType_SendMessageWithoutCallback;
		pTask->ePriority = SendMessagePriority_Important;
		pTask->ullSeqID = ullSeqID;

		RspMsg heartBeatRsp;
		heartBeatRsp.set_rsp_code(0);
		DidiPush::Encoder encoder(sBuf, sizeof(sBuf));
		Header header;
		header.set_type(DidiPush::kMsgTypeAppHeartbeatRsp);
		header.set_msg_id(ullSeqID);
		if (!encoder.EncodeHeader(header)) {
			delete pTask;
			LogMessage("ERR: Encode HeartBeatRsp header failed");
		}
		if (!encoder.Encode(heartBeatRsp)) {
			delete pTask;
			LogMessage("ERR: HeartBeatRsp payload encode failed");
		}

		pTask->sData = new char[encoder.DataLen()];
		pTask->uLength = encoder.DataLen();
		memmove(pTask->sData, encoder.Data(), pTask->uLength);

		if (!AddTask(pTask)) {
			delete pTask;
			LogMessage("ERR: HeartBeatRsp add failed");
		}

		LogMessage("INFO: Add HeartBeatRsp");
	}

	void PushConnector::StatMemory(const char* sFuncName)
	{
		(void) sFuncName;
		return ;

		/*
		LogMessage("sFuncName %s", sFuncName);

		pthread_mutex_lock(&mPipeMutex);
		LogMessage("mPipeFds %d %d", mPipeFds[0], mPipeFds[1]);
		LogMessage("miPipeEntryHead %d", miPipeEntryHead);
		LogMessage("miPipeEntryTail %d", miPipeEntryTail);
		LogMessage("miPipeEntryCount %d", miPipeEntryCount);
		pthread_mutex_unlock(&mPipeMutex);

		pthread_mutex_lock(&gStaticMutex);
		LogMessage("gullSeqId %llu", gullSeqID);
		LogMessage("gPushConnectionInstance %p", gPushConnectionInstance);
		LogMessage("miSocket %d", miSocket);
		LogMessage("bConnected %d", bConnected);
		pthread_mutex_unlock(&gStaticMutex);

		LogMessage("mlImportantTask.size() %lu", mlImportantTask.size());
		LogMessage("mlNormalTask.size() %lu", mlNormalTask.size());
		LogMessage("mlLowTask.size() %lu", mlLowTask.size());
		LogMessage("meFinalCode %lu", meFinalCode);

		LogMessage("miHeartBeatSec %lu", miHeartBeatSec);
		LogMessage("miHeartBeatRetrySec %lu", miHeartBeatRetrySec);
		LogMessage("miHeartBeatRetryCount %lu", miHeartBeatRetryCount);
		LogMessage("miHeartBeatHasRetryCount %lu", miHeartBeatHasRetryCount);
		LogMessage("miConnectTimeoutSec %lu", miConnectTimeoutSec);
		LogMessage("miLoop %lu", miLoop);
		LogMessage("miRecvSize %lu", miRecvSize);

		LogMessage("miReadLastTime %lu", miReadLastTime);
		LogMessage("miWriteLastTime %lu", miWriteLastTime);
		*/
	}

} /* end of namespace DidiPush */
