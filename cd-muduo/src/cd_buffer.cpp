#include "cd_buffer.h"
#include <boost/thread/lock_guard.hpp>
#include <time.h>
#include "MapMatcherService.h"
#include "cn_logger.h"
#include "serverpool_conhash.h"
namespace its{
namespace coord_dispatcher{

CD_Buffer::CD_Buffer(its::serverpool::ServerPoolManager* spm, boost::atomic_uint32_t* last_sent, boost::atomic_uint32_t* last_failed)
    : spm_(spm), last_sent_(last_sent), last_failed_(last_failed)
{
    buffer_.reserve(10000);
}

void CD_Buffer::AddCoord(const DidiPush::CollectSvrCoordinateReq& coor) {
    boost::lock_guard<boost::mutex> guard(lock_);
    buffer_.push_back(coor);
}
    
void CD_Buffer::StartSendingThread(){
    sending_thread_ = boost::thread(&CD_Buffer::Send2MM, this);
}

void CD_Buffer::Send2MM(){
    using namespace std;
    using namespace its::service;
    using namespace its::serverpool;
    using namespace apache::thrift;
    using namespace apache::thrift::transport;
    using namespace apache::thrift::protocol;


    uint64_t last_minute = 0;
    while(1){
        vector<DidiPush::CollectSvrCoordinateReq> my_buffer; 
        my_buffer.reserve(10000);
        {
            boost::lock_guard<boost::mutex> guard(lock_);
            my_buffer.swap(buffer_);
        }

        map<string, point_traj_t> map_traj;
        for(auto iter = my_buffer.begin(); iter != my_buffer.end(); iter++){
            time_point_t tp;
            Sender::ConvertCoordToTimePoint(*iter, tp);
            auto iter_map = map_traj.find(iter->phone());
            if(iter_map == map_traj.end()){
                point_traj_t traj;
                traj.user_id = iter->phone();
                traj.point_vec.push_back(tp);
                map_traj.insert(make_pair(traj.user_id, traj));
            } else {
                iter_map->second.point_vec.push_back(tp);
            }
        }

        //dispatche traj to request according to FindNode() return value
        map<Sender*, PointTraj2MapMatchPointRequest> map_requests;
        for(auto iter_map = map_traj.begin(); iter_map != map_traj.end() ;iter_map++){
            ServerPool_Conhash_Socket* my_socket = static_cast<ServerPool_Conhash_Socket*>(spm_->FindNode(iter_map->first));
            if(my_socket == NULL){
                CWARNING_LOG( "FindNode return NULL ptr, means all MM service dead!");
                continue; // finish this round
            }
            auto iter_socket = map_requests.find(my_socket->sender_);
            if(iter_socket == map_requests.end()){
                PointTraj2MapMatchPointRequest my_req;
                my_req.point_traj_vec.push_back(iter_map->second);
                map_requests.insert(make_pair(my_socket->sender_, my_req));
            } else {
                iter_socket->second.point_traj_vec.push_back(iter_map->second);
            }
        }

        //begin to send data to mm
        for(auto iter_socket = map_requests.begin(); iter_socket != map_requests.end(); iter_socket++){
            Sender* sender = iter_socket->first;
            PointTraj2MapMatchPointRequest& req = iter_socket->second;
            try{
                sender->transport->open();
                sender->client->point_traj2map_match_point_oneway(req);
                sender->transport->close();
                (*last_sent_)+=req.point_traj_vec.size();
                sent_counter_[sender->server_id_] += req.point_traj_vec.size();
            }
            catch(TException& tx) {
                CINFO_LOG( "Exception while sending message to %s:%d what: %s",
                        static_cast<TSocket*>(sender->socket.get())->getHost().c_str(), static_cast<TSocket*>(sender->socket.get())->getPort(), tx.what());
               (*last_failed_)+=req.point_traj_vec.size();
            }
        }

        time_t current_time;
        ::time(&current_time);
        uint64_t current_minute = current_time / 60;
        if(last_minute == 0){
            last_minute = current_minute;
        }

        if(last_minute == current_minute - 1){//每分钟统计
            std::stringstream ss;
            for(auto iter = sent_counter_.begin(); iter != sent_counter_.end(); iter++){
                ss << iter->first << "=[" << iter->second << "] ";
            }
            CINFO_LOG("[last minute summary] %s", ss.str().c_str());
            sent_counter_.clear();
            last_minute = current_minute;
        }

        boost::posix_time::milliseconds dura(100);
        boost::this_thread::sleep(dura);
    }
}
}
}



