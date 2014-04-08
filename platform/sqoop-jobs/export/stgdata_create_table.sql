-- MySQL dump 10.13  Distrib 5.5.28, for Linux (x86_64)
--
-- Host: stg0.jx    Database: data
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
-- Current Database: `data`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `data` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `data`;

--
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Admin` (
  `adminId` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `role` smallint(6) NOT NULL DEFAULT '0',
  `area` tinyint(4) NOT NULL DEFAULT '0',
  `district` tinyint(4) NOT NULL DEFAULT '0',
  `department` tinyint(4) NOT NULL,
  `company` bigint(20) NOT NULL DEFAULT '0',
  `b_company` bigint(20) NOT NULL DEFAULT '0',
  `operate` tinyint(4) DEFAULT '0',
  `realname` varchar(32) NOT NULL DEFAULT '',
  `phone` varchar(16) DEFAULT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`adminId`),
  UNIQUE KEY `username` (`username`),
  KEY `area` (`area`),
  KEY `district` (`district`),
  KEY `department` (`department`),
  KEY `company` (`company`)
) ENGINE=InnoDB AUTO_INCREMENT=1409 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admins_menu`
--

DROP TABLE IF EXISTS `admins_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admins_menu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `adminId` bigint(20) unsigned NOT NULL,
  `menu_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `adminId_menuid` (`adminId`,`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9774 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `city_info`
--

DROP TABLE IF EXISTS `city_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city_info` (
  `cityId` int(11) DEFAULT NULL,
  `cityName` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `driveractivedata`
--

DROP TABLE IF EXISTS `driveractivedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `driveractivedata` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `newdrivercnt` int(11) DEFAULT '0' COMMENT '月新增司机数',
  `totaldrivercnt` int(11) DEFAULT '0' COMMENT '月累计司机数',
  `monthstrivedrivercnt` int(11) DEFAULT '0' COMMENT '月抢单成功司机人数',
  `monthstrivesuccdrivercnt` int(11) DEFAULT '0' COMMENT '月抢单成功司机人数',
  `monthstrivesuccavgcnt` int(11) DEFAULT '0' COMMENT '月人均抢单成功数',
  `monthtotolonlinecnt` int(11) DEFAULT '0' COMMENT '月在线司机人数',
  `monthtotalonlinetime` bigint(20) DEFAULT '0' COMMENT '所有司机月总在线时长（分钟）',
  `monthavgonlimetime` float DEFAULT '0' COMMENT '月在线司机人均在线时长（分钟）',
  `avgdaydriveronlinecnt` int(11) DEFAULT '0' COMMENT '月日均在线司机人数',
  `avgdaydriveronlinerate` float DEFAULT '0' COMMENT '月日均在线率',
  `avgdaystrivedrivercnt` int(11) DEFAULT '0' COMMENT '月日均点击抢单司机人数',
  `avgdaystrivesuccdrivercnt` int(11) DEFAULT '0' COMMENT '月日均抢单成功司机人数',
  `avgdayonlinestrivesuccrate` float DEFAULT '0' COMMENT '月日均在线抢单成功率',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `indexs` (`statDate`,`area`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `investor_order_month`
--

DROP TABLE IF EXISTS `investor_order_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `investor_order_month` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `order_cnt` int(11) DEFAULT '0' COMMENT '月订单数',
  `ordersuc_cnt` int(11) DEFAULT '0' COMMENT '月成功订单量',
  `ordersuc_rate` float DEFAULT '0' COMMENT '月成交率',
  `realorder_cnt` int(11) DEFAULT '0' COMMENT '月实时订单数',
  `realordersuc_cnt` int(11) DEFAULT '0' COMMENT '月实时成功订单量',
  `realordersuc_rate` float DEFAULT '0' COMMENT '月实时订单成交率',
  `preorder_cnt` int(11) DEFAULT '0' COMMENT '月预约订单数',
  `preordersuc_cnt` int(11) DEFAULT '0' COMMENT '月预约成功订单量',
  `preordersuc_rate` float DEFAULT '0' COMMENT '月预约订单成交率',
  `ordertipsuc_cnt` int(11) DEFAULT '0' COMMENT '月主动加价订单数',
  `ordertip` varchar(255) DEFAULT NULL COMMENT '月主动加价总金额',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `indexs` (`statDate`,`area`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `investor_ordersrc_month`
--

DROP TABLE IF EXISTS `investor_ordersrc_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `investor_ordersrc_month` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL COMMENT '日期',
  `area` int(11) DEFAULT '0' COMMENT '地区（10000为全国）',
  `channel` int(11) DEFAULT '0' COMMENT '平台（默认0）',
  `selforder` int(11) DEFAULT '0' COMMENT '自有订单总量',
  `selfordersucc` int(11) DEFAULT '0' COMMENT '自有订单成功量',
  `selforderrate` double DEFAULT '0' COMMENT '自有订单成功率',
  `bdorder` int(11) DEFAULT '0' COMMENT '百度订单总量',
  `bdordersucc` int(11) DEFAULT '0' COMMENT '百度订单成功量',
  `bdordertate` double DEFAULT '0' COMMENT '百度订单成功率',
  `bdnotusedidi` int(11) DEFAULT '0' COMMENT '上个自然月百度注册并且没有使用其他渠道打车的用户数',
  `bdusedidirate` double DEFAULT '0' COMMENT '上个自然月百度注册并且使用嘀嘀打车的占比',
  `qnorder` int(11) DEFAULT '0' COMMENT '去哪儿订单总量',
  `qnordersucc` int(11) DEFAULT '0' COMMENT '去哪儿成功订单量',
  `qnorderrate` double DEFAULT '0' COMMENT '去哪儿订单成功率',
  `qnnotusedidi` int(11) DEFAULT '0' COMMENT '上个自然月去哪儿注册并且没有使用其他渠道打车的用户数',
  `qnusedidi` double DEFAULT '0' COMMENT '上个自然月去哪儿注册并且使用嘀嘀打车的占比',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `investor_wechat_month`
--

DROP TABLE IF EXISTS `investor_wechat_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `investor_wechat_month` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT '0',
  `webapp_cnt` int(11) DEFAULT '0' COMMENT '微信webapp订单数',
  `webapp_succcnt` int(11) DEFAULT '0' COMMENT '微信webapp成功订单数',
  `wechat_total` int(11) DEFAULT '0' COMMENT '微信支付订单数',
  `wechat_succcnt` int(11) DEFAULT '0' COMMENT '微信支付成功订单数',
  `wepay_app_succ_cost` varchar(255) DEFAULT '0' COMMENT '微信支付成功总金额',
  PRIMARY KEY (`statId`),
  KEY `statDate` (`statDate`),
  KEY `area` (`area`),
  KEY `channel` (`channel`),
  KEY `indexs` (`statDate`,`area`,`channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `investors_passenger_month`
--

DROP TABLE IF EXISTS `investors_passenger_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `investors_passenger_month` (
  `statId` int(11) NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `area` int(11) DEFAULT '0' COMMENT '城市',
  `channel` int(11) DEFAULT '0' COMMENT '渠道',
  `per_call_order_passenger_reate` double DEFAULT '0' COMMENT '月日均人均呼叫订单数',
  `per_callpassenger_cnt` double DEFAULT '0' COMMENT '月日均呼叫乘客数',
  `per_dayregandcall_cnt` double DEFAULT '0' COMMENT '月日均新增呼叫乘客数',
  `per_notdayregandcall_cnt` double DEFAULT '0' COMMENT '月日均呼叫老乘客数',
  `passenger_total_cnt` bigint(20) DEFAULT '0' COMMENT '累计注册乘客总数',
  `lastmonth_regcnt` bigint(20) DEFAULT '0' COMMENT '月新增注册乘客数',
  `month_passenger_callcnt` bigint(20) DEFAULT '0' COMMENT '月呼叫乘客数',
  `per_passenger_ordercnt` double DEFAULT '0' COMMENT '月人均呼叫订单数',
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

-- Dump completed on 2014-02-26 17:41:12
