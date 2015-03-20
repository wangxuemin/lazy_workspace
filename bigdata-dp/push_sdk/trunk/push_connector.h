#ifndef _PUSH_CONNECTOR_H_
#define _PUSH_CONNECTOR_H_

#include "didi_protocol.pb.h"
#include "event.h"
#include <pthread.h>
#include <list>
#include <stdarg.h>

namespace DidiPush
{

	enum PushRetCode
	{
		PushRetCode_OK = 0,

		/* Error */
		PushRetCode_InvalidIP = -1,						// StartConnection
		PushRetCode_InvalidPort = -2,					// StartConnection
		PushRetCode_InvalidPhoneNumber = -3,			// StartConnection
		PushRetCode_InvalidToken = -4,					// StartConnection
		PushRetCode_SocketCreateFailed = -5,			// StartConnection
		PushRetCode_ConnectFailed = -6,					// StartConnection
		PushRetCode_ConnectionAlive = -7,				// StartConnection
		PushRetCode_ConnectionNotAlive = -8,			// CloseConnection, SendMessage
		PushRetCode_TaskQueueFull = -9,					// CloseConnection, SendMessage
		PushRetCode_SendError = -10,					// StartConnection
		PushRetCode_RecvBufferFull = -11,				// ErrorMessageCallbackFunc
		PushRetCode_ConnectionCloseByPeer = -12,		// StartConnection
		PushRetCode_RecvError = -13,					// StartConnection
		PushRetCode_EncodeError = -14,					// SendMessage
		PushRetCode_RecvChallengeFailed = -15,			// StartConnection
		PushRetCode_ChallengeDecodeFailed = -16,		// StartConnection
		PushRetCode_ChallengePayloadDecodeFailed = -17,	// StartConnection
		PushRetCode_EncodeConnectReqFailed = -18,		// StartConnection
		PushRetCode_SendConnectReqFailed = -19,			// StartConnection
		PushRetCode_RecvConnectRspFailed = -20,			// StartConnection
		PushRetCode_ConnectRspDecodeFailed = -21,		// StartConnection
		PushRetCode_ConnectRspPayloadDecodeFailed = -22,// StartConnection
		PushRetCode_ConnectRspMsgFailed = -23,			// StartConnection
		PushRetCode_EncodeHeaderFailed = -24,			// StartConnection, SendMessage
		PushRetCode_BadPackage = -25,					// ErrorMessageCallbackFunc
		PushRetCode_DecodeHeaderFailed = -26,			// ErrorMessageCallbackFunc
		PushRetCode_DecodePayloadFailed = -27,			// ErrorMessageCallbackFunc
		PushRetCode_InvalidRandomStringLength = -28,	// StartConnection
		PushRetCode_InvalidData = -29,					// SendMessage
		PushRetCode_InvalidLength = -30,				// SendMessage
		PushRetCode_ConnectionForceClose = -31,			// StartConnection
		PushRetCode_InvalidHost = -32,					// StartConnection
		PushRetCode_GetHostByNameFailed = -33,			// StartConnection
		PushRetCode_GetHostByNameNotFound = -34,		// StartConnection
		PushRetCode_EncodeUserAgentFailed = -35,		// StartConnection
		PushRetCode_HeartBeatFailed = -36,				// StartConnection

		/* Done */
		PushRetCode_SendDone = 1,
		PushRetCode_RecvDone = 2,
		PushRetCode_ConnectDone = 3,
	};

	enum SendMessagePriority
	{
		SendMessagePriority_Important = 1,
		SendMessagePriority_Normal = 2,
		SendMessagePriority_Low = 3,
	};

	enum ConnectionState {
		ConnectionState_NotConnected = 1,
		ConnectionState_Connecting = 2,
		ConnectionState_Connected = 3,
	};

	enum HeartBeatStat {
		HeartBeatStat_Start = 1,
		HeartBeatStat_Read = 2,
		HeartBeatStat_Write = 3,
		HeartBeatStat_Retry = 4,
	};

	struct Task;

	typedef void (* SendMessageCallbackFunc)(PushRetCode eRetCode,
			unsigned long long ullSeqID);
	typedef void (* ErrorMessageCallbackFunc)(PushRetCode eRetCode,
			DidiPush::MsgType eType,
			unsigned long long ullSeqID);
	typedef void (* RecvMessageCallbackFunc)(DidiPush::MsgType eType,
			unsigned long long ullSeqID,
			const void* sData,
			unsigned int uLength);
	/*
	typedef void (* CdntSvrDownReqCallbackFunc)(double dX,
			double dY, 
			DidiPush::CoordinateType eType,
			unsigned int uDistance,
			unsigned int uWaitTime,
			const char* sLocalId);
			*/
	typedef void (* LogMessageCallbackFunc)(const char* fmt, va_list ap);

#define DIDI_PUSH_TASK_QUEUE_LENGTH 1024
#define DIDI_PUSH_RECV_BUFFER_LENGTH 1024 * 128

	class PushConnector
	{
		public:
			PushConnector();
			~PushConnector();

			/* 
			 * This is a one-instance class,
			 * must use GetInstance to get the instance.
			 * @return the instance of PushConnector
			 */
			static PushConnector* GetInstance();

			/*
			 * Start long connection to connsvr
			 * @param sIP the IP of connsvr
			 * @param uPort the port of connsvr
			 * @param sToken the token of mobile
			 * @param sOsType optional parameter, the type of operation of mobile
			 * @param sOsVer optional parameter, the version of operation of mobile
			 * @param sModel optional parameter, the description of mobile
			 * @param sClientVer optional parameter, the version of app
			 * @param sNetwork optional parameter, the type of network
			 * @param bHasLocation optional parameter, whether has location information
			 * @param eType optional parameter, the type of coordinate
			 * @param dLongitude optional parameter, the longitude of coordinate
			 * @param dLatitude optional parameter, the latitude of coordinate
			 * @param sOperator optional parameter, the operator of network, mobile or telecom or unicom
			 * @return error number or ok of connection
			 *
			 * @hint this function will do infinate loop, until CloseConnection 
			 * or network error, should use an empty thread to run.
			 */
			PushRetCode StartConnection(const char* sIP, 
					unsigned int uPort, 
					DidiPush::Role eRole,
					const char* sPhoneNumber,
					const char* sToken,
					const char* sOsType = NULL,
					const char* sOsVer = NULL,
					const char* sModel = NULL,
					const char* sClientVer = NULL,
					const char* sNetWork = NULL,
					const bool bHasLocation = false,
					const CoordinateType eType = BD_09,
					const double dLongitude = 0.0f,
					const double dLatitude = 0.0f,
					const char* sOperator = NULL);

			/*
			 * Start long connection to connsvr using host
			 * @param sHost the host of connsvr
			 * @param uPort the port of connsvr
			 * @param sToken the token of mobile
			 * @param sOsType optional parameter, the type of operation of mobile
			 * @param sOsVer optional parameter, the version of operation of mobile
			 * @param sModel optional parameter, the description of mobile
			 * @param sClientVer optional parameter, the version of app
			 * @param sNetwork optional parameter, the type of network
			 * @param bHasLocation optional parameter, whether has location information
			 * @param eType optional parameter, the type of coordinate
			 * @param dLongitude optional parameter, the longitude of coordinate
			 * @param dLatitude optional parameter, the latitude of coordinate
			 * @param sOperator optional parameter, the operator of network, mobile or telecom or unicom
			 * @return error number or ok of connection
			 *
			 * @hint this function will do infinate loop, until CloseConnection 
			 * or network error, should use an empty thread to run.
			 */
			PushRetCode StartConnectionByHost(const char* sHost,
					unsigned int uPort, 
					DidiPush::Role eRole,
					const char* sPhoneNumber,
					const char* sToken,
					const char* sOsType = NULL,
					const char* sOsVer = NULL,
					const char* sModel = NULL,
					const char* sClientVer = NULL,
					const char* sNetWork = NULL,
					const bool bHasLocation = false,
					const CoordinateType eType = BD_09,
					const double dLongitude = 0.0f,
					const double dLatitude = 0.0f,
					const char* sOperator = NULL);
			
			/*
			 * Close long connection
			 * @return whether adding close task is done
			 *
			 * @hint this function can be invoked in any thread.
			 */
			PushRetCode CloseConnection();

			/*
			 * Send message in long connection
			 * @param eType the type of message, defined in didi_protocol.proto
			 * @param sData the data of message, serialized by protobuf
			 * @param uLength the length of message
			 * @param ullSeqID return value of message id, if the message needed to be response,
			 * using this value as key to search for corresponding request.
			 * @param ePriority the priority of message
			 * @return whether adding sending message task is done
			 *
			 * @hint this function can be invoked in any thread.
			 */
			PushRetCode SendMessage(DidiPush::MsgType eType, 
					const char* sData, 
					unsigned int uLength,
					unsigned long long &ullSeqID,
					SendMessagePriority ePriority = SendMessagePriority_Normal);

			/*
			 * Response message in long connection
			 * @param eType the type of message, defined in didi_protocol.proto
			 * @param sData the data of message, serialized by protobuf
			 * @param uLength the length of message
			 * @param ullSeqID the id of message, equals to the request message
			 * @param ePriority the priority of message
			 * @return whether adding responsing message task is done
			 *
			 * @hint this function can be invoked in any thread.
			 */
			PushRetCode ResponseMessage(DidiPush::MsgType eType, 
					const char* sData, 
					unsigned int uLength,
					unsigned long long ullSeqID,
					SendMessagePriority ePriority = SendMessagePriority_Normal);

			/*
			 * Set callback function of send message done, connection done
			 * @pSendMessageCallback the callback function
			 * @hint implemention of this function should not be block
			 */
			void SetSendMessageCallbackFunc(SendMessageCallbackFunc pSendMessageCallback);

			/*
			 * Set callback function of error message
			 * @pErrorMessageCallback the callback function
			 * @hint implemention of this function should not be block
			 */
			void SetErrorMessageCallbackFunc(ErrorMessageCallbackFunc pErrorMessageCallback);

			/*
			 * Set callback function of log
			 * @pLogMessageCallback the callback function
			 * @hint implemention of this function should not be block
			 */
			void SetLogMessageCallbackFunc(LogMessageCallbackFunc pLogMessageCallback);

			/*
			 * Set callback function of recved message
			 * This function is very important because it is only entry to get the server data
			 * @pRecvMessageCallback the callback function
			 * @hint implemention of this function should not be block
			 */
			void SetRecvMessageCallbackFunc(RecvMessageCallbackFunc pRecvMessageCallback);

			/*
			 * Set the time interval of heartbeat
			 * @param iHeartBeatSec the seconds of time interval
			 */
			void SetHeartBeatSec(int iHeartBeatSec);
			
			/*
			 * Set the time interval of retry heartbeat
			 * @param iHeartBeatRetrySec the seconds of time interval
			 */
			void SetHeartBeatRetrySec(int iHeartBeatRetrySec);

			/*
			 * Set the count of retry heartbeat
			 * @param iHeartBeatRetryCount the count of retry
			 */
			void SetHeartBeatRetryCount(int iHeartBeatRetryCount);

			/*
			 * Check whether the long connection is connected
			 * @return the status of long connection
			 */
			bool IsConnected();

			/*
			 * Check whether the long connection is not connected
			 * @return the status of long connection
			 */
			bool IsNotConnected();

			/*
			 * Check whether the long connection is connecting
			 * @return the status of long connection
			 */
			bool IsConnecting();

			void SetConnectTimeoutSec(int iConnectTimeoutSec);

		public:
			/* msgqueue param */
			event mEvPipe;
			Task* mTaskQueue[DIDI_PUSH_TASK_QUEUE_LENGTH];
			int mPipeFds[2];
			pthread_mutex_t mPipeMutex;
			int miPipeEntryHead;
			int miPipeEntryTail;
			int miPipeEntryCount;

			std::list<Task*>* GetTaskList(SendMessagePriority ePriority);

			void AddWriteEvent();
			void InnerRead();
			void InnerWrite();
			void InnerHeartBeat();

			static void PipeCallbackFunc(int fd,
					short event,
					void* arg);

			static void OnRead(int fd, 
					short event, 
					void* arg);

			static void OnWrite(int fd, 
					short event, 
					void* arg);

			static void OnHeartBeat(int fd, 
					short event, 
					void* arg);

			void LogMessage(const char* fmt, ...);

			void StatMemory(const char* sFuncName);

			void ResetHeartBeat(HeartBeatStat eStat);

		private:

			static unsigned long long gullSeqID;
			static pthread_mutex_t gStaticMutex;
			static PushConnector* gPushConnectionInstance;

			int miSocket;
			ConnectionState bConnected;

			/* Callback param */
			SendMessageCallbackFunc mpSendMessageCallback;
			ErrorMessageCallbackFunc mpErrorMessageCallback;
			// CdntSvrDownReqCallbackFunc mpCdntSvrDownReqCallback;
			RecvMessageCallbackFunc mpRecvMessageCallback;
			LogMessageCallbackFunc mpLogMessageCallback;

			/* SendTask List param */
			std::list<Task*> mlImportantTask;
			std::list<Task*> mlNormalTask;
			std::list<Task*> mlLowTask;

			PushRetCode meFinalCode;

			/* Event param */
			event_base *mpEvBase;
			event mEvRead;
			event mEvWrite;
			event mEvHeartBeat;

			/* Other param */
			int miHeartBeatSec;
			int miHeartBeatRetrySec;
			int miHeartBeatRetryCount;
			int miHeartBeatHasRetryCount;

			int miConnectTimeoutSec;
			int miLoop;
			char mRecvBuffer[DIDI_PUSH_RECV_BUFFER_LENGTH];
			unsigned int miRecvSize;

			int miReadLastTime;
			int miWriteLastTime;

			bool AddTask(Task* pTask);

			PushRetCode Connect(const char* sIP,
					unsigned int uPort);
			PushRetCode Login(DidiPush::Role eRole,
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
					const char* sOperator);
			void InnerClose(PushRetCode retCode);
			static unsigned long long GenerateSeqID();
			void HeartbeatResponse(unsigned long long ullSeqID);

	};

} /* end of namespace DidiPush */

#endif /* _PUSH_CONNECTOR_H_ */
