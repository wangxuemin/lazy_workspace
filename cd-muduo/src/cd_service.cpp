/**
 * @file cd_service.h
 * @brief implement the logic rule of dispatching coord message
 * @author LiYan
 * @version 1.0.0
 * @date 2014-11-13
 */

#include <muduo/net/EventLoop.h>
#include <muduo/net/InetAddress.h>
#include <muduo/net/TcpServer.h>

#include <boost/bind.hpp>
#include <boost/array.hpp>
#include <boost/atomic.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/algorithm/string.hpp>

#include <iostream>
#include <map>
#include <vector>
#include <utility>
#include <sstream>

#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include "didi_protocol_helper.h"
#include "didi_protocol.pb.h"
#include "didi_protocol_collectsvr.pb.h"

#include "cn_logger.h"
#include "cn_return_type.h"
#include "cd_config.h"
#include "cd_sender.h"
#include "cd_filter.h"
#include "cd_buffer.h"

#include "serverpool/serverpool_manager.h"
#include "serverpool_conhash.h"

using namespace std;
using namespace boost;
using namespace libconfig;
using namespace muduo;
using namespace muduo::net;
using namespace DidiPush;
using namespace its;
using namespace its::serverpool;
using namespace its::coord_dispatcher;

const size_t kHeaderLen = 8;
int kWarnThrottle;
pair<std::string, uint16_t> listenAddrs;
static std::string config_file_name;


class CDService
{
    public:
        CDService(EventLoop* loop, const InetAddress& listenAddr)
            : server_(loop, listenAddr, "CDService"), 
            serverpool_manager_(new ServerPool_Conhash()), 
            cd_buffer_(&serverpool_manager_, &last_sent_, &last_failed_)
        {
            cd_buffer_.StartSendingThread();
            server_.setConnectionCallback(
                    boost::bind(&CDService::onClientConnection, this, _1));
            server_.setMessageCallback(
                    boost::bind(&CDService::onClientMessage, this, _1, _2, _3));
            //reporting QPS
            loop->runEvery(1.0, boost::bind(&CDService::onTimer, this));
            //loop->runEvery(60.0, boost::bind(&CDService::onTimerMinute, this));
        }
        ~CDService(){
            //will be blocked to jion the checking thread
            serverpool_manager_.StopCheckingRoutine();
        }

        int Init(){
            //init filter
            std::string coords;
            if(!CD_Config::GetInstance().my_config_.lookupValue("filter_beijing", coords)){
                CFATAL_LOG("config file missing filter_beijing");
                return -1;
            }

            double accuracy_threshold = 0.0;
            if(!CD_Config::GetInstance().my_config_.lookupValue("accuracy_threshold", accuracy_threshold)){
                CFATAL_LOG("config file missing accuracy_threshold");
                return -1;
            }

            if(filter_.Init(coords, accuracy_threshold) != 0){
                CFATAL_LOG(" filter init failed!");
                return -1;
            }

            //init ServerPoolManager 
            int interval = 1000;//检查配置文件和服务状态的时间间隔
            if(!CD_Config::GetInstance().my_config_.lookupValue("serverlist_checking_interval", interval)){
                CFATAL_LOG("config file missing serverlist_checking_interval");
                return -1;
            }
            std::string serverpool_item_name = "serverlist";
            if(serverpool_manager_.Init(config_file_name, serverpool_item_name, interval) != 0){
                CFATAL_LOG("serverpool_manager initialization failed!");
                return -1;
            }
            //starting serverpool_notify thread
            if(serverpool_manager_.StartCheckingRoutine() != 0){
                CFATAL_LOG("starting serverpool_notify failed!");
                return -1;
            }
            return RET_OK;
        }

        void start()
        {
            server_.start();
            last_received_ = 0;
            last_sent_ = 0;
            last_failed_ = 0;
            server_count_summary_.clear();
        }

    private:
        Filter filter_;
        TcpServer server_;
        serverpool::ServerPoolManager serverpool_manager_;
        std::map<std::string, int> server_count_summary_;
        CD_Buffer cd_buffer_;
        boost::atomic_uint32_t last_received_;
        boost::atomic_uint32_t last_sent_;
        boost::atomic_uint32_t last_failed_;

        void onTimer(){
            stringstream ss;
            ss << "last second received: " << last_received_ 
               << ", sent "  << last_sent_
               << ", failed " << last_failed_ ;
            CINFO_LOG(ss.str().c_str());

            last_received_ = 0;
            last_sent_ = 0;
            last_failed_ = 0;
        }

//        void onTimerMinute(){
//            std::stringstream ss;
//            for(auto iter = server_count_summary_.begin(); iter != server_count_summary_.end(); iter++){
//                ss << iter->first << ":" << iter->second << " ";
//            }
//            CINFO_LOG("[last minute summary] %s", ss.str().c_str());
//            server_count_summary_.clear();
//        }

        void onClientConnection(const TcpConnectionPtr& conn)
        {
            LOG4CPLUS_INFO (logger, "Client " << conn->peerAddress().toIpPort() << " -> "
                << conn->localAddress().toIpPort() << " is "
                << (conn->connected() ? "UP" : "DOWN"));
        }

// full package = outer_header + header + payload
// outer_header = magic(2B)+payload_offset(2B,payload offset)+data_length(4B,full package length)
//   .magic = kMagic
//   .payload_offset = sizeof(outer_header) + sizeof(header)
//   .data_length  = sizeof(full package)
// header       = (outer_header.payload_offset - sizeof(outer_header)) bytes，see protobuf message Header
// payload      = (data_length - outer_header.payload_offset) bytes, decided by Header.type
// 协议中出现的所有user_id(eg.
// driver_id,auth_user_id,user_id)均为uint64_t，最高16位为角色标记(0: 司机,1: 乘客)，其余48位为相应角色下的唯一标识(自增id)

void onClientMessage(
        const muduo::net::TcpConnectionPtr& conn,
        muduo::net::Buffer* buf,
        muduo::Timestamp timestamp)
{
    (void) timestamp;
    muduo::Timestamp callbackStart = muduo::Timestamp::now();
    int received_count = 0;
    int valid_count = 0;

    while(true) {
        DidiPush::NetHandler tNetHandler;
        int ret = tNetHandler.CheckComplete(buf->peek(), buf->readableBytes());
        if (ret == -1) {
            CWARNING_LOG("Client %s Send illegal package",
                    conn->peerAddress().toIpPort().c_str());
            conn->forceClose();
            //uClientClose++;
            return ;
        } else if (ret == 0) {
            break;
        }
        DidiPush::Decoder tDecoder;
        DidiPush::Header tHeader;
        bool bResult = tDecoder.DecodeHeader(buf->peek(), ret, &tHeader);
        if (!bResult) {
            CWARNING_LOG("Client %s decode header failed",
                    conn->peerAddress().toIpPort().c_str());
            buf->retrieve(ret);
            continue;
        }

        if (tHeader.type() == DidiPush::kMsgTypeCollectSvrNoRspReq) {
            DidiPush::BinaryMsg tReq;
            if (!tDecoder.DecodePayload(&tReq)) {
                CWARNING_LOG("Client %s decode payload failed",
                        conn->peerAddress().toIpPort().c_str());
                buf->retrieve(ret);
                continue;
            }

            CollectSvrCoordinateReq coord_req;
            if(!coord_req.ParseFromArray(tReq.payload().c_str(), tReq.payload().length())){
                CINFO_LOG("Parsing Message Payload Error");
                buf->retrieve(ret);
                continue;
            }
            if(!coord_req.has_phone() || !coord_req.has_accuracy() || !coord_req.has_lng() || !coord_req.has_lat()){
                CINFO_LOG ("Message incomplete, some field unset!");
            }
            else {
                received_count++;
                last_received_++;
                if (filter_.IsValid(&coord_req)) {
                    cd_buffer_.AddCoord(coord_req);
                    valid_count++;
                }
            }

            buf->retrieve(ret);
            continue;
        }

        buf->retrieve(ret);
    }
    CDEBUG_LOG("Receive: %d, Forward: %d", received_count , valid_count);
    muduo::Timestamp callbackEnd = muduo::Timestamp::now();
    double handleTime = timeDifference(callbackEnd, callbackStart);

    if (handleTime * 1000 >= kWarnThrottle) {
        CWARNING_LOG("Handle collectsvrreqcount %d handletime %0.0lf ms", received_count, (handleTime * 1000));
    }
}

};//end of class CDService define

ret_t ReadConfig(const libconfig::Config& my_cfg){

    try
    {
        kWarnThrottle = my_cfg.lookup("warn_throttle");
    }
    catch (const SettingNotFoundException &nfex)
    {
        CFATAL_LOG("No 'warn_throttle' setting in Config File");
        return RET_ERROR;
    }


    Setting &root = my_cfg.getRoot();
    std::string listenAddrString;
    if (!root.lookupValue("listen", listenAddrString))
    {
        LOG4CPLUS_ERROR (logger, "No 'listen' Setting in Config File");
        return RET_ERROR;
    }
    vector<std::string> splitListen;
    split(splitListen, listenAddrString, is_any_of(":"), token_compress_on);

    listenAddrs = make_pair(splitListen[0], atoi(splitListen[1].c_str()));

    return RET_OK;
}

  
int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        cerr << "usage: " << argv[0] << " conf" << endl;
        return -1;
    }

    config_file_name = argv[1];
    CD_Config::GetInstance().Init(config_file_name);

    if(ReadConfig(CD_Config::GetInstance().my_config_) != 0){
        cerr << "config file reading failed" << endl;
        return -1;
    }
    
    //init logger
    std::string log4cplus_conf_file;
    if(!CD_Config::GetInstance().my_config_.lookupValue("log4cplus_conf", log4cplus_conf_file)){
        std::cerr << "missing log4cplus_conf" << std::endl;
        return -1;
    }
    if(init_log(log4cplus_conf_file.c_str()) != 0){
        std::cerr << "log4cplus init failed!" << std::endl;
        return -1;
    }
    LOG4CPLUS_INFO(logger, "pid = " << getpid());


    EventLoop loop;
    CDService server(&loop, InetAddress(listenAddrs.first, listenAddrs.second));
    if(server.Init() != 0){
        return -1;
    }

    server.start();

    loop.loop();
}
