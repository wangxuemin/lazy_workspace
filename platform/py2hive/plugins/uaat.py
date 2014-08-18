#encoding: utf-8
import os,re,time,datetime,re
import conf

class Uaat(conf.Interface):
    def __init__(self, date):
        self.date = date
        self.date = self.date.replace('-','')
        
################################
# 按文件名 分组到不同的文件夹 完成去重
    def getpathname( self, file ):

        filename = file.split('.')
        filename = filename[0]
        filename = filename.split('_')
        pathname = filename[0]+'_'+filename[1]+'_'+filename[3]+'_'+filename[4]+'_'+filename[5]
        
        return pathname

###############################
# 解析文件每一行
# dirname 为 pathname
    def parseline( self, dirname, line):
        try:
            line = line.strip('\n')
            line = line.split(':')
            
            if( len(line) !=2 ):
                return ""

            if( len( line[0] ) >50 ):
                return ""

            match=re.compile(r'^[a-zA-Z0-9_]+$').match( line[0] )
            if not match:
                return ""

            match=re.compile(r'^\d{14}$').match( line[1] )
            if not match:
                return ""

            date_time = line[1]

            year = date_time[0:4]
            if( int(year) > 2099 ):
                return ""
            month = date_time[4:6]
            if( int(month) > 12 ):
                return ""
            day = date_time[6:8]
            if( int(day) > 31 ):
                return ""
            hour = date_time[8:10]
            if( int(hour) > 24 ):
                return ""
            minute = date_time[10:12]
            if( int(minute) > 60 ):
                return ""
            seconds = date_time[12:14]
            if( int(seconds) > 60 ):
                return ""

            time_stamp = "%s-%s-%s %s:%s:%s" %(year,month,day,hour,minute,seconds)
            date_time = date_time[0:8]

            line = "%s,%s,%s,%s," % (line[0],line[1],time_stamp,date_time)
            line += dirname.replace('_',',')+'\n'

        except Exception,e:
            print e
            line=""

        return line
        
###############################
# 检查历史是否已传过 
# tmpdir 为 存放 pathname文件夹的目录

    def checkfile( self, dir, file ):
        # 如果历史有 直接跳过， 没有则以日期为目录名 copy过去
        history_path = os.getcwd()+'/../history'
        workpath = os.getcwd()+'/tmpdir/'
        datedirname = file[0:8]
        
        if not os.path.exists( history_path+'/'+dir+'/'+datedirname ):
            try:
                cmd = 'mkdir -p %s' %(history_path+'/'+dir+'/'+datedirname)
                os.system( cmd )
            except Exception, e:
                print e
        
        # 根据佳佳建议，优化： 如果是当天的日志，直接返回false
        if self.date == datedirname:
            try:    
                cmd = 'cp %s %s' %(workpath+dir+'/'+file, history_path+'/'+dir+'/'+datedirname)
                os.system( cmd )
            except Exception, e:
                print e
            return False

        # 如果不是昨天的，去history查重
        dirname = dir.split('_')
        dirnames = dirname[0]+'_*_'+dirname[2]+'_'+dirname[3]+'_'+dirname[4]

        cmd = 'ls %s >/dev/null' %( history_path+'/'+dirnames+'/'+datedirname+'/'+file )
        ret = os.system( cmd )
        if ret == 0:
            return True
        else: #存入历史目录
            try:    
                cmd = 'cp %s %s' %(workpath+dir+'/'+file, history_path+'/'+dir+'/'+datedirname)
                os.system( cmd )
            except Exception, e:
                print e

        return False


##############   注册配置
pluginconf={
    'log_name':                    # 配置名称
        'uaat_log',
    'remote_machine':              # 远程机器
        ['web1.jx','web4.jx','web5.jx','web6.jx','web7.jx','web8.jx','web9.jx','db4.jx','db5.jx','db6.jx','db7.jx',],
    'remote_acct':                 # 远程账号
        'rd',
    'remote_file_path':            # 远程文件路径
        '/home/webroot/app/log/trace_log',
    'suffix':                      # 远程文件后缀
        'zip',
    'local_file_path':             # 本地文件路径
	'/home/disk2/data_source/uaat_log' ,
    'table':                       # Hive表名
        'uaat',
    'partition':                   # Hive分区
        'stat_date',
    'class':                       # 接口实现类
        Uaat,
}

conf.app_conf.append(pluginconf)
