#include "serverpool_conhash.h"
#include <iostream>
#include <string>
#include <time.h>     
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>
#include <thrift/transport/TTransportException.h>
#include "cd_config.h"

using namespace std;
using namespace apache::thrift;
using namespace apache::thrift::transport;

namespace its{
namespace serverpool{

ServerPool_Conhash_Socket::ServerPool_Conhash_Socket(const string& node_name, uint32_t replica)
    : node_name_(node_name), replica_(replica), status_(kNew), sender_(NULL), node_imp_(NULL)
{
}

ServerPool_Conhash_Socket::~ServerPool_Conhash_Socket(){
    if(sender_ != NULL){
        delete sender_;
        sender_ = NULL;
    }
    if(node_imp_ != NULL){
        delete node_imp_;
        node_imp_ = NULL;
    }
}

bool ServerPool_Conhash_Socket::AreYouOK(){
    its::coord_dispatcher::Sender sender((static_cast<TSocket*>(sender_->socket.get()))->getHost(), (static_cast<TSocket*>(sender_->socket.get()))->getPort());

    time_t now;
    ::time(&now);
    its::service::ServerKeepAliveRequest request;
    request.timestamp = now;

    try{
        sender.transport->open();
        //current server time
        its::service::ServerKeepAliveResponse response;
        sender.client->check_alive(response, request);
        if(response.ret_code != 0){
            CINFO_LOG("check_alive of %s ret code indicating error! ret message: %s", this->node_name_.c_str(), response.ret_msg.c_str());
            return false;
        }
        sender.transport->close();
    }   
    catch(TTransportException& tx){
        //std::string what_message(tx.what());
        //if(what_message.find("No more data to read") != string::npos||
        //   what_message.find("THRIFT_ECONNRESET") != string::npos||
        //   what_message.find("THRIFT_EAGAIN") != string::npos||
        //   what_message.find("Called read on non-open socket") != string::npos||
        //   what_message.find("Called write on non-open socket") != string::npos||
        //   what_message.find("Connection reset by peer") != string::npos||
        //   what_message.find("write() send(): Broken pipe") != string::npos||
        //   what_message.find("send(): Bad file descriptor") != string::npos
        //  )
        //{
        //    return true;
        //}
        CINFO_LOG("TTransportException while check_alive of %s: what: %s", this->node_name_.c_str(), tx.what());
        sender.transport->close();
        return false;
    }
    catch(TException& tx) {
        CINFO_LOG("TException while check_alive of %s: what: %s", this->node_name_.c_str(), tx.what());
        sender.transport->close();
        return false;
    }   
    return true;
}

ret_t ServerPool_Conhash_Socket::Init(){
    //create new Sender
    size_t found = node_name_.find(":");
    if(found == std::string::npos){
        CWARNING_LOG("%s is not a valid node_name, (valid format should be: ip:port)", node_name_.c_str());
        return RET_ERROR;
    }

    std::string hostname = node_name_.substr(0, found);
    uint16_t port = static_cast<uint16_t>(std::stoi(node_name_.substr(found + 1)));
    sender_ = new its::coord_dispatcher::Sender(hostname, port);


    node_imp_ = new node_s;
    conhash_set_node(node_imp_, node_name_.c_str(), replica_);
    return RET_OK;

}

ServerPool_Conhash::ServerPool_Conhash(){
    /* init conhash instance
     * parameter NULL means conhash will use build-in md5 function as hash function*/
    conhash_ = conhash_init(NULL);
}

ServerPool_Conhash::~ServerPool_Conhash(){
    if(conhash_ != NULL){
        conhash_fini(conhash_);
        conhash_ = NULL;
    }
    for(map<string, ServerPool_Conhash_Socket*>::iterator iter = conhash_nodes_.begin(); iter != conhash_nodes_.end(); iter++){
        delete iter->second;
    }
    conhash_nodes_.clear();
}

ret_t ServerPool_Conhash::AddNode(const string& node_name){
    //set default replica for each node 
    uint32_t defaultreplica = its::coord_dispatcher::CD_Config::GetInstance().my_config_.lookup("conhash_default_replica");
    ServerPool_Conhash_Socket* new_node = new ServerPool_Conhash_Socket(node_name, defaultreplica);
    if(new_node->Init() != 0){
        return RET_ERROR;
    }
    conhash_nodes_.insert(make_pair<string, ServerPool_Conhash_Socket*>(new_node->node_name_, new_node));

    if(conhash_add_node(conhash_, new_node->node_imp_) != 0){
        return RET_ERROR;
    } else {
        //cout << conhash_get_vnodes_num(conhash_) << endl;
        new_node->status_ = ServerPool_Conhash_Socket::kNormal;
        return RET_OK;
    }
}

ret_t ServerPool_Conhash::DisableNode(const string& node_name){
    ServerPool_Conhash_Socket* node = conhash_nodes_[node_name];
    if(node == NULL){
        CWARNING_LOG("%s not exist!", node_name.c_str());
        return RET_ERROR;
    }

    if(conhash_del_node(conhash_, node->node_imp_)!= 0){
        CWARNING_LOG("error while deleting %s!", node_name.c_str());
        return RET_ERROR;
    } else {
        node->status_ = ServerPool_Conhash_Socket::kDisabled;
        return RET_OK;
    }
}
ret_t ServerPool_Conhash::RecoverNode(const string& node_name){
    ServerPool_Conhash_Socket* node =conhash_nodes_[node_name];

    if(node == NULL){
        CWARNING_LOG("%s not exist before recover!", node_name.c_str());
    }

    if(node->status_ != ServerPool_Conhash_Socket::kDisabled){
        CWARNING_LOG("%s's status is not kDisabled before reover", node_name.c_str());
        return RET_ERROR;
    }
    if(conhash_add_node(conhash_, node->node_imp_) != 0){
        return RET_ERROR;
    } else {
        node->status_ = ServerPool_Conhash_Socket::kNormal;
        return RET_OK;
    }
}

ret_t ServerPool_Conhash::RemoveNode(const string& node_name){
    map<string, ServerPool_Conhash_Socket*>::iterator iter = conhash_nodes_.find(node_name);
    if(iter == conhash_nodes_.end()){
        CWARNING_LOG("%s not exist!", node_name.c_str());
        return RET_ERROR;
    }
    
    ServerPool_Conhash_Socket* node = iter->second;
    if(conhash_del_node(conhash_, node->node_imp_) != 0){
        return RET_ERROR;
    } else {
        //delete from map
        conhash_nodes_.erase(iter);
        delete node;
        return RET_OK;
    }
}

ServerPool_Socket* 
ServerPool_Conhash::GetNode(const string& node_name){
    boost::lock_guard<boost::mutex> guard(this->mtx_);
    ServerPool_Conhash_Socket* node = conhash_nodes_[node_name];
    if(node == NULL){
        CWARNING_LOG( "%s not exist!", node_name.c_str() );
        return NULL;
    }
    return node;
}

ServerPool_Socket* ServerPool_Conhash::FindNode(const std::string& key){
    boost::lock_guard<boost::mutex> guard(this->mtx_);
    ServerPool_Conhash_Socket* node = NULL;
    
    //cout << key << " hash is " << conhash_->cb_hashfunc(key.c_str()) << endl;
    const node_s* matching = conhash_lookup(conhash_, key.c_str());
    if(matching == NULL){
        return NULL;
    } else {
        string node_name(matching->iden);
        node = conhash_nodes_[node_name];
        if(node == NULL){
            CWARNING_LOG(" %s not exist!", node_name.c_str());
        }
    }

    return node;
}


} //namespace serverpool
} //namespace its
