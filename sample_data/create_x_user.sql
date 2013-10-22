-- MySQL dump 10.13  Distrib 5.5.20, for Linux (x86_64)
--
-- Host: localhost    Database: nor1
-- ------------------------------------------------------
-- Server version	5.5.20-enterprise-commercial-advanced-log

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
-- Table structure for table `x_user`
--

DROP TABLE IF EXISTS `x_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x_user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `FULLNAME` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `TITLE` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `GENDER` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'male',
  `STATUS` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'wait',
  `MODIFIED` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATED` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `REGKEY` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `COUNTRY` mediumtext COLLATE utf8_unicode_ci,
  `TIMEZONE` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Cityname of timeanddate.com',
  `DEBUG` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `PROPERTIES` text COLLATE utf8_unicode_ci,
  `HAS_IPROP` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'false',
  `HAS_AWARDMANAGER` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'false',
  `HAS_MONITOR` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'false',
  `SERVERS` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Comma seperated: LIVE,TEST,DEVEL or DEMO ',
  `BROADCAST_GLOBAL_WORD_CHANGES` tinyint(1) NOT NULL DEFAULT '1',
  `RESET_ON_LOGIN` smallint(6) NOT NULL DEFAULT '0' COMMENT '0=nothing to do, 1=need to change the password',
  `PASSWORD_EXPIRY` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'true' COMMENT 'false = never expire, true = will expire',
  `changed_by_user_id` int(11) NOT NULL DEFAULT '0',
  `changed_date` datetime NOT NULL,
  `LAST_LOGIN` date NOT NULL COMMENT 'Date of the user last time login.',
  `FAILED_ATTEMPT_LOGIN` tinyint(4) NOT NULL DEFAULT '0',
  `PASSWORD_LAST_RESET` date NOT NULL COMMENT 'The date the password was reset. The rules can change so it is best to know when the user last reset the password. Default value should be "today".',
  PRIMARY KEY (`ID`),
  KEY `index_fullname` (`FULLNAME`)
) ENGINE=InnoDB AUTO_INCREMENT=18691 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-23 21:42:42
