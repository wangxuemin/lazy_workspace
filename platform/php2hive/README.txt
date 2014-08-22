一、php Hive API的问题
默认情况下，Hive本身自带的php API是不太好使的。一个是路径有问题，一个是代码本身也有问题。所以，采用thrift重新自己生成hive的php api。

找到所有的thrift文件，并复制到某个路径下

#cd hive
#for i in `find ./ -name "*.thrift"`
>do
>cp ${i} /usr/local/www/hive/thrift
>done

然后找到thrift里面的fb303.thrift，复制到一起。修改hive_metastore和hive_service里面inlclude fb303的路径。然后用thrift -r --gen php 生成两个hive的thrift。

然后再复制thrift本身的protocol，transport文件夹和autoload.php和Thrift.php。

我把这些东西都放在libs文件夹下。最终目录结构和文件名如下：

./tree.sh libs | grep -v ".php"
|---transport
|---protocol
|---packages
||---fb303
||---hive_service
||---queryplan
||---hive_metastore


./tree.sh libs/
|---transport
||---TTransport.php
||---TNullTransport.php
||---TSocketPool.php
||---TMemoryBuffer.php
||---TFramedTransport.php
||---TBufferedTransport.php
||---THttpClient.php
||---TPhpStream.php
||---TSocket.php
|---autoload.php
|---Thrift.php
|---protocol
||---TProtocol.php
||---TBinaryProtocol.php
|---packages
||---fb303
|||---fb303_types.php
|||---FacebookService.php
||---hive_service
|||---hive_service_types.php
|||---ThriftHive.php
||---queryplan
|||---queryplan_types.php
||---hive_metastore
|||---ThriftHiveMetastore.php
|||---hive_metastore_types.php
|||---hive_metastore_constants.php

然后解决API中的代码bug问题，正常情况下，php是同步阻塞执行，而hive的查询时间比较长，在查询期间，端口会没有响应，所以thrift会返回socket timeout的错误。所以需要修改api中对socket buffer的处理。

编辑transport下TSocket.php红色修改前，绿色修改后，总共五个位置需要修改。

1.先找public function readAll($len)方法
在方法里
找到
if ($buf === FALSE || $buf === '') {

修改为
if($buf === FALSE) {

找到两处
if ($md['timed_out']) {
均改为
if (true === $md['timed_out'] && false === $md['blocked']) {

--------------------------------------------

2.找到public function read($len)方法
在方法里找到
if ($data === FALSE || $data === '') {

修改为
if ($data === FALSE) {

找到一处
if ($md['timed_out']) {
修改为
if (true === $md['timed_out'] && false === $md['blocked']) {

二、修改nginx和php的设置，为了保证hive正常使用，我用的php 5.3.8

nginx修改

http
{
keepalive_timeout    36000;
server {
location ~ \.php$
{
fastcgi_connect_timeout 36000;
fastcgi_send_timeout 36000;
fastcgi_read_timeout 36000;
}
}
}
#sbin/nginx -s reload

                            php修改

#cd etc
#vi php-fpm.conf
process_control_timeout = 36000s
request_terminate_timeout = 36000s

#cd lib
#vi php.ini
max_input_time = 36000
default_socket_timeout = 36000

#killall php-fpm
#sbin/php-fpm -c lib/php.ini

因为hive查询比较慢，为了防止超时，我都设置成了10小时超时，都是内网应用，无所谓了。


三、编写第一个php-hive程序

<?php

$GLOBALS['THRIFT_ROOT'] = './libs/';
// load the required files for connecting to Hive
require_once $GLOBALS['THRIFT_ROOT'] . 'packages/hive_service/ThriftHive.php';
require_once $GLOBALS['THRIFT_ROOT'] . 'transport/TSocket.php';
require_once $GLOBALS['THRIFT_ROOT'] . 'protocol/TBinaryProtocol.php';
// Set up the transport/protocol/client

define('HOST','192.168.1.49');
define('PORT','10000');

$transport = new TSocket(HOST, PORT);
$protocol = new TBinaryProtocol($transport);
$client = new ThriftHiveClient($protocol);
//Create ThriftHive object

$transport->open();

$client->execute('add jar /opt/modules/hive/hive-0.7.1/lib/hive-contrib-0.7.1.jar');
$client->execute('show databases');

$db_array = $client->fetchAll();

$i = 0;
while('' != @$db_array[$i]) {
                echo $db_array[$i];
                                $i++;
}

$transport->close();
?>

php中有几种hive方法，列出来以便参考

execute($query)             执行查询
fetchOne()                    返回一行结果
fetchN($numRows)          返回N行结果，给定行数
fetchAll()                       返回全部结果集
getSchema()                  获取Schema
getThriftSchema()           获取Thrift Server Schema
getClusterStatus()           获取集群状态，很贴心啊，还没试过
getQueryPlan()                获取QueryPlan
