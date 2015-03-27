#include "cd_sender.h"
#include <iostream>
#include <stdlib.h>
#include <time.h>
#include <cn_logger.h>
#include <sstream>

using namespace std;
using namespace apache::thrift;
using namespace apache::thrift::transport;
using namespace apache::thrift::protocol;
using namespace its;

namespace its{
namespace coord_dispatcher{


Sender::Sender(const string& server_name, uint16_t server_port)
    : socket(new TSocket(server_name, server_port)),
      transport(new TBufferedTransport(socket)),
      protocol(new TBinaryProtocol(transport)),
      client(new its::service::MapMatcherServiceClient(protocol))
{
    stringstream ss;
    ss << server_name << ":" << server_port;
    server_id_ = ss.str();
}

void Sender::ConvertCoordToTimePoint(const DidiPush::CollectSvrCoordinateReq& coor, its::service::time_point_t& tp){
    string phone_num = coor.phone();
    double lng = coor.lng();
    double lat = coor.lat();
    int32_t convert_lng = static_cast<int32_t>(lng * 100000);
    int32_t convert_lat = static_cast<int32_t>(lat * 100000);

    //use current server time as timestamp required by its::point_traj_t
    time_t current_time;
    ::time(&current_time);

    tp.x = convert_lng;
    tp.y = convert_lat;
    tp.timestamp = current_time;
}


ret_t Sender::ConvertFromProtocolBufferToThrift(const DidiPush::CollectSvrCoordinateReq& pb_message, its::service::PointTraj2MapMatchPointRequest& request){
    ::its::service::time_point_t tp;
    ConvertCoordToTimePoint(pb_message, tp);
    ::its::service::point_traj_t traj;
    //traj.user_id = ::strtoul(phone_num.c_str(), NULL, 0);
    traj.user_id = pb_message.phone();
    traj.point_vec.push_back(tp);
    
    request.point_traj_vec.push_back(traj);

    return RET_OK;
}

Sender::~Sender() {
}

ret_t Sender::SendThriftMessage(const DidiPush::CollectSvrCoordinateReq& pb_message){
    try{

        transport->open();
        its::service::PointTraj2MapMatchPointRequest request;
/*
        its::service::PointTraj2MapMatchPointResponse response;

        for (int i = 0; i < point_traj_vec.size(); i++) {
            request.point_traj_vec.push_back(its::service::point_traj_t_from_pod(point_traj_vec[i]));
        }   

        client.point_traj2map_match_point(response, request);

        for (int i = 0; i < response.map_match_point_vec.size(); i++) {
            its::map_match_point_t map_match_point = its::service::map_match_point_t_to_pod(response.map_match_point_vec[i]);
            std::cout << its::StringBuilder::build_map_match_point_string(map_match_point) << "\n";
        }   
*/

        if(ConvertFromProtocolBufferToThrift(pb_message, request) != 0){
            CINFO_LOG("ERROR: parsing pb to thrift!" );
        }
        client->point_traj2map_match_point_oneway(request);
        transport->close();

    }   
    catch(TException& tx) {
        CINFO_LOG( "Exception while sending message to %s:%d what: %s" , static_cast<TSocket*>(socket.get())->getHost().c_str(), static_cast<TSocket*>(socket.get())->getPort(), tx.what());

        transport->close();
        return RET_ERROR;
    }
    return RET_OK;
}
}
} //namespace its
