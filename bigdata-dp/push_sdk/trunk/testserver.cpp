#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <signal.h>
#include <unistd.h>

#include "didi_protocol_helper.h"
#include "didi_protocol_pushsvr.pb.h"
#include "didi_protocol_dispatchsvr.pb.h"

using namespace DidiPush;

int main(int argc, char** argv)
{
	(void) argc;
	(void) argv;
	signal(SIGCHLD, SIG_IGN);
	int iSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (iSocket < 0) {
		fprintf(stderr, "socket failed %d, errno %d\n", 
				iSocket, errno);
		return 0;
	}
	struct sockaddr_in servAddr, cliAddr;
	socklen_t iCliLen = sizeof(cliAddr);
	memset(&servAddr, 0, sizeof(servAddr));
	servAddr.sin_family = AF_INET;
	servAddr.sin_addr.s_addr = inet_addr(*(argv + 1));
	servAddr.sin_port = htons(atoi(*(argv + 2)));
	int option = 1;
	setsockopt(iSocket, SOL_SOCKET, SO_REUSEADDR, (const void *)&option, sizeof(option));
	bind(iSocket, (struct sockaddr *)&servAddr, sizeof(servAddr));
	listen(iSocket, 512);
	while(1) {
		int iCliFd;
		iCliFd = accept(iSocket, (struct sockaddr *)&cliAddr, &iCliLen);
		if (iCliFd < 0) {
			fprintf(stderr, "accept failed %d, errno %d\n",
					iCliFd, errno);
			return 0;
		}

		pid_t pid = fork();
		if (pid == 0)
		{

#define USERID 1
			char sBuf[10240];
			ssize_t size;
			uint64_t iMsgId = 1ull;
			Encoder encoder(sBuf, sizeof(sBuf));
			Decoder decoder;
			{
				ConnSvrConnectChallenge req;
				char sRandomStr[256];
				memset(sRandomStr, 'z', sizeof(sRandomStr));
				req.set_random_msg(sRandomStr, 256);
				Header header;
				header.set_type(kMsgTypeConnSvrConnectChallenge);
				header.set_msg_id(iMsgId++);
				encoder.EncodeHeader(header);
				encoder.Encode(req);
				size = send(iCliFd, encoder.Data(), encoder.DataLen(), 0);
				printf("send %ld\n", size);
			}
			{
				Header header;
				size = recv(iCliFd, sBuf, sizeof(sBuf), 0);
				decoder.DecodeHeader(sBuf, size, &header);
				ConnSvrConnectReq resp;
				decoder.DecodePayload(&resp);
				unsigned char sUserAgentBuf[1024];
				UserAgent userAgent;
				if (resp.has_user_agent()) {
					const std::string &sUserAgent = resp.user_agent();
					memcpy(sUserAgentBuf, sUserAgent.c_str(), sUserAgent.size());
					if (sUserAgent.size()) {
						unsigned char inputKey = sUserAgentBuf[0];
						unsigned char outputKey;
						for(int i = 1, n = sUserAgent.size(); i != n; i++) {
							outputKey = sUserAgentBuf[i];
							sUserAgentBuf[i] ^= inputKey;
							inputKey = outputKey;
						}
					}
					userAgent.ParseFromArray(sUserAgentBuf + 1, sUserAgent.size() - 1);
				}
				printf("type %d, msgid %lu, phonenum %s, role %d, secretchap %s, ostype %s, osver %s, model %s, clientver %s, network %s, location %s operator %s\n",
						header.type(), header.has_msg_id() ? header.msg_id() : 0,
						resp.phone_num().c_str(), resp.role(), resp.secret_chap().c_str(),
						userAgent.has_os_type() ? userAgent.os_type().c_str() : "",
						userAgent.has_os_ver() ? userAgent.os_ver().c_str() : "",
						userAgent.has_model() ? userAgent.model().c_str() : "",
						userAgent.has_client_ver() ? userAgent.client_ver().c_str() : "",
						userAgent.has_network() ? userAgent.network().c_str() : "",
						userAgent.has_location() ? userAgent.location().c_str() : "",
						userAgent.has_carrier_operator() ? userAgent.carrier_operator().c_str() : "");
			}
			{
				ConnSvrConnectRsp req;
				RspMsg* pRspMsg = req.mutable_rsp_msg();
				pRspMsg->set_rsp_code(0);
				pRspMsg->set_rsp_msg("OK");
				Header header;
				header.set_type(kMsgTypeConnSvrConnectRsp);
				header.set_msg_id(iMsgId++);
				encoder.EncodeHeader(header);
				encoder.Encode(req);
				size = send(iCliFd, encoder.Data(), encoder.DataLen(), 0);
				printf("send %ld\n", size);
			}
			int number = 0;
			while(number < 100) {
				size = recv(iCliFd, sBuf, sizeof(sBuf), 0);
				if (size == 0) {
					break;
				}
				Header header;
				decoder.DecodeHeader(sBuf, size, &header);
				printf("type %d, msgid %lu, ",
						header.type(), header.has_msg_id() ? header.msg_id() : 0);
				if (header.type() == kMsgTypeConnSvrHeartbeatReq) {
					ConnSvrHeartbeatReq resp;
					decoder.DecodePayload(&resp);
					printf("heartbeat\n");
				} else if (header.type() == kMsgTypeCdntSvrUpReq) {
					Coordinate resp;
					decoder.DecodePayload(&resp);
					printf("x %lf, y %lf, coordinatetype %d\n",
							resp.x(), resp.y(), resp.type());
				} else if (header.type() == kMsgTypeDispatchSvrNoRspReq) {
					BinaryMsg req;
					decoder.DecodePayload(&req);
					if (req.type() == kDispatchMessageTypeDriverOrderGetReq) {
						DriverOrderGetReq getReq;
						getReq.ParseFromArray(req.payload().data(), req.payload().size());
						const DriverOrderGetReq::LastStatus &lastStatus = getReq.laststatus();
						printf("type %d, phone %s, token %s, oid %s, down %d, play %d, cancel %d\n",
								req.type(), getReq.phone().c_str(), getReq.token().c_str(),
								lastStatus.oid().c_str(), lastStatus.down(), lastStatus.play(), 
								lastStatus.cancel());
					}
				} else {
					printf("unkown type %d\n", header.type());
				}
				number++;
				if (number == 4) {
					ConnSvrHeartbeatReq req;
					Header header;
					header.set_type(kMsgTypeConnSvrHeartbeatReq);
					header.set_msg_id(iMsgId++);
					encoder.EncodeHeader(header);
					encoder.Encode(req);
					size = send(iCliFd, encoder.Data(), encoder.DataLen(), 0);
					printf("send %ld\n", size);
				}
				/* else if (number == 7) {
					CdntSvrDownReq req;
					Header header;
					header.set_type(kMsgTypeCdntSvrDownReq);
					header.set_msg_id(iMsgId++);
					{
						PeerCoordinateInfo* pPeerCoordinateInfo = req.add_peer_coordinate_infos();
						Coordinate* pCoordinate = pPeerCoordinateInfo->mutable_coordinate();
						pCoordinate->set_x(1.0f);
						pCoordinate->set_y(1.0f);
						pCoordinate->set_type(DidiPush::BD_09);
						pPeerCoordinateInfo->set_distance(10);
						pPeerCoordinateInfo->set_wait_time(10);
						pPeerCoordinateInfo->set_local_id("aslkdjflajk");
					}
					{
						PeerCoordinateInfo* pPeerCoordinateInfo = req.add_peer_coordinate_infos();
						Coordinate* pCoordinate = pPeerCoordinateInfo->mutable_coordinate();
						pCoordinate->set_x(2.0f);
						pCoordinate->set_y(2.0f);
						pCoordinate->set_type(DidiPush::BD_09);
						pPeerCoordinateInfo->set_distance(20);
						pPeerCoordinateInfo->set_wait_time(20);
						pPeerCoordinateInfo->set_local_id("lkjlkjlkj");
					}
					encoder.EncodeHeader(header);
					encoder.Encode(req);
					size = send(iCliFd, encoder.Data(), encoder.DataLen(), 0);
					printf("send %ld\n", size);
				} else if (number == 9) {
					Header header;
					header.set_type(kMsgTypeConnSvrDisconnectReq);
					header.set_msg_id(iMsgId++);
					ConnSvrDisconnectReq req;
					encoder.EncodeHeader(header);
					encoder.Encode(req);
					size = send(iCliFd, encoder.Data(), encoder.DataLen(), 0);
					printf("send %ld\n", size);
				} else if (number == 4) {
					BinaryMsg msg;
					msg.set_type(kPushMessageTypeDriverOrderStrivedReq);
					char sBuf[10240];
					DriverOrderStrivedReq req;
					req.set_oid("asldkjfa");
					req.set_dinfo("alskjdflakj");
					req.set_msg("msg");
					req.set_showtype(DriverMessageTipShowTypeWindow);
					req.SerializeToArray(sBuf, req.ByteSize());
					msg.set_payload(sBuf, req.ByteSize());
					msg.SerializeToArray(sBuf, msg.ByteSize());
					Header header;
					header.set_type(kMsgTypeAppPushMessageReq);
					header.set_msg_id(iMsgId++);
					encoder.EncodeHeader(header);
					encoder.Encode(msg);
					size = send(iCliFd, encoder.Data(), encoder.DataLen(), 0);
					printf("send %ld\n", size);
				}
				*/
			}
			close(iCliFd);
			return 0;
		} else if (pid > 0) {
			close(iCliFd);
		} else {
			fprintf(stderr, "Fork failed\n");
		}
	}
	return 0;
}
