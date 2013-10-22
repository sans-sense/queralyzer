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
-- Table structure for table `chain_name_map`
--

DROP TABLE IF EXISTS `chain_name_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chain_name_map` (
  `chain_id` int(11) NOT NULL,
  `chain_name` varchar(100) DEFAULT NULL,
  `brand_name` varchar(100) DEFAULT NULL,
  `property_id` int(11) NOT NULL,
  `property_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`chain_id`,`property_id`),
  KEY `index_chain_name` (`chain_name`)
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

-- Dump completed on 2012-08-23 23:55:37
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
-- Table structure for table `exposure`
--

DROP TABLE IF EXISTS `exposure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exposure` (
  `id` int(20) NOT NULL,
  `exposure_date` date DEFAULT NULL COMMENT 'date of earliest timestamp',
  `property_id` int(11) NOT NULL,
  `ebc` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'ext_booking_id',
  `gad` date NOT NULL COMMENT 'arrival',
  `pet_list` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'a comma-separated list of provider entry types',
  `toro_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = exposed to toro at least once, 0 = never exposed to toro',
  `nmn` smallint(3) NOT NULL COMMENT 'number of nights',
  `gdd` date NOT NULL COMMENT 'departure date',
  `tbp` float(10,2) NOT NULL COMMENT 'total booking price'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
/*!50100 PARTITION BY KEY (property_id)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-23 23:57:28
ALTER TABLE exposure ADD INDEX `property_ts` (`property_id`, `gad`, `ebc`);
ALTER TABLE exposure ADD INDEX `arrival_ts` (`gad`, `property_id`, `toro_flag`);
ALTER TABLE exposure ADD INDEX `booking_ts` (`exposure_date`, `property_id`, `toro_flag`);

ALTER TABLE x_upgrade_request ADD INDEX `index_property_id` (`PROPERTY_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `index_booking_id` (`BOOKING_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `index_to_category_id` (`TO_CATEGORY_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `index_awarded` (`AWARDED`);
ALTER TABLE x_upgrade_request ADD INDEX `index_modified_user_id` (`MODIFIED_USER_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `revenue_ts` (`booking_id`,`awarded`,`total`);
ALTER TABLE x_upgrade_request ADD INDEX `property_id_ts` (`property_id`);
ALTER TABLE x_upgrade_request ADD INDEX `booking_id_ts` (`booking_id`);
ALTER TABLE x_upgrade_request ADD INDEX `category_id_ts` (`to_category_id`);
   

ALTER TABLE x_booking ADD INDEX  `toro_join` (`PROPERTY_ID`,`ARRIVAL`,`EXT_BOOKING_ID`,`UPGRADE_STATUS`,`UPGRADE_MATRIX_TYPE`);
ALTER TABLE x_booking ADD INDEX  `matrix_join` (`PROPERTY_ID`,`UPGRADE_MATRIX_ID`,`CATEGORY_ID`,`UPGRADE_STATUS`,`UPGRADE_MATRIX_TYPE`);
ALTER TABLE x_booking ADD INDEX  `arrival_ts` (`ARRIVAL`,`PROPERTY_ID`,`UPGRADE_STATUS`);
ALTER TABLE x_booking ADD INDEX  `created_ts` (`CREATED_DATE`,`PROPERTY_ID`,`UPGRADE_STATUS`);
ALTER TABLE x_booking ADD INDEX  `matrix_type_status` (`UPGRADE_MATRIX_TYPE`,`UPGRADE_STATUS`);-- MySQL dump 10.13  Distrib 5.5.20, for Linux (x86_64)
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
-- Table structure for table `leantaas_currency_symbol_code_map`
--

DROP TABLE IF EXISTS `leantaas_currency_symbol_code_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leantaas_currency_symbol_code_map` (
  `id` int(11) NOT NULL DEFAULT '0',
  `currency_symbol` varchar(10) DEFAULT NULL,
  `currency_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_currency_code` (`currency_code`)
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

-- Dump completed on 2012-08-23 23:55:52
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
-- Table structure for table `leantaas_exchange_rates`
--

DROP TABLE IF EXISTS `leantaas_exchange_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leantaas_exchange_rates` (
  `id` int(11) NOT NULL DEFAULT '0',
  `exchange_date` date DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `exchange_rate` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_date_currency` (`exchange_date`,`currency`)
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

-- Dump completed on 2012-08-23 23:56:06
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
-- Table structure for table `region_mapping`
--

DROP TABLE IF EXISTS `region_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region_mapping` (
  `state_code` varchar(5) NOT NULL DEFAULT '',
  `state` varchar(20) DEFAULT NULL,
  `region` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`state_code`)
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

-- Dump completed on 2012-08-23 23:56:19
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
-- Table structure for table `x_booking`
--

DROP TABLE IF EXISTS `x_booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x_booking` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SESSION_ID` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `GUEST_ID` bigint(20) NOT NULL DEFAULT '0',
  `GUEST_MODIFIED` timestamp NULL DEFAULT NULL,
  `MANAGER_MODIFIED` timestamp NULL DEFAULT NULL,
  `CREATED` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CREATED_DATE` date NOT NULL DEFAULT '0000-00-00',
  `MODIFIED` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CREATED_USER_ID` int(11) DEFAULT NULL,
  `MODIFIED_USER_ID` int(11) DEFAULT NULL,
  `EXT_BOOKING_ID` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `SOURCE_ID` int(11) NOT NULL DEFAULT '0' COMMENT 'data provider eg trust',
  `CHAIN_ID` int(11) NOT NULL DEFAULT '0' COMMENT 'hotel/property chain',
  `PROPERTY_ID` int(11) NOT NULL DEFAULT '0',
  `CATEGORY_ID` int(11) NOT NULL DEFAULT '0',
  `ROOM_ID` bigint(20) NOT NULL DEFAULT '0',
  `EXT_ROOM_CD` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `EXT_PHYS_ROOM_CD` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `UPGRADE_MATRIX_ID` bigint(20) DEFAULT NULL,
  `UPGRADE_MATRIX_TYPE` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'standard',
  `CONDITION_ID` bigint(20) DEFAULT NULL,
  `CURRENCY` char(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `PRICE` double(10,2) NOT NULL DEFAULT '0.00',
  `ARRIVAL` date NOT NULL DEFAULT '0000-00-00',
  `DEPARTURE` date NOT NULL DEFAULT '0000-00-00',
  `NIGHTS` int(11) NOT NULL DEFAULT '0',
  `ADULTS` int(3) NOT NULL DEFAULT '0' COMMENT 'number of',
  `CHILDREN` int(3) NOT NULL,
  `LOY_CD` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `RATE_CD` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `TIER_CD` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `CHANNEL_CD` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `REMINDER_EMAIL` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'not send',
  `TESTFLAG` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'live' COMMENT 'real upgrade or just a test',
  `UPGRADE_STATUS` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'nothx',
  `NO_OFFER` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `HAS_AGENCY` tinyint(1) NOT NULL DEFAULT '0',
  `COMMENTS` mediumtext CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `changed_by_user_id` int(11) NOT NULL DEFAULT '0',
  `changed_date` datetime NOT NULL,
  `PID` varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `PET` varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ROOMS` int(11) NOT NULL DEFAULT '1' COMMENT 'number of',
  `SENT_ALERT_REMINDER` varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12169931 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-23 21:34:11
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
-- Table structure for table `x_chain`
--

DROP TABLE IF EXISTS `x_chain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x_chain` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(200) DEFAULT NULL,
  `COLORS` varchar(2000) DEFAULT NULL,
  `LANGUAGE_CDS` varchar(250) DEFAULT NULL,
  `STATUS` varchar(10) DEFAULT NULL,
  `EMAIL_REMINDER_DAYS` int(11) DEFAULT NULL,
  `LOGO` varchar(20) DEFAULT NULL,
  `LOGO_POS` varchar(20) DEFAULT NULL,
  `BG_IMAGE` varchar(10) DEFAULT NULL,
  `CHANGED_BY_USER_ID` int(11) DEFAULT NULL,
  `CHANGED_DATE` date DEFAULT NULL,
  `ENABLE_PREARRIVAL_EMAILS` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`)
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

-- Dump completed on 2012-08-23 21:42:08
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
-- Table structure for table `x_property`
--

DROP TABLE IF EXISTS `x_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x_property` (
  `ID` int(11) NOT NULL,
  `CHAIN_ID` int(11) NOT NULL,
  `NAME` varchar(200) DEFAULT NULL,
  `STREET` varchar(100) DEFAULT NULL,
  `ZIP` varchar(30) DEFAULT NULL,
  `CITY` varchar(50) DEFAULT NULL,
  `STATE` varchar(100) DEFAULT NULL,
  `COUNTRY` varchar(100) DEFAULT NULL,
  `PHONE` varchar(50) DEFAULT NULL,
  `FAX` varchar(50) DEFAULT NULL,
  `CURRENCY` varchar(10) DEFAULT NULL,
  `CUTOFF_NEW` int(11) DEFAULT NULL,
  `CUTOFF_MODIFY` int(11) DEFAULT NULL,
  `CUTOFF_EMAIL` int(11) DEFAULT NULL,
  `DEFAULT_CHECKIN_TIME` time DEFAULT NULL,
  `GUESTAWARDS_EMAIL_SENDTIME` time DEFAULT NULL,
  `GUESTAWARD_DAY` int(11) DEFAULT NULL,
  `GMT` varchar(5) DEFAULT NULL,
  `TIMEZONE` varchar(20) DEFAULT NULL,
  `TIMEZONE_ID` int(11) DEFAULT NULL,
  `LAST_AWARD_EMAIL` datetime DEFAULT NULL,
  `GUEST_SMTP_ID` int(11) DEFAULT NULL,
  `PROPERTY_SMTP_ID` int(11) DEFAULT NULL,
  `COLORS` varchar(200) DEFAULT NULL,
  `STATUS` varchar(20) DEFAULT NULL,
  `LAUNCH_DATE` date DEFAULT NULL,
  `MODIFIED` datetime DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `TRUSTBOOKER_CD` varchar(50) DEFAULT NULL,
  `PMS_CD` varchar(50) DEFAULT NULL,
  `NUM_ROOMS` int(11) DEFAULT NULL,
  `REMINDER_EMAILS` varchar(2000) DEFAULT NULL,
  `REMINDER_EMAILS_SEND` varchar(50) DEFAULT '0',
  `SHOW_DISCLAIMER` varchar(10) DEFAULT '1',
  `SHOW_GUEST_SAL` varchar(5) DEFAULT '0',
  `MANAGER` int(11) DEFAULT NULL,
  `REM_FLAG_1` varchar(5) DEFAULT '0',
  `PRI_AM` int(11) DEFAULT NULL,
  `REM_FLAG_2` varchar(5) DEFAULT '0',
  `SEC_AM` varchar(20) DEFAULT NULL,
  `REM_FLAG_3` varchar(5) DEFAULT '0',
  `OTHER_MANAGER` int(11) DEFAULT NULL,
  `REM_FLAG_4` varchar(5) DEFAULT '0',
  `SHOW_NOR1_OPTIN` varchar(2) DEFAULT NULL,
  `SEND_CONFIRMATION_DELAY` varchar(5) DEFAULT '0',
  `UPGRADE_PERCENT_RULE_ID` varchar(5) DEFAULT '0',
  `OPTIMAL_OFFER` varchar(100) DEFAULT NULL,
  `BEST_AWARDING` varchar(100) DEFAULT NULL,
  `INVENTORY_DAYS` int(11) DEFAULT NULL,
  `DEPLOY` tinyint(1) DEFAULT '1',
  `WORKFLOW` varchar(20) DEFAULT NULL,
  `UPGRADE_POSITION` varchar(20) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `BILLING_PREFERENCE` varchar(20) DEFAULT NULL,
  `SPARE` varchar(20) DEFAULT NULL,
  `CHANGED_BY_USER_ID` int(11) DEFAULT NULL,
  `CHANGED_DATE` datetime DEFAULT NULL,
  `DENIED_EMAIL_REMINDER` varchar(2) DEFAULT NULL,
  `ACCOUNT_MANAGEMENT_ID` int(11) DEFAULT NULL,
  `SELF_IMPLEMENTATION_WIZARD` int(11) DEFAULT NULL,
  `SELF_MANAGED` varchar(5) DEFAULT '0',
  `WIZARD_UPDATED` datetime DEFAULT NULL,
  `SEND_PREARRIVAL_EMAILS` varchar(20) DEFAULT '0',
  `TYPE_PREARRIVAL_EMAILS` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`,`CHAIN_ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `index_pri_am` (`PRI_AM`),
  KEY `index_state` (`STATE`)
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

-- Dump completed on 2012-08-23 21:42:27
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
-- Table structure for table `x_upgrade_request`
--

DROP TABLE IF EXISTS `x_upgrade_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x_upgrade_request` (
  `ID` int(11) NOT NULL,
  `BOOKING_ID` int(11) NOT NULL,
  `PROPERTY_ID` int(11) NOT NULL,
  `FROM_ROOM_ID` int(11) DEFAULT NULL,
  `FROM_CATEGORY_ID` int(11) NOT NULL,
  `TO_CATEGORY_ID` int(11) NOT NULL,
  `UPGRADE_ID` int(11) DEFAULT NULL,
  `UPGRADE_TYPE` varchar(20) DEFAULT NULL,
  `AWARDED` varchar(20) DEFAULT NULL,
  `PRICE` float DEFAULT NULL,
  `TOTAL` float DEFAULT NULL,
  `SAVE` float DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `MODIFIED` datetime DEFAULT NULL,
  `CREATED_USER_ID` int(11) DEFAULT NULL,
  `MODIFIED_USER_ID` int(11) DEFAULT '0',
  `GUEST_MODIFIED` datetime DEFAULT NULL,
  `MANAGER_MODIFIED` datetime DEFAULT NULL,
  `GUEST_ID` int(11) DEFAULT NULL,
  `DISPL_POS` varchar(100) DEFAULT NULL,
  `changed_by_user_id` int(11) DEFAULT '0',
  `changed_date` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
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

-- Dump completed on 2012-08-23 21:42:58
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
