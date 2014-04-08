-- MySQL dump 10.13  Distrib 5.5.28, for Linux (x86_64)
--
-- Host: stg0.jx    Database: data_mart
-- ------------------------------------------------------
-- Server version	5.5.28-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `data_mart`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `data_mart` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `data_mart`;

--
-- Table structure for table `BIOrder`
--

DROP TABLE IF EXISTS `BIOrder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BIOrder` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderDayAverageDistance` int(11) DEFAULT NULL COMMENT '今日实时订单平均成交距离',
  `orderDensity` float DEFAULT NULL COMMENT '今日订单密度:今日司机累计在线时长/今日播送订单数',
  `realOrderDensity` float DEFAULT NULL COMMENT '今日实时订单密度:今日司机累积在线时长/今日实时订单播单数',
  `preOrderDensity` float DEFAULT NULL COMMENT '今日预约订单密度:今日司机累积在线时长/今日预约订单播单数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42547 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BIOrderBonus`
--

DROP TABLE IF EXISTS `BIOrderBonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BIOrderBonus` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `cityBonus` int(11) DEFAULT NULL COMMENT '今日奖励金额:总的平台奖励金额(单位',
  `cityBonuCnt` int(11) DEFAULT NULL COMMENT '今日奖励订单数',
  `moneyRate` float DEFAULT NULL COMMENT '今日现金使用效率:今日平台奖励带来的成交订单数/今日奖励金额',
  `avgRealDis` int(11) DEFAULT NULL COMMENT '今日平台奖励实时订单平均成交距离',
  `avgTime` int(11) DEFAULT NULL COMMENT '今日平台奖励订单平均成交时间:单位秒',
  `avgDrivStrive` float DEFAULT NULL COMMENT '今日司机人均奖励订单数:今日奖励订单数/今日抢单成功司机数',
  `newDrivRate` float(8,3) DEFAULT NULL COMMENT '今日平台奖励新司机占平台奖励司机比:今日奖励新司机数/今日奖励司机数(新司机指的是本周注册司机)',
  `newPasRate` float(8,3) DEFAULT NULL COMMENT '今日平台奖励新乘客占平台奖励乘客比:今日奖励新乘客数/今日奖励乘客数(新司机指的是本周注册司机)',
  `washDrivRate` float(8,3) DEFAULT NULL COMMENT '今日平台奖励流失司机占平台奖励司机比:今日奖励流失司机数/今日奖励司机数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=31960 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BIStrategy`
--

DROP TABLE IF EXISTS `BIStrategy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BIStrategy` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `total_listen_driver` int(11) DEFAULT NULL COMMENT '今日所有听单司机数',
  `normal_real_order_broadcast_num` int(11) DEFAULT NULL COMMENT '今日普通实时订单播送数',
  `normal_real_order_strive_num` int(11) DEFAULT NULL COMMENT '今日普通实时订单抢单数',
  `normal_real_order_strive_rate` float(8,3) DEFAULT NULL COMMENT '今日普通实时订单听单抢单率',
  `a_ride_real_order_broadcast_num` int(11) DEFAULT NULL COMMENT '今日a类实时订单播送数',
  `a_ride_real_order_strive_num` int(11) DEFAULT NULL COMMENT '今日a类时订单抢单数',
  `a_ride_real_order_strive_rate` float(8,3) DEFAULT NULL COMMENT '今日a类顺风车实时订单听单抢单率',
  `a_real_ride_listen_driver` int(11) DEFAULT NULL COMMENT '今日听到a类顺风车实时订单司机数',
  `a_real_ride_listen_driver_rate` float(8,3) DEFAULT NULL COMMENT '今日听到a类顺风车实时订单司机占比',
  `normal_pre_order_broadcast_num` int(11) DEFAULT NULL COMMENT '今日普通预约订单播送数',
  `normal_pre_order_strive_num` int(11) DEFAULT NULL COMMENT '今日普通预约订单抢单数',
  `normal_pre_order_strive_rate` float(8,3) DEFAULT NULL COMMENT '今日普通预约订单听单抢单率',
  `a_ride_pre_order_broadcast_num` int(11) DEFAULT NULL COMMENT '今日a类预约订单播送数',
  `a_ride_pre_order_strive_num` int(11) DEFAULT NULL COMMENT '今日a类预约订单抢单数',
  `a_ride_pre_order_strive_rate` float(8,3) DEFAULT NULL COMMENT '今日a类顺风车预约订单听单抢单率',
  `a_pre_ride_listen_driver` int(11) DEFAULT NULL COMMENT '今日听到a类顺风车预约订单司机数',
  `a_pre_ride_listen_driver_rate` float(8,3) DEFAULT NULL COMMENT '今日听到a类顺风车预约订单司机占比',
  `b_ride_pre_order_broadcast_num` int(11) DEFAULT NULL COMMENT '今日b类预约订单播送数',
  `b_ride_pre_order_strive_num` int(11) DEFAULT NULL COMMENT '今日b类预约订单抢单数',
  `b_ride_pre_order_strive_rate` float(8,3) DEFAULT NULL COMMENT '今日b类顺风车预约订单听单抢单率',
  `b_pre_ride_listen_driver` int(11) DEFAULT NULL COMMENT '今日听到b类顺风车预约订单司机数',
  `b_pre_ride_listen_driver_rate` float(8,3) DEFAULT NULL COMMENT '今日听到b类顺风车预约订单司机占比',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=141034 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DataMartIndex`
--

DROP TABLE IF EXISTS `DataMartIndex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DataMartIndex` (
  `itemId` int(11) NOT NULL AUTO_INCREMENT,
  `itemName` varchar(64) DEFAULT NULL,
  `itemType` varchar(64) DEFAULT NULL,
  `tableName` varchar(64) DEFAULT NULL,
  `itemChsName` varchar(64) DEFAULT NULL,
  `itemChsDesc` varchar(128) DEFAULT NULL,
  `valid` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`itemId`),
  UNIQUE KEY `itemName` (`itemName`,`tableName`)
) ENGINE=InnoDB AUTO_INCREMENT=564 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DataMartIndexBak`
--

DROP TABLE IF EXISTS `DataMartIndexBak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DataMartIndexBak` (
  `itemId` int(11) NOT NULL DEFAULT '0',
  `itemName` varchar(64) DEFAULT NULL,
  `itemType` varchar(64) DEFAULT NULL,
  `tableName` varchar(64) DEFAULT NULL,
  `itemChsName` varchar(64) DEFAULT NULL,
  `itemChsDesc` varchar(128) DEFAULT NULL,
  `valid` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverApprovedThreeWeeks`
--

DROP TABLE IF EXISTS `DriverApprovedThreeWeeks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverApprovedThreeWeeks` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `approvedDriverCnt` int(11) DEFAULT NULL COMMENT '三周内新审核通过司机总数',
  `dayOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '三周内新司机当天登录总数',
  `dayOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '三周内新司机当天登录比例',
  `driverAvgOrderSuccCntPerDay` float DEFAULT NULL COMMENT '三周内新激活司机三周内人均每天成单数',
  `driverAvgOrderBroadcastCntPerDay` float DEFAULT NULL COMMENT '三周内新激活司机三周内人均每天听单数',
  `driverAvgOrderStriveCntPerDay` float DEFAULT NULL COMMENT '三周内新激活司机三周内人均每天抢单数',
  `orderSuccCntDriverCnt` int(11) DEFAULT NULL COMMENT '三周内新激活司机成单人数去重',
  `orderBreakRate` float(8,3) DEFAULT NULL COMMENT '三周内新激活司机被爽约率',
  `orderSuccCntDriverRate` float(8,3) DEFAULT NULL COMMENT '三周内新司机成单人数占比',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=32316 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverApprovedTwoWeeks`
--

DROP TABLE IF EXISTS `DriverApprovedTwoWeeks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverApprovedTwoWeeks` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `approvedDriverCnt` int(11) DEFAULT NULL COMMENT '二周内新审核通过司机总数',
  `dayOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '二周内新司机当天登录总数',
  `dayOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '二周内新司机当天登录比例',
  `driverAvgOrderSuccCntPerDay` float DEFAULT NULL COMMENT '二周内新激活司机二周内人均每天成单数',
  `driverAvgOrderBroadcastCntPerDay` float DEFAULT NULL COMMENT '二周内新激活司机二周内人均每天听单数',
  `driverAvgOrderStriveCntPerDay` float DEFAULT NULL COMMENT '二周内新激活司机二周内人均每天抢单数',
  `orderSuccCntDriverCnt` int(11) DEFAULT NULL COMMENT '二周内新激活司机成单人数去重',
  `orderBreakRate` float(8,3) DEFAULT NULL COMMENT '二周内新激活司机被爽约率',
  `orderSuccCntDriverRate` float(8,3) DEFAULT NULL COMMENT '二周内新司机成单人数占比',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=32315 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverApprovedWeek`
--

DROP TABLE IF EXISTS `DriverApprovedWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverApprovedWeek` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `approvedDriverCnt` int(11) DEFAULT NULL COMMENT '一周内新审核通过司机总数:过去7天内，审核通过的司机总数',
  `dayOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '一周内新司机当天登录总数:过去7天内，审核通过的司机总数，最后上报时间为当天的司机总数',
  `dayOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '一周内新司机当天登录比例:过去7天内，审核通过的司机总数，最后上报时间为当天的司机总数/过去7天内，审核通过的司机总数',
  `driverAvgOrderSuccCntPerDay` float DEFAULT NULL COMMENT '一周内新激活司机一周内人均每天成单数:过去7天内，新激活的司机抢单总数/(审核通过的司机人数的总在线天数)',
  `driverAvgOrderBroadcastCntPerDay` float DEFAULT NULL COMMENT '一周内新激活司机一周内人均每天听单数:过去7天内，新激活的司机听单总数/(审核通过的司机人数的总在线天数)',
  `driverAvgOrderStriveCntPerDay` float DEFAULT NULL COMMENT '一周内新激活司机一周内人均每天抢单数:过去7天内，新激活的司机抢单总数/(审核通过的司机人数的总在线天数)',
  `orderSuccCntDriverCnt` int(11) DEFAULT NULL COMMENT '一周内新激活司机成单人数去重:过去7天内，新激活的司机 成单司机去重',
  `orderBreakRate` float(8,3) DEFAULT NULL COMMENT '一周内新激活司机被爽约率:过去7天内，新激活的司机 被爽约的司机去重/过去7天内，审核通过的司机 总数',
  `orderSuccCntDriverRate` float(8,3) DEFAULT NULL COMMENT '一周内新司机成单人数占比:过去7天内,新司机成单人数/过去7天内新司机数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42527 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverBDRegThreeWeek`
--

DROP TABLE IF EXISTS `DriverBDRegThreeWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverBDRegThreeWeek` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `driverCnt` int(11) DEFAULT NULL COMMENT '三周内BD注册新司机总数',
  `dayOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '三周内BD注册新司机当天登录总数',
  `dayOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '三周内BD注册新司机当天登录比例',
  `weekOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '三周内BD注册新司机在过去7天内的登录人数',
  `weekOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '三周内BD注册新司机在过去7天内的登录比例',
  `weekNotOnlineDriverCnt` int(11) DEFAULT NULL COMMENT 'BD注册过去7天未在线司机人数',
  `weekNotOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT 'BD注册过去7天未在线司机比例',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42674 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverDay`
--

DROP TABLE IF EXISTS `DriverDay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverDay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `regDriverCnt` int(11) DEFAULT NULL COMMENT '当天新注册司机数:当天新注册的司机数',
  `approvedDriverCnt` int(11) DEFAULT NULL COMMENT '当天新审核司机数:当天审核通过司机数',
  `activedDriverCnt` int(11) DEFAULT NULL COMMENT '当天新激活司机数:通过审核，且当天有上报司机数',
  `onlineDriverCnt` int(11) DEFAULT NULL COMMENT '当天在线司机数:当天有上报时间的在线司机数',
  `onlineDriverRate` float(8,3) DEFAULT NULL COMMENT '当天在线率:当天在线司机人数/总激活人数',
  `onlineMoreThan6HourDriverCnt` int(11) DEFAULT NULL COMMENT '当天6小时在线司机数:当天6小时及以上在线时长的司机人数（去重）',
  `onlineMoreThan6HourDriverRate` float(8,3) DEFAULT NULL COMMENT '当天6小时在线率:当天6小时在线司机人数/当天总在线人数',
  `striveOrderDriverCnt` int(11) DEFAULT NULL COMMENT '当天点击抢单司机数:当天有点击抢单司机数',
  `striveOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '当天抢单成功司机数:当天成功抢单司机数',
  `onlineDriverToStriveDriverRate` float(8,3) DEFAULT NULL COMMENT '当天在线司机点击抢单率:当天有点击抢单的司机人数/当天总在线人数',
  `orderStriveDriverToOrderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '当天点击抢单司机成功率:当天抢单成功司机人数/当天点击抢单总人数',
  `onlineMoreThan6hourAndStriveOrderDriverCnt` int(11) DEFAULT NULL COMMENT '当天6小时司机的点击抢单人数:当天6小时及以上在线时长，且有点击抢单的司机人数（去重）',
  `onlineMoreThan6hourAndStriveOrderDriverRate` float(8,3) DEFAULT NULL COMMENT '当天6小时在线司机点击抢单率:当天6小时司机的点击抢单人数/当天总在线人数',
  `onlineMoreThan6hourAndOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '当天6小时司机的抢单成功人数:当天6小时及以上在线时长，且抢单成功的司机人数（去重）',
  `onlineMoreThan6hourAndOrderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '当天6小时司机点击抢单成功率:当天抢单成功司机人数/当天点击抢单总人数',
  `striveCostDay` float DEFAULT NULL COMMENT '当天第一单抢单时长:当天第一次尝试抢单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `answerCostDay` float DEFAULT NULL COMMENT '当天第一单抢单成功时长:当天第一次完成抢单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `aboardCostDay` float DEFAULT NULL COMMENT '当天第一单成单时长:当天第一次完成订单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `orderBroadcastCnt` int(11) DEFAULT NULL COMMENT '当天总听单数:当天司机总听单数',
  `orderStriveCnt` int(11) DEFAULT NULL COMMENT '当天抢单次数:当天点击抢单总次数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '当天抢单成功数:当天总已应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '当天完成订单数:当天已上车订单数',
  `noOrderStriveDriverCnt` int(11) DEFAULT NULL COMMENT '当天无点击抢单司机总数:当天在线无点击抢单司机总数',
  `noOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '当天无抢单成功司机总数:当天在线抢单为0司机总人数',
  `onlineDriverAvgOrderBroadcastCnt` float DEFAULT NULL COMMENT '当天在线司机人均听单数:当天所有在线用户的听单总数/当天所有在线司机数',
  `onlineDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '当天在线司机人均抢单次数:当天点击抢单总数/当天司机在线人数',
  `onlineDriverOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '当天在线司机抢单成功率:当天抢单成功司机人数/当天在线总人数',
  `onlineDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '当天在线司机人均成功抢单数:当天所有在线用户的成功抢单总数/当天所有在线司机数',
  `onlineDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '当天在线司机人均在线时长:当天所有在线用户的在线总时长/当天在线司机数去重/统计天数',
  `strivedDriverAvgOrderbroadcastCnt` float DEFAULT NULL COMMENT '当天点击抢单司机人均听单数:当天所有点击抢单司机的听单总数/当天所有点击抢单司机数',
  `strivedDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '当天点击抢单司机人均抢单数:当天点击抢单总次数/当天司机点击抢单人数',
  `striveDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '当天点击抢单司机人均成功抢单数:当天所有点击抢单司机的成功抢单总数/当天所有点击抢单司机数',
  `striveDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '当天点击抢单司机人均在线时长:当天所有点击抢单司机的在线总时长/当天点击抢单司机数去重/统计天数',
  `orderSuccDriverAvgOrderBroadcastCnt` float DEFAULT NULL COMMENT '当天成功抢单司机人均听单数:当天所有抢单成功司机的听单总数/当天所有抢单成功司机数',
  `orderSuccDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '当天成功抢单司机人均抢单数:当天成功抢单总数/当天抢单成功司机人数',
  `orderSuccDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '当天成功抢单司机人均成功抢单数:当天所有抢单成功司机的成功抢单总数/当天所有抢单成功司机数',
  `orderSuccDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '当天成功抢单司机人均在线时长:当天所有抢单成功司机的在线总时长/当天抢单成功司机数去重/统计天数',
  `driverOnlineMins` int(11) DEFAULT NULL COMMENT '当天总在线时长:当天的司机在线总时长',
  `orderStriveRate` float(8,3) DEFAULT NULL COMMENT '当天听单抢单率:当天点击抢单总数/听单数',
  `orderSuccRate` float DEFAULT NULL,
  `orderEfficiency` float DEFAULT NULL COMMENT '当天抢单效率:当天，总成功抢单量/总在线时长',
  `orderStriveFrequency` float DEFAULT NULL COMMENT '当天抢单频率:当天，总抢单次数/总在线时长',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43722 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverMonth`
--

DROP TABLE IF EXISTS `DriverMonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverMonth` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `regDriverCnt` int(11) DEFAULT NULL COMMENT '本月新注册司机数:本月新注册的司机数',
  `approvedDriverCnt` int(11) DEFAULT NULL COMMENT '本月新审核司机数:本月审核通过司机数',
  `activedDriverCnt` int(11) DEFAULT NULL COMMENT '本月新激活司机数:通过审核，且本月有上报司机数',
  `onlineDriverCnt` int(11) DEFAULT NULL COMMENT '本月在线司机数:本月有上报时间的在线司机数',
  `onlineDriverRate` float(8,3) DEFAULT NULL COMMENT '本月在线率:本月在线司机人数/总激活人数',
  `onlineMoreThan6HourDriverCnt` int(11) DEFAULT NULL COMMENT '本月6小时在线司机数:本月6小时及以上在线时长的司机人数（去重）',
  `onlineMoreThan6HourDriverRate` float(8,3) DEFAULT NULL COMMENT '本月6小时在线率:本月6小时在线司机人数/本月总在线人数',
  `striveOrderDriverCnt` int(11) DEFAULT NULL COMMENT '本月点击抢单司机数:本月有点击抢单司机数',
  `striveOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '本月抢单成功司机数:本月成功抢单司机数',
  `onlineDriverToStriveDriverRate` float(8,3) DEFAULT NULL COMMENT '本月在线司机点击抢单率:本月有点击抢单的司机人数/本月总在线人数',
  `orderStriveDriverToOrderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '本月点击抢单司机成功率:本月抢单成功司机人数/本月点击抢单总人数',
  `onlineMoreThan6hourAndStriveOrderDriverCnt` int(11) DEFAULT NULL COMMENT '本月6小时司机的点击抢单人数:本月6小时及以上在线时长，且有点击抢单的司机人数（去重）',
  `onlineMoreThan6hourAndStriveOrderDriverRate` float(8,3) DEFAULT NULL COMMENT '本月6小时在线司机点击抢单率:本月6小时司机的点击抢单人数/本月总在线人数',
  `onlineMoreThan6hourAndOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '本月6小时司机的抢单成功人数:本月6小时及以上在线时长，且抢单成功的司机人数（去重）',
  `onlineMoreThan6hourAndOrderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '本月6小时司机点击抢单成功率:本月抢单成功司机人数/本月点击抢单总人数',
  `striveCostDay` float DEFAULT NULL COMMENT '本月第一单抢单时长:本月第一次尝试抢单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `answerCostDay` float DEFAULT NULL COMMENT '本月第一单抢单成功时长:本月第一次完成抢单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `aboardCostDay` float DEFAULT NULL COMMENT '本月第一单成单时长:本月第一次完成订单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `orderBroadcastCnt` int(11) DEFAULT NULL COMMENT '本月总听单数:本月司机总听单数',
  `orderStriveCnt` int(11) DEFAULT NULL COMMENT '本月抢单次数:本月点击抢单总次数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '本月抢单成功数:本月总已应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '本月完成订单数:本月已上车订单数',
  `noOrderStriveDriverCnt` int(11) DEFAULT NULL COMMENT '本月无点击抢单司机总数:本月在线无点击抢单司机总数',
  `noOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '本月无抢单成功司机总数:本月在线抢单为0司机总人数',
  `onlineDriverAvgOrderBroadcastCnt` float DEFAULT NULL COMMENT '本月在线司机人均听单数:本月所有在线用户的听单总数/本月所有在线司机数',
  `onlineDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '本月在线司机人均抢单次数:本月点击抢单总数/本月司机在线人数',
  `onlineDriverOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '本月在线司机抢单成功率:本月抢单成功司机人数/本月在线总人数',
  `onlineDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '本月在线司机人均成功抢单数:本月所有在线用户的成功抢单总数/本月所有在线司机数',
  `onlineDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '本月在线司机人均在线时长:本月所有在线用户的在线总时长/本月在线司机数去重/统计天数',
  `strivedDriverAvgOrderbroadcastCnt` float DEFAULT NULL COMMENT '本月点击抢单司机人均听单数:本月所有点击抢单司机的听单总数/本月所有点击抢单司机数',
  `strivedDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '本月点击抢单司机人均抢单数:本月点击抢单总次数/本月司机点击抢单人数',
  `striveDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '本月点击抢单司机人均成功抢单数:本月所有点击抢单司机的成功抢单总数/本月所有点击抢单司机数',
  `striveDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '本月点击抢单司机人均在线时长:本月所有点击抢单司机的在线总时长/本月点击抢单司机数去重/统计天数',
  `orderSuccDriverAvgOrderBroadcastCnt` float DEFAULT NULL COMMENT '本月成功抢单司机人均听单数:本月所有抢单成功司机的听单总数/本月所有抢单成功司机数',
  `orderSuccDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '本月成功抢单司机人均抢单数:本月成功抢单总数/本月抢单成功司机人数',
  `orderSuccDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '本月成功抢单司机人均成功抢单数:本月所有抢单成功司机的成功抢单总数/本月所有抢单成功司机数',
  `orderSuccDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '本月成功抢单司机人均在线时长:本月所有抢单成功司机的在线总时长/本月抢单成功司机数去重/统计天数',
  `driverOnlineMins` int(11) DEFAULT NULL COMMENT '本月总在线时长:本月的司机在线总时长',
  `orderStriveRate` float(8,3) DEFAULT NULL COMMENT '本月听单抢单率:本月点击抢单总数/听单数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '本月抢单成单率:本月抢单成功总数/点击抢单总数',
  `orderEfficiency` float DEFAULT NULL COMMENT '本月抢单效率:本月，总成功抢单量/总在线时长',
  `orderStriveFrequency` float DEFAULT NULL COMMENT '本月抢单频率:本月，总抢单次数/总在线时长',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42499 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverNatureRegThreeWeek`
--

DROP TABLE IF EXISTS `DriverNatureRegThreeWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverNatureRegThreeWeek` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `driverCnt` int(11) DEFAULT NULL COMMENT '三周内自然注册新司机总数',
  `dayOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '三周内自然注册新司机当天登录总数',
  `dayOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '三周内自然注册新司机当天登录比例',
  `weekOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '三周内自然注册新司机在过去7天内的登录人数',
  `weekOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '三周内自然注册新司机在过去7天内的登录比例',
  `weekNotOnlineDriverCnt` int(11) DEFAULT NULL COMMENT '自然注册过去7天未在线司机人数',
  `weekNotOnlineDriverRate` float(8,3) DEFAULT NULL COMMENT '自然注册过去7天未在线司机比例',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42559 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverNewOneDay`
--

DROP TABLE IF EXISTS `DriverNewOneDay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverNewOneDay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `onlineRate` float(8,3) DEFAULT NULL COMMENT '当天注册登录比例:当天注册当天有上报的新司机占比',
  `onlineCnt` int(11) DEFAULT NULL COMMENT '当天首次登录司机人数:之前无上报历史，当天第一次上报的司机',
  `onlineAvgOnlineMins` int(11) DEFAULT NULL COMMENT '首次登录司机当天人均在线时间:之前无上报历史，当天第一次上报的司机人均在线时长',
  `online3HoursRate` float(8,3) DEFAULT NULL COMMENT '首次登录司机在线超过3小时比例:之前无上报历史，当天第一次上报的司机中在线超过三小时的用户比例',
  `onlineLess3HoursRate` float(8,3) DEFAULT NULL COMMENT '首次登录司机在线小于3小时比例:之前无上报历史，当天第一次上报的司机中在线小于三小时的用户比例',
  `avgOrderBroadcastCnt` float DEFAULT NULL COMMENT '首次登录司机当天人均听单数:之前无上报历史，当天第一次上报的司机，人均的听单次数',
  `orderBroadcastDriverCnt` int(11) DEFAULT NULL COMMENT '首次登录司机当天听单人数:之前无上报历史，当天第一次上报的司机中有听单的司机人数',
  `orderBroadcastDriverRate` float(8,3) DEFAULT NULL COMMENT '首次登录司机当天听单占比:之前无上报历史，当天第一次上报的司机中有听单的司机人数占比',
  `driverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '首次登录司机人均抢单数:之前无上报历史，当天第一次上报的司机，人均的抢单次数',
  `orderStriveDriverCnt` int(11) DEFAULT NULL COMMENT '首次登录司机当天抢单人数:之前无上报历史，当天第一次上报的司机中有抢单的司机人数',
  `orderStriveDriverRate` float(8,3) DEFAULT NULL COMMENT '首次登录司机当天抢单占比:之前无上报历史，当天第一次上报的司机，当天有抢单的司机人数占比',
  `driverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '首次登录司机人均成单数:之前无上报历史，当天第一次上报的司机，人均的成单数',
  `orderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '首次登录司机当天成单人数:之前无上报历史，当天第一次上报的司机，当天有成单的司机',
  `orderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '首次登录司机及当天成单占比:之前无上报历史，当天第一次上报且成单的司机/之前无上报历史，当天第一次上报的司机',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42762 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverNewThreeDays`
--

DROP TABLE IF EXISTS `DriverNewThreeDays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverNewThreeDays` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `driverCnt` int(11) DEFAULT NULL COMMENT '三天前新登录司机总数:三天前审核通过的司机 总数',
  `online1DayRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机登录一天占比:三天前审核通过的司机 近三天登录总天数为1天的司机占比',
  `online2DayRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机登录二天占比:三天前审核通过的司机 近三天登录总天数为2天的司机占比',
  `online3DayRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机登录三天占比:三天前审核通过的司机 近三天登录总天数为3天的司机占比',
  `orderSucc1DayRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机成单一天占比:三天前审核通过的司机 近三天有1天有成单记录的司机占比',
  `orderSucc2DayRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机成单二天占比:三天前审核通过的司机 近三天有2天有成单记录的司机占比',
  `orderSucc3DayRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机成单三天占比:三天前审核通过的司机 近三天有3天有成单记录的司机占比',
  `avgOrderSuccCntPerDay` float DEFAULT NULL COMMENT '三天内新司机三天内人均每天成单数:三天前审核通过的司机，三天内人均每天成单数',
  `avgOrderBroadcastCntPerDay` float DEFAULT NULL COMMENT '三天内新司机三天内人均每天听单数:三天前审核通过的司机，三天内人均每天听单数',
  `avgOrderStriveCntPerDay` float DEFAULT NULL COMMENT '三天内新司机三天内人均每天抢单数:三天前审核通过的司机，三天内人均每天抢单数',
  `orderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '三天内新司机成单人数去重:三天前审核通过的司机，三天内有成单的人数去重',
  `orderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '三天内新司机成单人数占比:三天前审核通过的司机，三天内有成单的人数占比',
  `orderBreakRate` float(8,3) DEFAULT NULL COMMENT '新司机三天内被爽约率:三天前审核通过的司机，三天内被爽约的人数占比',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42872 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverOnlineDay`
--

DROP TABLE IF EXISTS `DriverOnlineDay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverOnlineDay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `onlineLessThan10MinsDriverRate` float(8,3) DEFAULT NULL COMMENT '当天在线小于10分钟人数占比:当天在线《10分钟人数/已激活人数',
  `onlineLessThan1HoursDriverRate` float(8,3) DEFAULT NULL COMMENT '当天在线小于1小时人数占比:当天在线《1小时人数/已激活人数',
  `onlineLessThan3HoursDriverRate` float(8,3) DEFAULT NULL COMMENT '当天在线小于3小时人数占比:当天在线《3小时人数/已激活人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=44118 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverOnlineMonth`
--

DROP TABLE IF EXISTS `DriverOnlineMonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverOnlineMonth` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `onlineLessThan10MinsDriverRate` float(8,3) DEFAULT NULL COMMENT '过去30天在线小于10分钟人数占比:过去30天在线《10分钟人数/已激活人数',
  `onlineLessThan1HoursDriverRate` float(8,3) DEFAULT NULL COMMENT '过去30天在线小于1小时人数占比:过去30天在线《1小时人数/已激活人数',
  `onlineLessThan3HoursDriverRate` float(8,3) DEFAULT NULL COMMENT '过去30天在线小于3小时人数占比:过去30天在线《3小时人数/已激活人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43858 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverOnlineWeek`
--

DROP TABLE IF EXISTS `DriverOnlineWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverOnlineWeek` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `onlineLessThan10MinsDriverRate` float(8,3) DEFAULT NULL COMMENT '过去7天在线小于10分钟人数占比:过去7天在线《10分钟人数/已激活人数',
  `onlineLessThan1HoursDriverRate` float(8,3) DEFAULT NULL COMMENT '过去7天在线小于1小时人数占比:过去7天在线《1小时人数/已激活人数',
  `onlineLessThan3HoursDriverRate` float(8,3) DEFAULT NULL COMMENT '过去7天在线小于3小时人数占比:过去7天在线《3小时人数/已激活人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=44154 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverOrder`
--

DROP TABLE IF EXISTS `DriverOrder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverOrder` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderDriverRate` float DEFAULT NULL,
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '成交率:成功订单量/订单量',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43220 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverReg`
--

DROP TABLE IF EXISTS `DriverReg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverReg` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `driver_reg_all` int(11) DEFAULT NULL COMMENT '历史总注册司机数',
  `driver_bdreg_all` int(11) DEFAULT NULL COMMENT 'bd来源注册司机数',
  `driver_newreg_today` int(11) DEFAULT NULL COMMENT '今日新注册司机数',
  `driver_6houronline_ratio` float DEFAULT NULL COMMENT '今日6小时在线司机比例',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=25378 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverRegOnline`
--

DROP TABLE IF EXISTS `DriverRegOnline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverRegOnline` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `dayNatureRegOnlineCnt` int(11) DEFAULT NULL COMMENT '今日自然注册今日在线司机数',
  `weekNatureRegOnlineCnt` int(11) DEFAULT NULL COMMENT '本周自然注册且本周在线司机数',
  `monthNatureRegOnlineCnt` int(11) DEFAULT NULL COMMENT '本月自然注册且本月在线司机数',
  `dayNatureReg6HoursOnlineCnt` int(11) DEFAULT NULL COMMENT '今日自然注册司机今日6小时在线数',
  `dayNatureRegNotOnlineCnt` int(11) DEFAULT NULL COMMENT '今日自然注册司机今日未在线数',
  `weekNatureRegOnlineRate` float(8,3) DEFAULT NULL COMMENT '自然注册司机周在线率:本周自然注册且在线司机数/本周自然注册司机总数',
  `monthNatureRegOnlineRate` float(8,3) DEFAULT NULL COMMENT '自然注册司机月在线率:本月自然注册且在线司机数/本月自然注册司机总数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43713 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverRegPeriod3MonthsAnd6Months`
--

DROP TABLE IF EXISTS `DriverRegPeriod3MonthsAnd6Months`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverRegPeriod3MonthsAnd6Months` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `activeCnt` int(11) DEFAULT NULL COMMENT '3-6个月注册已激活司机人数:3-6个月内注册且已激活的司机人数',
  `weekOnlineCnt` int(11) DEFAULT NULL COMMENT '3-6个月注册司机过去7天在线人数:3-6个月内注册已激活的司机，过去7天总在线人数',
  `weekStriveCnt` int(11) DEFAULT NULL COMMENT '3-6个月注册司机过去7天点击抢单人数:3-6个月内注册已激活的司机，过去7天总点击抢单人数',
  `weekOrderSuccCnt` int(11) DEFAULT NULL COMMENT '3-6个月注册司机过去7天抢单成功人数:3-6个月内注册已激活的司机，过去7天总抢单成功人数',
  `weekStayRate` float(8,3) DEFAULT NULL COMMENT '3-6个月注册司机过去7天留存率:3-6个月内注册已激活的司机，过去7天总在线人数/3-6个月内注册已激活人数',
  `weekStriveRate` float(8,3) DEFAULT NULL COMMENT '3-6个月注册司机过去7天点击抢单占比:3-6个月内注册已激活的司机，过去7天总点击抢单人数/过去7天总在线人数',
  `weekOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '3-6个月注册司机过去7天抢单成功人数占比:3-6个月内注册已激活的司机，过去7天总抢单成功人数/过去7天总在线人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43455 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverRegPeriod3Weeks`
--

DROP TABLE IF EXISTS `DriverRegPeriod3Weeks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverRegPeriod3Weeks` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `activeCnt` int(11) DEFAULT NULL COMMENT '近3周注册已激活司机人数:近三周内注册，且有过一次上报时间的激活新司机人数',
  `weekOnlineCnt` int(11) DEFAULT NULL COMMENT '近3周注册司机过去7天在线人数:近三周内注册已激活新司机，过去7天总在线人数',
  `weekStriveCnt` int(11) DEFAULT NULL COMMENT '近3周注册司机过去7天点击抢单司机人数:近三周注册已激活的司机，过去7天总抢单成功人数',
  `weekOrderSuccCnt` int(11) DEFAULT NULL COMMENT '近3周注册司机过去7天抢单成功司机人数:近三周注册已激活的司机，过去7天总抢单成功人数',
  `weekStayRate` float(8,3) DEFAULT NULL COMMENT '近3周注册司机过去7天留存率:近三周内注册已激活的新司机，过去7天总在线人数/近三周内注册已激活人数',
  `weekStriveRate` float(8,3) DEFAULT NULL COMMENT '近3周注册司机过去7天点击抢单占比:近三周注册已激活的司机，过去7天总点击抢单人数/过去7天总在线人数',
  `weekOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '近3周注册司机过去7天抢单成功人数占比:近三周注册已激活的司机，过去7天总抢单成功人数/过去7天总在线人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43456 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverRegPeriod3WeeksAnd3Months`
--

DROP TABLE IF EXISTS `DriverRegPeriod3WeeksAnd3Months`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverRegPeriod3WeeksAnd3Months` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `activeCnt` int(11) DEFAULT NULL COMMENT '3周-3个月注册已激活司机人数:三周前-3个月内注册且已激活的司机人数',
  `weekOnlineCnt` int(11) DEFAULT NULL COMMENT '3周-3个月注册司机过去7天在线人数:三周前-3个月内注册已激活的司机，过去7天总在线人数',
  `weekStriveCnt` int(11) DEFAULT NULL COMMENT '3周-3个月注册司机过去7天点击抢单人数:三周前-3个月内注册已激活的司机，过去7天总点击抢单人数',
  `weekOrderSuccCnt` int(11) DEFAULT NULL COMMENT '3周-3个月注册司机过去7天抢单成功人数:三周前-3个月内注册已激活的司机，过去7天总抢单成功人数',
  `weekStayRate` float(8,3) DEFAULT NULL COMMENT '3周-3个月注册司机过去7天留存率:三周前-3个月内注册已激活的司机，过去7天总在线人数/三周前-3个月内注册已激活人数',
  `weekStriveRate` float(8,3) DEFAULT NULL COMMENT '3周-3个月注册司机过去7天点击抢单占比:三周前-3个月内注册已激活的司机，过去7天总点击抢单人数/过去7天总在线人数',
  `weekOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '3周-3个月注册司机过去7天抢单成功人数占比:三周前-3个月内注册已激活的司机，过去7天总抢单成功人数/过去7天总在线人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43457 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverRegPeriodBefore6Months`
--

DROP TABLE IF EXISTS `DriverRegPeriodBefore6Months`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverRegPeriodBefore6Months` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `activeCnt` int(11) DEFAULT NULL COMMENT '6个月以前注册已激活司机人数:6个月以前注册且已激活的司机人数',
  `weekOnlineCnt` int(11) DEFAULT NULL COMMENT '6个月以前注册司机过去7天在线人数:6个月以前注册已激活的司机，过去7天总在线人数',
  `weekStriveCnt` int(11) DEFAULT NULL COMMENT '6个月以前注册司机过去7天点击抢单人数:6个月以前注册已激活的司机，过去7天总点击抢单人数',
  `weekOrderSuccCnt` int(11) DEFAULT NULL COMMENT '6个月以前注册司机过去7天抢单成功人数:6个月以前注册已激活的司机，过去7天总抢单成功人数',
  `weekStayRate` float(8,3) DEFAULT NULL COMMENT '6个月以前注册司机过去7天留存率:6个月以前注册已激活的司机，过去7天总在线人数/6个月以前注册已激活人数',
  `weekStriveRate` float(8,3) DEFAULT NULL COMMENT '6个月以前注册点击抢单司机占比:6个月以前注册已激活的司机，过去7天总点击抢单人数/过去7天总在线人数',
  `weekOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '6个月以前注册司机过去7天抢单成功人数占比:6个月以前注册已激活的司机，过去7天总抢单成功人数/过去7天总在线人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=43605 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverRetentionRates`
--

DROP TABLE IF EXISTS `DriverRetentionRates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverRetentionRates` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `save_ratio` float DEFAULT NULL COMMENT '司机周留存率',
  `month_save_ratio` float DEFAULT NULL COMMENT '司机月留存率',
  `nobdsave_ratio` float DEFAULT NULL COMMENT '自然注册司机周留存率',
  `bdsave_ratio` float DEFAULT NULL COMMENT 'bd注册司机周留存率',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=7172 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverStay`
--

DROP TABLE IF EXISTS `DriverStay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverStay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `weekDriverStayRate` float(8,3) DEFAULT NULL COMMENT '周留存率:一周前注册且已激活的司机，在过去7天总在线人数/一周前注册现已激活人数',
  `monthDriverStayRate` float(8,3) DEFAULT NULL COMMENT '月留存率:一个月前注册已激活的司机在本月在线总人数/一个月前总注册已激活人数',
  `weekBDDriverStayRate` float(8,3) DEFAULT NULL COMMENT 'BD周留存率:一周前BD来源注册且已激活的所有司机，在过去7天总在线人数/一周前BD来源注册已激活人数',
  `weekNatureDriverStayRate` float(8,3) DEFAULT NULL COMMENT '自然注册周留存率:一周前其他注册来源注册且已激活的所有司机，在过去7天总在线人数/一周前其他注册来源注册已激活人数',
  `weekDriverRunoffRate` float(8,3) DEFAULT NULL COMMENT '周流失率:过去第8-14天在线的司机在过去7天内不在线的人数/过去第8-14天在线司机总数',
  `monthDriverRunoffRate` float(8,3) DEFAULT NULL COMMENT '月流失率:过去第31-60天在线的司机在过去30天内不在线的人数/过去第31-60天在线司机总数',
  `lastweekOnlineDriverDayOnlineStayRate` float(8,3) DEFAULT NULL COMMENT '上周在线用户当天在线留存率:上周有过在线，在当天在线的司机人数/上周在线总人数',
  `lastweekOrderStriveDriverDayOnlineStayRate` float(8,3) DEFAULT NULL COMMENT '上周抢单用户当天在线留存率:上周有过点击抢单，在当天再点击抢单的司机人数/上周有点击抢单总人数',
  `lastweekOrderSuccDriverDayOnlineStayRate` float(8,3) DEFAULT NULL COMMENT '上周成单用户当天在线留存率:上周有过抢单成功，在当天再抢单成功的司机人数/上周抢单成功总人数',
  `reportIsNullDriverCnt` int(11) DEFAULT NULL COMMENT '历史上报为空司机人数:截止到当前，从没有过上报时间的已审核司机总人数',
  `monthNoReportRegThisMonthDriverCnt` int(11) DEFAULT NULL COMMENT '本月注册上报为空司机人数:当月注册从没有过上报时间的已审核司机总人数',
  `reportIsNullDriverRate` float(8,3) DEFAULT NULL COMMENT '历史无上报司机占所有注册用户比:历史上报为空人数/已审核总注册人数',
  `weekNoReportDriverCnt` int(11) DEFAULT NULL COMMENT '过去7天沉默司机数:过去7天没有上报时间的已激活总司机人数（去重）',
  `monthNoReportDriverCnt` int(11) DEFAULT NULL COMMENT '过去30天沉默司机数:过去30天没有上报时间的已激活总司机人数（去重）',
  `day3DayNoReportDriverCnt` int(11) DEFAULT NULL COMMENT '距上次登录连续3天未上报司机数:当天距上次登录连续3天未上报司机数',
  `day3DayNoOrderStriveDriverCnt` int(11) DEFAULT NULL COMMENT '距上次抢单连续3天未抢单司机数:当天距上次抢单连续3天未有点击抢单的司机数',
  `day3DayNoOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '距上次成单连续3天未成单司机数:当天距上次抢单连续3天未抢单成功的司机数',
  `twoWeeksOnlineAndNoOrderStriveDriverCnt` int(11) DEFAULT NULL COMMENT '两周在线且未抢单司机数',
  `twoWeeksOnlineAndNoOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '两周在线且未抢单成功司机数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=42602 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverTotalReg`
--

DROP TABLE IF EXISTS `DriverTotalReg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverTotalReg` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `driverRegNum` int(11) DEFAULT NULL COMMENT '司机总注册人数:司机总注册人数',
  `driverApprovedNum` int(11) DEFAULT NULL COMMENT '司机总审核人数:司机注册已审核总人数',
  `driverActivedNum` int(11) DEFAULT NULL COMMENT '司机总激活人数:司机注册已激活总人数',
  `driverRegNumFromBD` int(11) DEFAULT NULL COMMENT 'BD来源司机总注册人数:BD来源司机总注册人数',
  `driverActivedNumFromBD` int(11) DEFAULT NULL COMMENT 'BD来源司机总激活人数:BD来源司机注册已激活总人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=44263 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DriverWeek`
--

DROP TABLE IF EXISTS `DriverWeek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DriverWeek` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `regDriverCnt` int(11) DEFAULT NULL COMMENT '本周新注册司机数:本周新注册的司机数',
  `approvedDriverCnt` int(11) DEFAULT NULL COMMENT '本周新审核司机数:本周审核通过司机数',
  `activedDriverCnt` int(11) DEFAULT NULL COMMENT '本周新激活司机数:通过审核，且本周有上报司机数',
  `onlineDriverCnt` int(11) DEFAULT NULL COMMENT '本周在线司机数:本周有上报时间的在线司机数',
  `onlineDriverRate` float DEFAULT NULL,
  `onlineMoreThan6HourDriverCnt` int(11) DEFAULT NULL COMMENT '本周6小时在线司机数:本周6小时及以上在线时长的司机人数（去重）',
  `onlineMoreThan6HourDriverRate` float(8,3) DEFAULT NULL COMMENT '本周6小时在线率:本周6小时在线司机人数/本周总在线人数',
  `striveOrderDriverCnt` int(11) DEFAULT NULL COMMENT '本周点击抢单司机数:本周有点击抢单司机数',
  `striveOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '本周抢单成功司机数:本周成功抢单司机数',
  `onlineDriverToStriveDriverRate` float(8,3) DEFAULT NULL COMMENT '本周在线司机点击抢单率:本周有点击抢单的司机人数/本周总在线人数',
  `orderStriveDriverToOrderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '本周点击抢单司机成功率:本周抢单成功司机人数/本周点击抢单总人数',
  `onlineMoreThan6hourAndStriveOrderDriverCnt` int(11) DEFAULT NULL COMMENT '本周6小时司机的点击抢单人数:本周6小时及以上在线时长，且有点击抢单的司机人数（去重）',
  `onlineMoreThan6hourAndStriveOrderDriverRate` float(8,3) DEFAULT NULL COMMENT '本周6小时在线司机点击抢单率:本周6小时司机的点击抢单人数/本周总在线人数',
  `onlineMoreThan6hourAndOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '本周6小时司机的抢单成功人数:本周6小时及以上在线时长，且抢单成功的司机人数（去重）',
  `onlineMoreThan6hourAndOrderSuccDriverRate` float(8,3) DEFAULT NULL COMMENT '本周6小时司机点击抢单成功率:本周抢单成功司机人数/本周点击抢单总人数',
  `striveCostDay` float DEFAULT NULL COMMENT '本周第一单抢单时长:本周第一次尝试抢单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `answerCostDay` float DEFAULT NULL COMMENT '本周第一单抢单成功时长:本周第一次完成抢单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `aboardCostDay` float DEFAULT NULL COMMENT '本周第一单成单时长:本周第一次完成订单的所有司机，完成该单前的总在线时长（从注册到第一单）',
  `orderBroadcastCnt` int(11) DEFAULT NULL COMMENT '本周总听单数:本周司机总听单数',
  `orderStriveCnt` int(11) DEFAULT NULL COMMENT '本周抢单次数:本周点击抢单总次数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '本周抢单成功数:本周总已应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '本周完成订单数:本周已上车订单数',
  `noOrderStriveDriverCnt` int(11) DEFAULT NULL COMMENT '本周无点击抢单司机总数:本周在线无点击抢单司机总数',
  `noOrderSuccDriverCnt` int(11) DEFAULT NULL COMMENT '本周无抢单成功司机总数:本周在线抢单为0司机总人数',
  `onlineDriverAvgOrderBroadcastCnt` float DEFAULT NULL COMMENT '本周在线司机人均听单数:本周所有在线用户的听单总数/本周所有在线司机数',
  `onlineDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '本周在线司机人均抢单次数:本周点击抢单总数/本周司机在线人数',
  `onlineDriverOrderSuccRate` float(8,3) DEFAULT NULL COMMENT '本周在线司机抢单成功率:本周抢单成功司机人数/本周在线总人数',
  `onlineDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '本周在线司机人均成功抢单数:本周所有在线用户的成功抢单总数/本周所有在线司机数',
  `onlineDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '本周在线司机人均在线时长:本周所有在线用户的在线总时长/本周在线司机数去重/统计天数',
  `strivedDriverAvgOrderbroadcastCnt` float DEFAULT NULL COMMENT '本周点击抢单司机人均听单数:本周所有点击抢单司机的听单总数/本周所有点击抢单司机数',
  `strivedDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '本周点击抢单司机人均抢单数:本周点击抢单总次数/本周司机点击抢单人数',
  `striveDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '本周点击抢单司机人均成功抢单数:本周所有点击抢单司机的成功抢单总数/本周所有点击抢单司机数',
  `striveDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '本周点击抢单司机人均在线时长:本周所有点击抢单司机的在线总时长/本周点击抢单司机数去重/统计天数',
  `orderSuccDriverAvgOrderBroadcastCnt` float DEFAULT NULL COMMENT '本周成功抢单司机人均听单数:本周所有抢单成功司机的听单总数/本周所有抢单成功司机数',
  `orderSuccDriverAvgOrderStriveCnt` float DEFAULT NULL COMMENT '本周成功抢单司机人均抢单数:本周成功抢单总数/本周抢单成功司机人数',
  `orderSuccDriverAvgOrderSuccCnt` float DEFAULT NULL COMMENT '本周成功抢单司机人均成功抢单数:本周所有抢单成功司机的成功抢单总数/本周所有抢单成功司机数',
  `orderSuccDriverAvgOnlineMins` int(11) DEFAULT NULL COMMENT '本周成功抢单司机人均在线时长:本周所有抢单成功司机的在线总时长/本周抢单成功司机数去重/统计天数',
  `driverOnlineMins` int(11) DEFAULT NULL COMMENT '本周总在线时长:本周的司机在线总时长',
  `orderStriveRate` float(8,3) DEFAULT NULL COMMENT '本周听单抢单率:本周点击抢单总数/听单数',
  `orderSuccRate` float DEFAULT NULL,
  `orderEfficiency` float DEFAULT NULL COMMENT '本周抢单效率:本周，总成功抢单量/总在线时长',
  `orderStriveFrequency` float DEFAULT NULL COMMENT '本周抢单频率:本周，总抢单次数/总在线时长',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=46992 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FirstCallPassengerReplay`
--

DROP TABLE IF EXISTS `FirstCallPassengerReplay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FirstCallPassengerReplay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `firstcallreplaycnt` int(11) DEFAULT NULL COMMENT '首次呼叫乘客发单应答数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=69841 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderAirport`
--

DROP TABLE IF EXISTS `OrderAirport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderAirport` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日机场订单呼叫数',
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日机场订单数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '今日机场订单应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日机场订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日机场订单成功率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=135916 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderCall`
--

DROP TABLE IF EXISTS `OrderCall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderCall` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫数:用户通过语音、文本（滑动）或预约方式新创建的订单数，同时加上无司机应答时，用户重发订单数。',
  `orderRecallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫重发次数',
  `recallOrderCnt` int(11) DEFAULT NULL COMMENT '今日呼叫重发订单数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=135913 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderComplaint`
--

DROP TABLE IF EXISTS `OrderComplaint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderComplaint` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderComplainNum` int(11) DEFAULT NULL COMMENT '今日订单投诉数',
  `orderComplainRate` float(8,3) DEFAULT NULL COMMENT '今日订单投诉率:今日订单投诉数/今日订单数',
  `orderRealComplainNum` int(11) DEFAULT NULL COMMENT '今日实时订单投诉数',
  `orderRealPassengerComplainNum` int(11) DEFAULT NULL COMMENT '今日实时订单乘投司数',
  `orderRealDriverComplainNum` int(11) DEFAULT NULL COMMENT '今日实时订单司投乘数',
  `orderRealPassengerDriverComplainNum` int(11) DEFAULT NULL COMMENT '今日实时订单司乘互投数',
  `orderPreComplainNum` int(11) DEFAULT NULL COMMENT '今日预约订单投诉数',
  `orderComplainUncheckNum` int(11) DEFAULT NULL COMMENT '今日订单未审核投诉数',
  `orderComplainCheckRate` float(8,3) DEFAULT NULL COMMENT '今日办结率:今日订单投诉办结数/今日订单投诉数',
  `orderSuccComplainRate` float(8,3) DEFAULT NULL COMMENT '今日成功订单投诉率:今日成功订单投诉数/今日成功订单数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=133267 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderDay`
--

DROP TABLE IF EXISTS `OrderDay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderDay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日订单数:订单数指用户通过语音、文本（滑动）或预约方式新创建的订单数。不包括重发数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '今日订单应答数:用户发出的订单有司机抢单应答，记作已应答订单',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日订单成功数:乘客或司机点击“已上车”、或无点击订单30分钟后订单状态流转为“已上车”，记作“成功订单”',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日订单成功率',
  `yesterdayOrderSuccCnt` int(11) DEFAULT NULL COMMENT '昨日成功抢单数:不排除排除投诉、爽约、刷单、结束订单等未完成接送和违规订单的抢单数',
  `yesterdayPureOrderSuccCnt` int(11) DEFAULT NULL COMMENT '昨日纯粹成功订单数:排除投诉、爽约、刷单、结束订单等未完成接送和违规订单的抢单数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=133455 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderDayCallTip`
--

DROP TABLE IF EXISTS `OrderDayCallTip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderDayCallTip` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `orderdaycallnum` int(11) DEFAULT NULL COMMENT '今日呼叫次数',
  `orderdaycallreplynum` int(11) DEFAULT NULL COMMENT '今日呼叫应答数',
  `orderdaycallsuccrate` float DEFAULT NULL COMMENT '今日呼叫成功率',
  `orderdaytipnum` int(11) DEFAULT NULL COMMENT '今日加价发单数',
  `orderdaytipreplynum` int(11) DEFAULT NULL COMMENT '今日加价应答数',
  `orderdaytipsuccrate` float DEFAULT NULL COMMENT '今日加价成功率',
  `orderdaytip0yuannum` int(11) DEFAULT NULL COMMENT '今日加价0元发单数',
  `orderdaytip0yuanreplynum` int(11) DEFAULT NULL COMMENT '今日0元加价单应答数',
  `orderdaytip0yuansuccrate` float DEFAULT NULL COMMENT '今日0元加价单成功率',
  `orderdaytip5yuannum` int(11) DEFAULT NULL COMMENT '今日加价5元发单数',
  `orderdaytip5yuanreplynum` int(11) DEFAULT NULL COMMENT '今日5元加价单应答数',
  `orderdaytip5yuansuccrate` float DEFAULT NULL COMMENT '今日5元加价单成功率',
  `orderdaytip10yuannum` int(11) DEFAULT NULL COMMENT '今日加价10元发单数',
  `orderdaytip10yuanreplynum` int(11) DEFAULT NULL COMMENT '今日10元加价单应答数',
  `orderdaytip10yuansuccrate` float DEFAULT NULL COMMENT '今日10元加价单成功率',
  `orderdaytip20yuannum` int(11) DEFAULT NULL COMMENT '今日加价20元发单数',
  `orderdaytip20yuanreplynum` int(11) DEFAULT NULL COMMENT '今日20元加价单应答数',
  `orderdaytip20yuansuccrate` float DEFAULT NULL COMMENT '今日20元加价单成功率',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=69841 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderNeed`
--

DROP TABLE IF EXISTS `OrderNeed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderNeed` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderNeedCnt` int(11) DEFAULT NULL COMMENT '今日需求数:同一用户连续发出的订单间隔时间小于10分钟、地点距离间隔小于2km，此连续的订单只记作同一需求。',
  `orderNeedAnswerCnt` int(11) DEFAULT NULL COMMENT '今日需求应答数:暂无',
  `orderNeedSuccCnt` int(11) DEFAULT NULL COMMENT '今日需求成功数',
  `orderNeedSuccRate` float(8,3) DEFAULT NULL COMMENT '今日需求成功率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132343 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderPre`
--

DROP TABLE IF EXISTS `OrderPre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderPre` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日预约订单呼叫数',
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日预约订单数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '今日预约订单应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日预约订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日预约订单成功率',
  `orderBroadcastCnt` int(11) DEFAULT NULL COMMENT '今日预约订单播送数',
  `orderStriveCnt` int(11) DEFAULT NULL COMMENT '今日预约订单抢单数',
  `orderStriveRate` float(8,3) DEFAULT NULL COMMENT '今日预约订单听单抢单率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=129342 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderReal`
--

DROP TABLE IF EXISTS `OrderReal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderReal` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日实时订单呼叫数',
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日实时订单数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '今日实时订单应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日实时订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日实时订单成功率',
  `orderBroadcastCnt` int(11) DEFAULT NULL COMMENT '今日实时订单播送数',
  `orderStriveCnt` int(11) DEFAULT NULL COMMENT '今日实时订单抢单数',
  `orderStriveRate` float(8,3) DEFAULT NULL COMMENT '今日实时订单听单抢单率:今日实时订单抢单数/今日实时订单听单数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=129262 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderText`
--

DROP TABLE IF EXISTS `OrderText`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderText` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日文本订单呼叫数',
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日文本订单数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '今日文本订单应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日文本订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日文本订单成功率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=133003 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderTip`
--

DROP TABLE IF EXISTS `OrderTip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderTip` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderDayTipNum` int(11) DEFAULT NULL COMMENT '今日加价订单数',
  `orderDayTipSuccNum` int(11) DEFAULT NULL COMMENT '今日加价订单成功数',
  `orderDayTipSuccRate` float(8,3) DEFAULT NULL COMMENT '今日加价订单成功率',
  `orderDayTip0YuanNum` int(11) DEFAULT NULL COMMENT '今日0元加价订单数',
  `orderDayTip0YuanSuccNum` int(11) DEFAULT NULL COMMENT '今日0元加价订单成功数',
  `orderDayTip0YuanSuccRate` float(8,3) DEFAULT NULL COMMENT '今日0元加价订单成功率',
  `orderDayTip5YuanNum` int(11) DEFAULT NULL COMMENT '今日5元加价订单数',
  `orderDayTip5YuanSuccNum` int(11) DEFAULT NULL COMMENT '今日5元加价订单成功数',
  `orderDayTip5YuanSuccRate` float(8,3) DEFAULT NULL COMMENT '今日5元加价订单成功率',
  `orderDayTip10YuanNum` int(11) DEFAULT NULL COMMENT '今日10元加价订单数',
  `orderDayTip10YuanSuccNum` int(11) DEFAULT NULL COMMENT '今日10元加价订单成功数',
  `orderDayTip10YuanSuccRate` float(8,3) DEFAULT NULL COMMENT '今日10元加价订单成功率',
  `orderDayTip20YuanNum` int(11) DEFAULT NULL COMMENT '今日20元加价订单数',
  `orderDayTip20YuanSuccNum` int(11) DEFAULT NULL COMMENT '今日20元加价订单成功数',
  `orderDayTip20YuanSuccRate` float(8,3) DEFAULT NULL COMMENT '今日20元加价订单成功率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132707 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderTotal`
--

DROP TABLE IF EXISTS `OrderTotal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderTotal` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `totalOrderCnt` int(11) DEFAULT NULL COMMENT '历史总订单数',
  `totalOrderSuccCnt` int(11) DEFAULT NULL COMMENT '历史总订单成功数',
  `totalRealOrderCnt` int(11) DEFAULT NULL COMMENT '历史总实时订单数',
  `totalRealOrderSuccCnt` int(11) DEFAULT NULL COMMENT '历史总实时订单成功数',
  `totalPreOrderCnt` int(11) DEFAULT NULL COMMENT '历史总预约订单数',
  `totalPreOrderSuccCnt` int(11) DEFAULT NULL COMMENT '历史总预约订单成功数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132430 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderVoice`
--

DROP TABLE IF EXISTS `OrderVoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrderVoice` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日语音订单呼叫数',
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日语音订单数',
  `orderAnswerCnt` int(11) DEFAULT NULL COMMENT '今日语音订单应答数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日语音订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日语音订单成功率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=133453 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerCall`
--

DROP TABLE IF EXISTS `PassengerCall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerCall` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `todayRegAndCallTransferRate` float(8,3) DEFAULT NULL COMMENT '当天注册乘客呼叫转化率:当日注册并呼叫的乘客数/当日注册乘客数',
  `todayRegAndCallPassengerCnt` int(11) DEFAULT NULL COMMENT '今日注册今日呼叫乘客数:当日注册且在当日发起呼叫的乘客数',
  `notTodayRegAndCallPassengerCnt` int(11) DEFAULT NULL COMMENT '往日注册今日呼叫乘客数:往日注册且在当日发起首次呼叫的乘客数',
  `weekCallPassengerCnt` int(11) DEFAULT NULL COMMENT '过去7天，发出订单的用户数（去重）',
  `monthCallPassengerCnt` int(11) DEFAULT NULL COMMENT '过去30天，发出订单的用户数（去重）',
  `todayRegAndCallRate` float(8,3) DEFAULT NULL COMMENT '今日注册乘客呼叫人数占比:当天注册的新乘客呼叫人数/当天总乘客呼叫人数',
  `notTodayRegAndCallRate` float(8,3) DEFAULT NULL COMMENT '往日注册乘客呼叫人数占比:在当天呼叫人数/当天总乘客呼叫人数',
  `monthRegAndCallRate` float(8,3) DEFAULT NULL COMMENT '过去30天注册乘客呼叫人数占比:过去30天注册的新乘客呼叫人数/过去30天总乘客呼叫人数',
  `notMonthRegAndCallRate` float(8,3) DEFAULT NULL COMMENT '过去30天注册乘客呼叫人数占比:过去30天以前注册的老乘客，在过去30天呼叫人数/过去30天总乘客呼叫人数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132467 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerCallFirst`
--

DROP TABLE IF EXISTS `PassengerCallFirst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerCallFirst` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '新呼叫乘客订单呼叫次数:今日首次呼叫乘客订单的呼叫次数',
  `orderCnt` int(11) DEFAULT NULL COMMENT '新呼叫乘客订单数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '新呼叫乘客订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '新呼叫乘客订单成功率',
  `firstCallSuccRate` float(8,3) DEFAULT NULL COMMENT '新呼叫乘客首次呼叫成功率:今日首次呼叫乘客首次呼叫订单成功率',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132131 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerCallHistory`
--

DROP TABLE IF EXISTS `PassengerCallHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerCallHistory` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `firstCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫为历史第一次呼叫乘客数',
  `secondCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫为历史第二次呼叫乘客数',
  `thirdCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫为历史第三次呼叫乘客数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132904 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerCallMonth`
--

DROP TABLE IF EXISTS `PassengerCallMonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerCallMonth` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `firstCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫为本月第一次呼叫乘客数',
  `secondCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫为本月第二次呼叫乘客数',
  `thirdCallCnt` int(11) DEFAULT NULL COMMENT '今日呼叫为本月第三次呼叫乘客数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=128005 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerNotTodayReg`
--

DROP TABLE IF EXISTS `PassengerNotTodayReg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerNotTodayReg` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCnt` int(11) DEFAULT NULL COMMENT '往日注册乘客今日订单数',
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '往日注册乘客今日呼叫数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '往日注册乘客今日订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '往日注册乘客今日订单成功率',
  `orderNeedCnt` int(11) DEFAULT NULL COMMENT '往日注册乘客今日呼叫需求数:暂无',
  `orderNeedSuccCnt` int(11) DEFAULT NULL COMMENT '往日注册乘客今日需求成功数:暂无',
  `orderNeedSuccRate` float(8,3) DEFAULT NULL COMMENT '往日注册乘客今日需求成功率:暂无',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132343 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerOrder`
--

DROP TABLE IF EXISTS `PassengerOrder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerOrder` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) DEFAULT '0',
  `new_pass_call_times` int(11) DEFAULT NULL COMMENT '今日新增乘客今日呼叫数',
  `passcallsuccs` int(11) DEFAULT NULL COMMENT '今日新增乘客今日呼叫应答数',
  `todayneed_num` int(11) DEFAULT NULL COMMENT '今日新增乘客今日订单数',
  `totayneed_succ_num` int(11) DEFAULT NULL COMMENT '今日新增乘客今日订单成功数',
  `todayneedrate` float DEFAULT NULL COMMENT '今日新增乘客今日订单成功率',
  `prepasscallsuccs` int(11) DEFAULT NULL COMMENT '往日注册乘客今日呼叫应答数',
  `preneed_num` int(11) DEFAULT NULL COMMENT '往日注册乘客今日订单数',
  `preneed_succ_num` int(11) DEFAULT NULL COMMENT '往日注册乘客今日订单成功数',
  `preneedrate` float DEFAULT NULL COMMENT '往日注册乘客今日订单成功率',
  `totalneed_num` int(11) DEFAULT NULL COMMENT '今日订单数',
  `totalneed_succ_num` int(11) DEFAULT NULL COMMENT '今日订单成功数',
  `totalneedrate` float DEFAULT NULL COMMENT '今日订单成功率',
  `hisneed_num` int(11) DEFAULT NULL COMMENT '历史总订单数',
  `hisneed_succ_num` int(11) DEFAULT NULL COMMENT '历史总订单成功数',
  `first_succ_rate` float DEFAULT NULL COMMENT '首次呼叫成功率',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=7435 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerOrderHistory`
--

DROP TABLE IF EXISTS `PassengerOrderHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerOrderHistory` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `weekSuccOrderMoreThanThreeCnt` int(11) DEFAULT NULL COMMENT '过去7天成功订单超过3次成功乘客数',
  `weekNoOrderCnt` int(11) DEFAULT NULL COMMENT '过去7天无订单乘客数',
  `halfMonthNoOrderCnt` int(11) DEFAULT NULL COMMENT '过去15天无订单乘客数',
  `monthNoOrderCnt` int(11) DEFAULT NULL COMMENT '过去30天无订单乘客数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=131476 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerReg`
--

DROP TABLE IF EXISTS `PassengerReg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerReg` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `totalActivedCnt` int(11) DEFAULT NULL COMMENT '历史总激活乘客数:暂无',
  `totalRegCnt` int(11) DEFAULT NULL COMMENT '历史总注册乘客数',
  `activedCnt` int(11) DEFAULT NULL COMMENT '今日新激活乘客数:暂无',
  `regCnt` int(11) DEFAULT NULL COMMENT '今日注册乘客数',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132896 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerRegAndCall`
--

DROP TABLE IF EXISTS `PassengerRegAndCall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerRegAndCall` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `passengertotal` int(11) DEFAULT NULL COMMENT '历史总注册乘客数',
  `newpassenger` int(11) DEFAULT NULL COMMENT '今日新增乘客数',
  `new_pass_call_num` int(11) DEFAULT NULL COMMENT '今日新增呼叫乘客数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=76132 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PassengerTodayReg`
--

DROP TABLE IF EXISTS `PassengerTodayReg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PassengerTodayReg` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL,
  `orderCnt` int(11) DEFAULT NULL COMMENT '今日注册乘客今日订单数',
  `orderCallCnt` int(11) DEFAULT NULL COMMENT '今日注册乘客今日呼叫数',
  `orderSuccCnt` int(11) DEFAULT NULL COMMENT '今日注册乘客今日订单成功数',
  `orderSuccRate` float(8,3) DEFAULT NULL COMMENT '今日注册乘客今日订单成功率',
  `orderNeedCnt` int(11) DEFAULT NULL COMMENT '今日注册乘客今日呼叫需求数:暂无',
  `orderNeedSuccCnt` int(11) DEFAULT NULL COMMENT '今日注册乘客今日需求成功数:暂无',
  `orderNeedSuccRate` float(8,3) DEFAULT NULL COMMENT '今日注册乘客今日需求成功率:暂无',
  PRIMARY KEY (`statId`)
) ENGINE=InnoDB AUTO_INCREMENT=132023 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TodayCallPassenger`
--

DROP TABLE IF EXISTS `TodayCallPassenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TodayCallPassenger` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `todaycallpassenger` int(11) DEFAULT NULL COMMENT '今日呼叫乘客数',
  `todaycallsuccpassenger` int(11) DEFAULT NULL COMMENT '今日呼叫成功乘客数',
  `todaycallpassengersuccrate` float DEFAULT NULL COMMENT '今日呼叫成功乘客比例',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=78832 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TodayDriver6HourOnline_dpRate`
--

DROP TABLE IF EXISTS `TodayDriver6HourOnline_dpRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TodayDriver6HourOnline_dpRate` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `driver_strive` int(11) DEFAULT NULL COMMENT '今日抢单成功司机数',
  `dp_ratio` float DEFAULT NULL COMMENT '司乘比',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=7768 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `driver_updateapp`
--

DROP TABLE IF EXISTS `driver_updateapp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `driver_updateapp` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `todaytotalcnt` varchar(255) DEFAULT '0' COMMENT '司机累积升级数',
  `todayupdatecnt` varchar(255) DEFAULT '0' COMMENT '当日司机升级数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=7389 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `driver_wechat_collection`
--

DROP TABLE IF EXISTS `driver_wechat_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `driver_wechat_collection` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `todaywechat_drivercnt` varchar(255) DEFAULT '0' COMMENT '微信收款司机数 当日微信收款司机数',
  `all_wechat_drivercnt` varchar(255) DEFAULT '0' COMMENT '累积微信收款司机数 历史所有使用微信收款的司机数',
  `driver_wechat_rate` float DEFAULT '0' COMMENT '微信收款司机占比  当日微信收款司机数/当日在线司机数',
  `driver_wechat_newadd` varchar(255) DEFAULT '0' COMMENT '微信收款新增司机数 当日首次使用微信收款司机数',
  `driver_wechat_newaddrate` float DEFAULT '0' COMMENT '微信收款新增司机占比 微信收款新增司机数/微信收款司机数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=5504 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `driverrecommend`
--

DROP TABLE IF EXISTS `driverrecommend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `driverrecommend` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `recommend_driver` float DEFAULT '0' COMMENT '有推荐乘客的司机数',
  `recommend_driverrate_reg` float DEFAULT '0' COMMENT '推荐司机占总注册司机比例',
  `recommend_driverrate_online` float DEFAULT '0' COMMENT '推荐司机占在线人数比例',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2048 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finance_report`
--

DROP TABLE IF EXISTS `finance_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finance_report` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `drivernum` int(11) DEFAULT '0' COMMENT '司机注册数',
  `passengernum` int(11) DEFAULT '0' COMMENT '乘客注册数',
  `ordernum` int(11) DEFAULT '0' COMMENT '订单数',
  `successordernum` int(11) DEFAULT '0' COMMENT '成功订单数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kd_info`
--

DROP TABLE IF EXISTS `kd_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kd_info` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `pushddrivers` int(11) DEFAULT '0' COMMENT '检测司机数',
  `kdonlinedrivers` int(11) DEFAULT '0' COMMENT '竞品在线司机数',
  `kdinstalldrivers` int(11) DEFAULT '0' COMMENT '竞品安装司机数',
  `onlinedrivers` int(11) DEFAULT '0' COMMENT '在线司机数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2033 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lj_driver`
--

DROP TABLE IF EXISTS `lj_driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lj_driver` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `per_driver_money` double DEFAULT '0' COMMENT '人均立减司机金额',
  `per_lijianordercnt` double DEFAULT '0' COMMENT '司机人均立奖订单数',
  `five_drivercnt` bigint(20) DEFAULT '0' COMMENT '微信收车费满5单司机数',
  `ten_drivercnt` bigint(20) DEFAULT '0' COMMENT '微信收车费满10单司机数',
  `overten_drivercnt` bigint(20) DEFAULT '0' COMMENT '微信收车费满10单以上司机数',
  `amrush_cnt` bigint(20) DEFAULT '0' COMMENT '微信收车费早高峰期收车费订单数',
  `pmrush_cnt` bigint(20) DEFAULT '0' COMMENT '微信收车费晚高峰期收车费订单数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=1043 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lj_passenger`
--

DROP TABLE IF EXISTS `lj_passenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lj_passenger` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `lj_fee_ave` float DEFAULT '0' COMMENT '人均微信支付立减金额',
  `lj_order_ave` float DEFAULT '0' COMMENT '乘客人均立减订单数',
  `one_order` int(11) DEFAULT '0' COMMENT '支付1单乘客数',
  `two_order` int(11) DEFAULT '0' COMMENT '支付2单乘客数',
  `three_order` int(11) DEFAULT '0' COMMENT '支付3单乘客数',
  `more_order` int(11) DEFAULT '0' COMMENT '支付3单以上乘客数',
  `lj_order_0` int(11) DEFAULT '0' COMMENT '立减后0元订单数',
  `lj_order_0_5` int(11) DEFAULT '0' COMMENT '立减后5元以下订单数',
  `lj_order_5_10` int(11) DEFAULT '0' COMMENT '立减后5-10元订单数',
  `lj_order_10_20` int(11) DEFAULT '0' COMMENT '立减后11-20元订单数',
  `lj_order_20_30` int(11) DEFAULT '0' COMMENT '立减后21-30元订单数',
  `lj_order_30` int(11) DEFAULT '0' COMMENT '立减后30元以上订单数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=475 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mis_order`
--

DROP TABLE IF EXISTS `mis_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mis_order` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `realorder_rate` float DEFAULT '0' COMMENT '实时订单占比',
  `preorder_rate` float DEFAULT '0' COMMENT '预约订单占比',
  `realorder_ave_time` float DEFAULT '0' COMMENT '实时订单平均成交时间',
  `preorder_ave_time` float DEFAULT '0' COMMENT '预约订单平均成交时间',
  `realordersuc_rate` float DEFAULT '0' COMMENT '实时订单抢单成单率',
  `preordersuc_rate` float DEFAULT '0' COMMENT '预约订单抢单成单率',
  `realcomplaint_rate` float DEFAULT '0' COMMENT '实时订单投诉率',
  `precomplaint_rate` float DEFAULT '0' COMMENT '预约订单投诉率',
  `repeatorder_rate` float DEFAULT '0' COMMENT '需求重复发送成功率',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2237 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newdrivercheckdata`
--

DROP TABLE IF EXISTS `newdrivercheckdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newdrivercheckdata` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `newcheckcnt` int(11) DEFAULT '0' COMMENT '当天注册并审核司机数',
  `newactivecnt` int(11) DEFAULT '0' COMMENT '当天审核并上报司机数',
  `weeknewcheckcnt` int(11) DEFAULT '0' COMMENT '当周注册并审核司机数',
  `weeknewactivecnt` int(11) DEFAULT '0' COMMENT '当周审核并上报司机数',
  `monthnewcheckcnt` int(11) DEFAULT '0' COMMENT '当月注册并审核司机数',
  `monthnewactivecnt` int(11) DEFAULT '0' COMMENT '当月审核并上报司机数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2455 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `passenger_needdata`
--

DROP TABLE IF EXISTS `passenger_needdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passenger_needdata` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `stctotalneedcnt` int(11) DEFAULT '0' COMMENT '司推乘乘客产生订单数(总需求)',
  `btjpassengercnt` int(11) DEFAULT '0' COMMENT '被推荐乘客呼叫人数（有一次需求就算）',
  `btjpassenger2cnt` int(11) DEFAULT '0' COMMENT '被推荐乘客二次呼叫人数（有两次或者以上）',
  `btjpassenger2z1rate` float DEFAULT '0' COMMENT '被推荐乘客一次呼叫后产生二次呼叫占比',
  `nobtjpassenger1ztotlrate` float DEFAULT '0' COMMENT '当天非推荐乘客的一次呼叫占比',
  `nobtjpassenger2z1rate` float DEFAULT '0' COMMENT '当天非推荐乘客一次呼叫后产生二次呼叫占比',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2145 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recommended_passenger`
--

DROP TABLE IF EXISTS `recommended_passenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recommended_passenger` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT NULL,
  `recommended_passenger_cnt` bigint(20) DEFAULT '0' COMMENT '被推荐乘客数',
  `new_regandcall_passengercnt` bigint(20) DEFAULT '0' COMMENT '新增呼叫乘客人数',
  `recommended_reg_passengercnt` bigint(20) DEFAULT '0' COMMENT '被推荐乘客注册数',
  `recommended_reg_rate` double DEFAULT '0' COMMENT '被推荐乘客注册占比',
  `recommended_call_reate` double DEFAULT '0' COMMENT '被推荐乘客一次呼叫占比（分母是推荐人数）',
  `recommended_regcall_reate` double DEFAULT '0' COMMENT '被推荐乘客注册后一次呼叫数占比（分母是注册人数）',
  `recommended_reg_newadd_rate` double DEFAULT '0' COMMENT '被推荐注册乘客占总新增注册比例',
  `recommended_call_newadd_rate` double DEFAULT '0' COMMENT '被推荐呼叫乘客占总新增呼叫比例',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `webapp_wechat`
--

DROP TABLE IF EXISTS `webapp_wechat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webapp_wechat` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `webapp_cnt` int(11) DEFAULT '0' COMMENT 'Webapp 订单量',
  `webapp_succcnt` int(11) DEFAULT '0' COMMENT 'Webapp 成功订单量',
  `webapp_succrate` float DEFAULT '0' COMMENT 'Webapp 订单成功率',
  `webapp_accounted` float DEFAULT '0' COMMENT 'webapp 成功订单占比',
  `wechat_cnt` int(11) DEFAULT '0' COMMENT 'webapp 微信支付订单数',
  `wechat_succcnt` int(11) DEFAULT '0' COMMENT 'webapp 微信支付成功订单数',
  `wechat_rate` float DEFAULT '0' COMMENT 'webapp 微信支付占比',
  `wechat_transrate` float DEFAULT '0' COMMENT 'Webapp 微信支付转化率',
  `native_cnt` varchar(255) DEFAULT '0' COMMENT 'native 订单量',
  `native_succcnt` varchar(255) DEFAULT '0' COMMENT 'native 成功订单量',
  `native_succrate` float DEFAULT '0' COMMENT 'native 成功率',
  `native_succaccounted` float DEFAULT '0' COMMENT 'native 成功订单量占比',
  `native_wechat_cnt` varchar(255) DEFAULT '0' COMMENT 'native 微信支付订单数',
  `native_wechat_succcnt` varchar(255) DEFAULT '0' COMMENT 'native 微信支付成功订单数',
  `native_wechat_accounted` float DEFAULT '0' COMMENT 'native 微信支付占比',
  `native_wechat_transrate` float DEFAULT '0' COMMENT 'native 微信支付转化率',
  `all_wechat_succcnt` varchar(255) DEFAULT '0' COMMENT '微信支付总订单量',
  `wechat_chargerate` float DEFAULT '0' COMMENT '微信支付占比',
  `wechat_total` varchar(255) DEFAULT '0' COMMENT '有微信支付行为的总订单数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=6013 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `webapp_wechathistory`
--

DROP TABLE IF EXISTS `webapp_wechathistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `webapp_wechathistory` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `webapp_wechat_total` varchar(255) DEFAULT '0' COMMENT 'Webapp 微信支付累积订单量',
  `native_wechat_total` varchar(255) DEFAULT '0' COMMENT 'native 微信支付累积订单量',
  `wechat_total` varchar(255) DEFAULT '0' COMMENT '微信支付累积订单量',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=5333 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wechat_getenvelope`
--

DROP TABLE IF EXISTS `wechat_getenvelope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wechat_getenvelope` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `getenvelope_renshu` bigint(20) DEFAULT '0' COMMENT '当日得红包人数',
  `getenvelope_cishu` bigint(20) DEFAULT '0' COMMENT '当日得红包次数',
  `getenvelope_geshu` bigint(20) DEFAULT '0' COMMENT '当日得红包个数',
  `per_envelope_geshu` double DEFAULT '0' COMMENT '人均得到红包数',
  `total_getenvelope_renshu` bigint(20) DEFAULT '0' COMMENT '累积得红包人数',
  `total_getenvelope_cishu` bigint(20) DEFAULT '0' COMMENT '累积得红包次数',
  `total_getenvelope_geshu` bigint(20) DEFAULT '0' COMMENT '累积得红包个数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wechat_passenger`
--

DROP TABLE IF EXISTS `wechat_passenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wechat_passenger` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `webapp_cnt` int(11) DEFAULT '0' COMMENT 'Webapp 呼叫乘客数',
  `webapp_succcnt` int(11) DEFAULT '0' COMMENT 'Webapp 成功呼叫乘客数',
  `webapp_succrate` float DEFAULT '0' COMMENT 'Webapp 呼叫成功乘客占比',
  `webapp_wechat_cnt` int(11) DEFAULT '0' COMMENT 'webapp 微信支付乘客数',
  `webapp_wechat_rate` float DEFAULT '0' COMMENT 'webapp 微信支付乘客占比',
  `webapp_wechat_newcnt` int(11) DEFAULT '0' COMMENT 'Webapp 微信支付新用户数',
  `webapp_wechat_newrate` float DEFAULT '0' COMMENT 'Webapp 微信支付新用户占比',
  `native_cnt` int(11) DEFAULT '0' COMMENT 'native 呼叫乘客数',
  `native_succcnt` int(11) DEFAULT '0' COMMENT 'native 呼叫成功乘客数',
  `native_succrate` float DEFAULT '0' COMMENT 'native 呼叫成功乘客占比',
  `native_wechat_cnt` int(11) DEFAULT '0' COMMENT 'native 微信支付乘客数',
  `native_wechat_rate` float DEFAULT '0' COMMENT 'native 微信支付乘客占比',
  `native_wechat_newcnt` int(11) DEFAULT '0' COMMENT 'native 微信支付新用户数',
  `native_wechat_newrate` float DEFAULT '0' COMMENT 'native 微信支付新用户占比',
  `wechat_cnt` int(11) DEFAULT '0' COMMENT '微信支付乘客数',
  `wechat_newcnt` int(11) DEFAULT '0' COMMENT '微信支付新用户',
  `wechat_newrate` float DEFAULT '0' COMMENT '微信支付新用户占比',
  `webapp_wechat_totalcnt` varchar(255) DEFAULT '0' COMMENT 'webapp微信支付累计乘客数',
  `native_wechat_totalcnt` varchar(255) DEFAULT '0' COMMENT 'native微信支付累计乘客数',
  `wechat_totalcnt` varchar(255) DEFAULT '0' COMMENT '微信支付累计乘客数',
  `native_updatecnt` int(11) DEFAULT '0' COMMENT 'native升级乘客数',
  `native_total_updatecnt` varchar(255) DEFAULT '0' COMMENT 'native累计升级乘客数',
  `wechat_one_cnt` varchar(255) DEFAULT '0' COMMENT '一次微信支付乘客数',
  `webchat_two_cnt` varchar(255) DEFAULT '0' COMMENT '两次及以上微信支付乘客数',
  `webchat_two_avgcnt` float DEFAULT '0' COMMENT '两次及以上人均微信支付次数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=6655 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wechat_robenvelope_statistical`
--

DROP TABLE IF EXISTS `wechat_robenvelope_statistical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wechat_robenvelope_statistical` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `robenvelope_renshu` bigint(20) DEFAULT '0' COMMENT '抢到红包总人数',
  `robenvelope_geshu` bigint(20) DEFAULT '0' COMMENT '抢到红包总个数',
  `robenvelope_money` varchar(255) DEFAULT '0' COMMENT '抢到红包总金额',
  `total_robenvelope_renshu` bigint(20) DEFAULT '0' COMMENT '累计抢到红包总人数',
  `total_robenvelope_geshu` bigint(20) DEFAULT '0' COMMENT '累计抢到红包总个数',
  `total_robenvelope_money` varchar(255) DEFAULT '0' COMMENT '累计抢到红包总金额',
  `robenvelope_didiapp_cnt` bigint(20) DEFAULT '0' COMMENT '抢到红包嘀嘀人数',
  `pre_robenvelope_didiapp_cnt` double DEFAULT '0' COMMENT '抢到红包嘀嘀用户占比',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wechat_robenvelope_taxi`
--

DROP TABLE IF EXISTS `wechat_robenvelope_taxi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wechat_robenvelope_taxi` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `robenvelope_taxi_cnt` bigint(20) DEFAULT '0' COMMENT '抢到红包后打车人数',
  `robenvelope_taxi_rate` double DEFAULT '0' COMMENT '抢到红包后打车率',
  `robenvelope_order_cnt` bigint(20) DEFAULT '0' COMMENT '抢到红包后打车用户产生的订单量',
  `robenvelope_order_succcnt` bigint(20) DEFAULT '0' COMMENT '抢到红包后打车用户产生的成交量',
  `robenvelope_order_succrate` double DEFAULT '0' COMMENT '抢到红包后打车用户产生的成交量占比',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wechat_senditem_day`
--

DROP TABLE IF EXISTS `wechat_senditem_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wechat_senditem_day` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `passenger_share` int(11) DEFAULT '0' COMMENT '当天发红包的乘客总人数',
  `passenger_per_share` float DEFAULT '0' COMMENT '发红包人数占比',
  `items_cnt_share` int(11) DEFAULT '0' COMMENT '发红包总个数',
  `items_ave_share` float DEFAULT '0' COMMENT '人均发红包数',
  `items_cnt_left` int(11) DEFAULT '0' COMMENT '剩余未发红包总数',
  `passenger_share_first` int(11) DEFAULT '0' COMMENT '当天第一次发红包人数',
  `passenger_not_share` int(11) DEFAULT '0' COMMENT '从未发红包人数',
  `passenger_per_not_share` float DEFAULT '0' COMMENT '从未发红包人数占比',
  `items_cnt_not_share` int(11) DEFAULT '0' COMMENT '从未发红包乘客的红包数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wechat_senditem_total`
--

DROP TABLE IF EXISTS `wechat_senditem_total`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wechat_senditem_total` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `passenger_share` int(11) DEFAULT '0' COMMENT '累计发红包人数',
  `items_share` int(11) DEFAULT '0' COMMENT '累计发红包总个数',
  `left_items` int(11) DEFAULT '0' COMMENT '剩余未发红包总数',
  `passenger_notshare` int(11) DEFAULT '0' COMMENT '累计从未发红包乘客人数',
  `items_notshare` int(11) DEFAULT '0' COMMENT '累计从未发红包乘客的红包数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wx_lj`
--

DROP TABLE IF EXISTS `wx_lj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_lj` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `lj_10` int(11) DEFAULT '0' COMMENT '立减10元订单数',
  `lj_5` int(11) DEFAULT '0' COMMENT '立减5元订单数',
  `lj_15_frist` int(11) DEFAULT '0' COMMENT '首次支付，立减15元订单数',
  `lj_12` int(11) DEFAULT '0' COMMENT '立减12元订单数',
  `lj_15` int(11) DEFAULT '0' COMMENT '立减15元订单数',
  `lj_18` int(11) DEFAULT '0' COMMENT '立减18元订单数',
  `lj_20` int(11) DEFAULT '0' COMMENT '立减20元订单数',
  `lj_8` int(11) DEFAULT '0' COMMENT '立减8元订单数',
  `lj_6` int(11) DEFAULT '0' COMMENT '立减6元订单数',
  `lj_10_rate` float DEFAULT '0' COMMENT '立减10元占总微信支付订单比',
  `lj_5_rate` float DEFAULT '0' COMMENT '立减5元占总微信支付订单比',
  `lj_15_first_rate` float DEFAULT '0' COMMENT '立减15元占总微信支付订单比',
  `lj_12_rate` float DEFAULT '0' COMMENT '立减12元占总微信支付订单比',
  `lj_15_rate` float DEFAULT '0' COMMENT '立减15元占总微信支付订单比',
  `lj_18_rate` float DEFAULT '0' COMMENT '立减18元占总微信支付订单比',
  `lj_20_rate` float DEFAULT '0' COMMENT '立减20元占总微信支付订单比',
  `lj_8_rate` float DEFAULT '0' COMMENT '立减8元占总微信支付订单比',
  `lj_6_rate` float DEFAULT '0' COMMENT '立减6元占总微信支付订单比',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=2583 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wx_money_data`
--

DROP TABLE IF EXISTS `wx_money_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_money_data` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `cash_people_num` int(11) DEFAULT '0' COMMENT '提现司机数',
  `cash_people_num_succ` int(11) DEFAULT '0' COMMENT '成功提现司机数',
  `cash_total` varchar(255) DEFAULT '0' COMMENT '提现金额',
  `cash_total_succ` varchar(255) DEFAULT '0' COMMENT '成功提现金额',
  `cash_num` int(11) DEFAULT '0' COMMENT '总提现次数',
  `cash_num_succ` int(11) DEFAULT '0' COMMENT '成功提现次数',
  `avg_cash_num_succ` double DEFAULT '0' COMMENT '人均成功提现次数',
  `avg_cash_total_succ` varchar(255) DEFAULT '0' COMMENT '人均成功提现金额',
  `wepay_web_succ_cost` varchar(255) DEFAULT '0' COMMENT 'Webapp成功微信支付金额',
  `wepay_app_succ_cost` varchar(255) DEFAULT '0' COMMENT 'Native成功微信支付金额',
  `wepay_total_succ_cost` varchar(255) DEFAULT '0' COMMENT '微信支付总金额',
  `wepay_web_succ_cost_total` varchar(255) DEFAULT '0' COMMENT 'Webapp累积微信支付金额',
  `wepay_app_succ_cost_total` varchar(255) DEFAULT '0' COMMENT 'Native累积成功微信支付金额',
  `wepay_total_succ_cost_total` varchar(255) DEFAULT '0' COMMENT '累积微信支付总金额',
  `driver_num` int(11) DEFAULT '0' COMMENT '立减司机人数',
  `driver_money` varchar(255) DEFAULT '0' COMMENT '立减司机总金额',
  `total_p_num` int(11) DEFAULT '0' COMMENT '立减乘客人数',
  `total_p_cost` varchar(255) DEFAULT '0' COMMENT '立减乘客总金额',
  `driver_num_total` int(11) DEFAULT '0' COMMENT '立减累积司机人数',
  `driver_money_total` varchar(255) DEFAULT '0' COMMENT '立减累积司机总金额',
  `total_p_num_total` int(11) DEFAULT '0' COMMENT '立减累积乘客人数',
  `total_p_cost_total` varchar(255) DEFAULT '0' COMMENT '立减累积乘客总金额',
  `all_cut_total_cost` varchar(255) DEFAULT '0' COMMENT '免单总金额',
  `all_cut_total` int(11) DEFAULT '0' COMMENT '免单总数',
  `all_cut_total_passenger` int(11) DEFAULT '0' COMMENT '免单总人数',
  `all_cut_below_20` int(11) DEFAULT '0' COMMENT '免单 20 元内单数',
  `all_cut_below_20_ratio` float DEFAULT '0' COMMENT '免单 20 元内订单占比',
  `all_cut_below_20_cost` varchar(255) DEFAULT '0' COMMENT '免单 20 元内金额',
  `all_cut_below_50` int(11) DEFAULT '0' COMMENT '免单 20 -50 元内单数',
  `all_cut_below_50_ratio` float DEFAULT '0' COMMENT '免单 20 -50 元内订单占比',
  `all_cut_below_50_cost` varchar(255) DEFAULT '0' COMMENT '免单 20-50 元内金额',
  `all_cut_below_100` int(11) DEFAULT '0' COMMENT '免单 50-100 元内单数',
  `all_cut_below_100_ratio` float DEFAULT '0' COMMENT '免单 50-100 元内订单占比',
  `all_cut_below_100_cost` varchar(255) DEFAULT '0' COMMENT '免单 50-100 元内金额',
  `all_cut_above_100` int(11) DEFAULT '0' COMMENT '免单 100 元以上单数',
  `all_cut_above_100_ratio` float DEFAULT '0' COMMENT '免单 100 元以上订单占比',
  `all_cut_above_100_cost` varchar(255) DEFAULT '0' COMMENT '免单 100 元以上金额',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=4385 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wx_money_pay`
--

DROP TABLE IF EXISTS `wx_money_pay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_money_pay` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `wx_allowance` float DEFAULT '0' COMMENT '微信补贴总金额',
  `passenger_pay` float DEFAULT '0' COMMENT '微信支付总金额',
  `lj_order_num` int(11) DEFAULT '0' COMMENT '立减订单数',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB AUTO_INCREMENT=1239 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wx_usebalance_data`
--

DROP TABLE IF EXISTS `wx_usebalance_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_usebalance_data` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date DEFAULT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `balance_passenger` int(11) DEFAULT '0' COMMENT '使用余额打车的乘客数',
  `balance_passenger_ratio` varchar(255) DEFAULT '0' COMMENT '使用余额打车的乘客占比',
  `balance_money` varchar(255) DEFAULT '0' COMMENT '余额被使用总金额',
  `last_balance_money` varchar(255) DEFAULT '0' COMMENT '剩余总余额',
  `balance_order` varchar(255) DEFAULT '0' COMMENT '使用余额打车订单量',
  `balance_succorder` varchar(255) DEFAULT '0' COMMENT '使用余额打车成交量',
  `balance_succorder_ratio` varchar(255) DEFAULT '0' COMMENT '使用余额打车成交量占比',
  `balance_money_per` varchar(255) DEFAULT '0' COMMENT '人均使用金额',
  `balance_passenger_total` varchar(255) DEFAULT '0' COMMENT '累计使用余额打车的乘客数',
  `balance_money_total` varchar(255) DEFAULT '0' COMMENT '累计使用余额总金额',
  `balance_order_total` varchar(255) DEFAULT '0' COMMENT '累计使用余额打车订单量',
  `balance_succorder_total` varchar(255) DEFAULT '0' COMMENT '累计使用余额打车成交量',
  `last_balance_money_total` varchar(255) DEFAULT '0' COMMENT '累计剩余总余额',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-03-13 20:13:27
