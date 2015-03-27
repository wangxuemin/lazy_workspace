/**
 * @file serverpool_conhash.h
 * @brief implement ServerPool_Conhash -- 实现conhash版本的serverpool
 * @author LiYan
 * @version 1.0.0
 * @date 2014-11-28
_*/

#ifndef _ITS_SERVERPOOL_CONHASH_H_
#define _ITS_SERVERPOOL_CONHASH_H_

#include <boost/thread/lock_guard.hpp>
#include <cstdint>
#include <map>
#include <string>
#include "libconhash/conhash.h"
#include "serverpool/serverpool.h"
#include "cd_sender.h"
#include "cn_logger.h"
#include "cn_return_type.h"

namespace its{

namespace serverpool{
class ServerPool_Conhash_Socket : public ServerPool_Socket
{
    public:
        enum ConHash_Node_Status{
            kNew,
            kNormal,
            kDisabled,
        };
        ServerPool_Conhash_Socket(const std::string& node_name, uint32_t replica);
        virtual ~ServerPool_Conhash_Socket();
        virtual bool AreYouOK();

        std::string node_name_;
        uint32_t replica_;
        ConHash_Node_Status status_;

        its::coord_dispatcher::Sender* sender_;
        node_s* node_imp_;
        ret_t Init();
};


class ServerPool_Conhash :public  ServerPool
{
    public:
        ServerPool_Conhash();
        virtual ~ServerPool_Conhash();

        virtual ret_t AddNode(const std::string& node_name);
        virtual ret_t DisableNode(const std::string& node_name);
        virtual ret_t RecoverNode(const std::string& node_name);
        virtual ret_t RemoveNode(const std::string& node_name);

        virtual ServerPool_Socket* GetNode(const std::string& node_name);
        virtual ServerPool_Socket* FindNode(const std::string& key);

    private:
        conhash_s* conhash_;
        std::map<std::string, ServerPool_Conhash_Socket*> conhash_nodes_;

        
};

} //namespace serverpool
} //namespace its

#endif /* end of include guard: _ITS_SERVERPOOL_CONHASH_H_*/
