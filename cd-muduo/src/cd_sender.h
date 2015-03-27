/**
 * @file cd_sender_client.h
 * @brief use thrift client of mm service to transfer data 
 * @author LiYan
 * @version 1.0.0
 * @date 2014-11-17
 */

#ifndef _CD_SENDER_H_
#define _CD_SENDER_H_

#include <boost/shared_ptr.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/noncopyable.hpp>
#include <cstdint>
#include <string>

#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>

#include "cn_return_type.h"
#include "didi_protocol.pb.h"
#include "didi_protocol_collectsvr.pb.h"
#include "MapMatcherService.h"


namespace its{
namespace coord_dispatcher{

    class Sender : boost::noncopyable
    {



        public:
            Sender(const std::string& server_name, uint16_t server_port);
            ~Sender();
            ret_t SendThriftMessage(const DidiPush::CollectSvrCoordinateReq& pb_message);
            ret_t SendThriftMessageBatch(const DidiPush::CollectSvrCoordinateReq& pb_message);
            boost::shared_ptr<apache::thrift::transport::TTransport> socket;
            boost::shared_ptr<apache::thrift::transport::TTransport> transport;
            boost::shared_ptr<apache::thrift::protocol::TProtocol> protocol;
            boost::scoped_ptr<its::service::MapMatcherServiceClient> client;
            static void ConvertCoordToTimePoint(const DidiPush::CollectSvrCoordinateReq& coor, its::service::time_point_t& tp);
            std::string server_id_;
        private:
            ret_t ConvertFromProtocolBufferToThrift(const DidiPush::CollectSvrCoordinateReq& pb_message, its::service::PointTraj2MapMatchPointRequest& thrift_message);
           
    };
} //namespace coord_dispatcher
} //namespace its
#endif /* end of include guard: _CD_SENDER_H_ */
