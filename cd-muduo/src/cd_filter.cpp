#include "cd_filter.h"
#include <boost/scoped_ptr.hpp>
#include <geos.h>
#include <iostream>

#include "didi_protocol.pb.h"
#include "didi_protocol_collectsvr.pb.h"

#include "cd_config.h"
#include "cn_logger.h"
using namespace std;
using namespace geos::geom;

namespace its{
namespace coord_dispatcher{
Filter::Filter()
    : valid_poly_(NULL), accuracy_threshold_(0.0)
{

}

ret_t Filter::Init(const string& valid_bound, double accuracy_threshold){

    geos::io::WKTReader reader(&gf_);
    valid_poly_ = reader.read(valid_bound);
    if(valid_poly_ == NULL){
        LOG4CPLUS_ERROR(logger, "valid poly creating failed!");
        return RET_ERROR;
    }

    this->accuracy_threshold_ = accuracy_threshold;
   
    return RET_OK;
}
        
bool Filter::IsValid(const DidiPush::CollectSvrCoordinateReq* coord){
    if(!coord->has_accuracy() || !coord->has_lng() || !coord->has_lat()){
        return false;
    }
    double accuracy = coord->accuracy();
    if(IsValidAccuracy(accuracy)){
        if(IsValidCoord(coord->lng(), coord->lat())){
            return true;
        }
    }
    return false;
}

bool Filter::IsValidAccuracy(double my_acc){
    return (my_acc <= accuracy_threshold_) ? true : false;
}

bool Filter::IsValidCoord(double lng, double lat){

    geos::geom::Coordinate coord(lng, lat);
    boost::scoped_ptr<geos::geom::Point> p(gf_.createPoint(coord));
    return (valid_poly_->contains(p.get())) ? true : false;
}


Filter::~Filter(){
    if(valid_poly_ != NULL){
        delete valid_poly_;
        valid_poly_ = NULL;
    }
}
} 
} //namespace its
