-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: cmpt354
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `athlete`
--

DROP TABLE IF EXISTS `athlete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `athlete` (
  `registration_number` int NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `middle_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) NOT NULL,
  `date_of_birth` date NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `height` decimal(5,2) NOT NULL,
  `weight` decimal(5,2) NOT NULL,
  `country_code` char(3) DEFAULT NULL,
  `sport` varchar(20) NOT NULL,
  PRIMARY KEY (`registration_number`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_athlete_country` (`country_code`),
  KEY `fk_athlete_sport` (`sport`),
  CONSTRAINT `fk_athlete_country` FOREIGN KEY (`country_code`) REFERENCES `country` (`country_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_athlete_sport` FOREIGN KEY (`sport`) REFERENCES `sport` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_height` CHECK (((`height` > 0) and (`height` < 300))),
  CONSTRAINT `check_weight` CHECK (((`weight` > 0) and (`weight` < 300)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `athlete_participation`
--

DROP TABLE IF EXISTS `athlete_participation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `athlete_participation` (
  `athlete_registration_number` int NOT NULL,
  `sport` varchar(20) NOT NULL,
  `format` varchar(30) NOT NULL,
  `gender_category` enum('Male','Female','Mixed') NOT NULL,
  `game_number` varchar(30) NOT NULL,
  `score` decimal(5,2) NOT NULL,
  `medal` enum('Gold','Silver','Bronze') DEFAULT NULL,
  PRIMARY KEY (`athlete_registration_number`,`format`,`gender_category`,`game_number`),
  CONSTRAINT `fk_athlete_participation_athlete` FOREIGN KEY (`athlete_registration_number`) REFERENCES `athlete` (`registration_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_athlete_participation_game_full` FOREIGN KEY (`sport`, `format`, `gender_category`, `game_number`) REFERENCES `game` (`sport`, `format`, `gender_category`, `game_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `country_code` char(3) NOT NULL,
  `name` varchar(45) NOT NULL,
  `flag` varchar(500) NOT NULL,
  `continent` enum('Africa','Antarctica','Asia','Europe','North America','Oceania','South America') NOT NULL,
  PRIMARY KEY (`country_code`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `flag` (`flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event` (
  `sport` varchar(20) NOT NULL,
  `format` varchar(30) NOT NULL,
  `gender_category` enum('Male','Female','Mixed') NOT NULL,
  `venue_id` int NOT NULL,
  PRIMARY KEY (`sport`,`format`,`gender_category`),
  KEY `fk_event_venue` (`venue_id`),
  KEY `fk_event_sport` (`sport`),
  KEY `idx_gender_category` (`gender_category`),
  CONSTRAINT `fk_event_sport` FOREIGN KEY (`sport`) REFERENCES `sport` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_event_venue` FOREIGN KEY (`venue_id`) REFERENCES `venue` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game` (
  `sport` varchar(20) NOT NULL,
  `format` varchar(30) NOT NULL,
  `gender_category` enum('Male','Female','Mixed') NOT NULL,
  `game_number` varchar(30) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`sport`,`format`,`gender_category`,`game_number`),
  CONSTRAINT `fk_game_event_full` FOREIGN KEY (`sport`, `format`, `gender_category`) REFERENCES `event` (`sport`, `format`, `gender_category`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `individual_event`
--

DROP TABLE IF EXISTS `individual_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `individual_event` (
  `sport` varchar(20) NOT NULL,
  `format` varchar(30) NOT NULL,
  `gender_category` enum('Male','Female','Mixed') NOT NULL,
  PRIMARY KEY (`sport`,`format`,`gender_category`),
  CONSTRAINT `fk_individual_event_full` FOREIGN KEY (`sport`, `format`, `gender_category`) REFERENCES `event` (`sport`, `format`, `gender_category`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member_of`
--

DROP TABLE IF EXISTS `member_of`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_of` (
  `athlete_registration_number` int NOT NULL,
  `country_code` char(3) NOT NULL,
  `team_id` int NOT NULL,
  PRIMARY KEY (`athlete_registration_number`,`country_code`,`team_id`),
  KEY `fk_member_of_country` (`country_code`),
  KEY `fk_member_of_team` (`team_id`),
  CONSTRAINT `fk_member_of_athlete` FOREIGN KEY (`athlete_registration_number`) REFERENCES `athlete` (`registration_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_member_of_country` FOREIGN KEY (`country_code`) REFERENCES `country` (`country_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_member_of_team` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sport`
--

DROP TABLE IF EXISTS `sport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sport` (
  `name` varchar(20) NOT NULL,
  `type` enum('Indoor','Outdoor') NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `team_id` int NOT NULL,
  `country_code` char(3) NOT NULL,
  `number_of_players` int NOT NULL,
  PRIMARY KEY (`team_id`,`country_code`),
  KEY `fk_team_country` (`country_code`),
  CONSTRAINT `fk_team_country` FOREIGN KEY (`country_code`) REFERENCES `country` (`country_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_players` CHECK ((`number_of_players` > 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_event`
--

DROP TABLE IF EXISTS `team_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_event` (
  `sport` varchar(20) NOT NULL,
  `format` varchar(30) NOT NULL,
  `gender_category` enum('Male','Female','Mixed') NOT NULL,
  `team_size` int NOT NULL,
  PRIMARY KEY (`format`,`gender_category`),
  CONSTRAINT `fk_team_event_full` FOREIGN KEY (`sport`, `format`, `gender_category`) REFERENCES `event` (`sport`, `format`, `gender_category`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `check_size` CHECK ((`team_size` > 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_participation`
--

DROP TABLE IF EXISTS `team_participation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_participation` (
  `country_code` char(3) NOT NULL,
  `team_id` int NOT NULL,
  `sport` varchar(20) NOT NULL,
  `format` varchar(30) NOT NULL,
  `gender_category` enum('Male','Female','Mixed') NOT NULL,
  `game_number` varchar(30) NOT NULL,
  `score` decimal(5,2) NOT NULL,
  `medal` enum('Gold','Silver','Bronze') DEFAULT NULL,
  PRIMARY KEY (`country_code`,`team_id`,`format`,`gender_category`,`game_number`),
  KEY `fk_team_participation_team` (`team_id`),
  CONSTRAINT `fk_team_participation_country` FOREIGN KEY (`country_code`) REFERENCES `team` (`country_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_team_participation_team` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_team_participation_game_full` FOREIGN KEY (`sport`, `format`, `gender_category`, `game_number`) REFERENCES `game` (`sport`, `format`, `gender_category`, `game_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `venue`
--

DROP TABLE IF EXISTS `venue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venue` (
  `venue_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `capacity` int NOT NULL,
  `city` varchar(50) NOT NULL,
  `country` varchar(60) NOT NULL,
  PRIMARY KEY (`venue_id`),
  CONSTRAINT `capacity_nonnegative` CHECK ((`capacity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-07 16:45:33
