/**
 * @file cd_filter.h
 * @brief implement the logic rule of filtering invalid coord
 * @author LiYan
 * @version 1.0.0
 * @date 2014-11-24
 */


#ifndef _CD_FILTER_H_
#define _CD_FILTER_H_

#include <geos.h>
#include <string>
#include <cn_return_type.h>

namespace DidiPush{
class CollectSvrCoordinateReq;
}

namespace its{
namespace coord_dispatcher{
class Filter{
    public:
        Filter();
        virtual ~Filter();

        ret_t Init(const std::string& valid_bound, double accuracy_threshold);
        bool IsValid(const DidiPush::CollectSvrCoordinateReq* coord);
    private:
        bool IsValidAccuracy(double my_acc);
        bool IsValidCoord(double lng, double lat);

        geos::geom::GeometryFactory gf_;
        geos::geom::Geometry* valid_poly_;
        double accuracy_threshold_;
};
}
} //namespace its
#endif //_CD_FILTER_H_
