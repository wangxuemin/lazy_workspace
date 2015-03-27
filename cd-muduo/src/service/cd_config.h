/**
 * @file cd_config.h
 * @brief config header. Using Singleton
 * @author LiYan
 * @version 1.0.0
 * @date 2014-11-24
 */


#ifndef _CD_CONFIG_H_
#define _CD_CONFIG_H_

#include <string>
#include <libconfig.h++>
#include <cn_return_type.h>
namespace its{
namespace coord_dispatcher{

class CD_Config
{
    public:
        static CD_Config& GetInstance();
        ret_t Init(const std::string& conf_file_name);
        libconfig::Config my_config_;
    private:
        static CD_Config* inst_;
        CD_Config();
        CD_Config(const CD_Config& rhs);
        CD_Config& operator = (const CD_Config& rhs);

};

}
}




#endif //_CD_CONFIG_H_
