#include "cd_config.h"
#include <iostream>

namespace its{
namespace coord_dispatcher{
CD_Config* CD_Config::inst_ = NULL;

CD_Config::CD_Config(){
}

CD_Config& CD_Config::GetInstance(){
    //FIXME not thread safe
    if(inst_ == NULL){
        inst_ = new CD_Config();
    }
    return *inst_;
}


ret_t CD_Config::Init(const std::string& conf_file_name){
    try
    {
        my_config_.readFile(conf_file_name.c_str());
    }
    catch (const libconfig::FileIOException &fioex)
    {
        std::cerr << "I/O Error While Reading File: " << conf_file_name;
        return RET_ERROR;
    }
    catch (const libconfig::ParseException &pex)
    {
        std::cerr << "Parse Error At " << pex.getFile() << ":" << pex.getLine() << " - " << pex.getError();
        return RET_ERROR;
    }
    return RET_OK;
}

}
}
