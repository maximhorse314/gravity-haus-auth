-- MySQL dump 10.13  Distrib 8.0.30, for macos12.4 (arm64)
--
-- Host: gravityhaus-production-cluster-instance-1.cx7pthlyf3as.us-east-2.rds.amazonaws.com    Database: gh_develop_db
-- ------------------------------------------------------
-- Server version	5.7.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `gh_develop_db`
--

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `verified` tinyint(1) NOT NULL,
  `firstName` varchar(254) NOT NULL,
  `middleName` varchar(254) NOT NULL,
  `lastName` varchar(254) NOT NULL,
  `title` varchar(254) NOT NULL,
  `suffix` varchar(254) NOT NULL,
  `billingAddressId` int(11) DEFAULT NULL,
  `mailingAddressId` int(11) DEFAULT NULL,
  `phoneId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `handle` varchar(254) DEFAULT NULL,
  `preferredLocation` enum('Unspecified','Front Range','Summit County') DEFAULT NULL,
  `preferredIntensity` enum('Low','Medium','High') DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `emailOptIn` tinyint(1) NOT NULL,
  `liabilityWaiver` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `billingAddressId` (`billingAddressId`),
  KEY `mailingAddressId` (`mailingAddressId`),
  KEY `phoneId` (`phoneId`),
  KEY `userId` (`userId`),
  CONSTRAINT `Account_ibfk_1` FOREIGN KEY (`billingAddressId`) REFERENCES `Address` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Account_ibfk_2` FOREIGN KEY (`mailingAddressId`) REFERENCES `Address` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Account_ibfk_3` FOREIGN KEY (`phoneId`) REFERENCES `Phone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Account_ibfk_4` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13249 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `ActiveMemberships`
--

DROP TABLE IF EXISTS `ActiveMemberships`;
/*!50001 DROP VIEW IF EXISTS `ActiveMemberships`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ActiveMemberships` AS SELECT 
 1 AS `userId`,
 1 AS `email`,
 1 AS `name`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ActivityLog`
--

DROP TABLE IF EXISTS `ActivityLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ActivityLog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activityType` varchar(255) NOT NULL,
  `userId` bigint(20) DEFAULT NULL,
  `userEmail` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `result` varchar(255) DEFAULT NULL,
  `requestData` text,
  `resultData` text,
  `dateCreated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10357 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address1` varchar(254) NOT NULL,
  `address2` varchar(254) NOT NULL,
  `address3` varchar(254) NOT NULL,
  `address4` varchar(254) NOT NULL,
  `city` varchar(254) NOT NULL,
  `county` varchar(254) NOT NULL,
  `state` varchar(254) NOT NULL,
  `postalCode` varchar(254) NOT NULL,
  `country` varchar(254) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9757 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AliceConfiguration`
--

DROP TABLE IF EXISTS `AliceConfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AliceConfiguration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `endpoint` varchar(255) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `sms_chat_service_id` int(11) NOT NULL,
  `checkin_failure_service_id` int(11) NOT NULL,
  `checkin_failure_option_id` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `AliceConfiguration_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AliceMapper`
--

DROP TABLE IF EXISTS `AliceMapper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AliceMapper` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requestId` varchar(254) NOT NULL,
  `hotelId` varchar(254) NOT NULL,
  `facilityId` varchar(254) NOT NULL,
  `serviceId` varchar(254) NOT NULL,
  `serviceName` varchar(254) NOT NULL,
  `optionId` varchar(254) DEFAULT NULL,
  `optionValue` varchar(254) DEFAULT NULL,
  `optionName` varchar(254) DEFAULT NULL,
  `optionDisplayValue` varchar(254) DEFAULT NULL,
  `environment` varchar(254) NOT NULL,
  `successResponse` varchar(2048) NOT NULL,
  `failureResponse` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `requestId` (`requestId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AppTour`
--

DROP TABLE IF EXISTS `AppTour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AppTour` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionName` varchar(255) NOT NULL,
  `sectionTitle` varchar(255) NOT NULL,
  `btnText` varchar(255) NOT NULL,
  `videoThumbnailUrl` varchar(255) NOT NULL,
  `videoUrl` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Attachment`
--

DROP TABLE IF EXISTS `Attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mediaType` varchar(254) NOT NULL,
  `url` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Audit`
--

DROP TABLE IF EXISTS `Audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modelId` int(11) NOT NULL,
  `modelName` varchar(255) NOT NULL,
  `values` text NOT NULL,
  `changedValues` text NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4244 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AwsSnsTopic`
--

DROP TABLE IF EXISTS `AwsSnsTopic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AwsSnsTopic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `topicArn` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Benefits`
--

DROP TABLE IF EXISTS `Benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Benefits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `membership` varchar(255) DEFAULT NULL,
  `benefits` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ChangePassword`
--

DROP TABLE IF EXISTS `ChangePassword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ChangePassword` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(254) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `expires` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `ChangePassword_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CreditCard`
--

DROP TABLE IF EXISTS `CreditCard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CreditCard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountId` int(11) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `CreditCard_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `Account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5565 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerSupportEmail`
--

DROP TABLE IF EXISTS `CustomerSupportEmail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerSupportEmail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `destinationName` varchar(255) DEFAULT NULL,
  `description` text,
  `email` varchar(255) DEFAULT NULL,
  `destinationImageUrl` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `lastUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerSupportFaq`
--

DROP TABLE IF EXISTS `CustomerSupportFaq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerSupportFaq` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `answer` text,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `lastUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerSupportHome`
--

DROP TABLE IF EXISTS `CustomerSupportHome`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerSupportHome` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `lastUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerSupportPhone`
--

DROP TABLE IF EXISTS `CustomerSupportPhone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerSupportPhone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locationName` varchar(255) DEFAULT NULL,
  `description` text,
  `contactPhoneNumber` varchar(255) DEFAULT NULL,
  `frontDeskPhoneNumber` varchar(255) DEFAULT NULL,
  `reservationsPhoneNumber` varchar(255) DEFAULT NULL,
  `locationImageUrl` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `lastUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerSupportTypes`
--

DROP TABLE IF EXISTS `CustomerSupportTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerSupportTypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `lastUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DataVault_PIF_END_ANALYSIS`
--

DROP TABLE IF EXISTS `DataVault_PIF_END_ANALYSIS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataVault_PIF_END_ANALYSIS` (
  `email` varchar(128) NOT NULL,
  `stripeSubscriptionId` varchar(128) DEFAULT NULL,
  `membership` varchar(128) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `trialstart` date DEFAULT NULL,
  `trialend` date DEFAULT NULL,
  `expectedtrialend` date DEFAULT NULL,
  `trialendStatus` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DataVault_ReferrerCredits`
--

DROP TABLE IF EXISTS `DataVault_ReferrerCredits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DataVault_ReferrerCredits` (
  `-60.00` double DEFAULT NULL,
  `Referrer Credit` text,
  `in_1HiZbzGuI3uPg2UzQxkQZ5iG` text,
  `9/30/20, 10:28 PM` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Detail`
--

DROP TABLE IF EXISTS `Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entityId` int(11) DEFAULT NULL,
  `entityType` enum('Event','ParticipantPreference','ParticipantProfile','UserPreference','UserProfile') DEFAULT NULL,
  `detailCategoryId` int(11) DEFAULT NULL,
  `name` varchar(254) NOT NULL,
  `value` varchar(255) NOT NULL,
  `staticId` varchar(254) NOT NULL,
  `type` enum('Boolean','Number','Date','List','Text') DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `detailCategoryId` (`detailCategoryId`),
  CONSTRAINT `Detail_ibfk_1` FOREIGN KEY (`detailCategoryId`) REFERENCES `DetailCategory` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DetailCategory`
--

DROP TABLE IF EXISTS `DetailCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DetailCategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DeviceTokens`
--

DROP TABLE IF EXISTS `DeviceTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DeviceTokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(256) NOT NULL,
  `platform` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `lastNotificationDate` datetime NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9968 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EmailVerificationToken`
--

DROP TABLE IF EXISTS `EmailVerificationToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EmailVerificationToken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(254) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `expires` datetime NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5837 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `department` int(11) DEFAULT NULL,
  `departmentRole` int(11) DEFAULT NULL,
  `role` int(11) DEFAULT NULL,
  `contractor` smallint(6) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` int(11) NOT NULL,
  `lastUpdatedAt` datetime NOT NULL,
  `lastUpdatedBy` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event`
--

DROP TABLE IF EXISTS `Event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `endTime` datetime DEFAULT NULL,
  `eventTypeId` int(11) DEFAULT NULL,
  `hasWaitlist` tinyint(1) NOT NULL DEFAULT '0',
  `intensity` enum('Low','Medium','High') DEFAULT NULL,
  `leaderId` int(11) DEFAULT NULL,
  `locationId` int(11) DEFAULT NULL,
  `maxAge` int(11) DEFAULT NULL,
  `maxCapacity` int(11) DEFAULT NULL,
  `maxGuests` int(11) DEFAULT NULL,
  `membersOnly` tinyint(1) NOT NULL DEFAULT '0',
  `minAge` int(11) DEFAULT NULL,
  `minCapacity` int(11) DEFAULT NULL,
  `name` varchar(254) NOT NULL,
  `noCancelWithinHours` int(11) DEFAULT NULL,
  `ownerId` int(11) DEFAULT NULL,
  `pageUrl` varchar(2048) DEFAULT NULL,
  `primaryImageUrl` varchar(2048) DEFAULT NULL,
  `productId` int(11) DEFAULT NULL,
  `promotional` tinyint(1) DEFAULT '0',
  `secondaryImageUrl` varchar(2048) DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `status` enum('Published','Unpublished','Cancelled') DEFAULT 'Unpublished',
  `termsAndConditionsUrl` varchar(2048) DEFAULT NULL,
  `waiverUrl` varchar(2048) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdById` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedById` int(11) DEFAULT NULL,
  `eventAttendanceType` int(11) DEFAULT NULL,
  `eventSkillLevelId` int(11) DEFAULT NULL,
  `eventParticipantTypeId` int(11) DEFAULT NULL,
  `contactNumber` int(11) DEFAULT NULL,
  `publishToFacebook` tinyint(1) DEFAULT NULL,
  `publishToFacebookStatus` tinyint(1) DEFAULT NULL,
  `agreedToTermsAndConditions` tinyint(1) DEFAULT NULL,
  `isGHEvent` tinyint(1) DEFAULT NULL,
  `locationName` varchar(255) DEFAULT NULL,
  `isPaidEvent` tinyint(1) DEFAULT NULL,
  `eventAddressId` int(11) DEFAULT NULL,
  `getStreamActivityId` varchar(255) DEFAULT NULL,
  `getStreamFeedUserId` varchar(255) DEFAULT NULL,
  `cutOffTime` int(11) DEFAULT NULL,
  `mustBring` varchar(255) DEFAULT NULL,
  `recommendedBring` varchar(255) DEFAULT NULL,
  `allowedThings` varchar(255) DEFAULT NULL,
  `notifyHostOnJoin` tinyint(1) NOT NULL,
  `notifyHostOnCancel` tinyint(1) NOT NULL,
  `cancellationReason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eventTypeId` (`eventTypeId`),
  KEY `leaderId` (`leaderId`),
  KEY `locationId` (`locationId`),
  KEY `ownerId` (`ownerId`),
  KEY `productId` (`productId`),
  KEY `createdById` (`createdById`),
  KEY `updatedById` (`updatedById`),
  KEY `Event_eventAddressId_foreign_idx` (`eventAddressId`),
  CONSTRAINT `Event_eventAddressId_foreign_idx` FOREIGN KEY (`eventAddressId`) REFERENCES `EventAddress` (`id`),
  CONSTRAINT `Event_ibfk_1` FOREIGN KEY (`eventTypeId`) REFERENCES `EventType` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_2` FOREIGN KEY (`leaderId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_3` FOREIGN KEY (`locationId`) REFERENCES `Location` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_4` FOREIGN KEY (`ownerId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_5` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_6` FOREIGN KEY (`createdById`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Event_ibfk_7` FOREIGN KEY (`updatedById`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1249 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventAddress`
--

DROP TABLE IF EXISTS `EventAddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventAddress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `addressLine1` varchar(255) DEFAULT NULL,
  `addressLine2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zipCode` int(11) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `placeId` text,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=711 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventAllowedThing`
--

DROP TABLE IF EXISTS `EventAllowedThing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventAllowedThing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventAllowedThingOption`
--

DROP TABLE IF EXISTS `EventAllowedThingOption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventAllowedThingOption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `eventAllowedThingId` int(11) NOT NULL,
  `eventId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=707 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventAttendance`
--

DROP TABLE IF EXISTS `EventAttendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventAttendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attendanceNotes` varchar(2048) DEFAULT NULL,
  `eventId` int(11) DEFAULT NULL,
  `eventBookingId` int(11) DEFAULT NULL,
  `participantId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `participantId` (`participantId`),
  KEY `userId` (`userId`),
  CONSTRAINT `EventAttendance_ibfk_1` FOREIGN KEY (`participantId`) REFERENCES `Participant` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `EventAttendance_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventBooking`
--

DROP TABLE IF EXISTS `EventBooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventBooking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bookingNotes` varchar(2048) DEFAULT NULL,
  `eventId` int(11) DEFAULT NULL,
  `eventBookingStatus` enum('Waitlist','Booked','Cancelled') DEFAULT 'Booked',
  `guests` int(11) DEFAULT NULL,
  `participantId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `paymentIntentId` text,
  `refundId` text,
  PRIMARY KEY (`id`),
  KEY `eventId` (`eventId`),
  KEY `participantId` (`participantId`),
  KEY `userId` (`userId`),
  CONSTRAINT `EventBooking_ibfk_1` FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `EventBooking_ibfk_2` FOREIGN KEY (`participantId`) REFERENCES `Participant` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `EventBooking_ibfk_3` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2023 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventBookingCancellation`
--

DROP TABLE IF EXISTS `EventBookingCancellation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventBookingCancellation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cancellationNotes` varchar(2048) DEFAULT NULL,
  `eventId` int(11) DEFAULT NULL,
  `eventBookingId` int(11) DEFAULT NULL,
  `participantId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `participantId` (`participantId`),
  KEY `userId` (`userId`),
  CONSTRAINT `EventBookingCancellation_ibfk_1` FOREIGN KEY (`participantId`) REFERENCES `Participant` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `EventBookingCancellation_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventBookmark`
--

DROP TABLE IF EXISTS `EventBookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventBookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `EventBookmark_eventId_userId_unique` (`eventId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `EventBookmark_ibfk_1` FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `EventBookmark_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventCategory`
--

DROP TABLE IF EXISTS `EventCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventCategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  `displayOrder` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventGear`
--

DROP TABLE IF EXISTS `EventGear`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventGear` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventGearOption`
--

DROP TABLE IF EXISTS `EventGearOption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventGearOption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `eventGearId` int(11) NOT NULL,
  `eventId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventInvitee`
--

DROP TABLE IF EXISTS `EventInvitee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventInvitee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `emailInviteSent` tinyint(1) NOT NULL,
  `emailInviteSentDate` datetime DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `phoneInviteSent` tinyint(1) NOT NULL,
  `phoneInviteSentDate` datetime DEFAULT NULL,
  `rsvpResponse` varchar(255) DEFAULT NULL,
  `rsvpDate` datetime DEFAULT NULL,
  `inviteCode` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `removed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventLocation`
--

DROP TABLE IF EXISTS `EventLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventLocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locationName` varchar(255) NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventNotificationPublisher`
--

DROP TABLE IF EXISTS `EventNotificationPublisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventNotificationPublisher` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventCategoryId` int(11) NOT NULL,
  `eventId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3666 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventNotificationSubscriber`
--

DROP TABLE IF EXISTS `EventNotificationSubscriber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventNotificationSubscriber` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventCategoryId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16123 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventNotificationWhitelist`
--

DROP TABLE IF EXISTS `EventNotificationWhitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventNotificationWhitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `notificationEnabled` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `notificationType` varchar(255) DEFAULT 'event',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1251 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventParticipantType`
--

DROP TABLE IF EXISTS `EventParticipantType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventParticipantType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventProduct`
--

DROP TABLE IF EXISTS `EventProduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventProduct` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL,
  `price` float NOT NULL,
  `stripeProductId` varchar(255) DEFAULT NULL,
  `stripePriceId` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdById` int(11) DEFAULT NULL,
  `updatedById` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventProfile`
--

DROP TABLE IF EXISTS `EventProfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventProfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `profileImage` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `interestIds` varchar(255) DEFAULT NULL,
  `idealAdventure` varchar(255) DEFAULT NULL,
  `favouriteGhHotel` varchar(255) DEFAULT NULL,
  `favouritePostDrink` varchar(255) DEFAULT NULL,
  `favouriteAdventureSnack` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=658 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventPublicInvitee`
--

DROP TABLE IF EXISTS `EventPublicInvitee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventPublicInvitee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `isNotificationSend` tinyint(1) NOT NULL,
  `eventId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77821 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventQuestions`
--

DROP TABLE IF EXISTS `EventQuestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventQuestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `eventId` int(11) NOT NULL,
  `questionFormatId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eventId` (`eventId`),
  CONSTRAINT `EventQuestions_ibfk_1` FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventQuestionsFormat`
--

DROP TABLE IF EXISTS `EventQuestionsFormat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventQuestionsFormat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventQuizAttemption`
--

DROP TABLE IF EXISTS `EventQuizAttemption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventQuizAttemption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `isAttempted` tinyint(1) NOT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventQuizOptions`
--

DROP TABLE IF EXISTS `EventQuizOptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventQuizOptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `optionText` varchar(255) NOT NULL,
  `isAnswer` tinyint(1) NOT NULL,
  `questionId` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `questionId` (`questionId`),
  CONSTRAINT `EventQuizOptions_ibfk_1` FOREIGN KEY (`questionId`) REFERENCES `EventQuizQuestions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventQuizQuestions`
--

DROP TABLE IF EXISTS `EventQuizQuestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventQuizQuestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questionText` varchar(255) NOT NULL,
  `order` int(11) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventSettings`
--

DROP TABLE IF EXISTS `EventSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventSkillLevel`
--

DROP TABLE IF EXISTS `EventSkillLevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventSkillLevel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventSocialFeed`
--

DROP TABLE IF EXISTS `EventSocialFeed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventSocialFeed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `eventId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2714 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventStaff`
--

DROP TABLE IF EXISTS `EventStaff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventStaff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventId` int(11) DEFAULT NULL,
  `staffId` int(11) DEFAULT NULL,
  `eventRoleId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staffId` (`staffId`),
  KEY `eventRoleId` (`eventRoleId`),
  CONSTRAINT `EventStaff_ibfk_1` FOREIGN KEY (`staffId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `EventStaff_ibfk_2` FOREIGN KEY (`eventRoleId`) REFERENCES `EventStaffRole` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventStaffRole`
--

DROP TABLE IF EXISTS `EventStaffRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventStaffRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventStats`
--

DROP TABLE IF EXISTS `EventStats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventStats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `eventId` (`eventId`),
  CONSTRAINT `EventStats_ibfk_1` FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventTag`
--

DROP TABLE IF EXISTS `EventTag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventTag` (
  `eventId` int(11) NOT NULL DEFAULT '0',
  `tagId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eventId`,`tagId`),
  KEY `tagId` (`tagId`),
  CONSTRAINT `EventTag_ibfk_1` FOREIGN KEY (`eventId`) REFERENCES `Event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `EventTag_ibfk_2` FOREIGN KEY (`tagId`) REFERENCES `Tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventType`
--

DROP TABLE IF EXISTS `EventType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `displayOrder` int(11) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `displayType` int(11) DEFAULT NULL,
  `isForNotification` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventTypeImage`
--

DROP TABLE IF EXISTS `EventTypeImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventTypeImage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventTypeId` int(11) NOT NULL,
  `numImages` int(11) NOT NULL,
  `baseUrl` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EventWebhook`
--

DROP TABLE IF EXISTS `EventWebhook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventWebhook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventType` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FamilyAssociation`
--

DROP TABLE IF EXISTS `FamilyAssociation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FamilyAssociation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `parentId` int(11) DEFAULT NULL,
  `status` enum('Not Yet Accepted','Accepted','Deleted') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `parentId` (`parentId`),
  CONSTRAINT `FamilyAssociation_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `FamilyAssociation_ibfk_2` FOREIGN KEY (`parentId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FamilyAssociationInvitation`
--

DROP TABLE IF EXISTS `FamilyAssociationInvitation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FamilyAssociationInvitation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `associationId` int(11) DEFAULT NULL,
  `email` varchar(254) NOT NULL,
  `token` varchar(254) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `expires` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `associationId` (`associationId`),
  CONSTRAINT `FamilyAssociationInvitation_ibfk_1` FOREIGN KEY (`associationId`) REFERENCES `FamilyAssociation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FamilyIndividual`
--

DROP TABLE IF EXISTS `FamilyIndividual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FamilyIndividual` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `firstName` varchar(254) NOT NULL,
  `middleName` varchar(254) NOT NULL,
  `lastName` varchar(254) NOT NULL,
  `title` varchar(254) NOT NULL,
  `suffix` varchar(254) NOT NULL,
  `dateOfBirth` datetime DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `status` enum('Active','Converted','Deleted') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parentId` (`parentId`),
  CONSTRAINT `FamilyIndividual_ibfk_1` FOREIGN KEY (`parentId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Form`
--

DROP TABLE IF EXISTS `Form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Form` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FormAnswer`
--

DROP TABLE IF EXISTS `FormAnswer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FormAnswer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formId` int(11) DEFAULT NULL,
  `questionId` int(11) DEFAULT NULL,
  `value` varchar(2048) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `formId` (`formId`),
  KEY `questionId` (`questionId`),
  CONSTRAINT `FormAnswer_ibfk_1` FOREIGN KEY (`formId`) REFERENCES `Form` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `FormAnswer_ibfk_2` FOREIGN KEY (`questionId`) REFERENCES `FormQuestion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FormQuestion`
--

DROP TABLE IF EXISTS `FormQuestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FormQuestion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(2048) NOT NULL,
  `subtitle` varchar(2048) NOT NULL,
  `type` enum('single_select','multi_select','text_entry') DEFAULT NULL,
  `formId` int(11) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `formId` (`formId`),
  CONSTRAINT `FormQuestion_ibfk_1` FOREIGN KEY (`formId`) REFERENCES `Form` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FormUserAnswer`
--

DROP TABLE IF EXISTS `FormUserAnswer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FormUserAnswer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questionId` int(11) DEFAULT NULL,
  `value` varchar(2048) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `questionId` (`questionId`),
  KEY `userId` (`userId`),
  CONSTRAINT `FormUserAnswer_ibfk_1` FOREIGN KEY (`questionId`) REFERENCES `FormQuestion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FormUserAnswer_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GlobalSettings`
--

DROP TABLE IF EXISTS `GlobalSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GlobalSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `string_value` varchar(255) DEFAULT NULL,
  `numeric_value` float DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `date_value` datetime DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GlofoxBooking`
--

DROP TABLE IF EXISTS `GlofoxBooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GlofoxBooking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `eventTime` datetime DEFAULT NULL,
  `planName` varchar(254) DEFAULT NULL,
  `membershipName` varchar(254) DEFAULT NULL,
  `glofoxUserName` varchar(254) DEFAULT NULL,
  `eventName` varchar(254) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `GlofoxBooking_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymBooking`
--

DROP TABLE IF EXISTS `GymBooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymBooking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `categoryId` int(11) NOT NULL,
  `locationId` int(11) NOT NULL,
  `bookingId` int(11) NOT NULL,
  `isCancel` tinyint(1) NOT NULL DEFAULT '0',
  `startDateTime` datetime NOT NULL,
  `endDateTime` datetime NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'classes',
  `thirdPartyId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT '2022-07-11 21:40:42',
  `updatedAt` datetime DEFAULT '2022-07-11 21:40:42',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49710 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymCategory`
--

DROP TABLE IF EXISTS `GymCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymCategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locationId` int(11) NOT NULL,
  `categoryId` int(11) NOT NULL DEFAULT '0',
  `categoryType` tinyint(1) DEFAULT '1',
  `categoryName` varchar(255) DEFAULT NULL,
  `displayLabel` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `thirdPartyType` varchar(255) NOT NULL,
  `thirdPartyId` varchar(255) NOT NULL,
  `hasSchedule` tinyint(1) NOT NULL,
  `categoryStatus` tinyint(1) NOT NULL,
  `categoryImageUrl` varchar(255) DEFAULT NULL,
  `mindBodyType` varchar(255) NOT NULL DEFAULT 'Classes',
  `hasTrainer` tinyint(1) NOT NULL DEFAULT '0',
  `locationType` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymCategoryData`
--

DROP TABLE IF EXISTS `GymCategoryData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymCategoryData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoryId` int(11) NOT NULL,
  `isCategory` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `classId` int(11) NOT NULL,
  `locationId` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `notes` text,
  `maxCapacity` int(11) NOT NULL,
  `totalBooked` int(11) NOT NULL,
  `totalBookedWaitlist` tinyint(1) NOT NULL,
  `isEnrolled` tinyint(1) NOT NULL,
  `isCanceled` tinyint(1) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `isWaitlistAvailable` tinyint(1) NOT NULL,
  `startDateTime` datetime NOT NULL,
  `endDateTime` datetime NOT NULL,
  `lastModifiedDateTime` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `levelId` varchar(255) NOT NULL,
  `levelName` varchar(255) DEFAULT NULL,
  `levelDescription` varchar(255) DEFAULT NULL,
  `bookingWindowStartDateTime` datetime DEFAULT NULL,
  `bookingWindowEndDateTime` datetime DEFAULT NULL,
  `bookingStatus` varchar(255) DEFAULT NULL,
  `virtualStreamLink` varchar(255) DEFAULT NULL,
  `staffId` int(11) DEFAULT NULL,
  `staffFirstName` varchar(255) DEFAULT NULL,
  `staffLastName` varchar(255) DEFAULT NULL,
  `staffPhoneNumber` varchar(255) DEFAULT NULL,
  `staffEmail` varchar(255) DEFAULT NULL,
  `staffBio` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymCustomerData`
--

DROP TABLE IF EXISTS `GymCustomerData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymCustomerData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `thirdPartyId` varchar(254) NOT NULL,
  `gymLocationId` varchar(255) NOT NULL,
  `gymSystemId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `emailOptIn` tinyint(1) NOT NULL,
  `liabilityWaiver` tinyint(1) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `thirdPartyEmail` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9431 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymLocation`
--

DROP TABLE IF EXISTS `GymLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymLocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `businessDescription` text,
  `description` varchar(255) DEFAULT NULL,
  `hasClasses` tinyint(1) NOT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) NOT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `locationName` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `phoneExtension` varchar(255) DEFAULT NULL,
  `zipCode` varchar(255) DEFAULT NULL,
  `thirdPartySiteId` varchar(255) DEFAULT NULL,
  `stateProvCode` varchar(255) DEFAULT NULL,
  `displayOrder` int(11) NOT NULL,
  `locationStatus` int(11) NOT NULL,
  `state` varchar(255) DEFAULT NULL,
  `openTime` varchar(255) DEFAULT NULL,
  `closeTime` varchar(255) DEFAULT NULL,
  `openDays` varchar(255) DEFAULT NULL,
  `imageLocationUrl` varchar(255) DEFAULT NULL,
  `user` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `apiKey` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `baseUrl` varchar(255) NOT NULL DEFAULT 'https://api.mindbodyonline.com/public/v6',
  `timezone` varchar(255) DEFAULT NULL,
  `locationType` int(11) NOT NULL DEFAULT '1',
  `isSubLocation` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymLocations`
--

DROP TABLE IF EXISTS `GymLocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymLocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `branch_id` varchar(254) NOT NULL,
  `gymSystemId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `branch_id` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymMembershipData`
--

DROP TABLE IF EXISTS `GymMembershipData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymMembershipData` (
  `id` int(11) NOT NULL,
  `subscriptionId` int(11) NOT NULL,
  `ghMembershipPlanId` varchar(255) NOT NULL,
  `gymLocationId` varchar(255) NOT NULL,
  `gymMembershipId` varchar(255) NOT NULL,
  `gymMembershipPlan` varchar(255) NOT NULL,
  `gymSystemId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GymSettings`
--

DROP TABLE IF EXISTS `GymSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GymSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Haus`
--

DROP TABLE IF EXISTS `Haus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Haus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `location_description` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `iqware_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `payment_url` varchar(1024) NOT NULL DEFAULT 'https://gatewaydemomoc.elavon.net:7006/?CHAINCODE=TSTLA3&LOCATION_ID=SIMTESTVOLT&TERMINAL_ID=RETERM1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `support_email` varchar(255) DEFAULT NULL,
  `support_phone` varchar(255) DEFAULT NULL,
  `booking_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `use_booking_url` tinyint(1) NOT NULL DEFAULT '0',
  `country` varchar(255) NOT NULL DEFAULT 'US',
  `is_partner_property` tinyint(1) NOT NULL DEFAULT '0',
  `is_coming_soon` tinyint(1) NOT NULL DEFAULT '0',
  `rank` int(11) NOT NULL,
  `iqvault_username` varchar(45) DEFAULT NULL,
  `iqvault_password` varchar(45) DEFAULT NULL,
  `checkin_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `slack_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `use_notification_whitelist` tinyint(1) NOT NULL DEFAULT '1',
  `slack_channel` varchar(255) DEFAULT NULL,
  `display_pet_policy` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausAmenities`
--

DROP TABLE IF EXISTS `HausAmenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausAmenities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `icon_url` varchar(255) DEFAULT NULL,
  `icon_name` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausAmenities_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausBookingUrls`
--

DROP TABLE IF EXISTS `HausBookingUrls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausBookingUrls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `rate_type` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausBookingUrls_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausCancellationPolicy`
--

DROP TABLE IF EXISTS `HausCancellationPolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausCancellationPolicy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `header` varchar(255) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `rank` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausCancellationPolicy_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausCancellationReasons`
--

DROP TABLE IF EXISTS `HausCancellationReasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausCancellationReasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` int(11) NOT NULL,
  `reason` varchar(1024) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausCancellationReasons_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausElements`
--

DROP TABLE IF EXISTS `HausElements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausElements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `iqware_element_id` int(11) NOT NULL,
  `iqware_element_name` varchar(255) NOT NULL,
  `element_type` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausElements_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausFeed`
--

DROP TABLE IF EXISTS `HausFeed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausFeed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feed` text,
  `hausType` varchar(255) DEFAULT NULL,
  `topic` varchar(45) DEFAULT NULL,
  `publishStatus` int(11) NOT NULL DEFAULT '0',
  `targetUserType` int(11) NOT NULL DEFAULT '3',
  `displayLocation` varchar(255) DEFAULT NULL,
  `displayOnHausFeed` int(11) NOT NULL DEFAULT '1',
  `hausFeedDisplayOrder` int(11) NOT NULL DEFAULT '0',
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `createdOn` bigint(20) NOT NULL DEFAULT '1620066358584',
  `screen` varchar(255) DEFAULT NULL,
  `archived` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausFeedStats`
--

DROP TABLE IF EXISTS `HausFeedStats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausFeedStats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hausFeedId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9837 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausGuestHistory`
--

DROP TABLE IF EXISTS `HausGuestHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausGuestHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hausId` int(11) DEFAULT NULL,
  `iqwareGuid` int(11) DEFAULT NULL,
  `confirmationCode` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `firstName` varchar(256) DEFAULT NULL,
  `lastName` varchar(256) DEFAULT NULL,
  `roomType` varchar(512) DEFAULT NULL,
  `roomTypeId` int(11) DEFAULT NULL,
  `bookingDate` datetime DEFAULT NULL,
  `arrivalDate` datetime DEFAULT NULL,
  `departureDate` datetime DEFAULT NULL,
  `guestCount` int(11) DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL,
  `bookingSource` varchar(128) DEFAULT NULL,
  `bookingType` varchar(45) DEFAULT NULL,
  `rateCode` varchar(45) DEFAULT NULL,
  `rateCodeId` int(11) DEFAULT NULL,
  `rateName` varchar(45) DEFAULT NULL,
  `city` varchar(256) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zipcode` varchar(45) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42052 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausGuestHistoryBackup`
--

DROP TABLE IF EXISTS `HausGuestHistoryBackup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausGuestHistoryBackup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hausId` int(11) DEFAULT NULL,
  `iqwareGuid` int(11) DEFAULT NULL,
  `confirmationCode` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `firstName` varchar(256) DEFAULT NULL,
  `lastName` varchar(256) DEFAULT NULL,
  `roomType` varchar(512) DEFAULT NULL,
  `roomTypeId` int(11) DEFAULT NULL,
  `bookingDate` datetime DEFAULT NULL,
  `arrivalDate` datetime DEFAULT NULL,
  `departureDate` datetime DEFAULT NULL,
  `guestCount` int(11) DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL,
  `bookingSource` varchar(128) DEFAULT NULL,
  `bookingType` varchar(45) DEFAULT NULL,
  `rateCode` varchar(45) DEFAULT NULL,
  `rateCodeId` int(11) DEFAULT NULL,
  `rateName` varchar(45) DEFAULT NULL,
  `city` varchar(256) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zipcode` varchar(45) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23719 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausGuestHistoryBackup2`
--

DROP TABLE IF EXISTS `HausGuestHistoryBackup2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausGuestHistoryBackup2` (
  `id` int(11) NOT NULL DEFAULT '0',
  `hausId` int(11) DEFAULT NULL,
  `iqwareGuid` int(11) DEFAULT NULL,
  `confirmationCode` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `firstName` varchar(256) DEFAULT NULL,
  `lastName` varchar(256) DEFAULT NULL,
  `roomType` varchar(512) DEFAULT NULL,
  `roomTypeId` int(11) DEFAULT NULL,
  `bookingDate` datetime DEFAULT NULL,
  `arrivalDate` datetime DEFAULT NULL,
  `departureDate` datetime DEFAULT NULL,
  `guestCount` int(11) DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL,
  `bookingSource` varchar(128) DEFAULT NULL,
  `bookingType` varchar(45) DEFAULT NULL,
  `rateCode` varchar(45) DEFAULT NULL,
  `rateCodeId` int(11) DEFAULT NULL,
  `rateName` varchar(45) DEFAULT NULL,
  `city` varchar(256) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zipcode` varchar(45) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausGuestPolicy`
--

DROP TABLE IF EXISTS `HausGuestPolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausGuestPolicy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `header` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `rank` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausGuestPolicy_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausKeys`
--

DROP TABLE IF EXISTS `HausKeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausKeys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `haus_id` int(11) NOT NULL,
  `key` varchar(2000) NOT NULL,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL,
  `primary_room` varchar(100) NOT NULL,
  `secondary_room` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_copy` tinyint(1) NOT NULL DEFAULT '0',
  `last_access_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `iqware_folio` varchar(200) DEFAULT NULL,
  `lateCheckOut` tinyint(1) NOT NULL DEFAULT '0',
  `displayTime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausMasterCalendar`
--

DROP TABLE IF EXISTS `HausMasterCalendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausMasterCalendar` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  `iqware_id` int(11) NOT NULL,
  `haus_id` int(11) NOT NULL,
  `haus_name` varchar(1024) NOT NULL,
  `haus_city` varchar(256) NOT NULL,
  `haus_state` varchar(256) NOT NULL,
  `room_type` int(11) NOT NULL,
  `room_name` varchar(1024) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL,
  `room_number` varchar(255) DEFAULT NULL,
  `floor_number` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL,
  `rate_code` int(11) NOT NULL,
  `rate_name` varchar(256) DEFAULT NULL,
  `price` float NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausPetPolicy`
--

DROP TABLE IF EXISTS `HausPetPolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausPetPolicy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `header` varchar(255) DEFAULT NULL,
  `description` varchar(2550) NOT NULL,
  `rank` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausPetPolicy_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausQuiverCart`
--

DROP TABLE IF EXISTS `HausQuiverCart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausQuiverCart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `productItemId` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `cartId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `orderedAt` datetime DEFAULT NULL,
  `orderPlaced` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausRates`
--

DROP TABLE IF EXISTS `HausRates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausRates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `iqware_rate_id` int(11) NOT NULL,
  `iqware_rate_name` varchar(255) NOT NULL,
  `rate_type` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausRates_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausReservations`
--

DROP TABLE IF EXISTS `HausReservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausReservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `confirmation_code` varchar(255) NOT NULL,
  `deposit` float NOT NULL,
  `stay_value` float NOT NULL,
  `to` datetime NOT NULL,
  `from` datetime NOT NULL,
  `rate_code` int(11) NOT NULL,
  `room_type` int(11) NOT NULL,
  `haus_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6032 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausRoomBeds`
--

DROP TABLE IF EXISTS `HausRoomBeds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausRoomBeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `count` int(11) NOT NULL,
  `haus_room_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_room_type_id` (`haus_room_type_id`),
  CONSTRAINT `HausRoomBeds_ibfk_1` FOREIGN KEY (`haus_room_type_id`) REFERENCES `HausRoomType` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausRoomImages`
--

DROP TABLE IF EXISTS `HausRoomImages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausRoomImages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `rank` int(11) NOT NULL,
  `haus_room_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_room_type_id` (`haus_room_type_id`),
  CONSTRAINT `HausRoomImages_ibfk_1` FOREIGN KEY (`haus_room_type_id`) REFERENCES `HausRoomType` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausRoomType`
--

DROP TABLE IF EXISTS `HausRoomType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausRoomType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iqware_room_type_name` varchar(255) NOT NULL,
  `iqware_room_type_id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `short_description` varchar(2000) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `occupancy` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `display_size` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausRoomType_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausServices`
--

DROP TABLE IF EXISTS `HausServices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausServices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `iqware_service_id` int(11) NOT NULL,
  `iqware_service_name` varchar(255) NOT NULL,
  `service_type` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `haus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `haus_id` (`haus_id`),
  CONSTRAINT `HausServices_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausSharedKeys`
--

DROP TABLE IF EXISTS `HausSharedKeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausSharedKeys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_user_id` int(11) NOT NULL,
  `shared_user_id` int(11) DEFAULT NULL,
  `shared_user_email` varchar(2000) NOT NULL,
  `key_id` int(11) DEFAULT NULL,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_access_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `shared_user_name` varchar(200) DEFAULT NULL,
  `shared_user_phone` varchar(200) DEFAULT NULL,
  `lateCheckOut` tinyint(1) NOT NULL DEFAULT '0',
  `displayTime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausTileContent`
--

DROP TABLE IF EXISTS `HausTileContent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausTileContent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `haus_tile_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` varchar(2000) DEFAULT NULL,
  `image_url` varchar(2000) DEFAULT NULL,
  `rank` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausTileContentActions`
--

DROP TABLE IF EXISTS `HausTileContentActions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausTileContentActions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `haus_tile_content_id` int(11) NOT NULL,
  `button_title` varchar(255) DEFAULT NULL,
  `rank` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `default_action_url` varchar(2000) DEFAULT '0',
  `android_action_url` varchar(2000) DEFAULT NULL,
  `member_action_url` varchar(2000) DEFAULT '0',
  `require_alert` tinyint(1) NOT NULL DEFAULT '0',
  `alert_description` varchar(2000) DEFAULT NULL,
  `alert_confirmation` varchar(256) DEFAULT NULL,
  `ios_view_controller_identifier` varchar(2000) DEFAULT NULL,
  `android_view_controller_identifier` varchar(2000) DEFAULT NULL,
  `target_tile_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HausTiles`
--

DROP TABLE IF EXISTS `HausTiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HausTiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `tile_image_url` varchar(2000) NOT NULL,
  `header_image_url` varchar(2000) DEFAULT NULL,
  `rank` int(11) NOT NULL,
  `has_native_content` tinyint(1) NOT NULL DEFAULT '0',
  `ios_view_controller_identifier` varchar(2000) DEFAULT NULL,
  `android_view_controller_identifier` varchar(2000) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `is_member_only` tinyint(1) NOT NULL DEFAULT '0',
  `parent_tile_id` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `HotelGuestData`
--

DROP TABLE IF EXISTS `HotelGuestData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HotelGuestData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT '0',
  `email` varchar(254) NOT NULL,
  `confirmationNumber` varchar(254) NOT NULL,
  `roomNumber` int(11) DEFAULT NULL,
  `arrivalDate` datetime NOT NULL,
  `departureDate` datetime NOT NULL,
  `thirdPartyId` varchar(254) NOT NULL,
  `syncWithTP` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `IQWareCancellations`
--

DROP TABLE IF EXISTS `IQWareCancellations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IQWareCancellations` (
  `cancellation_number` int(11) NOT NULL,
  `confirmation_code` int(11) DEFAULT NULL,
  `cancellation_date` datetime DEFAULT NULL,
  `due_to_payment_failure` tinyint(4) NOT NULL DEFAULT '0',
  `haus_id` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`cancellation_number`,`haus_id`),
  KEY `IQWareCancellations_ibfk_1` (`haus_id`),
  CONSTRAINT `IQWareCancellations_ibfk_1` FOREIGN KEY (`haus_id`) REFERENCES `Haus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Link`
--

DROP TABLE IF EXISTS `Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(254) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Location`
--

DROP TABLE IF EXISTS `Location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locationTypeId` int(11) DEFAULT NULL,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `directions` varchar(2048) DEFAULT NULL,
  `addressId` int(11) DEFAULT NULL,
  `latitude` int(11) DEFAULT NULL,
  `longitude` int(11) DEFAULT NULL,
  `mapUrl` varchar(2048) DEFAULT NULL,
  `contactName` varchar(2048) DEFAULT NULL,
  `contactPhone1Id` int(11) DEFAULT NULL,
  `contactPhone2Id` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `locationTypeId` (`locationTypeId`),
  KEY `addressId` (`addressId`),
  KEY `contactPhone1Id` (`contactPhone1Id`),
  KEY `contactPhone2Id` (`contactPhone2Id`),
  CONSTRAINT `Location_ibfk_1` FOREIGN KEY (`locationTypeId`) REFERENCES `LocationType` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Location_ibfk_2` FOREIGN KEY (`addressId`) REFERENCES `Address` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Location_ibfk_3` FOREIGN KEY (`contactPhone1Id`) REFERENCES `Phone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Location_ibfk_4` FOREIGN KEY (`contactPhone2Id`) REFERENCES `Phone` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `LocationType`
--

DROP TABLE IF EXISTS `LocationType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LocationType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MagicAuthTokenPair`
--

DROP TABLE IF EXISTS `MagicAuthTokenPair`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MagicAuthTokenPair` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `token` varchar(254) NOT NULL,
  `auth` varchar(254) NOT NULL,
  `valid` tinyint(1) NOT NULL,
  `used` tinyint(1) NOT NULL,
  `expires` datetime NOT NULL,
  `created` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `MagicAuthTokenPair_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2537 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MemberCancellationNotificationHistory`
--

DROP TABLE IF EXISTS `MemberCancellationNotificationHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MemberCancellationNotificationHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `stripePlanId` varchar(255) DEFAULT NULL,
  `subscriptionStartDate` datetime DEFAULT NULL,
  `notficationDate` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `MemberCancellationNotificationHistory_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=917 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MemberCancellationNotificationTracker`
--

DROP TABLE IF EXISTS `MemberCancellationNotificationTracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MemberCancellationNotificationTracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memberCancellationNotificationHistoryId` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `actionResult` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `memberCancellationNotificationHistoryId` (`memberCancellationNotificationHistoryId`),
  CONSTRAINT `MemberCancellationNotificationTracker_ibfk_1` FOREIGN KEY (`memberCancellationNotificationHistoryId`) REFERENCES `MemberCancellationNotificationHistory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Membership`
--

DROP TABLE IF EXISTS `Membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Membership` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `planId` int(11) NOT NULL,
  `plans` text NOT NULL,
  `location` text NOT NULL,
  `addOns` text NOT NULL,
  `sequenceId` int(11) NOT NULL,
  `displayText` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipApplication`
--

DROP TABLE IF EXISTS `MembershipApplication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipApplication` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formId` int(11) DEFAULT NULL,
  `subscriptionId` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `formId` (`formId`),
  KEY `MembershipApplication_subscriptionId_foreign_idx` (`subscriptionId`),
  CONSTRAINT `MembershipApplication_ibfk_1` FOREIGN KEY (`formId`) REFERENCES `Form` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `MembershipApplication_subscriptionId_foreign_idx` FOREIGN KEY (`subscriptionId`) REFERENCES `Subscription` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=822 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipApplicationStatus`
--

DROP TABLE IF EXISTS `MembershipApplicationStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipApplicationStatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `applicationId` int(11) DEFAULT NULL,
  `status` enum('NEW','UNDER_REVIEW','APPROVE','DENY','OVERDUE','CANCEL','COUPON_FAILED','STRIPE_FAILED') DEFAULT NULL,
  `stripeSubscriptionId` text,
  `startDate` datetime DEFAULT NULL,
  `renewalDate` datetime DEFAULT NULL,
  `stripeCoupon` text,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `applicationId` (`applicationId`),
  CONSTRAINT `MembershipApplicationStatus_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `MembershipApplicationStatus_ibfk_2` FOREIGN KEY (`applicationId`) REFERENCES `MembershipApplication` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7066 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipBenefitRule`
--

DROP TABLE IF EXISTS `MembershipBenefitRule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipBenefitRule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `membershipTypeId` bigint(20) NOT NULL,
  `benefitType` int(11) NOT NULL,
  `benefitValue` decimal(10,3) NOT NULL,
  `benefitValueType` int(11) NOT NULL,
  `minmaxType` int(11) DEFAULT NULL,
  `min` decimal(10,3) DEFAULT NULL,
  `max` decimal(10,3) DEFAULT NULL,
  `usage` decimal(10,3) DEFAULT NULL,
  `period` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipBenefitUsage`
--

DROP TABLE IF EXISTS `MembershipBenefitUsage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipBenefitUsage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userId` bigint(20) NOT NULL,
  `membershipBenefitRuleId` bigint(20) NOT NULL,
  `benefitType` int(11) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` bigint(20) NOT NULL,
  `lastUpdatedAt` datetime NOT NULL,
  `lastUpdatedBy` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipBenefits`
--

DROP TABLE IF EXISTS `MembershipBenefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipBenefits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `benefitLink` text,
  `membership` varchar(255) DEFAULT NULL,
  `membershipTypeId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membershipTypeId` (`membershipTypeId`),
  CONSTRAINT `MembershipBenefits_ibfk_1` FOREIGN KEY (`membershipTypeId`) REFERENCES `MembershipType` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipLocation`
--

DROP TABLE IF EXISTS `MembershipLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipLocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `displayName` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `membershipTypeId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membershipTypeId` (`membershipTypeId`),
  CONSTRAINT `MembershipLocation_ibfk_1` FOREIGN KEY (`membershipTypeId`) REFERENCES `MembershipType` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipPlan`
--

DROP TABLE IF EXISTS `MembershipPlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipPlan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `membershipTypeId` int(11) NOT NULL,
  `parentId` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `isAddOn` tinyint(1) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `pricePeriod` varchar(255) NOT NULL,
  `stripePlanId` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `isFamilyPlan` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `displayName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipPrice`
--

DROP TABLE IF EXISTS `MembershipPrice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipPrice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` varchar(255) DEFAULT NULL,
  `membershipPlanId` int(11) NOT NULL,
  `pricePeriod` varchar(255) DEFAULT NULL,
  `displayName` varchar(255) DEFAULT NULL,
  `stripePlanId` varchar(255) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `membershipPlanId` (`membershipPlanId`),
  CONSTRAINT `MembershipPrice_ibfk_1` FOREIGN KEY (`membershipPlanId`) REFERENCES `MembershipPlan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipStatusReport`
--

DROP TABLE IF EXISTS `MembershipStatusReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipStatusReport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `canceledWithBalanceWithinThreeMonths` int(11) NOT NULL,
  `canceledTotalLoss` int(11) NOT NULL,
  `netChange` int(11) NOT NULL,
  `netGrowth` float NOT NULL,
  `memberRetentionRate` float NOT NULL,
  `outOfContractRetentionRate` float NOT NULL,
  `inContractRetentionRate` float NOT NULL,
  `investorsRetentionRate` float NOT NULL,
  `employeesRetentionRate` float NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `currentActive` int(11) DEFAULT NULL,
  `currentTrialing` int(11) DEFAULT NULL,
  `currentUnpaid` int(11) DEFAULT NULL,
  `currentPastDue` int(11) DEFAULT NULL,
  `currentCanceled` int(11) DEFAULT NULL,
  `currentEmployees` int(11) DEFAULT NULL,
  `currentInvestors` int(11) DEFAULT NULL,
  `currentPaused` int(11) DEFAULT NULL,
  `totalActiveInPeriod` int(11) DEFAULT NULL,
  `newSubscriptionsInPeriod` int(11) DEFAULT NULL,
  `paymentHolidaySubscriptionsInPeriod` int(11) DEFAULT NULL,
  `firstTimePaymentInPeriod` int(11) DEFAULT NULL,
  `payingSubscriptionsInPeriod` int(11) DEFAULT NULL,
  `employeesInPeriod` int(11) DEFAULT NULL,
  `investorsInPeriod` int(11) DEFAULT NULL,
  `unpaidInPeriod` int(11) DEFAULT NULL,
  `pastDueInPeriod` int(11) DEFAULT NULL,
  `canceledWithOutRenewalInPeriod` int(11) DEFAULT NULL,
  `canceledWithOutBalanceInPeriod` int(11) DEFAULT NULL,
  `canceledWithNegativeBalanceInPeriod` int(11) DEFAULT NULL,
  `currentOutOfContract` int(11) DEFAULT NULL,
  `notPayingSubscriptionsInPeriod` int(11) DEFAULT NULL,
  `expiringContractsInPeriod` int(11) DEFAULT NULL,
  `outOfContractInPeriod` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MembershipType`
--

DROP TABLE IF EXISTS `MembershipType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MembershipType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `pricePeriod` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `MembershipType` varchar(255) DEFAULT NULL,
  `displayName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Message`
--

DROP TABLE IF EXISTS `Message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `messageFromId` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `publishStatus` int(11) DEFAULT NULL,
  `publishStartDate` datetime DEFAULT NULL,
  `publishEndDate` datetime DEFAULT NULL,
  `language` varchar(254) NOT NULL,
  `title` varchar(254) NOT NULL,
  `summary` varchar(254) NOT NULL,
  `content` varchar(254) NOT NULL,
  `thumbnailId` int(11) DEFAULT NULL,
  `action` int(11) DEFAULT NULL,
  `url` varchar(254) NOT NULL,
  `edited` tinyint(1) NOT NULL DEFAULT '0',
  `likeable` tinyint(1) NOT NULL DEFAULT '0',
  `sharable` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `messageFromId` (`messageFromId`),
  KEY `thumbnailId` (`thumbnailId`),
  CONSTRAINT `Message_ibfk_1` FOREIGN KEY (`messageFromId`) REFERENCES `MessageFrom` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Message_ibfk_2` FOREIGN KEY (`thumbnailId`) REFERENCES `Attachment` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageAccount`
--

DROP TABLE IF EXISTS `MessageAccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageAccount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(254) NOT NULL,
  `type` int(11) NOT NULL,
  `dateSubscribed` datetime DEFAULT NULL,
  `accountId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `MessageAccount_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `Account` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageAttachment`
--

DROP TABLE IF EXISTS `MessageAttachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageAttachment` (
  `messageId` int(11) NOT NULL DEFAULT '0',
  `attachmentId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`messageId`,`attachmentId`),
  KEY `attachmentId` (`attachmentId`),
  CONSTRAINT `MessageAttachment_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `Message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `MessageAttachment_ibfk_2` FOREIGN KEY (`attachmentId`) REFERENCES `Attachment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageFrom`
--

DROP TABLE IF EXISTS `MessageFrom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageFrom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(254) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageLink`
--

DROP TABLE IF EXISTS `MessageLink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageLink` (
  `messageId` int(11) NOT NULL DEFAULT '0',
  `linkId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`messageId`,`linkId`),
  KEY `linkId` (`linkId`),
  CONSTRAINT `MessageLink_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `Message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `MessageLink_ibfk_2` FOREIGN KEY (`linkId`) REFERENCES `Link` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageTag`
--

DROP TABLE IF EXISTS `MessageTag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageTag` (
  `messageId` int(11) NOT NULL DEFAULT '0',
  `tagId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`messageId`,`tagId`),
  KEY `tagId` (`tagId`),
  CONSTRAINT `MessageTag_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `Message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `MessageTag_ibfk_2` FOREIGN KEY (`tagId`) REFERENCES `Tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageTo`
--

DROP TABLE IF EXISTS `MessageTo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageTo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to` varchar(254) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MessageTos`
--

DROP TABLE IF EXISTS `MessageTos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MessageTos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `messageId` int(11) DEFAULT NULL,
  `messageToId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `MessageTos_messageId_messageToId_unique` (`messageId`,`messageToId`),
  KEY `messageToId` (`messageToId`),
  CONSTRAINT `MessageTos_ibfk_1` FOREIGN KEY (`messageId`) REFERENCES `Message` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `MessageTos_ibfk_2` FOREIGN KEY (`messageToId`) REFERENCES `MessageTo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MobileCheckin`
--

DROP TABLE IF EXISTS `MobileCheckin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MobileCheckin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hausId` int(11) NOT NULL,
  `iqwareGuid` int(11) NOT NULL,
  `folio` varchar(256) NOT NULL,
  `unit` varchar(256) NOT NULL,
  `unitName` varchar(1000) NOT NULL,
  `firstName` varchar(512) NOT NULL,
  `lastName` varchar(512) NOT NULL,
  `phone` varchar(256) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `preAuthAmount` varchar(256) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `pin` varchar(5) DEFAULT NULL,
  `checkinSuccessDate` datetime DEFAULT NULL,
  `checkinFailureDate` datetime DEFAULT NULL,
  `checkinFailureReason` varchar(2000) DEFAULT NULL,
  `checkinNotificationDate` datetime DEFAULT NULL,
  `keySentNotificationDate` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `depositDueAmount` varchar(256) DEFAULT '0',
  `stayLength` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_index` (`folio`,`iqwareGuid`)
) ENGINE=InnoDB AUTO_INCREMENT=21266 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `NotificationWhitelist`
--

DROP TABLE IF EXISTS `NotificationWhitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NotificationWhitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OldMembershipInfo`
--

DROP TABLE IF EXISTS `OldMembershipInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OldMembershipInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `membershipName` varchar(256) NOT NULL,
  `replacementName` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=642 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OnBoardingBenefitsOptions`
--

DROP TABLE IF EXISTS `OnBoardingBenefitsOptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OnBoardingBenefitsOptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `bgImage` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OnBoardingDescriptionOptions`
--

DROP TABLE IF EXISTS `OnBoardingDescriptionOptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OnBoardingDescriptionOptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OnBoardingDestinationOptions`
--

DROP TABLE IF EXISTS `OnBoardingDestinationOptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OnBoardingDestinationOptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OnBoardingOutdoorActivitiesOptions`
--

DROP TABLE IF EXISTS `OnBoardingOutdoorActivitiesOptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OnBoardingOutdoorActivitiesOptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) NOT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Participant`
--

DROP TABLE IF EXISTS `Participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Participant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(254) NOT NULL,
  `middleName` varchar(254) NOT NULL,
  `lastName` varchar(254) NOT NULL,
  `accountId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `dateOfBirth` datetime DEFAULT NULL,
  `active` int(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `Participant_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `Account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8330 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ParticipantSubscription`
--

DROP TABLE IF EXISTS `ParticipantSubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ParticipantSubscription` (
  `participantId` int(11) NOT NULL DEFAULT '0',
  `subscriptionId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`participantId`,`subscriptionId`),
  UNIQUE KEY `ParticipantSubscription_subscriptionId_participantId_unique` (`participantId`,`subscriptionId`),
  KEY `subscriptionId` (`subscriptionId`),
  CONSTRAINT `ParticipantSubscription_ibfk_1` FOREIGN KEY (`participantId`) REFERENCES `Participant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ParticipantSubscription_ibfk_2` FOREIGN KEY (`subscriptionId`) REFERENCES `Subscription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ParticipantType`
--

DROP TABLE IF EXISTS `ParticipantType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ParticipantType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `maxGuestAllowed` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PasswordReset`
--

DROP TABLE IF EXISTS `PasswordReset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PasswordReset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(254) NOT NULL,
  `auth` varchar(254) NOT NULL,
  `valid` tinyint(1) NOT NULL,
  `used` tinyint(1) NOT NULL,
  `expires` datetime NOT NULL,
  `created` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `PasswordReset_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4750 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Phone`
--

DROP TABLE IF EXISTS `Phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Phone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `countryCode` varchar(3) NOT NULL,
  `number` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5820 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `sku` varchar(254) DEFAULT NULL,
  `description` text NOT NULL,
  `unitOfMeasure` varchar(255) NOT NULL,
  `unitCost` float NOT NULL,
  `unitPrice` float NOT NULL,
  `stripeProductId` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=981 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ProspectTracker`
--

DROP TABLE IF EXISTS `ProspectTracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProspectTracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `values` text,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=560 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Referral`
--

DROP TABLE IF EXISTS `Referral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Referral` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `referrerUserId` bigint(20) DEFAULT NULL,
  `referrerEmail` varchar(255) DEFAULT NULL,
  `recipientUserId` bigint(20) DEFAULT NULL,
  `recipientEmail` varchar(255) DEFAULT NULL,
  `couponId` bigint(20) DEFAULT NULL,
  `coupon` varchar(255) NOT NULL,
  `stripePlanId` varchar(255) NOT NULL,
  `stripeToken` varchar(255) NOT NULL,
  `noteForRecipient` text,
  `status` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `createdBy` bigint(20) NOT NULL,
  `lastUpdatedAt` datetime NOT NULL,
  `lastUpdatedBy` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3625 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RegistrationToken`
--

DROP TABLE IF EXISTS `RegistrationToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RegistrationToken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(256) NOT NULL,
  `platform` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `lastNotificationDate` datetime NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7605 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RegistrationVerificationCode`
--

DROP TABLE IF EXISTS `RegistrationVerificationCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RegistrationVerificationCode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `code` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `expiresAt` datetime NOT NULL,
  `status` int(11) NOT NULL,
  `verificationAttempts` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalActivityStream`
--

DROP TABLE IF EXISTS `RentalActivityStream`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalActivityStream` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `objectType` varchar(64) DEFAULT NULL,
  `objectId` int(11) DEFAULT NULL,
  `creationDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `RentalActivityStream_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=133544 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalBooking`
--

DROP TABLE IF EXISTS `RentalBooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalBooking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `alternatePickupLocationId` int(11) DEFAULT NULL,
  `alternateDropoffLocationId` int(11) DEFAULT NULL,
  `pickupLockerId` int(11) DEFAULT NULL,
  `dropOfflLockerId` int(11) DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `cancelled` tinyint(4) NOT NULL DEFAULT '0',
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `thirdPartyName` varchar(255) DEFAULT NULL,
  `expectedDropoffHour` int(11) DEFAULT NULL,
  `expectedDropoffMinute` int(11) DEFAULT NULL,
  `expectedPickupHour` int(11) DEFAULT NULL,
  `expectedPickupMinute` int(11) DEFAULT NULL,
  `rentalProductVariantId` int(11) DEFAULT '0',
  `rentalProductItemId` int(11) DEFAULT NULL,
  `rentalProductId` int(11) DEFAULT NULL,
  `rentalLocationId` int(11) DEFAULT NULL,
  `rentalTypeId` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `status` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `returnStatus` int(11) DEFAULT NULL,
  `returnedDate` datetime DEFAULT NULL,
  `checkedOutAt` datetime DEFAULT NULL,
  `checkedOutBy` int(11) DEFAULT '0',
  `checkedInAt` datetime DEFAULT NULL,
  `checkedInBy` int(11) DEFAULT '0',
  `categoryName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `alternatePickupLocationId` (`alternatePickupLocationId`),
  KEY `alternateDropoffLocationId` (`alternateDropoffLocationId`),
  KEY `pickupLockerId` (`pickupLockerId`),
  KEY `dropOfflLockerId` (`dropOfflLockerId`),
  KEY `rentalProductItemId` (`rentalProductItemId`),
  KEY `rentalLocationId` (`rentalLocationId`),
  KEY `rentalTypeId` (`rentalTypeId`),
  CONSTRAINT `RentalBooking_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_2` FOREIGN KEY (`alternatePickupLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_3` FOREIGN KEY (`alternateDropoffLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_4` FOREIGN KEY (`pickupLockerId`) REFERENCES `RentalLocker` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_5` FOREIGN KEY (`dropOfflLockerId`) REFERENCES `RentalLocker` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_6` FOREIGN KEY (`rentalProductItemId`) REFERENCES `RentalProductItem` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_7` FOREIGN KEY (`rentalLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalBooking_ibfk_8` FOREIGN KEY (`rentalTypeId`) REFERENCES `RentalType` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19235 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalCustomerInfo`
--

DROP TABLE IF EXISTS `RentalCustomerInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalCustomerInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataName` varchar(255) DEFAULT NULL,
  `dataValue` varchar(255) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `RentalCustomerInfo_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19292 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalFulfillment`
--

DROP TABLE IF EXISTS `RentalFulfillment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalFulfillment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `renterNotified` tinyint(4) DEFAULT NULL,
  `renterSignedDINSettingAgreement` tinyint(4) DEFAULT NULL,
  `renterSignedWaiver` tinyint(4) DEFAULT NULL,
  `productCode` varchar(255) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `rentalId` int(11) DEFAULT NULL,
  `rentalFulfillmentStatusId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalId` (`rentalId`),
  KEY `rentalFulfillmentStatusId` (`rentalFulfillmentStatusId`),
  CONSTRAINT `RentalFulfillment_ibfk_1` FOREIGN KEY (`rentalId`) REFERENCES `RentalBooking` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalFulfillment_ibfk_2` FOREIGN KEY (`rentalFulfillmentStatusId`) REFERENCES `RentalFulfillmentStatus` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalFulfillmentStatus`
--

DROP TABLE IF EXISTS `RentalFulfillmentStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalFulfillmentStatus` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalInventoryFeed`
--

DROP TABLE IF EXISTS `RentalInventoryFeed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalInventoryFeed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rentalItem` varchar(255) DEFAULT NULL,
  `itemTypeDesc` varchar(255) DEFAULT NULL,
  `itemTypeId` int(11) DEFAULT NULL,
  `manufacturer` varchar(255) DEFAULT NULL,
  `manufacturerId` int(11) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `modelId` int(11) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `modelYear` int(11) DEFAULT NULL,
  `serialNumber` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `statusId` int(11) DEFAULT NULL,
  `locationCode` int(11) DEFAULT NULL,
  `locationDesc` varchar(255) DEFAULT NULL,
  `ssvResortCode` int(11) DEFAULT NULL,
  `ssvProductId` int(11) DEFAULT NULL,
  `widthUnderFoot` int(11) DEFAULT NULL,
  `type2` varchar(255) DEFAULT NULL,
  `type1` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  `bindingMondopointSize` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=488 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalInventoryLocationHistory`
--

DROP TABLE IF EXISTS `RentalInventoryLocationHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalInventoryLocationHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `locationCode` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `changedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=398 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalInventoryProductHistory`
--

DROP TABLE IF EXISTS `RentalInventoryProductHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalInventoryProductHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rentalItem` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `changedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3212 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalLocation`
--

DROP TABLE IF EXISTS `RentalLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalLocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressLine1` varchar(255) DEFAULT NULL,
  `addressLine2` varchar(255) DEFAULT NULL,
  `addressLine3` varchar(255) DEFAULT NULL,
  `addressLine4` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `locationName` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zipCode` varchar(255) DEFAULT NULL,
  `cutofftime` time DEFAULT NULL,
  `openTime` time DEFAULT NULL,
  `closeTime` time DEFAULT NULL,
  `description` text,
  `imageLocationUrl` varchar(255) DEFAULT NULL,
  `hasDemoGear` int(11) NOT NULL DEFAULT '0',
  `displayOrder` int(11) NOT NULL DEFAULT '0',
  `locationStatus` int(11) NOT NULL DEFAULT '1',
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `locationType` varchar(255) NOT NULL DEFAULT 'rentskis',
  `locationConnectorType` varchar(255) DEFAULT NULL,
  `timezone` varchar(255) NOT NULL,
  `phoneErrorPeriod` int(11) DEFAULT NULL,
  `phoneErrorNumber` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `thirdPartyUrl` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `confirmationScreen` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=844007 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalLocker`
--

DROP TABLE IF EXISTS `RentalLocker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalLocker` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand` varchar(255) DEFAULT NULL,
  `digitalKeyCode` varchar(255) DEFAULT NULL,
  `instructionForRenter` varchar(255) DEFAULT NULL,
  `instructionForStaff` varchar(255) DEFAULT NULL,
  `lockerIdentifier` varchar(255) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `manualKeyCode` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `rfidKeyCode` varchar(255) DEFAULT NULL,
  `supplier` varchar(255) DEFAULT NULL,
  `rentalLocationId` int(11) DEFAULT NULL,
  `rentalLockerStatusId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalLocationId` (`rentalLocationId`),
  KEY `rentalLockerStatusId` (`rentalLockerStatusId`),
  CONSTRAINT `RentalLocker_ibfk_1` FOREIGN KEY (`rentalLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalLocker_ibfk_2` FOREIGN KEY (`rentalLockerStatusId`) REFERENCES `RentalLockerStatus` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalLockerInventory`
--

DROP TABLE IF EXISTS `RentalLockerInventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalLockerInventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantityAvailable` int(11) DEFAULT NULL,
  `totalQuantity` int(11) DEFAULT NULL,
  `rentalLockerInventoryStatusId` int(11) DEFAULT NULL,
  `rentalLocationId` int(11) DEFAULT NULL,
  `rentalLockerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalLockerInventoryStatusId` (`rentalLockerInventoryStatusId`),
  KEY `rentalLocationId` (`rentalLocationId`),
  KEY `rentalLockerId` (`rentalLockerId`),
  CONSTRAINT `RentalLockerInventory_ibfk_1` FOREIGN KEY (`rentalLockerInventoryStatusId`) REFERENCES `RentalLockerInventoryStatus` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalLockerInventory_ibfk_2` FOREIGN KEY (`rentalLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalLockerInventory_ibfk_3` FOREIGN KEY (`rentalLockerId`) REFERENCES `RentalLocker` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalLockerInventoryStatus`
--

DROP TABLE IF EXISTS `RentalLockerInventoryStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalLockerInventoryStatus` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalLockerStatus`
--

DROP TABLE IF EXISTS `RentalLockerStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalLockerStatus` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProduct`
--

DROP TABLE IF EXISTS `RentalProduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProduct` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `unitOfMeasure` varchar(255) DEFAULT NULL,
  `unitCost` int(11) DEFAULT NULL,
  `unitPrice` int(11) DEFAULT NULL,
  `rentalProductCategoryId` int(11) DEFAULT NULL,
  `rentalProductImageId` int(11) DEFAULT NULL,
  `isBookable` tinyint(1) NOT NULL DEFAULT '1',
  `bookabilityDescription` varchar(255) DEFAULT NULL,
  `bookableStartDate` datetime DEFAULT NULL,
  `bookableEndDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalProductCategoryId` (`rentalProductCategoryId`),
  KEY `rentalProductImageId` (`rentalProductImageId`),
  CONSTRAINT `RentalProduct_ibfk_1` FOREIGN KEY (`rentalProductCategoryId`) REFERENCES `RentalProductCategory` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalProduct_ibfk_2` FOREIGN KEY (`rentalProductImageId`) REFERENCES `RentalProductImage` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=223076 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductAllocation`
--

DROP TABLE IF EXISTS `RentalProductAllocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductAllocation` (
  `rentalLocationId` int(11) NOT NULL DEFAULT '0',
  `rentalProductItemId` int(11) NOT NULL DEFAULT '0',
  `Day_1` int(11) NOT NULL DEFAULT '0',
  `Day_2` int(11) NOT NULL DEFAULT '0',
  `Day_3` int(11) NOT NULL DEFAULT '0',
  `Day_4` int(11) NOT NULL DEFAULT '0',
  `Day_5` int(11) NOT NULL DEFAULT '0',
  `Day_6` int(11) NOT NULL DEFAULT '0',
  `Day_7` int(11) NOT NULL DEFAULT '0',
  `Day_8` int(11) NOT NULL DEFAULT '0',
  `Day_9` int(11) NOT NULL DEFAULT '0',
  `Day_10` int(11) NOT NULL DEFAULT '0',
  `Day_11` int(11) NOT NULL DEFAULT '0',
  `Day_12` int(11) NOT NULL DEFAULT '0',
  `Day_13` int(11) NOT NULL DEFAULT '0',
  `Day_14` int(11) NOT NULL DEFAULT '0',
  `Day_15` int(11) NOT NULL DEFAULT '0',
  `Day_16` int(11) NOT NULL DEFAULT '0',
  `Day_17` int(11) NOT NULL DEFAULT '0',
  `Day_18` int(11) NOT NULL DEFAULT '0',
  `Day_19` int(11) NOT NULL DEFAULT '0',
  `Day_20` int(11) NOT NULL DEFAULT '0',
  `Day_21` int(11) NOT NULL DEFAULT '0',
  `Day_22` int(11) NOT NULL DEFAULT '0',
  `Day_23` int(11) NOT NULL DEFAULT '0',
  `Day_24` int(11) NOT NULL DEFAULT '0',
  `Day_25` int(11) NOT NULL DEFAULT '0',
  `Day_26` int(11) NOT NULL DEFAULT '0',
  `Day_27` int(11) NOT NULL DEFAULT '0',
  `Day_28` int(11) NOT NULL DEFAULT '0',
  `Day_29` int(11) NOT NULL DEFAULT '0',
  `Day_30` int(11) NOT NULL DEFAULT '0',
  `Day_31` int(11) NOT NULL DEFAULT '0',
  `Day_32` int(11) NOT NULL DEFAULT '0',
  `Day_33` int(11) NOT NULL DEFAULT '0',
  `Day_34` int(11) NOT NULL DEFAULT '0',
  `Day_35` int(11) NOT NULL DEFAULT '0',
  `Day_36` int(11) NOT NULL DEFAULT '0',
  `Day_37` int(11) NOT NULL DEFAULT '0',
  `Day_38` int(11) NOT NULL DEFAULT '0',
  `Day_39` int(11) NOT NULL DEFAULT '0',
  `Day_40` int(11) NOT NULL DEFAULT '0',
  `Day_41` int(11) NOT NULL DEFAULT '0',
  `Day_42` int(11) NOT NULL DEFAULT '0',
  `Day_43` int(11) NOT NULL DEFAULT '0',
  `Day_44` int(11) NOT NULL DEFAULT '0',
  `Day_45` int(11) NOT NULL DEFAULT '0',
  `Day_46` int(11) NOT NULL DEFAULT '0',
  `Day_47` int(11) NOT NULL DEFAULT '0',
  `Day_48` int(11) NOT NULL DEFAULT '0',
  `Day_49` int(11) NOT NULL DEFAULT '0',
  `Day_50` int(11) NOT NULL DEFAULT '0',
  `Day_51` int(11) NOT NULL DEFAULT '0',
  `Day_52` int(11) NOT NULL DEFAULT '0',
  `Day_53` int(11) NOT NULL DEFAULT '0',
  `Day_54` int(11) NOT NULL DEFAULT '0',
  `Day_55` int(11) NOT NULL DEFAULT '0',
  `Day_56` int(11) NOT NULL DEFAULT '0',
  `Day_57` int(11) NOT NULL DEFAULT '0',
  `Day_58` int(11) NOT NULL DEFAULT '0',
  `Day_59` int(11) NOT NULL DEFAULT '0',
  `Day_60` int(11) NOT NULL DEFAULT '0',
  `Day_61` int(11) NOT NULL DEFAULT '0',
  `Day_62` int(11) NOT NULL DEFAULT '0',
  `Day_63` int(11) NOT NULL DEFAULT '0',
  `Day_64` int(11) NOT NULL DEFAULT '0',
  `Day_65` int(11) NOT NULL DEFAULT '0',
  `Day_66` int(11) NOT NULL DEFAULT '0',
  `Day_67` int(11) NOT NULL DEFAULT '0',
  `Day_68` int(11) NOT NULL DEFAULT '0',
  `Day_69` int(11) NOT NULL DEFAULT '0',
  `Day_70` int(11) NOT NULL DEFAULT '0',
  `Day_71` int(11) NOT NULL DEFAULT '0',
  `Day_72` int(11) NOT NULL DEFAULT '0',
  `Day_73` int(11) NOT NULL DEFAULT '0',
  `Day_74` int(11) NOT NULL DEFAULT '0',
  `Day_75` int(11) NOT NULL DEFAULT '0',
  `Day_76` int(11) NOT NULL DEFAULT '0',
  `Day_77` int(11) NOT NULL DEFAULT '0',
  `Day_78` int(11) NOT NULL DEFAULT '0',
  `Day_79` int(11) NOT NULL DEFAULT '0',
  `Day_80` int(11) NOT NULL DEFAULT '0',
  `Day_81` int(11) NOT NULL DEFAULT '0',
  `Day_82` int(11) NOT NULL DEFAULT '0',
  `Day_83` int(11) NOT NULL DEFAULT '0',
  `Day_84` int(11) NOT NULL DEFAULT '0',
  `Day_85` int(11) NOT NULL DEFAULT '0',
  `Day_86` int(11) NOT NULL DEFAULT '0',
  `Day_87` int(11) NOT NULL DEFAULT '0',
  `Day_88` int(11) NOT NULL DEFAULT '0',
  `Day_89` int(11) NOT NULL DEFAULT '0',
  `Day_90` int(11) NOT NULL DEFAULT '0',
  `Day_91` int(11) NOT NULL DEFAULT '0',
  `Day_92` int(11) NOT NULL DEFAULT '0',
  `Day_93` int(11) NOT NULL DEFAULT '0',
  `Day_94` int(11) NOT NULL DEFAULT '0',
  `Day_95` int(11) NOT NULL DEFAULT '0',
  `Day_96` int(11) NOT NULL DEFAULT '0',
  `Day_97` int(11) NOT NULL DEFAULT '0',
  `Day_98` int(11) NOT NULL DEFAULT '0',
  `Day_99` int(11) NOT NULL DEFAULT '0',
  `Day_100` int(11) NOT NULL DEFAULT '0',
  `Day_101` int(11) NOT NULL DEFAULT '0',
  `Day_102` int(11) NOT NULL DEFAULT '0',
  `Day_103` int(11) NOT NULL DEFAULT '0',
  `Day_104` int(11) NOT NULL DEFAULT '0',
  `Day_105` int(11) NOT NULL DEFAULT '0',
  `Day_106` int(11) NOT NULL DEFAULT '0',
  `Day_107` int(11) NOT NULL DEFAULT '0',
  `Day_108` int(11) NOT NULL DEFAULT '0',
  `Day_109` int(11) NOT NULL DEFAULT '0',
  `Day_110` int(11) NOT NULL DEFAULT '0',
  `Day_111` int(11) NOT NULL DEFAULT '0',
  `Day_112` int(11) NOT NULL DEFAULT '0',
  `Day_113` int(11) NOT NULL DEFAULT '0',
  `Day_114` int(11) NOT NULL DEFAULT '0',
  `Day_115` int(11) NOT NULL DEFAULT '0',
  `Day_116` int(11) NOT NULL DEFAULT '0',
  `Day_117` int(11) NOT NULL DEFAULT '0',
  `Day_118` int(11) NOT NULL DEFAULT '0',
  `Day_119` int(11) NOT NULL DEFAULT '0',
  `Day_120` int(11) NOT NULL DEFAULT '0',
  `Day_121` int(11) NOT NULL DEFAULT '0',
  `Day_122` int(11) NOT NULL DEFAULT '0',
  `Day_123` int(11) NOT NULL DEFAULT '0',
  `Day_124` int(11) NOT NULL DEFAULT '0',
  `Day_125` int(11) NOT NULL DEFAULT '0',
  `Day_126` int(11) NOT NULL DEFAULT '0',
  `Day_127` int(11) NOT NULL DEFAULT '0',
  `Day_128` int(11) NOT NULL DEFAULT '0',
  `Day_129` int(11) NOT NULL DEFAULT '0',
  `Day_130` int(11) NOT NULL DEFAULT '0',
  `Day_131` int(11) NOT NULL DEFAULT '0',
  `Day_132` int(11) NOT NULL DEFAULT '0',
  `Day_133` int(11) NOT NULL DEFAULT '0',
  `Day_134` int(11) NOT NULL DEFAULT '0',
  `Day_135` int(11) NOT NULL DEFAULT '0',
  `Day_136` int(11) NOT NULL DEFAULT '0',
  `Day_137` int(11) NOT NULL DEFAULT '0',
  `Day_138` int(11) NOT NULL DEFAULT '0',
  `Day_139` int(11) NOT NULL DEFAULT '0',
  `Day_140` int(11) NOT NULL DEFAULT '0',
  `Day_141` int(11) NOT NULL DEFAULT '0',
  `Day_142` int(11) NOT NULL DEFAULT '0',
  `Day_143` int(11) NOT NULL DEFAULT '0',
  `Day_144` int(11) NOT NULL DEFAULT '0',
  `Day_145` int(11) NOT NULL DEFAULT '0',
  `Day_146` int(11) NOT NULL DEFAULT '0',
  `Day_147` int(11) NOT NULL DEFAULT '0',
  `Day_148` int(11) NOT NULL DEFAULT '0',
  `Day_149` int(11) NOT NULL DEFAULT '0',
  `Day_150` int(11) NOT NULL DEFAULT '0',
  `Day_151` int(11) NOT NULL DEFAULT '0',
  `Day_152` int(11) NOT NULL DEFAULT '0',
  `Day_153` int(11) NOT NULL DEFAULT '0',
  `Day_154` int(11) NOT NULL DEFAULT '0',
  `Day_155` int(11) NOT NULL DEFAULT '0',
  `Day_156` int(11) NOT NULL DEFAULT '0',
  `Day_157` int(11) NOT NULL DEFAULT '0',
  `Day_158` int(11) NOT NULL DEFAULT '0',
  `Day_159` int(11) NOT NULL DEFAULT '0',
  `Day_160` int(11) NOT NULL DEFAULT '0',
  `Day_161` int(11) NOT NULL DEFAULT '0',
  `Day_162` int(11) NOT NULL DEFAULT '0',
  `Day_163` int(11) NOT NULL DEFAULT '0',
  `Day_164` int(11) NOT NULL DEFAULT '0',
  `Day_165` int(11) NOT NULL DEFAULT '0',
  `Day_166` int(11) NOT NULL DEFAULT '0',
  `Day_167` int(11) NOT NULL DEFAULT '0',
  `Day_168` int(11) NOT NULL DEFAULT '0',
  `Day_169` int(11) NOT NULL DEFAULT '0',
  `Day_170` int(11) NOT NULL DEFAULT '0',
  `Day_171` int(11) NOT NULL DEFAULT '0',
  `Day_172` int(11) NOT NULL DEFAULT '0',
  `Day_173` int(11) NOT NULL DEFAULT '0',
  `Day_174` int(11) NOT NULL DEFAULT '0',
  `Day_175` int(11) NOT NULL DEFAULT '0',
  `Day_176` int(11) NOT NULL DEFAULT '0',
  `Day_177` int(11) NOT NULL DEFAULT '0',
  `Day_178` int(11) NOT NULL DEFAULT '0',
  `Day_179` int(11) NOT NULL DEFAULT '0',
  `Day_180` int(11) NOT NULL DEFAULT '0',
  `Day_181` int(11) NOT NULL DEFAULT '0',
  `Day_182` int(11) NOT NULL DEFAULT '0',
  `Day_183` int(11) NOT NULL DEFAULT '0',
  `Day_184` int(11) NOT NULL DEFAULT '0',
  `Day_185` int(11) NOT NULL DEFAULT '0',
  `Day_186` int(11) NOT NULL DEFAULT '0',
  `Day_187` int(11) NOT NULL DEFAULT '0',
  `Day_188` int(11) NOT NULL DEFAULT '0',
  `Day_189` int(11) NOT NULL DEFAULT '0',
  `Day_190` int(11) NOT NULL DEFAULT '0',
  `Day_191` int(11) NOT NULL DEFAULT '0',
  `Day_192` int(11) NOT NULL DEFAULT '0',
  `Day_193` int(11) NOT NULL DEFAULT '0',
  `Day_194` int(11) NOT NULL DEFAULT '0',
  `Day_195` int(11) NOT NULL DEFAULT '0',
  `Day_196` int(11) NOT NULL DEFAULT '0',
  `Day_197` int(11) NOT NULL DEFAULT '0',
  `Day_198` int(11) NOT NULL DEFAULT '0',
  `Day_199` int(11) NOT NULL DEFAULT '0',
  `Day_200` int(11) NOT NULL DEFAULT '0',
  `Day_201` int(11) NOT NULL DEFAULT '0',
  `Day_202` int(11) NOT NULL DEFAULT '0',
  `Day_203` int(11) NOT NULL DEFAULT '0',
  `Day_204` int(11) NOT NULL DEFAULT '0',
  `Day_205` int(11) NOT NULL DEFAULT '0',
  `Day_206` int(11) NOT NULL DEFAULT '0',
  `Day_207` int(11) NOT NULL DEFAULT '0',
  `Day_208` int(11) NOT NULL DEFAULT '0',
  `Day_209` int(11) NOT NULL DEFAULT '0',
  `Day_210` int(11) NOT NULL DEFAULT '0',
  `Day_211` int(11) NOT NULL DEFAULT '0',
  `Day_212` int(11) NOT NULL DEFAULT '0',
  `Day_213` int(11) NOT NULL DEFAULT '0',
  `Day_214` int(11) NOT NULL DEFAULT '0',
  `Day_215` int(11) NOT NULL DEFAULT '0',
  `Day_216` int(11) NOT NULL DEFAULT '0',
  `Day_217` int(11) NOT NULL DEFAULT '0',
  `Day_218` int(11) NOT NULL DEFAULT '0',
  `Day_219` int(11) NOT NULL DEFAULT '0',
  `Day_220` int(11) NOT NULL DEFAULT '0',
  `Day_221` int(11) NOT NULL DEFAULT '0',
  `Day_222` int(11) NOT NULL DEFAULT '0',
  `Day_223` int(11) NOT NULL DEFAULT '0',
  `Day_224` int(11) NOT NULL DEFAULT '0',
  `Day_225` int(11) NOT NULL DEFAULT '0',
  `Day_226` int(11) NOT NULL DEFAULT '0',
  `Day_227` int(11) NOT NULL DEFAULT '0',
  `Day_228` int(11) NOT NULL DEFAULT '0',
  `Day_229` int(11) NOT NULL DEFAULT '0',
  `Day_230` int(11) NOT NULL DEFAULT '0',
  `Day_231` int(11) NOT NULL DEFAULT '0',
  `Day_232` int(11) NOT NULL DEFAULT '0',
  `Day_233` int(11) NOT NULL DEFAULT '0',
  `Day_234` int(11) NOT NULL DEFAULT '0',
  `Day_235` int(11) NOT NULL DEFAULT '0',
  `Day_236` int(11) NOT NULL DEFAULT '0',
  `Day_237` int(11) NOT NULL DEFAULT '0',
  `Day_238` int(11) NOT NULL DEFAULT '0',
  `Day_239` int(11) NOT NULL DEFAULT '0',
  `Day_240` int(11) NOT NULL DEFAULT '0',
  `Day_241` int(11) NOT NULL DEFAULT '0',
  `Day_242` int(11) NOT NULL DEFAULT '0',
  `Day_243` int(11) NOT NULL DEFAULT '0',
  `Day_244` int(11) NOT NULL DEFAULT '0',
  `Day_245` int(11) NOT NULL DEFAULT '0',
  `Day_246` int(11) NOT NULL DEFAULT '0',
  `Day_247` int(11) NOT NULL DEFAULT '0',
  `Day_248` int(11) NOT NULL DEFAULT '0',
  `Day_249` int(11) NOT NULL DEFAULT '0',
  `Day_250` int(11) NOT NULL DEFAULT '0',
  `Day_251` int(11) NOT NULL DEFAULT '0',
  `Day_252` int(11) NOT NULL DEFAULT '0',
  `Day_253` int(11) NOT NULL DEFAULT '0',
  `Day_254` int(11) NOT NULL DEFAULT '0',
  `Day_255` int(11) NOT NULL DEFAULT '0',
  `Day_256` int(11) NOT NULL DEFAULT '0',
  `Day_257` int(11) NOT NULL DEFAULT '0',
  `Day_258` int(11) NOT NULL DEFAULT '0',
  `Day_259` int(11) NOT NULL DEFAULT '0',
  `Day_260` int(11) NOT NULL DEFAULT '0',
  `Day_261` int(11) NOT NULL DEFAULT '0',
  `Day_262` int(11) NOT NULL DEFAULT '0',
  `Day_263` int(11) NOT NULL DEFAULT '0',
  `Day_264` int(11) NOT NULL DEFAULT '0',
  `Day_265` int(11) NOT NULL DEFAULT '0',
  `Day_266` int(11) NOT NULL DEFAULT '0',
  `Day_267` int(11) NOT NULL DEFAULT '0',
  `Day_268` int(11) NOT NULL DEFAULT '0',
  `Day_269` int(11) NOT NULL DEFAULT '0',
  `Day_270` int(11) NOT NULL DEFAULT '0',
  `Day_271` int(11) NOT NULL DEFAULT '0',
  `Day_272` int(11) NOT NULL DEFAULT '0',
  `Day_273` int(11) NOT NULL DEFAULT '0',
  `Day_274` int(11) NOT NULL DEFAULT '0',
  `Day_275` int(11) NOT NULL DEFAULT '0',
  `Day_276` int(11) NOT NULL DEFAULT '0',
  `Day_277` int(11) NOT NULL DEFAULT '0',
  `Day_278` int(11) NOT NULL DEFAULT '0',
  `Day_279` int(11) NOT NULL DEFAULT '0',
  `Day_280` int(11) NOT NULL DEFAULT '0',
  `Day_281` int(11) NOT NULL DEFAULT '0',
  `Day_282` int(11) NOT NULL DEFAULT '0',
  `Day_283` int(11) NOT NULL DEFAULT '0',
  `Day_284` int(11) NOT NULL DEFAULT '0',
  `Day_285` int(11) NOT NULL DEFAULT '0',
  `Day_286` int(11) NOT NULL DEFAULT '0',
  `Day_287` int(11) NOT NULL DEFAULT '0',
  `Day_288` int(11) NOT NULL DEFAULT '0',
  `Day_289` int(11) NOT NULL DEFAULT '0',
  `Day_290` int(11) NOT NULL DEFAULT '0',
  `Day_291` int(11) NOT NULL DEFAULT '0',
  `Day_292` int(11) NOT NULL DEFAULT '0',
  `Day_293` int(11) NOT NULL DEFAULT '0',
  `Day_294` int(11) NOT NULL DEFAULT '0',
  `Day_295` int(11) NOT NULL DEFAULT '0',
  `Day_296` int(11) NOT NULL DEFAULT '0',
  `Day_297` int(11) NOT NULL DEFAULT '0',
  `Day_298` int(11) NOT NULL DEFAULT '0',
  `Day_299` int(11) NOT NULL DEFAULT '0',
  `Day_300` int(11) NOT NULL DEFAULT '0',
  `Day_301` int(11) NOT NULL DEFAULT '0',
  `Day_302` int(11) NOT NULL DEFAULT '0',
  `Day_303` int(11) NOT NULL DEFAULT '0',
  `Day_304` int(11) NOT NULL DEFAULT '0',
  `Day_305` int(11) NOT NULL DEFAULT '0',
  `Day_306` int(11) NOT NULL DEFAULT '0',
  `Day_307` int(11) NOT NULL DEFAULT '0',
  `Day_308` int(11) NOT NULL DEFAULT '0',
  `Day_309` int(11) NOT NULL DEFAULT '0',
  `Day_310` int(11) NOT NULL DEFAULT '0',
  `Day_311` int(11) NOT NULL DEFAULT '0',
  `Day_312` int(11) NOT NULL DEFAULT '0',
  `Day_313` int(11) NOT NULL DEFAULT '0',
  `Day_314` int(11) NOT NULL DEFAULT '0',
  `Day_315` int(11) NOT NULL DEFAULT '0',
  `Day_316` int(11) NOT NULL DEFAULT '0',
  `Day_317` int(11) NOT NULL DEFAULT '0',
  `Day_318` int(11) NOT NULL DEFAULT '0',
  `Day_319` int(11) NOT NULL DEFAULT '0',
  `Day_320` int(11) NOT NULL DEFAULT '0',
  `Day_321` int(11) NOT NULL DEFAULT '0',
  `Day_322` int(11) NOT NULL DEFAULT '0',
  `Day_323` int(11) NOT NULL DEFAULT '0',
  `Day_324` int(11) NOT NULL DEFAULT '0',
  `Day_325` int(11) NOT NULL DEFAULT '0',
  `Day_326` int(11) NOT NULL DEFAULT '0',
  `Day_327` int(11) NOT NULL DEFAULT '0',
  `Day_328` int(11) NOT NULL DEFAULT '0',
  `Day_329` int(11) NOT NULL DEFAULT '0',
  `Day_330` int(11) NOT NULL DEFAULT '0',
  `Day_331` int(11) NOT NULL DEFAULT '0',
  `Day_332` int(11) NOT NULL DEFAULT '0',
  `Day_333` int(11) NOT NULL DEFAULT '0',
  `Day_334` int(11) NOT NULL DEFAULT '0',
  `Day_335` int(11) NOT NULL DEFAULT '0',
  `Day_336` int(11) NOT NULL DEFAULT '0',
  `Day_337` int(11) NOT NULL DEFAULT '0',
  `Day_338` int(11) NOT NULL DEFAULT '0',
  `Day_339` int(11) NOT NULL DEFAULT '0',
  `Day_340` int(11) NOT NULL DEFAULT '0',
  `Day_341` int(11) NOT NULL DEFAULT '0',
  `Day_342` int(11) NOT NULL DEFAULT '0',
  `Day_343` int(11) NOT NULL DEFAULT '0',
  `Day_344` int(11) NOT NULL DEFAULT '0',
  `Day_345` int(11) NOT NULL DEFAULT '0',
  `Day_346` int(11) NOT NULL DEFAULT '0',
  `Day_347` int(11) NOT NULL DEFAULT '0',
  `Day_348` int(11) NOT NULL DEFAULT '0',
  `Day_349` int(11) NOT NULL DEFAULT '0',
  `Day_350` int(11) NOT NULL DEFAULT '0',
  `Day_351` int(11) NOT NULL DEFAULT '0',
  `Day_352` int(11) NOT NULL DEFAULT '0',
  `Day_353` int(11) NOT NULL DEFAULT '0',
  `Day_354` int(11) NOT NULL DEFAULT '0',
  `Day_355` int(11) NOT NULL DEFAULT '0',
  `Day_356` int(11) NOT NULL DEFAULT '0',
  `Day_357` int(11) NOT NULL DEFAULT '0',
  `Day_358` int(11) NOT NULL DEFAULT '0',
  `Day_359` int(11) NOT NULL DEFAULT '0',
  `Day_360` int(11) NOT NULL DEFAULT '0',
  `Day_361` int(11) NOT NULL DEFAULT '0',
  `Day_362` int(11) NOT NULL DEFAULT '0',
  `Day_363` int(11) NOT NULL DEFAULT '0',
  `Day_364` int(11) NOT NULL DEFAULT '0',
  `Day_365` int(11) NOT NULL DEFAULT '0',
  `Day_366` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`rentalLocationId`,`rentalProductItemId`),
  KEY `rentalProductItemId` (`rentalProductItemId`),
  CONSTRAINT `RentalProductAllocation_ibfk_1` FOREIGN KEY (`rentalLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalProductAllocation_ibfk_2` FOREIGN KEY (`rentalProductItemId`) REFERENCES `RentalProductItem` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductCategory`
--

DROP TABLE IF EXISTS `RentalProductCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductCategory` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imageLocationUrl` varchar(255) DEFAULT NULL,
  `displayCategory` tinyint(1) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '1',
  `categoryType` varchar(255) DEFAULT NULL,
  `parentCategory` int(11) DEFAULT NULL,
  `displayOrder` int(11) NOT NULL DEFAULT '0',
  `thirdPartyId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=999997 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductDetail`
--

DROP TABLE IF EXISTS `RentalProductDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductDetail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `displayOrder` int(11) DEFAULT NULL,
  `rentalProductId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalProductId` (`rentalProductId`),
  CONSTRAINT `RentalProductDetail_ibfk_1` FOREIGN KEY (`rentalProductId`) REFERENCES `RentalProduct` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductImage`
--

DROP TABLE IF EXISTS `RentalProductImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductImage` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imageLocationUrl` varchar(255) DEFAULT NULL,
  `imageMediaType` varchar(255) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductInventory`
--

DROP TABLE IF EXISTS `RentalProductInventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductInventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantityAvailable` int(11) DEFAULT NULL,
  `totalQuantity` int(11) DEFAULT NULL,
  `rentalProductInventoryStatusId` int(11) DEFAULT NULL,
  `rentalLocationId` int(11) DEFAULT NULL,
  `rentalProductId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalProductInventoryStatusId` (`rentalProductInventoryStatusId`),
  KEY `rentalLocationId` (`rentalLocationId`),
  KEY `rentalProductId` (`rentalProductId`),
  CONSTRAINT `RentalProductInventory_ibfk_1` FOREIGN KEY (`rentalProductInventoryStatusId`) REFERENCES `RentalProductInventoryStatus` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalProductInventory_ibfk_2` FOREIGN KEY (`rentalLocationId`) REFERENCES `RentalLocation` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalProductInventory_ibfk_3` FOREIGN KEY (`rentalProductId`) REFERENCES `RentalProduct` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductInventoryStatus`
--

DROP TABLE IF EXISTS `RentalProductInventoryStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductInventoryStatus` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductItem`
--

DROP TABLE IF EXISTS `RentalProductItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductItem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rentalProductId` int(11) DEFAULT NULL,
  `rentalItem` varchar(255) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `modelYear` int(11) DEFAULT NULL,
  `serialNumber` varchar(255) DEFAULT NULL,
  `statusId` int(11) DEFAULT NULL,
  `locationId` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '0',
  `ssvResortCode` int(11) DEFAULT NULL,
  `ssvProductId` int(11) DEFAULT NULL,
  `widthUnderFoot` int(11) DEFAULT NULL,
  `type2` varchar(255) DEFAULT NULL,
  `type1` varchar(255) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `bindingMondopointSize` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalProductId` (`rentalProductId`),
  KEY `statusId` (`statusId`),
  CONSTRAINT `RentalProductItem_ibfk_1` FOREIGN KEY (`rentalProductId`) REFERENCES `RentalProduct` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalProductItem_ibfk_2` FOREIGN KEY (`statusId`) REFERENCES `RentalProductInventoryStatus` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1489 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductLocation`
--

DROP TABLE IF EXISTS `RentalProductLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductLocation` (
  `productId` int(11) NOT NULL DEFAULT '0',
  `locationId` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`productId`,`locationId`),
  UNIQUE KEY `RentalProductLocation_productId_locationId_unique` (`productId`,`locationId`),
  KEY `locationId` (`locationId`),
  CONSTRAINT `RentalProductLocation_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `RentalProduct` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `RentalProductLocation_ibfk_2` FOREIGN KEY (`locationId`) REFERENCES `RentalLocation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductUserAction`
--

DROP TABLE IF EXISTS `RentalProductUserAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductUserAction` (
  `rentalProductId` int(11) NOT NULL DEFAULT '0',
  `userId` int(11) NOT NULL DEFAULT '0',
  `action` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`rentalProductId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `RentalProductUserAction_ibfk_1` FOREIGN KEY (`rentalProductId`) REFERENCES `RentalProduct` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RentalProductUserAction_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductVariant`
--

DROP TABLE IF EXISTS `RentalProductVariant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductVariant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rentalProductItemId` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `variantType` varchar(255) DEFAULT NULL,
  `variantValue` varchar(255) DEFAULT NULL,
  `variantStatus` tinyint(4) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `thirdPartySKU` varchar(255) DEFAULT NULL,
  `serialNumber` varchar(255) DEFAULT NULL,
  `equipmentStatus` tinyint(4) DEFAULT '1',
  `option1` varchar(255) DEFAULT NULL,
  `option2` varchar(255) DEFAULT NULL,
  `option3` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2295 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductVariantOption`
--

DROP TABLE IF EXISTS `RentalProductVariantOption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductVariantOption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rentalProductVariantTypeId` int(11) DEFAULT NULL,
  `variantOption` varchar(255) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=498 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductVariantOverride`
--

DROP TABLE IF EXISTS `RentalProductVariantOverride`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductVariantOverride` (
  `thirdPartyId` varchar(255) NOT NULL,
  `productName` varchar(255) NOT NULL,
  `variantName` varchar(255) NOT NULL,
  `variantValue` varchar(255) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`,`thirdPartyId`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProductVariantType`
--

DROP TABLE IF EXISTS `RentalProductVariantType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProductVariantType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rentalProductId` int(11) DEFAULT NULL,
  `thirdPartyId` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=230 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalProfile`
--

DROP TABLE IF EXISTS `RentalProfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalProfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `ageRange` varchar(255) DEFAULT NULL,
  `skierLevel` varchar(255) DEFAULT NULL,
  `heightRange` varchar(255) DEFAULT NULL,
  `weightRange` varchar(255) DEFAULT NULL,
  `bootLength` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `lastUpdatedAt` datetime DEFAULT NULL,
  `stance` varchar(255) DEFAULT NULL,
  `direction` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `RentalProfile_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=612 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalSettings`
--

DROP TABLE IF EXISTS `RentalSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalStatus`
--

DROP TABLE IF EXISTS `RentalStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalStatus` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalStatusTracker`
--

DROP TABLE IF EXISTS `RentalStatusTracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalStatusTracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `messageForRenter` varchar(255) DEFAULT NULL,
  `notesForRenter` text,
  `notesForStaff` text,
  `rental` blob,
  `renterNotified` tinyint(4) DEFAULT NULL,
  `rentalStatusId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalStatusId` (`rentalStatusId`),
  CONSTRAINT `RentalStatusTracker_ibfk_1` FOREIGN KEY (`rentalStatusId`) REFERENCES `RentalStatus` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalStatusTrackerArchive`
--

DROP TABLE IF EXISTS `RentalStatusTrackerArchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalStatusTrackerArchive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `messageForRenter` varchar(255) DEFAULT NULL,
  `notesForRenter` text,
  `notesForStaff` text,
  `rental` blob,
  `renterNotified` tinyint(4) DEFAULT NULL,
  `rentalStatusId` int(11) DEFAULT NULL,
  `rentalStatusTrackerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalStatusTrackerId` (`rentalStatusTrackerId`),
  CONSTRAINT `RentalStatusTrackerArchive_ibfk_1` FOREIGN KEY (`rentalStatusTrackerId`) REFERENCES `RentalStatus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalStatusTrackerImage`
--

DROP TABLE IF EXISTS `RentalStatusTrackerImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalStatusTrackerImage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `imageLocationURL` varchar(255) DEFAULT NULL,
  `imageMediaType` varchar(255) DEFAULT NULL,
  `notes` text,
  `rentalStatusTrackerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rentalStatusTrackerId` (`rentalStatusTrackerId`),
  CONSTRAINT `RentalStatusTrackerImage_ibfk_1` FOREIGN KEY (`rentalStatusTrackerId`) REFERENCES `RentalStatusTracker` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RentalType`
--

DROP TABLE IF EXISTS `RentalType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalType` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SaltoRoom`
--

DROP TABLE IF EXISTS `SaltoRoom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SaltoRoom` (
  `haus_id` int(11) NOT NULL,
  `salto_room_name` varchar(2000) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `iqware_room_name` varchar(255) DEFAULT NULL,
  `salto_partition` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SequelizeMeta`
--

DROP TABLE IF EXISTS `SequelizeMeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SequelizeMeta` (
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Service`
--

DROP TABLE IF EXISTS `Service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SignUpCouponPromotion`
--

DROP TABLE IF EXISTS `SignUpCouponPromotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SignUpCouponPromotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `pif` tinyint(1) DEFAULT NULL,
  `couponId` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SignUpPhasePromotion`
--

DROP TABLE IF EXISTS `SignUpPhasePromotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SignUpPhasePromotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `pif` tinyint(1) DEFAULT NULL,
  `freeMonths` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SlackChannels`
--

DROP TABLE IF EXISTS `SlackChannels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SlackChannels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` varchar(255) DEFAULT NULL,
  `channel_name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SlackUsers`
--

DROP TABLE IF EXISTS `SlackUsers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SlackUsers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `slack_api_key` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Stream`
--

DROP TABLE IF EXISTS `Stream`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stream` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `Stream_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StreamCommunityUser`
--

DROP TABLE IF EXISTS `StreamCommunityUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StreamCommunityUser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `streamId` varchar(36) NOT NULL,
  `name` varchar(254) NOT NULL,
  `description` varchar(256) NOT NULL,
  `profileImage` varchar(256) NOT NULL,
  `allFollow` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StreamLobUser`
--

DROP TABLE IF EXISTS `StreamLobUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StreamLobUser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `streamId` varchar(36) NOT NULL,
  `name` varchar(254) NOT NULL,
  `description` varchar(256) NOT NULL,
  `profileImage` varchar(256) NOT NULL,
  `allFollow` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Stripe`
--

DROP TABLE IF EXISTS `Stripe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stripe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` varchar(255) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `defaultPaymentMethodId` text,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `Stripe_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13394 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StripeARPU`
--

DROP TABLE IF EXISTS `StripeARPU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StripeARPU` (
  `month` text,
  `currency` text,
  `MRR` double DEFAULT NULL,
  `customer_count` int(11) DEFAULT NULL,
  `ARPU` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StripeActiveAndPastDueSubscriptions`
--

DROP TABLE IF EXISTS `StripeActiveAndPastDueSubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StripeActiveAndPastDueSubscriptions` (
  `stripe_customer_id` varchar(256) DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `subscription_id` varchar(45) DEFAULT NULL,
  `subscription_name` varchar(256) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unit_amount` int(11) DEFAULT NULL,
  `total_amount` int(11) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `current_period_end` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StripeCustomerRanking`
--

DROP TABLE IF EXISTS `StripeCustomerRanking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StripeCustomerRanking` (
  `rank` int(11) NOT NULL,
  `stripe_customer_id` varchar(256) NOT NULL,
  `name` varchar(256) NOT NULL,
  `email` varchar(256) NOT NULL,
  `delinquent` tinyint(4) NOT NULL,
  `total_payments` int(11) DEFAULT NULL,
  `total_spend` int(11) DEFAULT NULL,
  `last_payment` datetime DEFAULT NULL,
  `next_due_date` datetime DEFAULT NULL,
  `customer_create_date` datetime NOT NULL,
  `total_subscriptions` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StripePlan`
--

DROP TABLE IF EXISTS `StripePlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StripePlan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stripePlanVersionId` int(11) NOT NULL,
  `intervalCount` int(11) NOT NULL,
  `planId` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `interval` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `membershipPlan` varchar(255) DEFAULT NULL,
  `membershipType` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `c1` tinyint(1) DEFAULT NULL,
  `term` int(11) DEFAULT NULL,
  `unitAmount` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=545 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StripePlanVersion`
--

DROP TABLE IF EXISTS `StripePlanVersion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StripePlanVersion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StripeWebhookEvent`
--

DROP TABLE IF EXISTS `StripeWebhookEvent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StripeWebhookEvent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stripeEventId` varchar(255) NOT NULL,
  `stripeEvent` text,
  `type` varchar(255) NOT NULL,
  `retries` int(11) NOT NULL DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1110 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Subscription`
--

DROP TABLE IF EXISTS `Subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `displayName` varchar(254) NOT NULL,
  `displayValue` varchar(255) NOT NULL,
  `displayValueCondition` varchar(255) NOT NULL,
  `displayValueInfo` varchar(255) NOT NULL,
  `displayInstruction` varchar(255) NOT NULL,
  `serviceId` int(11) DEFAULT NULL,
  `productId` int(11) DEFAULT NULL,
  `subscriptionTypeId` int(11) DEFAULT NULL,
  `stripePlanId` text,
  `stripePlanCurrentCoupon` varchar(255) NOT NULL,
  `stripePlanReferralCoupon` varchar(255) NOT NULL,
  `autoApprove` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `serviceId` (`serviceId`),
  KEY `productId` (`productId`),
  KEY `subscriptionTypeId` (`subscriptionTypeId`),
  CONSTRAINT `Subscription_ibfk_1` FOREIGN KEY (`serviceId`) REFERENCES `Service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Subscription_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Subscription_ibfk_3` FOREIGN KEY (`subscriptionTypeId`) REFERENCES `SubscriptionType` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=831 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SubscriptionBenefit`
--

DROP TABLE IF EXISTS `SubscriptionBenefit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubscriptionBenefit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `subscriptionId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriptionId` (`subscriptionId`),
  CONSTRAINT `SubscriptionBenefit_ibfk_1` FOREIGN KEY (`subscriptionId`) REFERENCES `Subscription` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SubscriptionBenefitRule`
--

DROP TABLE IF EXISTS `SubscriptionBenefitRule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubscriptionBenefitRule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `benefitRuleType` int(11) NOT NULL,
  `benefitValue` varchar(255) NOT NULL,
  `benefitValueUnitType` int(11) NOT NULL,
  `dependentProductId` int(11) DEFAULT NULL,
  `productId` int(11) DEFAULT NULL,
  `subscriptionBenefitId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dependentProductId` (`dependentProductId`),
  KEY `productId` (`productId`),
  KEY `subscriptionBenefitId` (`subscriptionBenefitId`),
  CONSTRAINT `SubscriptionBenefitRule_ibfk_1` FOREIGN KEY (`dependentProductId`) REFERENCES `Product` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `SubscriptionBenefitRule_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `SubscriptionBenefitRule_ibfk_3` FOREIGN KEY (`subscriptionBenefitId`) REFERENCES `SubscriptionBenefit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SubscriptionType`
--

DROP TABLE IF EXISTS `SubscriptionType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubscriptionType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  `description` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TEMPNewProducts2021`
--

DROP TABLE IF EXISTS `TEMPNewProducts2021`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TEMPNewProducts2021` (
  `id` int(11) NOT NULL,
  `rentalItem` varchar(255) NOT NULL,
  `itemTypeDesc` varchar(255) NOT NULL,
  `itemTypeId` int(11) NOT NULL,
  `manufacturer` varchar(255) NOT NULL,
  `manufacturerId` int(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `modelId` int(11) NOT NULL,
  `length` int(11) NOT NULL,
  `modelYear` int(11) NOT NULL,
  `serialNumber` datetime NOT NULL,
  `status` varchar(255) NOT NULL,
  `statusId` int(11) NOT NULL,
  `locationCode` int(11) NOT NULL,
  `locationDesc` varchar(255) NOT NULL,
  `ssvResortCode` int(11) NOT NULL,
  `ssvProductId` int(11) NOT NULL,
  `widthUnderFoot` int(11) NOT NULL,
  `type2` varchar(255) NOT NULL,
  `type1` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TEMP_OG_Emails`
--

DROP TABLE IF EXISTS `TEMP_OG_Emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TEMP_OG_Emails` (
  `og_email` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TEMP_ghnonusers`
--

DROP TABLE IF EXISTS `TEMP_ghnonusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TEMP_ghnonusers` (
  `email` text,
  `stripeid` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TEMP_hqmembers`
--

DROP TABLE IF EXISTS `TEMP_hqmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TEMP_hqmembers` (
  `id` text,
  `Customer ID` text,
  `Customer Description` text,
  `Customer Email` text,
  `Plan` text,
  `Quantity` int(11) DEFAULT NULL,
  `Interval` text,
  `Amount` int(11) DEFAULT NULL,
  `Status` text,
  `Created (UTC)` text,
  `Start (UTC)` text,
  `Current Period Start (UTC)` text,
  `Current Period End (UTC)` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tag`
--

DROP TABLE IF EXISTS `Tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `password` varchar(60) NOT NULL,
  `roleId` int(11) DEFAULT NULL,
  `uuid` varchar(36) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `lastActivityDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `roleId` (`roleId`),
  CONSTRAINT `User_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `Role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28878 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `UserActivity`
--

DROP TABLE IF EXISTS `UserActivity`;
/*!50001 DROP VIEW IF EXISTS `UserActivity`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `UserActivity` AS SELECT 
 1 AS `Active Users`,
 1 AS `Membership Type`,
 1 AS `Last Activity Date`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `UserActivityTracker`
--

DROP TABLE IF EXISTS `UserActivityTracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserActivityTracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `activityType` varchar(255) DEFAULT NULL,
  `activityDate` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `UserActivityTracker_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49525 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserAuthenticationProvider`
--

DROP TABLE IF EXISTS `UserAuthenticationProvider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserAuthenticationProvider` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `providerKey` varchar(255) NOT NULL,
  `providerType` varchar(255) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `UserAuthenticationProvider_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserCustomerSubscriptions`
--

DROP TABLE IF EXISTS `UserCustomerSubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserCustomerSubscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `stripeSubscriptionId` varchar(255) NOT NULL,
  `stripeCustomerId` varchar(255) NOT NULL,
  `stripePlanId` varchar(255) NOT NULL,
  `stripePriceId` varchar(255) NOT NULL,
  `joinDate` datetime NOT NULL,
  `endedAt` datetime DEFAULT NULL,
  `expirationDate` datetime DEFAULT NULL,
  `subscriptionCurrentPeriodEnd` datetime NOT NULL,
  `membershipLength` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `memberType` varchar(255) NOT NULL,
  `subscriptionStartDate` datetime NOT NULL,
  `buckets` text NOT NULL,
  `status` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_customer_subscriptions_index` (`userId`,`stripeSubscriptionId`,`stripeCustomerId`),
  CONSTRAINT `UserCustomerSubscriptions_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8753 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserLastNotificationDates`
--

DROP TABLE IF EXISTS `UserLastNotificationDates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserLastNotificationDates` (
  `userId` int(11) NOT NULL,
  `lastSMSNotificationDate` datetime DEFAULT NULL,
  `lastEmailNotificationDate` datetime DEFAULT NULL,
  `lastPushNotificationDate` datetime DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `updatedAt` datetime NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserMembership`
--

DROP TABLE IF EXISTS `UserMembership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserMembership` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `subscriptionId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7332 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserProfileData`
--

DROP TABLE IF EXISTS `UserProfileData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserProfileData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `profileImageUrl` text,
  `bio` text NOT NULL,
  `personalDescription` varchar(255) NOT NULL,
  `benefitsRating` varchar(255) NOT NULL,
  `favouriteLocations` varchar(255) NOT NULL,
  `favouriteOutdoorActivities` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5392 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `VerificationCode`
--

DROP TABLE IF EXISTS `VerificationCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VerificationCode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `code` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `expiresAt` datetime NOT NULL,
  `status` int(11) NOT NULL,
  `verificationAttempts` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `verificationRequestType` int(11) DEFAULT NULL,
  `verificationRequest` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rentaleligibleuser`
--

DROP TABLE IF EXISTS `rentaleligibleuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rentaleligibleuser` (
  `id` text,
  `customerID` text,
  `customerDescription` text,
  `customerEmail` text,
  `plan` text,
  `quantity` int(11) DEFAULT NULL,
  `interval` text,
  `amount` int(11) DEFAULT NULL,
  `status` text,
  `created` text,
  `start` text,
  `currentPeriodStart` text,
  `currentPeriodEnd` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `gh_develop_db`
--

USE `gh_develop_db`;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-07 15:05:54