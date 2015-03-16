# encoding: utf-8
import os,sys
import math
import logging

logging.basicConfig(
        level = logging.INFO,
        format = "[%(asctime)s] %(levelname)s: %(message)s"
        )

isDebug = logging.getLogger().isEnabledFor( logging.DEBUG )

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

def calcTimeAndDistanceSpan( p1,p2 ):
    p1 = p1.split(',')
    p2 = p2.split(',')

    _dt = int(p2[0]) - int(p1[0])

    p1_lng = float(p1[1])
    p1_lat = float(p1[2])
    p2_lng = float(p2[1])
    p2_lat = float(p2[2])
    _ds = calcGpsDistance( [p1_lng,p1_lat],[p2_lng,p2_lat] )

    return _dt, _ds

def main( time_threshold, distance_threshold ):
    user_count = 0
    # 轨迹分割
    # 默认时间阈值60s，距离阈值300m
    # dt_threshold = time_hreshold
    # ds_threshold = distance_threshold

    for line in sys.stdin:
        user_count += 1
        userId,trajs = line.split(' ')

        # 删除换行符
        trajs = trajs[:-1]
        loc_point = trajs.split(';')

        # 统计项
        trajs_point_cnt = 0         # 所有合法轨迹点数
        trajs_total_online_time = 0 # 所有轨迹在线时长
        trajs_total_length = 0.0    # 所有轨迹长度
        sub_traj_cnt = 0            # 子轨迹数

        sub_traj_point_cnt = 0      # 当前子轨迹点数
        sub_traj_online_time = 0    # 当前子轨迹在线时长
        sub_trajs_length = 0.0      # 当前子轨迹长度

        # 子轨迹变量 (辅助调试)
        if isDebug:
            sub_traj = []
            ret_traj = []

        # 查询 第一个point的 城市 CityCode
        area = 0

        # 设置第一个point
        prev_point = loc_point[0]
        for point in loc_point[1:]:
            # 子轨迹点数 += 1
            sub_traj_point_cnt += 1
            # 计算 时间差 dt
            #dt = calcTimeSpan( prev_point, point )
            # 计算 距离差 ds
            #ds = calcDistanceSpan( prev_point, point )
            dt,ds = calcTimeAndDistanceSpan( prev_point, point )

            if isDebug:
                sub_traj.append(prev_point)
            logging.debug( "%s %s" , prev_point, point)
            logging.debug( "dt: %d ds: %f" , dt, ds)
            logging.debug( "sub_traj_point_cnt :%d", sub_traj_point_cnt )

            # 轨迹分割
            if dt > time_threshold or ds > distance_threshold :
                # 跳过连续的 孤立点
                if sub_traj_point_cnt > 1 :
                    # 子轨迹数 +=1
                    sub_traj_cnt += 1
                    # 统计轨迹点数: 加和长于1的子轨迹点数
                    trajs_point_cnt += sub_traj_point_cnt

                    logging.debug( "sub_traj_cnt: %d",sub_traj_cnt)
                    if isDebug:
                        ret_traj.append( sub_traj )

                if isDebug:
                    sub_traj=[]

                # 重置 子轨迹点数，在线时长，距离
                sub_traj_point_cnt = 0 
                sub_traj_online_time = 0
                sub_trajs_length = 0.0

                # 移动指针
                prev_point = point
                logging.debug( "============================" );
                continue

            # 添加移动点，忽略异常不动点
            if dt > 0 or ds > 0.0 :
                sub_traj_online_time += dt
                sub_trajs_length += ds

                # 统计 轨迹的在线时长，轨迹的长度
                trajs_total_online_time += dt
                trajs_total_length += ds

                logging.debug( "trajs_total_online_time: %d",trajs_total_online_time)
                logging.debug( "trajs_total_length: %f",trajs_total_length)

            logging.debug( "============================" );
            # 移动指针
            prev_point = point

        # 添加最后一段traj
        # if sub_traj_online_time > 0 and sub_trajs_length > 0.0 :
        if sub_traj_point_cnt > 1 :
            sub_traj_cnt += 1
            trajs_point_cnt += sub_traj_point_cnt
            if isDebug:
                ret_traj.append( sub_traj )

        # 输出 一个，userId的统计信息, 等待reduce聚合
        if isDebug:
            for tj in ret_traj:
                print tj,len(tj)
            print "area:%s\tonline_time:%d,trajs_length:%lf,pt_cnt:%d,subtraj_cnt:%d" %( area, trajs_total_online_time, trajs_total_length, trajs_point_cnt , sub_traj_cnt )
        print "area:%s\t%d,%lf,%d,%d" %( area, trajs_total_online_time, trajs_total_length, trajs_point_cnt , sub_traj_cnt )

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
