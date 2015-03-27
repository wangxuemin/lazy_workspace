/**
 * @file cd_buffer.h
 * @brief 用来缓存发送给mapmatcher的结果 
 * @author LiYan
 * @version 1.0.0
 * @date 2014-12-29
 */

#ifndef _ITS_CD_BUFFER_H_
#define _ITS_CD_BUFFER_H_

#include <boost/noncopyable.hpp>
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <boost/atomic.hpp>
#include <cstdint>
#include <map>
#include <vector>

#include "didi_protocol.pb.h"
#include "didi_protocol_collectsvr.pb.h"
#include "serverpool/serverpool_manager.h"
#include "cn_return_type.h"
#include "cd_sender.h"

namespace its{
namespace coord_dispatcher{
class CD_Buffer : boost::noncopyable
{
public:
    CD_Buffer(its::serverpool::ServerPoolManager* spm, boost::atomic_uint32_t* last_sent, boost::atomic_uint32_t* last_failed);
    void Send2MM();
    void AddCoord(const DidiPush::CollectSvrCoordinateReq& coor);
    void StartSendingThread();

    std::vector<DidiPush::CollectSvrCoordinateReq> buffer_; //坐标点缓冲区
    boost::mutex lock_;
    boost::thread sending_thread_;
    its::serverpool::ServerPoolManager* spm_;
    boost::atomic_uint32_t* last_sent_;
    boost::atomic_uint32_t* last_failed_;

    std::map<std::string, uint32_t> sent_counter_;

};
}
}




#endif //_ITS_CD_BUFFER_H_
