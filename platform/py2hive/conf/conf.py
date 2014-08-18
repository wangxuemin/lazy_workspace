#encoding: utf-8

HDFS_HOST = '' # 默认空 使用本地hadoop集群
HIVE_HOST = 'hdp999.jx'
HIVE_PORT = 10000
# HIVE_WAREHOUSE_DIR='/user/xiaoju/warehouse/'

MYSQL_HOST= 'stg0.jx'
MYSQL_PORT= 3377
APPDB_NAME= 'data_mart'
APPDB_USER= 'guanxingtai'
APPDB_PSWD= 'shuxingxing'

class Interface:
    def getpathname( self, file ):
        return file
        
    def parseline( self, dir, line ):
        return line.strip('\n')+','+dir
        
    def checkfile( self, dir, file ):
        return False

app_conf = [] # App 主配置 #供插件task自行配置注册

# 导入任务列表
#from plugins import *
