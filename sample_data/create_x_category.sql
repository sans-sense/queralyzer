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
-- Table structure for table `x_category`
--

DROP TABLE IF EXISTS `x_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x_category` (
  `id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `NAME` varchar(200) DEFAULT NULL,
  `PRICE` double DEFAULT NULL,
  `STATUS` varchar(20) DEFAULT NULL,
  `TYPE` varchar(20) DEFAULT NULL,
  `DESCR` varchar(500) DEFAULT NULL,
  `MODIFIED` datetime DEFAULT NULL,
  `REPLACEMENT` varchar(20) DEFAULT '0',
  `PRICE_PER` varchar(20) DEFAULT NULL,
  `CRS_LISTED` tinyint(1) DEFAULT '0',
  `VIRTUAL_ROOM` int(11) DEFAULT NULL,
  `ADDON_TYPE` varchar(20) DEFAULT NULL,
  `REPORTING_TYPE` varchar(20) DEFAULT NULL,
  `IMAGE_FLAG` int(11) DEFAULT NULL,
  `SHOW_SAVE` tinyint(1) DEFAULT '1',
  `IS_FIXED_RATE` varchar(1) DEFAULT NULL,
  `changed_by_user_id` int(11) DEFAULT NULL,
  `changed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`property_id`),
  UNIQUE KEY `id` (`id`),
  KEY `type_ts` (`TYPE`)
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

-- Dump completed on 2012-08-23 21:40:49
