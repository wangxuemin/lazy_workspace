# encoding: utf-8
import os,sys
import math

def calcGpsDistance(gps1,gps2):
    Rc = 6378137.0
    Rj = 6356725.0
    Pi = math.pi

    a_lat_1 = gps1[1]
    a_lng_1 = gps1[0]
    r_lat_1 = a_lat_1 * Pi / 180.0
    r_lng_1 = a_lng_1 * Pi / 180.0

    a_lat_2 = gps2[1]
    a_lng_2 = gps2[0]
    r_lat_2 = a_lat_2 * Pi / 180.0
    r_lng_2 = a_lng_2 * Pi / 180.0

    Ec=Rj+(Rc-Rj)*(90.0-a_lat_1)/90.0
    Ed=Ec*math.cos(r_lat_1)
    dx=(r_lng_2-r_lng_1)*Ed
    dy=(r_lat_2-r_lat_1)*Ec

    return math.sqrt(dx*dx+dy*dy)

class BdGcjConvertor:
    x_pi = math.pi * 3000.0 / 180.0

    @staticmethod
    def bd_encrypt( gcj_lng, gcj_lat ):
        x = gcj_lng
        y = gcj_lat
        z = math.sqrt(x * x + y * y) + 0.00002 * math.sin( y * BdGcjConvertor.x_pi )
        theta = math.atan2(y,x) + 0.000003 * math.cos( x * BdGcjConvertor.x_pi )

        bd_lng = z * math.cos(theta) + 0.0065
        bd_lat = z * math.sin(theta) + 0.006

        return bd_lng,bd_lat

    @staticmethod
    def bd_decrypt( bd_lng, bd_lat ):
        x = bd_lng - 0.0065
        y = bd_lat - 0.006
        z = math.sqrt(x * x + y * y) - 0.00002 * math.sin(y * BdGcjConvertor.x_pi)
        theta = math.atan2(y, x) - 0.000003 * math.cos(x * BdGcjConvertor.x_pi)

        gcj_lng = z * math.cos(theta)
        gcj_lat = z * math.sin(theta)

        return gcj_lng,gcj_lat
