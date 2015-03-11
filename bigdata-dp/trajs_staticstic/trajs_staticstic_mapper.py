# encoding: utf-8
import os,sys
import math

# 功能：计算球面距离
# 输入：两个gps点
# 输出：距离单位 m
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
#print calcGpsDistance([116.166713,40.070953],[116.373683,39.920605])

def calcTimeSpan( p1,p2 ):
    return int(p2.split(',')[0]) - int(p1.split(',')[0])

def calcDistanceSpan( p1,p2 ):
    p1 = p1.split(',')
    p2 = p2.split(',')

    p1_lng = float(p1[1])
    p1_lat = float(p1[2])
    p2_lng = float(p2[1])
    p2_lat = float(p2[2])

    return calcGpsDistance( [p1_lng,p1_lat],[p2_lng,p2_lat] )

def main( time_threshold, distance_threshold ):
    user_count = 0
    # 轨迹分割默认时间阈值60s，距离阈值300m
    #dt_threshold = time_hreshold
    #ds_threshold = distance_threshold

    for line in sys.stdin:
        user_count += 1
        userId,trajs = line.split(' ')
        loc_point = trajs.split(';')

        # 统计项
        point_count = 0
        outlier_count = 0 

        online_time = 0
        trajs_length = 0.0
        total_online_time = 0
        total_trajs_length = 0.0

        # 子轨迹计数
        sub_traj=[]
        sub_traj_count = 0

        # 查询 第一个point的 城市 CityCode
        area = 0

        # 设置第一个point
        prev_point = loc_point[0]
        for point in loc_point[1:]:
            point_count += 1
            # 计算 时间差 dt
            dt = calcTimeSpan( prev_point, point )
            # 计算 距离差 ds
            ds = calcDistanceSpan( prev_point, point )

            # traj 分割,新的 traj
            if dt > time_threshold or ds > distance_threshold :
                # 加入子轨迹，重新计算online_time, trajs_length 
                if online_time > 0 and trajs_length > 0.0 :
                    sub_traj_count += 1
                    #sub_traj.append([online_time,trajs_length])

                # 如果 online_time ==0 and trahs_length == 0.0
                # 跳过单点，计数
                elif not online_time < 0 and not trajs_length < 0.0 :
                    outlier_count += 1

                online_time = 0
                trajs_length = 0.0

                # 移动指针
                prev_point = point
                continue

            online_time += dt
            trajs_length += ds

            total_online_time += dt
            total_trajs_length += ds

            # 移动指针
            prev_point = point

        # 添加最后一段traj
        if online_time > 0 and trajs_length > 0.0 :
            sub_traj_count += 1
            #sub_traj.append([online_time,trajs_length])

        # 输出 一个，userId的统计信息, 等待reduce聚合
        print "%s\t%d,%lf,%d,%d" %( area, total_online_time, total_trajs_length, point_count - outlier_count, sub_traj_count )

if __name__ == '__main__':

    time_threshold = 60
    distance_threshold = 300

    for idx in range(1, len(sys.argv)) :
        if sys.argv[idx] == "-time":
            idx += 1
            time_threshold = sys.argv[idx]

        if sys.argv[idx] == "-distance":
            idx += 1
            distance_threshold = sys.argv[idx]

    main( time_threshold, distance_threshold )
