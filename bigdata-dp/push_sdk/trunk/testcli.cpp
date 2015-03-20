#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>
#include <unistd.h>

#include "push_connector.h"
#include "didi_protocol_pushsvr.pb.h"
#include "didi_protocol_dispatchsvr.pb.h"
#include "didi_protocol_collectsvr.pb.h"

char* host;
int port;
int role;
char* phone;
char* token;
unsigned long long gullSeqID;
double x;
double y;
int doRsp;

void* loop(void * arg)
{
	// sleep(4);
	DidiPush::PushConnector* pushConnector = (DidiPush::PushConnector*) arg;
	DidiPush::PushRetCode ret = pushConnector->StartConnectionByHost(
			host, port, role == 0 ? DidiPush::Driver : DidiPush::Passenger,
			phone, token, "", NULL, "", NULL,
			"WCDMA", false, DidiPush::GCJ_02, 1.0, 2.1, "mobile");

	printf("start ret %d\n", ret);

	return NULL;
}

void* sendresponse(void *arg)
{
	sleep(5);
	DidiPush::PushConnector* pushConnector = 
		DidiPush::PushConnector::GetInstance();
	int* type = (int*) arg;
	char sBuf[1024];
	int byteSize = 0;
	{
		DidiPush::BinaryMsg msg1;
		msg1.set_type(*type);
		msg1.SerializeToArray(sBuf, msg1.ByteSize());
		byteSize = msg1.ByteSize();
	}
	DidiPush::PushRetCode ret = pushConnector->ResponseMessage(
			DidiPush::kMsgTypeAppPushMessageRsp,
			sBuf, byteSize, gullSeqID);
	printf("responcemessage seqid %llu, ret %d\n", gullSeqID, ret);

	return NULL;
}
void sendcallback(DidiPush::PushRetCode ret, unsigned long long msgid)
{
	printf("sendcallback ret %d, msgid %llu\n", ret, msgid);
}

void errorcallback(DidiPush::PushRetCode ret, DidiPush::MsgType type, unsigned long long msgid)
{
	printf("errorcallback ret %d, type %d msgid %llu\n", ret, type, msgid);
}

void recvmessagecallback(DidiPush::MsgType eType, unsigned long long ullSeqID,
		const void* sData, unsigned int uLength)
{
	printf("recvmessagecallback\n");
	if (eType == DidiPush::kMsgTypeCdntSvrDownReq) {
		DidiPush::CdntSvrDownReq req;
		req.ParseFromArray(sData, uLength);
		printf("type %d, msgid %llu, length %u\n", eType, ullSeqID, uLength);
		for(int i = 0, n = req.peer_coordinate_infos_size(); i != n; i++) {
			const DidiPush::PeerCoordinateInfo& info = req.peer_coordinate_infos(i);
			const DidiPush::Coordinate& coordinate = info.coordinate();
			printf("localid %s, x %lf, y %lf, cotype %d, distance %u, waittime %u isarrived %d\n",
					info.local_id().c_str(), 
					coordinate.x(),
					coordinate.y(),
					coordinate.type(),
					info.distance(),
					info.wait_time(),
					info.has_is_arrived_limited() ? info.is_arrived_limited() : 2);
		}
	} else if (eType == DidiPush::kMsgTypeAppPushMessageReq) {
		DidiPush::PushMsg msg;
		msg.ParseFromArray(sData, uLength);
		bool bKnownType = true;
		switch (msg.type()) {
			case DidiPush::kPushMessageTypeDriverOrderComingReq:
				{
					DidiPush::DriverOrderComingReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, oid %s, key %s, "
							"type %d, input %d, createtime %d, setuptime %d, "
							"distance %s, from %s, to %s, "
							"fromLat %lf, fromLng %lf, toLat %lf, toLng %lf, "
							"tip %d, bonus %d, twait %d, twaitmax %d, "
							"exp %d, playtxt %s, timestamp %d, "
							"voicesize %d, audiourl %s, phone %s, "
							"disabletime %d %d, fromAddr1 %d %s, "
							"fromAddr2 %d %s, toAddr1 %d %s, toAddr2 %d %s\n"
							"extrainfo %d %s",
							msg.type(), req.oid().c_str(), req.key().c_str(),
							req.type(), req.input(), req.createtime(), req.setuptime(),
							req.distance().c_str(), req.from().c_str(), req.to().c_str(),
							req.fromlat(), req.fromlng(), req.tolat(), req.tolng(),
							req.tip(), req.bonus(), req.twait(), req.twaitmax(),
							req.exp(), req.playtxt().c_str(), req.timestamp(),
							req.voicesize(), req.audiourl().c_str(), req.phone().c_str(),
							req.has_disabletime(), req.has_disabletime() ? req.disabletime() : 0,
							req.has_fromaddr1(), req.has_fromaddr1() ? req.fromaddr1().c_str() : "",
							req.has_fromaddr2(), req.has_fromaddr2() ? req.fromaddr2().c_str() : "",
							req.has_toaddr1(), req.has_toaddr1() ? req.toaddr1().c_str() : "",
							req.has_toaddr2(), req.has_toaddr2() ? req.toaddr2().c_str() : "",
							req.has_extrainfo(), req.has_extrainfo() ? req.extrainfo().c_str() : "");
					break;
				}
			case DidiPush::kPushMessageTypeDriverOrderCancelledReq:
				{
					DidiPush::DriverOrderCancelledReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, oid %s, msg %s, showtype %d\n",
							msg.type(), req.oid().c_str(),
							req.msg().c_str(), req.showtype());
					break;
				}
			case DidiPush::kPushMessageTypeDriverOrderChangeTipReq:
				{
					DidiPush::DriverOrderChangeTipReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, oid %s, tip %d, showtype %d\n",
							msg.type(), req.oid().c_str(),
							req.tip(), req.showtype());
					break;
				}
			case DidiPush::kPushMessageTypeDriverMsgBroadcastReq:
				{
					DidiPush::DriverMsgBroadcastReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, pos_type %d, show_type %d, title %s, text %s, pushtime %d, expiretime %d, voiceurl %s, portaltype %d, portalurl %s\n",
							msg.type(), req.postype(), req.showtype(), req.title().c_str(),
							req.text().c_str(), req.pushtime(), req.expiretime(), 
							req.voiceurl().c_str(), req.portaltype(), req.portalurl().c_str());
					break;
				}
			case DidiPush::kPushMessageTypeDriverUploadLogReq:
				{
					DidiPush::DriverUploadLogReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, upload %d, logenable %d\n",
							msg.type(), req.upload(), req.logenable());
					break;
				}
			case DidiPush::kPushMessageTypeDriverTraceLogReq:
				{
					DidiPush::DriverTraceLogReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, tracelogenable %d\n",
							msg.type(), req.tracelogenable());
					break;
				}
			case DidiPush::kPushMessageTypeDriverMonitorInfoReq:
				{
					DidiPush::DriverMonitorInfoReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, info %s\n",
							msg.type(), req.info().c_str());
					break;
				}
			case DidiPush::kPushMessageTypeDriverCoordinateUploadReq:
				{
					DidiPush::DriverCoordinateUploadReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, type %d\n",
							msg.type(), req.type());
					break;
				}
			case DidiPush::kPushMessageTypeDriverAppCheckReq:
				{
					DidiPush::DriverAppCheckReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d\n", msg.type());
					break;
				}
			case DidiPush::kPushMessageTypeDriverOrderStrivedReq: 
				{
					DidiPush::DriverOrderStrivedReq req;
					req.ParseFromArray(msg.payload().data(), msg.payload().size());
					printf("innertype %d, oid %s, dinfo %s, msg %s, showtype %d\n",
							msg.type(), req.oid().c_str(), req.dinfo().c_str(),
							req.msg().c_str(), req.showtype());
					break;
				}
			default:
				{
					printf("unknown innertype %d\n", msg.type());
					bKnownType = false;
					break;
				}
		}
		if (bKnownType && doRsp) {
			char sBuf[1024];
			DidiPush::BinaryMsg responseMsg;
			responseMsg.set_type(msg.type());
			responseMsg.SerializeToArray(sBuf, responseMsg.ByteSize());

			DidiPush::PushConnector* pushConnector =
				DidiPush::PushConnector::GetInstance();
			pushConnector->ResponseMessage(
					DidiPush::kMsgTypeAppPushMessageRsp,
					sBuf,
					responseMsg.ByteSize(),
					ullSeqID);
		}
		/*
		DidiPush::PushConnector* pushConnector =
			DidiPush::PushConnector::GetInstance();
		pushConnector->CloseConnection();
		pthread_t pid, pid1;
		pthread_create(&pid, NULL, loop, pushConnector);
		gullSeqID = ullSeqID;
		int* ptype = new int;
		*ptype = msg.type();
		pthread_create(&pid1, NULL, sendresponse, ptype);
		*/
	} else {
		printf("unknown type %d, msgid %llu, length %u\n", eType, ullSeqID, uLength);
	}
}

void print(const char* fmt, va_list ap)
{
	vprintf(fmt, ap);
	printf("\n");
}

void usage(const char* program)
{
	printf("USAGE: %s host port role phone token x y dorsp\n", program);
}

int main(int argc, char** argv)
{
	if (argc != 9) {
		usage(*argv);
		return 0;
	}
	host = *(argv + 1);
	port = atoi(*(argv + 2));
	role = atoi(*(argv + 3));
	phone = *(argv + 4);
	token = *(argv + 5);
	x = strtod(*(argv + 6), NULL);
	y = strtod(*(argv + 7), NULL);
	doRsp = atoi(*(argv + 8));
	DidiPush::PushConnector* pushConnector = 
		DidiPush::PushConnector::GetInstance();
	pushConnector->SetSendMessageCallbackFunc(sendcallback);
	pushConnector->SetErrorMessageCallbackFunc(errorcallback);
	pushConnector->SetLogMessageCallbackFunc(print);
	pushConnector->SetRecvMessageCallbackFunc(recvmessagecallback);
	pushConnector->SetHeartBeatSec(13);
	pushConnector->SetHeartBeatRetryCount(1);
	pushConnector->SetHeartBeatRetrySec(3);
	// pushConnector->SetHeartBeatSec(30);
	// pushConnector->SetHeartBeatRetryCount(3);
	// pushConnector->SetHeartBeatRetrySec(5);

	pthread_t pid;
	pthread_create(&pid, NULL, loop, pushConnector);

	{
		sleep(4);

		int num = 0;
		while(num++ < 10000) {
			unsigned long long msgid = 0llu;
			DidiPush::CdntSvrUpReq req;
			req.set_x(x);
			req.set_y(y);
			req.set_type(DidiPush::GCJ_02);
			req.set_pull_peer(true);
			char sBuf[1024];
			req.SerializeToArray(sBuf, req.ByteSize());
			DidiPush::PushRetCode ret = pushConnector->SendMessage(DidiPush::kMsgTypeCdntSvrUpReq,
					sBuf,
					req.ByteSize(),
					msgid);
			printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
			/*
			printf("num %d\n", num);
			switch (num % 3) {
				case 0:
					{
						if (role != 0 || num % 6 == 0) {
							DidiPush::CdntSvrUpReq req;
							req.set_x(116.599556);
							req.set_y(40.0855);
							req.set_type(DidiPush::BD_09);
							req.set_pull_peer(true);
							char sBuf[1024];
							req.SerializeToArray(sBuf, req.ByteSize());
							DidiPush::PushRetCode ret = pushConnector->SendMessage(DidiPush::kMsgTypeCdntSvrUpReq,
									sBuf,
									req.ByteSize(),
									msgid);
							printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
							break;
						} else {
							DidiPush::CollectSvrCoordinateReq req;
							req.set_phone("12345");
							req.set_lng(1.0);
							req.set_lat(2.0);
							req.set_type(DidiPush::GCJ_02);
							req.set_accuracy(3.0);
							req.set_direction(4.0);
							req.set_speed(5.0);
							req.set_acceleratedspeedx(6.0);
							req.set_acceleratedspeedy(7.0);
							req.set_acceleratedspeedz(8.0);
							req.set_includedangleyaw(9.0);
							req.set_includedangleroll(10.0);
							req.set_includedanglepitch(11.0);
							req.set_pull_peer(true);
							char sBuf[1024];
							req.SerializeToArray(sBuf, req.ByteSize());
							DidiPush::BinaryMsg binaryMsg;
							binaryMsg.set_type(DidiPush::kCollectSvrMessageTypeCollectSvrCoordinateReq);
							binaryMsg.set_payload(sBuf, req.ByteSize());
							binaryMsg.SerializeToArray(sBuf, binaryMsg.ByteSize());
							DidiPush::PushRetCode ret = pushConnector->SendMessage(
									DidiPush::kMsgTypeCollectSvrNoRspReq,
									sBuf,
									binaryMsg.ByteSize(),
									msgid);
							printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
							break;
						}
					}
				case 1:
					{
						if (role != 0 || num % 6 == 1) {
							DidiPush::CdntSvrUpReq req;
							req.set_x(116.599556);
							req.set_y(40.0855);
							req.set_type(DidiPush::BD_09);
							req.set_pull_peer(false);
							char sBuf[1024];
							req.SerializeToArray(sBuf, req.ByteSize());
							DidiPush::PushRetCode ret = pushConnector->SendMessage(DidiPush::kMsgTypeCdntSvrUpReq,
									sBuf,
									req.ByteSize(),
									msgid);
							printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
							break;
						} else {
							DidiPush::CollectSvrCoordinateReq req;
							req.set_phone("12345");
							req.set_lng(1.0);
							req.set_lat(2.0);
							req.set_type(DidiPush::GCJ_02);
							req.set_accuracy(3.0);
							req.set_direction(4.0);
							req.set_speed(5.0);
							req.set_acceleratedspeedx(6.0);
							req.set_acceleratedspeedy(7.0);
							req.set_acceleratedspeedz(8.0);
							req.set_includedangleyaw(9.0);
							req.set_includedangleroll(10.0);
							req.set_includedanglepitch(11.0);
							req.set_pull_peer(false);
							char sBuf[1024];
							req.SerializeToArray(sBuf, req.ByteSize());
							DidiPush::BinaryMsg binaryMsg;
							binaryMsg.set_type(DidiPush::kCollectSvrMessageTypeCollectSvrCoordinateReq);
							binaryMsg.set_payload(sBuf, req.ByteSize());
							binaryMsg.SerializeToArray(sBuf, binaryMsg.ByteSize());
							DidiPush::PushRetCode ret = pushConnector->SendMessage(
									DidiPush::kMsgTypeCollectSvrNoRspReq,
									sBuf,
									binaryMsg.ByteSize(),
									msgid);
							printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
							break;
						}
					}
				case 2:
					{
						if (role != 0 || num % 6 == 2) {
							DidiPush::CdntSvrUpReq req;
							req.set_x(116.599556);
							req.set_y(40.0855);
							req.set_type(DidiPush::BD_09);
							char sBuf[1024];
							req.SerializeToArray(sBuf, req.ByteSize());
							DidiPush::PushRetCode ret = pushConnector->SendMessage(DidiPush::kMsgTypeCdntSvrUpReq,
									sBuf,
									req.ByteSize(),
									msgid);
							printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
							break;
						} else {
							DidiPush::CollectSvrCoordinateReq req;
							req.set_phone("12345");
							req.set_lng(1.0);
							req.set_lat(2.0);
							req.set_type(DidiPush::GCJ_02);
							req.set_accuracy(3.0);
							req.set_direction(4.0);
							req.set_speed(5.0);
							req.set_acceleratedspeedx(6.0);
							req.set_acceleratedspeedy(7.0);
							req.set_acceleratedspeedz(8.0);
							req.set_includedangleyaw(9.0);
							req.set_includedangleroll(10.0);
							req.set_includedanglepitch(11.0);
							char sBuf[1024];
							req.SerializeToArray(sBuf, req.ByteSize());
							DidiPush::BinaryMsg binaryMsg;
							binaryMsg.set_type(DidiPush::kCollectSvrMessageTypeCollectSvrCoordinateReq);
							binaryMsg.set_payload(sBuf, req.ByteSize());
							binaryMsg.SerializeToArray(sBuf, binaryMsg.ByteSize());
							DidiPush::PushRetCode ret = pushConnector->SendMessage(
									DidiPush::kMsgTypeCollectSvrNoRspReq,
									sBuf,
									binaryMsg.ByteSize(),
									msgid);
							printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
							break;
						}
					}
			}
		*/
			/*else if (num == 4) {
				DidiPush::PushRetCode ret = pushConnector->CloseConnection();
				printf("CloseConnection ret %d\n", ret);
				} */ /* else if (num == 2) {
						DidiPush::BinaryMsg msg;
						msg.set_type(DidiPush::kDispatchMessageTypeDriverOrderGetReq);
						char sBuf[10240];
						DidiPush::DriverOrderGetReq req;
						req.set_phone("12345678901");
						req.set_token("abcdefghijk");
						DidiPush::DriverOrderGetReq::LastStatus* pLastStatus = req.mutable_laststatus();
						pLastStatus->set_oid("hijklmn");
						pLastStatus->set_down(1);
						pLastStatus->set_play(0);
						pLastStatus->set_cancel(1);
						req.SerializeToArray(sBuf, req.ByteSize());
						msg.set_payload(sBuf, req.ByteSize());
						msg.SerializeToArray(sBuf, msg.ByteSize());
						DidiPush::PushRetCode ret = pushConnector->SendMessage(DidiPush::kMsgTypeDispatchSvrNoRspReq,
						sBuf,
						msg.ByteSize(),
						msgid);
						printf("svrupreq ret %d, msgid %llu\n", ret, msgid);
						} */

			sleep(4);
		}
	}

	void* pRet;
	pthread_join(pid, &pRet);

	delete pushConnector;

	printf("End\n");
	return 0;
}
