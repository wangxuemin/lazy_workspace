#!/usr/bin/env python
#-*- coding: utf-8 -*-
#author:renchangyan@diditaxi.com.cn
import sys
import time
import math

#存储每个pid当天对应的所有订单信息
result_dict = {}
# input comes from STDIN (standard input)
for line in sys.stdin:
    try:
        # remove leading and trailing whitespace
        line = line.strip()
        line_list = line.split("||")
        # 获取订单的pid/status/lng/lat/createtime
        pid = line_list[1]
        if (line_list[3] == ''):
            driverid = 0
        else :
            driverid = int(line_list[3])
        order_status = int(line_list[4])
        lng = float(line_list[6])
        lat = float(line_list[7])
        #时间转秒
        create_time = line_list[18]
        time_object = time.strptime(create_time, "%Y-%m-%d %X")
        time_seconds = int(time.mktime(time_object))
        one_order_info = [time_seconds, lng, lat, order_status, driverid]
        if (result_dict.has_key(pid)) :
            result_dict[pid].append(one_order_info)
        else:
            result_dict[pid] = [one_order_info]
    except Exception as e :
        sys.stderr.write("Error line:" + line)
#记录每个pid的需求数,需求成功数
need_dict = {}
PI = 3.14159265
EARTH_RADIUS = 6378137
RAD = PI / 180.0
for key in result_dict :
    #result_dict[key].sort()
    need_num = 0
    need_succ_num = 0
    flag = 1
    i = 0
    #last success order time
    pre_succ_time = 0
    while (i < len(result_dict[key])) :
        cur_time = result_dict[key][i][0]
        cur_lng = result_dict[key][i][1]
        cur_lat = result_dict[key][i][2]
        cur_status = result_dict[key][i][3]
        cur_driverid = result_dict[key][i][4]
        if (flag == 0) :
            if (cur_time - pre_time < 600) :
                #计算订单之间的距离
                lng_minus = (cur_lng - pre_lng) * RAD
                radLat1 = cur_lng  * RAD
                radLat2 = pre_lng  * RAD
                lat_minus = radLat1 - radLat2
                distance = 2 * math.asin(math.sqrt(math.pow(math.sin(lat_minus / 2), 2) + \
                           math.cos(radLat1) * math.cos(radLat2) * math.pow(math.sin(lng_minus / 2), 2)))
                distance = distance * EARTH_RADIUS
                if (distance < 1000) :
                    if ( ((cur_status == 1) or (cur_status == 2) or (cur_status == 3) or (cur_status == 4 \
                             and cur_driverid > 0)) and (need_succ_num == 0 or pre_succ_time < pre_time)) :
                        need_succ_num += 1
                        pre_time = cur_time
                        pre_lng = cur_lng
                        pre_lat = cur_lat
                        pre_succ_time = pre_time
                    flag = 1
                    i += 1
                    continue
        need_num += 1
        pre_time = cur_time
        pre_lng = cur_lng
        pre_lat = cur_lat
        if ( (cur_status == 1) or (cur_status == 2) or (cur_status == 3) \
                               or (cur_status == 4 and cur_driverid > 0)) :
            need_succ_num += 1
            pre_succ_time = pre_time
        flag = 0
        i += 1
    need_dict[key] = [need_num, need_succ_num]
for key in need_dict:
    #第四列预留area
    print "%s||%d||%d||0" % (key, need_dict[key][0], need_dict[key][1])
