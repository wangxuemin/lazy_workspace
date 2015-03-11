#encoding: utf-8
import os,sys
import math
import logging

logging.basicConfig(
        level = logging.INFO,
        format = "[%(asctime)s] %(levelname)s: %(message)s"
        )   

WKT={}
CHINA=[
        [73.33,18.00],
        [135.05,53.63]
        ]
WKT['shanghai']=[
        [121.21201180354633209,31.34282983544029477],
        [121.23408358063758783,31.36796094127358714],
        [121.44560477776207108,31.44488314783405158],
        [121.52469531233906253,31.43703683234345192],
        [121.62033967973447091,31.37895368768769089],
        [121.78403869316124997,31.24538340090365551],
        [121.92934455901199442,31.05176450324688275],
        [121.93670181804240826,31.00290390700595111],
        [121.99372057552812976,30.88932460823007631],
        [121.93670181804240826,30.85459291135049398],
        [121.81346772928294797,30.84196008338077633],
        [121.60746447643126089,30.82774616367326104],
        [121.45847998106530952,30.77877100071681582],
        [121.37203218745790423,30.71870289961773537],
        [121.31685274472975777,30.70605221107217986],
        [121.27638782006249585,30.73451392656626879],
        [121.239601524910384,30.79615214107293752],
        [121.21569043306155322,30.88616770138709811],
        [121.1733861936366452,30.96190473431976642],
        [121.12924263945413372,31.05806727033511905],
        [121.13292126896935486,31.10847437210327726],
        [121.14211784275737216,31.17774046019817291],
        [121.14211784275737216,31.24852840632988915],
        [121.149475101787786,31.32083460918133255],
        [121.21201180354633209,31.34282983544029477]
        ]
WKT['beijing']=[
        [116.20665468767711559,40.02704952615601286],
        [116.25240132245656355,40.02941994077353627],
        [116.25343320143655035,40.02915656543930112],
        [116.27682245831624641,40.03758407172811218],
        [116.36625196991515452,40.04074411810563561],
        [116.37037948583510172,40.04179743435418004],
        [116.50108415663351025,40.03231700233223478],
        [116.56299689543277509,40.00702940708109878],
        [116.56712441135272229,39.93427537773349201],
        [116.56162105679277374,39.84137530142693606],
        [116.55474186359285227,39.75786916185643349],
        [116.20115133311716704,39.75152278071590217],
        [116.20665468767711559,40.02704952615601286]
        ]
WKT['guangzhou']=[
        [113.11382993600180669,23.28656287368526279],
        [113.04062066240881279,23.45876794259536879],
        [113.08332607200472353,23.48814642512106587],
        [113.12298109520094158,23.54828193779103529],
        [113.18703920959480058,23.57764045478125681],
        [113.33345775678081679,23.60000444335235059],
        [113.53478325916155711,23.61956980554798591],
        [113.68120180634757332,23.59022066737471945],
        [113.78796533033737148,23.46016706626912551],
        [113.85812421753065848,23.39299241727394829],
        [113.85812421753065848,23.3019724274049338],
        [113.8047424555357594,23.16322230000756477],
        [113.75288588674072798,23.1491991224536946],
        [113.69645373834612201,23.11974567341255593],
        [113.64307197635122293,23.10291222772828945],
        [113.5881650211564704,23.09730061020587755],
        [113.54698480476041311,23.06923900736834909],
        [113.51953132716302264,23.04818896281244989],
        [113.53173287276187864,23.00186728401295966],
        [113.54698480476041311,22.96255156898065408],
        [113.5912154075561773,22.83329093937519616],
        [113.7025545111455358,22.67294972193531422],
        [113.7056048975452569,22.63353892055116034],
        [113.67815141994786643,22.57862646659493677],
        [113.64459716955107638,22.5490491515031799],
        [113.61561849875386088,22.58848416137025694],
        [113.51038016796391616,22.68983660051564399],
        [113.41124260997339945,22.73485810127397144],
        [113.29685311998431985,22.84313031390119519],
        [113.26482406278738324,22.95272085306633159],
        [113.25262251718855566,23.02152084903335805],
        [113.20381633479320271,23.08327054096513109],
        [113.13365744759992992,23.14218698328848234],
        [113.11688032240152779,23.19266619282016251],
        [113.11382993600180669,23.28656287368526279]
        ]
WKT['shenzhen']=[
        [113.75753131371972415,22.70494254637339182],
        [113.77821110750902278,22.74581617508214748],
        [113.8254792075988604,22.78123010183494657],
        [113.87127017956089503,22.79893361948580832],
        [113.95546648284592095,22.78803941906838659],
        [114.01307447983040788,22.73628008751817475],
        [114.09283939873201064,22.70766783481835205],
        [114.19180698329510903,22.7226559515122446],
        [114.2568006209186251,22.7471784189952011],
        [114.33951979607583382,22.72538088727830896],
        [114.39860492118815216,22.76897247436073712],
        [114.45473579004480769,22.79348662808553172],
        [114.47689271196192351,22.79484839633876803],
        [114.51972942766835217,22.75262725884607562],
        [114.5640432715025554,22.72538088727830896],
        [114.59949434656995493,22.70494254637339182 ],
        [114.62165126848704233,22.67223485582983145],
        [114.66448798419345678,22.4799199065442501],
        [114.50052676200684232,22.43077528024882739],
        [114.41042194621059025,22.59861404073869195],
        [114.34985969297048314,22.56178885362118791],
        [114.26418626155766844,22.5631529249248608],
        [114.24055221151273543,22.54132616528333699],
        [114.16521867699457005,22.56178885362118791],
        [114.08545375809296729,22.51267330542964018],
        [114.04113991425874985,22.49493284355770228],
        [113.96580637974057026,22.49902699827045893],
        [113.88751858896678471,22.42394826032275645],
        [113.81661643883202828,22.43487133103450049],
        [113.78411962002026314,22.62997587676328948],
        [113.75753131371972415,22.70494254637339182]
        ]
WKT['nanjing']=[
        [118.585360,32.571630],
        [118.823450,32.579300],
        [119.033600,32.501650],
        [119.038460,32.235390],
        [119.226750,32.205140],
        [119.211900,32.196570],
        [119.124300,32.189900],
        [119.011090,32.120390],
        [119.061340,32.089100],
        [119.088090,32.047570],
        [119.109130,31.971810],
        [119.020260,31.949850],
        [119.107890,31.924200],
        [119.094700,31.860410],
        [118.980820,31.820260],
        [119.077200,31.775940],
        [119.229780,31.611310],
        [119.154690,31.422370],
        [119.216310,31.353990],
        [119.105160,31.234670],
        [118.782410,31.233010],
        [118.703500,31.290280],
        [118.972350,31.445600],
        [118.970860,31.541920],
        [118.873330,31.522770],
        [118.804660,31.645560],
        [118.671130,31.638150],
        [118.645760,31.733730],
        [118.518770,31.761820],
        [118.476260,31.863540],
        [118.369770,31.916670],
        [118.387220,32.059070],
        [118.516830,32.182450],
        [118.655160,32.212720],
        [118.693280,32.469110],
        [118.592050,32.476280]
        ]
WKT['qingdao']=[
        [119.614450,36.983490],
        [120.264250,37.000000],
        [120.242130,37.106560],
        [120.547350,37.114920],
        [120.624060,36.907400],
        [120.580380,36.717920],
        [120.966240,36.544790],
        [120.880160,36.389020],
        [120.803960,36.495090],
        [120.656430,36.296430],
        [120.688700,36.156970],
        [119.919940,35.629440],
        [119.551270,35.596700],
        [119.529800,35.699870],
        [119.708120,35.941720],
        [119.666760,36.163150],
        [120.006280,36.469340],
        [119.617180,36.653600],
        [119.535920,36.751960]
        ]

# 函数功能：判断点是否在多边形内( 适合凹凸多边形 )
# 方法： 计算该点与边界点连线的夹角，夹角和为360, 则在内部
# 参数： point,polygon (点，多边形),
# 平直空间
def PointInPolygonByCalcAngle( _point, _polygon ):
    """_polygon consists of [x, y] in Mercator."""

    # 使用rect bounding Box加速

    angle = 0.0
    nCount = len( _polygon )

    for i in range( nCount ):
        pt1 = _polygon[i]
        pt2 = _polygon[(i+1) % nCount ]

        dx1 = pt1.x - _point.x 
        dy1 = pt1.y - _point.y 
        dx2 = pt2.x - _point.x 
        dy2 = pt2.y - _point.y 

        cos_v = ( dx1 * dx2 + dy1 * dy2 ) / ( ( (dx1*dx1+dy1*dy1) ** 0.5 ) * ( (dx2*dx2+dy2*dy2) ** 0.5 ) )
        if math.fabs(cos_v) <= 1.0 :
            #print "acos: %lf" %math.acos( cos_v )
            angle += math.acos( cos_v )

    return ( math.fabs( angle - 2 * math.pi ) < 0.001 )

# 函数功能：判断点是否在多边形内( 适合凹凸多边形 )
# 方法： 计算该点的水平线与多边形的交点 ,交点为奇数，则在多边形内
# 参数： point,polygon (点，多边形)
# 例  ： pointInPolygon( Point(lng,lat), [Point(pt[0],pt[1]) for pt in city_wkt] )
def pointInPolygon( _point, _polygon ):

    nCross = 0
    nCount = len( _polygon )
    
    for i in range( nCount ):
        pt1 = _polygon[i]
        pt2 = _polygon[(i+1) % nCount ]

        # 计算 point 与 pt1 pt2 的交点个数

        # pt1.y 与 pt2.y 平行
        if pt1.y == pt2.y :
            continue
        # 无交点,交点在 pt1 pt2 的延长线上
        if _point.y < min(pt1.y,pt2.y) :
            continue
        # 无交点,交点在 pt1 pt2 的延长线上
        if _point.y >= max(pt1.y,pt2.y) :
            continue
        # 只对point.x的上界做限制, 下界用作计算交点x
        if _point.x > max(pt1.x,pt2.x) :
            continue

        # 计算交点 x 坐标
        x_cross = (_point.y-pt1.y)*(pt2.x-pt1.x)/(pt2.y-pt1.y) + pt1.x
        # 统计射线单方向交点
        #if x_cross > _point.x or pt1.x == pt2.x :
        if x_cross > _point.x :
            nCross += 1
    # 交点为偶数，点在多边形外
    return ( nCross % 2 == 1 )

# 函数功能：判断点是否在多边形内( 适合凹凸多边形 )
# 方法： 计算该点的水平线与多边形的交点 ,交点为奇数，则在多边形内
# 参数： point,polygon (点，多边形)
def pointInPolygon( _point, _polygon ):

    nCross = 0
    nCount = len( _polygon )
    
    for i in range( nCount ):
        pt1 = _polygon[i]
        pt2 = _polygon[(i+1) % nCount ]

        # 计算 point 与 pt1 pt2 的交点个数

        # pt1.y 与 pt2.y 平行
        if pt1[1] == pt2[1] :
            continue
        # 无交点,交点在 pt1 pt2 的延长线上
        if _point[1] < min(pt1[1],pt2[1]) :
            continue
        # 无交点,交点在 pt1 pt2 的延长线上
        if _point[1] >= max(pt1[1],pt2[1]) :
            continue
        # 只对point.x的上界做限制, 下界用作计算交点x
        if _point[0] > max(pt1[0],pt2[0]) :
            continue

        # 计算交点 x 坐标
        x_cross = (_point[1]-pt1[1])*(pt2[0]-pt1[0])/(pt2[1]-pt1[1]) + pt1[0]
        # 统计射线单方向交点
        #if x_cross > _point.x or pt1.x == pt2.x :
        if x_cross > _point[0] :
            nCross += 1
    # 交点为偶数，点在多边形外
    return ( nCross % 2 == 1 )

class Point:
    def __init__( self, x, y, info="" ):
        self.x = x
        self.y = y
        self.info = info

class BitMap:
    def __init__(self):
        self.bitmap_ = {}
        self.conflictmap_ = {}

    def getBitMapValue( self, _key1, _key2 ):
        if self.bitmap_.has_key( _key1 ):
            if self.bitmap_[_key1].has_key( _key2 ):
                return self.bitmap_[_key1][_key2]
            else:
                return None
        else:
            return None

    # 冲突的value，构成list[]
    def setBitMap( self, _key1, _key2 , _value ):
        if self.bitmap_.has_key( _key1 ):
            if self.bitmap_[_key1].has_key(_key2):
                # 发生冲突,此时key1,key2都有,只需append
                self.bitmap_[_key1][_key2].append(_value)
            else: 
                # 有key1，只需重建key2
                self.bitmap_[_key1][_key2]=[] 
                self.bitmap_[_key1][_key2].append(_value)
        else: 
            # 新建 key1 , key2 ,Map和List 没有key1,一定没有key2
            self.bitmap_[_key1]={} 
            self.bitmap_[_key1][_key2]=[] 
            self.bitmap_[_key1][_key2].append(_value)

    # 返回值: 冲突 True 
    def setBitMapValue( self, _key1, _key2 , _value ):
        if self.bitmap_.has_key( _key1 ):
            # 注意冲突
            if self.bitmap_[_key1].has_key(_key2):
                #self.bitmap_[_key1][_key2]= -1
                logging.debug("Conflict KEY %d %d new:[%d] old:[%d]", _key1, _key2 , _value, self.bitmap_[_key1][_key2] )
                return True
            else:
               self.bitmap_[_key1][_key2]= _value
        else:
           self.bitmap_[_key1]={}
           self.bitmap_[_key1][_key2]= _value

    def dump(self):
        print self.bitmap_

class CityPolygon:
    def __init__(self,wkt,scale=100):
        # city的id，用于bitmap填充
        self.id2city_ = {}
        self.wkt_ = wkt
        self.scale_ = scale

        # 经纬度位图
        self.bitmap_ = BitMap()
        # 地区冲突位图
        self.conflictbitmap_ = BitMap()

        id_ = 1
        for city in wkt:
            self.id2city_[id_] = city
            logging.debug("Build GeoBitMap %-10s", city)
            self.buildCityGeoBitMap(wkt[city],id_)
            id_ +=1

    def buildCityGeoBitMap(self, city_wkt ,cityid):
        scale = self.scale_

        lnglst=[ lnglat[0] for lnglat in city_wkt]
        latlst=[ lnglat[1] for lnglat in city_wkt]

        min_lng = min( lnglst )
        min_lat = min( latlst )
        max_lng = max( lnglst )
        max_lat = max( latlst )

        for idx_lng in range( int(min_lng*scale), int(max_lng*scale) ):
            for idx_lat in range( int(min_lat*scale), int(max_lat*scale) ):
                # 判断经纬度 是否在 Polygon, 如果在，设置cityid
                lng = idx_lng*1.0 / scale
                lat = idx_lat*1.0 / scale

                if pointInPolygon( [lng,lat], city_wkt ):
                    # setBitMapValue 应注意边界 区域覆盖
                    logging.debug( "setBitMapValue %d %d %d", idx_lng, idx_lat, cityid )
                    # 如果冲突,加入冲突表
                    if self.bitmap_.setBitMapValue( idx_lng, idx_lat, cityid ):
                        self.conflictbitmap_.setBitMap( idx_lng, idx_lat, cityid )

    def getKeyByPoint(self,point):
        return self.getKeyByPoint( point[0],point[1] )

    def getKeyByPoint(self,x,y):
        scale = self.scale_
        return [int(x*scale),int(y*scale)]

    def getCityByPoint(self,point):
        return getCityByPoint(self,point[0],point[1])

    def getCityId4Neighbors(self, key1, key2):
        citylst = []

        cityid = self.bitmap_.getBitMapValue( key1, key2 )
        if cityid != None:
            citylst.append( cityid )
            #查找冲突表
            cityid = self.conflictbitmap_.getBitMapValue( key1, key2 )
            if cityid != None:
                citylst.append( cityid )

        cityid = self.bitmap_.getBitMapValue( key1-1, key2 )
        if cityid != None:
            citylst.append( cityid )
            #查找冲突表
            cityid = self.conflictbitmap_.getBitMapValue( key1-1, key2 )
            if cityid != None:
                citylst.append( cityid )

        cityid = self.bitmap_.getBitMapValue( key1, key2-1 )
        if cityid != None:
            citylst.append( cityid )
            #查找冲突表
            cityid = self.conflictbitmap_.getBitMapValue( key1, key2-1 )
            if cityid != None:
                citylst.append( cityid )

        cityid = self.bitmap_.getBitMapValue( key1+1, key2 )
        if cityid != None:
            citylst.append( cityid )
            #查找冲突表
            cityid = self.conflictbitmap_.getBitMapValue( key1+1, key2 )
            if cityid != None:
                citylst.append( cityid )

        cityid = self.bitmap_.getBitMapValue( key1, key2+1 )
        if cityid != None:
            citylst.append( cityid )
            #查找冲突表
            cityid = self.conflictbitmap_.getBitMapValue( key1, key2+1 )
            if cityid != None:
                citylst.append( cityid )

        return set(citylst)

    # 边界处理
    # 取一个点附近 4 个点 , 逐个遍历
    def getCityByPoint(self,x,y):
        [ key1,key2 ] = self.getKeyByPoint(x,y)
        logging.debug( "getCityByPoint %d %d", key1, key2 )
        
        cityidlst = self.getCityId4Neighbors(key1,key2)
        logging.debug("getCityId4Neighbors cityidlst: [%s]",cityidlst)
        for cityid in cityidlst:
            cityname = self.id2city_[cityid]
            city_wkt = self.wkt_[ cityname ]
            if pointInPolygon( [x,y], city_wkt ):
                return self.id2city_[ cityid ]

    def dump_conflict_bitmap(self):
        self.conflictbitmap_.dump()

def getCityPolygon():
    return CityPolygon( WKT )

if __name__ == '__main__':
    cityPolygon = CityPolygon( WKT ,100 )
    print cityPolygon.getCityByPoint(116.271132,40.03395)
    print cityPolygon.getCityByPoint(121.472034,31.292263)
    print cityPolygon.getCityByPoint(113.266839,23.148763)
    print cityPolygon.getCityByPoint(118.790628,32.098446)
    print cityPolygon.getCityByPoint(114.14531,22.6758)
    print cityPolygon.getCityByPoint(120.391192,36.130978)
