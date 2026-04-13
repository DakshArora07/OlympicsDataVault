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
-- Dumping data for table `athlete`
--

LOCK TABLES `athlete` WRITE;
/*!40000 ALTER TABLE `athlete` DISABLE KEYS */;
INSERT INTO `athlete` (`registration_number`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `email`, `gender`, `height`, `weight`, `country_code`, `sport`) VALUES
(1, 'Novak',      NULL,    'Djokovic',    '1987-05-22', 'djokovic@tennis.com',    'Male',   188.00, 77.00, 'SRB', 'Tennis'),
(2, 'Carlos',     NULL,    'Alcaraz',     '2003-05-05', 'alcaraz@tennis.com',     'Male',   185.00, 79.00, 'ESP', 'Tennis'),
(3, 'Lorenzo',    NULL,    'Musetti',     '2002-03-03', 'musetti@tennis.com',     'Male',   182.00, 75.00, 'ITA', 'Tennis'),
(4, 'Felix',      'Auger', 'Aliassime',   '2000-08-08', 'faa@tennis.com',         'Male',   193.00, 88.00, 'CAN', 'Tennis'),
(5, 'Zheng',      NULL,    'Qinwen',      '2002-10-10', 'zheng@tennis.com',       'Female', 179.00, 67.00, 'CHN', 'Tennis'),
(6, 'Donna',      NULL,    'Vekic',       '1996-06-28', 'vekic@tennis.com',       'Female', 180.00, 68.00, 'CRO', 'Tennis'),
(7, 'Iga',        NULL,    'Swiatek',     '2001-05-31', 'swiatek@tennis.com',     'Female', 175.00, 65.00, 'POL', 'Tennis'),
(8, 'Coco',       NULL,    'Gauff',       '2004-03-13', 'gauff@tennis.com',       'Female', 180.00, 68.00, 'USA', 'Tennis'),
(9,  'Tomas',     NULL,    'Machac',      '1996-05-13', 'machac@tennis.com',      'Male',   193.00, 85.00, 'CZE', 'Tennis'),
(10, 'Katerina',  NULL,    'Siniakova',   '1996-03-10', 'siniakova@tennis.com',   'Female', 171.00, 62.00, 'CZE', 'Tennis'),
(11, 'Zhang',     NULL,    'Zhizhen',     '1997-10-27', 'zhangzhizhen@tennis.com','Male',   191.00, 82.00, 'CHN', 'Tennis'),
(12, 'Wang',      NULL,    'Xinyu',       '2000-10-08', 'wangxinyu@tennis.com',   'Female', 168.00, 60.00, 'CHN', 'Tennis'),
(13, 'Gabriela',  NULL,    'Dabrowski',   '1993-09-11', 'dabrowski@tennis.com',   'Female', 175.00, 65.00, 'CAN', 'Tennis'),
(14, 'Wesley',    NULL,    'Koolhof',     '1993-09-13', 'koolhof@tennis.com',     'Male',   185.00, 80.00, 'NED', 'Tennis'),
(15, 'Demi',      NULL,    'Schuurs',     '1999-04-04', 'schuurs@tennis.com',     'Female', 174.00, 64.00, 'NED', 'Tennis'),
(16, 'Pirmin',    NULL,    'Blaak',       '1997-02-11', 'pblaak@ned.hockey',      'Male',   190.00, 85.00, 'NED', 'Field Hockey'),
(17, 'Thierry',   NULL,    'Brinkman',    '1998-11-16', 'tbrinkman@ned.hockey',   'Male',   181.00, 76.00, 'NED', 'Field Hockey'),
(18, 'Jorrit',    NULL,    'Croon',       '1997-06-22', 'jcroon@ned.hockey',      'Male',   180.00, 75.00, 'NED', 'Field Hockey'),
(19, 'Jip',       NULL,    'Janssen',     '1999-03-14', 'jjanssen@ned.hockey',    'Male',   178.00, 74.00, 'NED', 'Field Hockey'),
(20, 'Seve',      NULL,    'Van Ass',     '1994-04-08', 'svanass@ned.hockey',     'Male',   182.00, 77.00, 'NED', 'Field Hockey'),
(21, 'Jonas',     NULL,    'de Geus',     '1999-01-09', 'jdegeus@ned.hockey',     'Male',   179.00, 76.00, 'NED', 'Field Hockey'),
(22, 'Lars',      NULL,    'Balk',        '2000-05-20', 'lbalk@ned.hockey',       'Male',   183.00, 78.00, 'NED', 'Field Hockey'),
(23, 'Florent',   NULL,    'van Aubel',   '1993-06-30', 'fvanaubel@ned.hockey',   'Male',   176.00, 73.00, 'NED', 'Field Hockey'),
(24, 'Glenn',     NULL,    'Schuurman',   '1998-09-17', 'gschuurman@ned.hockey',  'Male',   185.00, 80.00, 'NED', 'Field Hockey'),
(25, 'Duco',      NULL,    'Telgenkamp',  '2002-03-11', 'dtelgenkamp@ned.hockey', 'Male',   187.00, 82.00, 'NED', 'Field Hockey'),
(26, 'Thijs',     NULL,    'van Dam',     '1997-08-05', 'tvandam@ned.hockey',     'Male',   180.00, 76.00, 'NED', 'Field Hockey'),
(27, 'Mats',      NULL,    'Grambusch',   '1997-01-19', 'mgrambusch@ger.hockey',  'Male',   182.00, 78.00, 'GER', 'Field Hockey'),
(28, 'Christopher',NULL,   'Ruhr',        '1993-12-17', 'cruhr@ger.hockey',       'Male',   178.00, 74.00, 'GER', 'Field Hockey'),
(29, 'Gonzalo',   NULL,    'Peillat',     '1992-06-20', 'gpeillat@ger.hockey',    'Male',   180.00, 76.00, 'GER', 'Field Hockey'),
(30, 'Tom',       NULL,    'Grambusch',   '1997-01-19', 'tgrambusch@ger.hockey',  'Male',   181.00, 77.00, 'GER', 'Field Hockey'),
(31, 'Jean-Paul', NULL,    'Danneberg',   '1994-09-03', 'jpdanneberg@ger.hockey', 'Male',   188.00, 84.00, 'GER', 'Field Hockey'),
(32, 'Niklas',    NULL,    'Wellen',      '1998-02-13', 'nwellen@ger.hockey',     'Male',   183.00, 79.00, 'GER', 'Field Hockey'),
(33, 'Martin',    NULL,    'Zwicker',     '1998-06-21', 'mzwicker@ger.hockey',    'Male',   179.00, 75.00, 'GER', 'Field Hockey'),
(34, 'Hannes',    NULL,    'Muller',      '2000-04-15', 'hmuller@ger.hockey',     'Male',   177.00, 73.00, 'GER', 'Field Hockey'),
(35, 'Timur',     NULL,    'Oruz',        '1997-11-30', 'toruz@ger.hockey',       'Male',   180.00, 76.00, 'GER', 'Field Hockey'),
(36, 'Elian',     NULL,    'Mazkev',      '2001-07-22', 'emazkev@ger.hockey',     'Male',   182.00, 78.00, 'GER', 'Field Hockey'),
(37, 'Marco',     NULL,    'Miltkau',     '1996-05-08', 'mmiltkau@ger.hockey',    'Male',   181.00, 77.00, 'GER', 'Field Hockey'),
(38, 'PR',        NULL,    'Sreejesh',    '1988-05-08', 'prsreejesh@ind.hockey',  'Male',   185.00, 80.00, 'IND', 'Field Hockey'),
(39, 'Harmanpreet',NULL,   'Singh',       '1996-06-06', 'hsingh@ind.hockey',      'Male',   180.00, 78.00, 'IND', 'Field Hockey'),
(40, 'Hardik',    NULL,    'Singh',       '1999-07-25', 'hardiksingh@ind.hockey', 'Male',   177.00, 74.00, 'IND', 'Field Hockey'),
(41, 'Manpreet',  NULL,    'Singh',       '1992-06-26', 'manpreets@ind.hockey',   'Male',   175.00, 72.00, 'IND', 'Field Hockey'),
(42, 'Amit',      NULL,    'Rohidas',     '1994-01-15', 'arohidas@ind.hockey',    'Male',   173.00, 71.00, 'IND', 'Field Hockey'),
(43, 'Jarmanpreet',NULL,   'Singh',       '2000-04-03', 'jsingh@ind.hockey',      'Male',   178.00, 75.00, 'IND', 'Field Hockey'),
(44, 'Sukhjeet',  NULL,    'Singh',       '1997-09-12', 'sukhjeet@ind.hockey',    'Male',   174.00, 72.00, 'IND', 'Field Hockey'),
(45, 'Raj Kumar', NULL,    'Pal',         '1998-02-22', 'rkpal@ind.hockey',       'Male',   172.00, 70.00, 'IND', 'Field Hockey'),
(46, 'Abhishek',  NULL,    'Sharma',      '2001-08-17', 'absharma@ind.hockey',    'Male',   176.00, 73.00, 'IND', 'Field Hockey'),
(47, 'Sumit',     NULL,    'Walmiki',     '1995-05-18', 'swalmiki@ind.hockey',    'Male',   175.00, 72.00, 'IND', 'Field Hockey'),
(48, 'Vivek',     NULL,    'Sagar',       '1999-11-10', 'vsagar@ind.hockey',      'Male',   171.00, 69.00, 'IND', 'Field Hockey'),
(49, 'Marc',      NULL,    'Miralles',    '1994-09-11', 'mmiralles@esp.hockey',   'Male',   178.00, 74.00, 'ESP', 'Field Hockey'),
(50, 'Alvaro',    NULL,    'Iglesias',    '1988-03-28', 'aiglesias@esp.hockey',   'Male',   176.00, 73.00, 'ESP', 'Field Hockey'),
(51, 'Joaquin',   NULL,    'Menini',      '1988-07-15', 'jmenini@esp.hockey',     'Male',   177.00, 74.00, 'ESP', 'Field Hockey'),
(52, 'Josep',     NULL,    'Romeu',       '1993-12-04', 'jromeu@esp.hockey',      'Male',   179.00, 76.00, 'ESP', 'Field Hockey'),
(53, 'Pau',       NULL,    'Quemada',     '1997-08-21', 'pquemada@esp.hockey',    'Male',   180.00, 77.00, 'ESP', 'Field Hockey'),
(54, 'David',     NULL,    'Alegre',      '1994-05-10', 'dalegre@esp.hockey',     'Male',   175.00, 72.00, 'ESP', 'Field Hockey'),
(55, 'Alex',      NULL,    'Casasayas',   '1999-02-18', 'acasasayas@esp.hockey',  'Male',   177.00, 74.00, 'ESP', 'Field Hockey'),
(56, 'Enrique',   NULL,    'Gonzalez',    '1995-11-03', 'egonzalez@esp.hockey',   'Male',   178.00, 75.00, 'ESP', 'Field Hockey'),
(57, 'Quico',     NULL,    'Cortes',      '1992-06-14', 'qcortes@esp.hockey',     'Male',   181.00, 78.00, 'ESP', 'Field Hockey'),
(58, 'Jose',      NULL,    'Basterra',    '1997-01-22', 'jbasterra@esp.hockey',   'Male',   176.00, 73.00, 'ESP', 'Field Hockey'),
(59, 'Lluis',     NULL,    'Dolcet',      '2000-09-05', 'ldolcet@esp.hockey',     'Male',   179.00, 76.00, 'ESP', 'Field Hockey'),
(60, 'Anne',      NULL,    'Veenendaal',  '1991-05-03', 'aveenendaal@ned.hockey', 'Female', 175.00, 68.00, 'NED', 'Field Hockey'),
(61, 'Felice',    NULL,    'Albers',      '2002-03-03', 'falbers@ned.hockey',     'Female', 172.00, 65.00, 'NED', 'Field Hockey'),
(62, 'Maria',     NULL,    'Verschoor',   '1995-08-29', 'mverschoor@ned.hockey',  'Female', 170.00, 64.00, 'NED', 'Field Hockey'),
(63, 'Xan',       NULL,    'de Waard',    '1997-02-10', 'xdewaard@ned.hockey',    'Female', 168.00, 62.00, 'NED', 'Field Hockey'),
(64, 'Frederique',NULL,    'Matla',       '1994-05-12', 'fmatla@ned.hockey',      'Female', 171.00, 63.00, 'NED', 'Field Hockey'),
(65, 'Pien',      NULL,    'Sanders',     '1999-07-11', 'psanders@ned.hockey',    'Female', 169.00, 63.00, 'NED', 'Field Hockey'),
(66, 'Yibbi',     NULL,    'Jansen',      '1998-09-25', 'yjansen@ned.hockey',     'Female', 167.00, 61.00, 'NED', 'Field Hockey'),
(67, 'Laura',     NULL,    'Nunnink',     '2001-06-18', 'lnunnink@ned.hockey',    'Female', 170.00, 64.00, 'NED', 'Field Hockey'),
(68, 'Sanne',     NULL,    'Koolen',      '1995-03-22', 'skoleen@ned.hockey',     'Female', 166.00, 61.00, 'NED', 'Field Hockey'),
(69, 'Luna',      NULL,    'Fokke',       '2002-11-07', 'lfokke@ned.hockey',      'Female', 168.00, 62.00, 'NED', 'Field Hockey'),
(70, 'Renee',     NULL,    'van Laarhoven','1998-04-14','rvanlaarhoven@ned.hockey','Female', 172.00, 65.00, 'NED', 'Field Hockey'),
(71, 'Chen',      NULL,    'Yi',          '1997-04-10', 'chenyi@chn.hockey',      'Female', 168.00, 60.00, 'CHN', 'Field Hockey'),
(72, 'Wu',        NULL,    'Zimeng',      '1998-06-15', 'wuzimeng@chn.hockey',    'Female', 165.00, 58.00, 'CHN', 'Field Hockey'),
(73, 'Liu',       NULL,    'Hui',         '1996-03-22', 'liuhui@chn.hockey',      'Female', 167.00, 60.00, 'CHN', 'Field Hockey'),
(74, 'Zhang',     NULL,    'Yining',      '1999-08-05', 'zhangyining@chn.hockey', 'Female', 166.00, 59.00, 'CHN', 'Field Hockey'),
(75, 'Ye',        NULL,    'Jiaojiao',    '2000-01-12', 'yejiaojiao@chn.hockey',  'Female', 164.00, 57.00, 'CHN', 'Field Hockey'),
(76, 'Liang',     NULL,    'Meiyu',       '1997-11-28', 'liangmeiyu@chn.hockey',  'Female', 168.00, 61.00, 'CHN', 'Field Hockey'),
(77, 'Song',      NULL,    'Yanzhu',      '2001-04-17', 'songyanzhu@chn.hockey',  'Female', 165.00, 58.00, 'CHN', 'Field Hockey'),
(78, 'Gu',        NULL,    'Bingfeng',    '1998-09-30', 'gubingfeng@chn.hockey',  'Female', 163.00, 57.00, 'CHN', 'Field Hockey'),
(79, 'Sun',       NULL,    'Li',          '2000-07-22', 'sunli@chn.hockey',       'Female', 167.00, 60.00, 'CHN', 'Field Hockey'),
(80, 'Sheng',     NULL,    'Jiajia',      '1999-03-08', 'shengjiajia@chn.hockey', 'Female', 164.00, 58.00, 'CHN', 'Field Hockey'),
(81, 'Li',        NULL,    'Danyang',     '2002-05-19', 'lidanyang@chn.hockey',   'Female', 166.00, 59.00, 'CHN', 'Field Hockey'),
(82, 'Valentina', NULL,    'Raposo',      '2002-03-09', 'vraposo@arg.hockey',     'Female', 170.00, 63.00, 'ARG', 'Field Hockey'),
(83, 'Augustina', NULL,    'Gorzelany',   '1994-08-12', 'agorzelany@arg.hockey',  'Female', 167.00, 61.00, 'ARG', 'Field Hockey'),
(84, 'Victoria',  NULL,    'Granatto',    '1997-04-25', 'vgranatto@arg.hockey',   'Female', 169.00, 62.00, 'ARG', 'Field Hockey'),
(85, 'Julieta',   NULL,    'Jankunas',    '1999-11-03', 'jjankunas@arg.hockey',   'Female', 168.00, 62.00, 'ARG', 'Field Hockey'),
(86, 'Sofia',     NULL,    'Toccalino',   '1998-06-18', 'stoccalino@arg.hockey',  'Female', 165.00, 60.00, 'ARG', 'Field Hockey'),
(87, 'Emilia',    NULL,    'Forcherio',   '2001-09-14', 'eforcherio@arg.hockey',  'Female', 166.00, 61.00, 'ARG', 'Field Hockey'),
(88, 'Luciana',   NULL,    'Mendez',      '1996-02-28', 'lmendez@arg.hockey',     'Female', 168.00, 62.00, 'ARG', 'Field Hockey'),
(89, 'Trinidad',  NULL,    'Genetino',    '1997-07-07', 'tgenetino@arg.hockey',   'Female', 170.00, 63.00, 'ARG', 'Field Hockey'),
(90, 'Agustina',  NULL,    'Albertarrio', '2000-03-21', 'aalbertarrio@arg.hockey','Female', 167.00, 61.00, 'ARG', 'Field Hockey'),
(91, 'Julieta',   NULL,    'Castellotti', '1994-12-10', 'jcastellotti@arg.hockey','Female', 171.00, 64.00, 'ARG', 'Field Hockey'),
(92, 'Micaela',   NULL,    'Retegui',     '1999-08-30', 'mretegui@arg.hockey',    'Female', 169.00, 63.00, 'ARG', 'Field Hockey'),
(93,  'Stephanie',NULL,    'Vanden Borre','1998-05-15', 'svandenborre@bel.hockey','Female', 171.00, 64.00, 'BEL', 'Field Hockey'),
(94,  'Aisling',  NULL,    'd''Hooghe',   '1992-03-10', 'adhooghe@bel.hockey',    'Female', 168.00, 62.00, 'BEL', 'Field Hockey'),
(95,  'Barbara',  NULL,    'Nelen',       '1995-08-22', 'bnelen@bel.hockey',      'Female', 166.00, 60.00, 'BEL', 'Field Hockey'),
(96,  'Tiphaine', NULL,    'Duquesne',    '1997-11-18', 'tduquesne@bel.hockey',   'Female', 169.00, 63.00, 'BEL', 'Field Hockey'),
(97,  'Lien',     NULL,    'Hillewaert',  '1994-06-05', 'lhillewaert@bel.hockey', 'Female', 167.00, 61.00, 'BEL', 'Field Hockey'),
(98,  'Alix',     NULL,    'Gerniers',    '1998-09-14', 'agerniers@bel.hockey',   'Female', 165.00, 60.00, 'BEL', 'Field Hockey'),
(99,  'Elena',    NULL,    'Sotgiu',      '2000-04-27', 'esotgiu@bel.hockey',     'Female', 168.00, 62.00, 'BEL', 'Field Hockey'),
(100, 'Judith',   NULL,    'Vandermeiren','1996-01-19', 'jvandermeiren@bel.hockey','Female',170.00, 64.00, 'BEL', 'Field Hockey'),
(101, 'Delphine', NULL,    'Marien',      '1993-07-30', 'dmarien@bel.hockey',     'Female', 167.00, 61.00, 'BEL', 'Field Hockey'),
(102, 'Pauline',  NULL,    'Leclef',      '2001-02-11', 'pleclef@bel.hockey',     'Female', 166.00, 60.00, 'BEL', 'Field Hockey'),
(103, 'Charlotte',NULL,    'Englebert',   '1999-10-23', 'cenglebert@bel.hockey',  'Female', 169.00, 63.00, 'BEL', 'Field Hockey');
/*!40000 ALTER TABLE `athlete` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `athlete_participation`
--

LOCK TABLES `athlete_participation` WRITE;
/*!40000 ALTER TABLE `athlete_participation` DISABLE KEYS */;
INSERT INTO `athlete_participation` (`athlete_registration_number`, `sport`, `format`, `gender_category`, `game_number`, `score`, `medal`) VALUES
(1, 'Tennis', 'Singles', 'Male', 'SEMI FINAL 1', 2.00, NULL),
(2, 'Tennis', 'Singles', 'Male', 'SEMI FINAL 1', 0.00, NULL),
(3, 'Tennis', 'Singles', 'Male', 'SEMI FINAL 2', 2.00, NULL),
(4, 'Tennis', 'Singles', 'Male', 'SEMI FINAL 2', 1.00, NULL),
(3, 'Tennis', 'Singles', 'Male', 'BRONZE MATCH', 2.00, 'Bronze'),
(4, 'Tennis', 'Singles', 'Male', 'BRONZE MATCH', 1.00, NULL),
(1, 'Tennis', 'Singles', 'Male', 'FINAL', 2.00, 'Gold'),
(2, 'Tennis', 'Singles', 'Male', 'FINAL', 0.00, 'Silver'),
(5, 'Tennis', 'Singles', 'Female', 'SEMI FINAL 1', 2.00, NULL),
(8, 'Tennis', 'Singles', 'Female', 'SEMI FINAL 1', 0.00, NULL),
(6, 'Tennis', 'Singles', 'Female', 'SEMI FINAL 2', 2.00, NULL),
(7, 'Tennis', 'Singles', 'Female', 'SEMI FINAL 2', 1.00, NULL),
(7, 'Tennis', 'Singles', 'Female', 'BRONZE MATCH', 2.00, 'Bronze'),
(8, 'Tennis', 'Singles', 'Female', 'BRONZE MATCH', 0.00, NULL),
(5, 'Tennis', 'Singles', 'Female', 'FINAL', 2.00, 'Gold'),
(6, 'Tennis', 'Singles', 'Female', 'FINAL', 1.00, 'Silver');
/*!40000 ALTER TABLE `athlete_participation` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` (`country_code`, `name`, `flag`, `continent`) VALUES
-- Africa
('AGO', 'Angola', 'https://www.worldometers.info/images/flags/original/ao.webp', 'Africa'),
('BDI', 'Burundi', 'https://www.worldometers.info/images/flags/original/bi.webp', 'Africa'),
('BEN', 'Benin', 'https://www.worldometers.info/images/flags/original/bj.webp', 'Africa'),
('BOT', 'Botswana', 'https://www.worldometers.info/images/flags/original/bw.webp', 'Africa'),
('BUR', 'Burkina Faso', 'https://www.worldometers.info/images/flags/original/bf.webp', 'Africa'),
('CAF', 'Central African Republic', 'https://www.worldometers.info/images/flags/original/cf.webp', 'Africa'),
('CGO', 'Republic of the Congo', 'https://www.worldometers.info/images/flags/original/cg.webp', 'Africa'),
('CHA', 'Chad', 'https://www.worldometers.info/images/flags/original/td.webp', 'Africa'),
('CIV', 'Ivory Coast', 'https://www.worldometers.info/images/flags/original/ci.webp', 'Africa'),
('CMR', 'Cameroon', 'https://www.worldometers.info/images/flags/original/cm.webp', 'Africa'),
('COD', 'Democratic Republic of the Congo', 'https://www.worldometers.info/images/flags/original/cd.webp', 'Africa'),
('COM', 'Comoros', 'https://www.worldometers.info/images/flags/original/km.webp', 'Africa'),
('CPV', 'Cape Verde', 'https://www.worldometers.info/images/flags/original/cv.webp', 'Africa'),
('DJI', 'Djibouti', 'https://www.worldometers.info/images/flags/original/dj.webp', 'Africa'),
('EGY', 'Egypt', 'https://www.worldometers.info/images/flags/original/eg.webp', 'Africa'),
('ERI', 'Eritrea', 'https://www.worldometers.info/images/flags/original/er.webp', 'Africa'),
('ETH', 'Ethiopia', 'https://www.worldometers.info/images/flags/original/et.webp', 'Africa'),
('GAB', 'Gabon', 'https://www.worldometers.info/images/flags/original/ga.webp', 'Africa'),
('GAM', 'Gambia', 'https://www.worldometers.info/images/flags/original/gm.webp', 'Africa'),
('GBS', 'Guinea-Bissau', 'https://www.worldometers.info/images/flags/original/gw.webp', 'Africa'),
('GEQ', 'Equatorial Guinea', 'https://www.worldometers.info/images/flags/original/gq.webp', 'Africa'),
('GHA', 'Ghana', 'https://www.worldometers.info/images/flags/original/gh.webp', 'Africa'),
('GUI', 'Guinea', 'https://www.worldometers.info/images/flags/original/gn.webp', 'Africa'),
('KEN', 'Kenya', 'https://www.worldometers.info/images/flags/original/ke.webp', 'Africa'),
('LBA', 'Libya', 'https://www.worldometers.info/images/flags/original/ly.webp', 'Africa'),
('LBR', 'Liberia', 'https://www.worldometers.info/images/flags/original/lr.webp', 'Africa'),
('LES', 'Lesotho', 'https://www.worldometers.info/images/flags/original/ls.webp', 'Africa'),
('MAD', 'Madagascar', 'https://www.worldometers.info/images/flags/original/mg.webp', 'Africa'),
('MAR', 'Morocco', 'https://www.worldometers.info/images/flags/original/ma.webp', 'Africa'),
('MAW', 'Malawi', 'https://www.worldometers.info/images/flags/original/mw.webp', 'Africa'),
('MLI', 'Mali', 'https://www.worldometers.info/images/flags/original/ml.webp', 'Africa'),
('MOZ', 'Mozambique', 'https://www.worldometers.info/images/flags/original/mz.webp', 'Africa'),
('MRI', 'Mauritius', 'https://www.worldometers.info/images/flags/original/mu.webp', 'Africa'),
('MTN', 'Mauritania', 'https://www.worldometers.info/images/flags/original/mr.webp', 'Africa'),
('NAM', 'Namibia', 'https://www.worldometers.info/images/flags/original/na.webp', 'Africa'),
('NIG', 'Niger', 'https://www.worldometers.info/images/flags/original/ne.webp', 'Africa'),
('NGR', 'Nigeria', 'https://www.worldometers.info/images/flags/original/ng.webp', 'Africa'),
('RSA', 'South Africa', 'https://www.worldometers.info/images/flags/original/za.webp', 'Africa'),
('RWA', 'Rwanda', 'https://www.worldometers.info/images/flags/original/rw.webp', 'Africa'),
('SEN', 'Senegal', 'https://www.worldometers.info/images/flags/original/sn.webp', 'Africa'),
('SEY', 'Seychelles', 'https://www.worldometers.info/images/flags/original/sc.webp', 'Africa'),
('SLE', 'Sierra Leone', 'https://www.worldometers.info/images/flags/original/sl.webp', 'Africa'),
('SOM', 'Somalia', 'https://www.worldometers.info/images/flags/original/so.webp', 'Africa'),
('SSD', 'South Sudan', 'https://www.worldometers.info/images/flags/original/ss.webp', 'Africa'),
('STP', 'Sao Tome and Principe', 'https://www.worldometers.info/images/flags/original/st.webp', 'Africa'),
('SUD', 'Sudan', 'https://www.worldometers.info/images/flags/original/sd.webp', 'Africa'),
('SWZ', 'Eswatini', 'https://www.worldometers.info/images/flags/original/sz.webp', 'Africa'),
('TAN', 'Tanzania', 'https://www.worldometers.info/images/flags/original/tz.webp', 'Africa'),
('TOG', 'Togo', 'https://www.worldometers.info/images/flags/original/tg.webp', 'Africa'),
('TUN', 'Tunisia', 'https://www.worldometers.info/images/flags/original/tn.webp', 'Africa'),
('UGA', 'Uganda', 'https://www.worldometers.info/images/flags/original/ug.webp', 'Africa'),
('ZAM', 'Zambia', 'https://www.worldometers.info/images/flags/original/zm.webp', 'Africa'),
('ZIM', 'Zimbabwe', 'https://www.worldometers.info/images/flags/original/zw.webp', 'Africa'),
-- Asia
('AFG', 'Afghanistan', 'https://www.worldometers.info/images/flags/original/af.webp', 'Asia'),
('BAN', 'Bangladesh', 'https://www.worldometers.info/images/flags/original/bd.webp', 'Asia'),
('BHU', 'Bhutan', 'https://www.worldometers.info/images/flags/original/bt.webp', 'Asia'),
('BRN', 'Brunei', 'https://www.worldometers.info/images/flags/original/bn.webp', 'Asia'),
('CAM', 'Cambodia', 'https://www.worldometers.info/images/flags/original/kh.webp', 'Asia'),
('CHN', 'China', 'https://www.worldometers.info/images/flags/original/cn.webp', 'Asia'),
('HKG', 'Hong Kong', 'https://www.worldometers.info/images/flags/original/hk.webp', 'Asia'),
('INA', 'Indonesia', 'https://www.worldometers.info/images/flags/original/id.webp', 'Asia'),
('IND', 'India', 'https://www.worldometers.info/images/flags/original/in.webp', 'Asia'),
('IRI', 'Iran', 'https://www.worldometers.info/images/flags/original/ir.webp', 'Asia'),
('IRQ', 'Iraq', 'https://www.worldometers.info/images/flags/original/iq.webp', 'Asia'),
('JOR', 'Jordan', 'https://www.worldometers.info/images/flags/original/jo.webp', 'Asia'),
('JPN', 'Japan', 'https://www.worldometers.info/images/flags/original/jp.webp', 'Asia'),
('KAZ', 'Kazakhstan', 'https://www.worldometers.info/images/flags/original/kz.webp', 'Asia'),
('KGZ', 'Kyrgyzstan', 'https://www.worldometers.info/images/flags/original/kg.webp', 'Asia'),
('KOR', 'South Korea', 'https://www.worldometers.info/images/flags/original/kr.webp', 'Asia'),
('KSA', 'Saudi Arabia', 'https://www.worldometers.info/images/flags/original/sa.webp', 'Asia'),
('KUW', 'Kuwait', 'https://www.worldometers.info/images/flags/original/kw.webp', 'Asia'),
('LAO', 'Laos', 'https://www.worldometers.info/images/flags/original/la.webp', 'Asia'),
('LBN', 'Lebanon', 'https://www.worldometers.info/images/flags/original/lb.webp', 'Asia'),
('MAS', 'Malaysia', 'https://www.worldometers.info/images/flags/original/my.webp', 'Asia'),
('MDV', 'Maldives', 'https://www.worldometers.info/images/flags/original/mv.webp', 'Asia'),
('MGL', 'Mongolia', 'https://www.worldometers.info/images/flags/original/mn.webp', 'Asia'),
('MYA', 'Myanmar', 'https://www.worldometers.info/images/flags/original/mm.webp', 'Asia'),
('NEP', 'Nepal', 'https://www.worldometers.info/images/flags/original/np.webp', 'Asia'),
('OMA', 'Oman', 'https://www.worldometers.info/images/flags/original/om.webp', 'Asia'),
('PAK', 'Pakistan', 'https://www.worldometers.info/images/flags/original/pk.webp', 'Asia'),
('PHI', 'Philippines', 'https://www.worldometers.info/images/flags/original/ph.webp', 'Asia'),
('PLE', 'Palestine', 'https://www.worldometers.info/images/flags/original/ps.webp', 'Asia'),
('PRK', 'North Korea', 'https://www.worldometers.info/images/flags/original/kp.webp', 'Asia'),
('QAT', 'Qatar', 'https://www.worldometers.info/images/flags/original/qa.webp', 'Asia'),
('SGP', 'Singapore', 'https://www.worldometers.info/images/flags/original/sg.webp', 'Asia'),
('SRI', 'Sri Lanka', 'https://www.worldometers.info/images/flags/original/lk.webp', 'Asia'),
('SYR', 'Syria', 'https://www.worldometers.info/images/flags/original/sy.webp', 'Asia'),
('THA', 'Thailand', 'https://www.worldometers.info/images/flags/original/th.webp', 'Asia'),
('TJK', 'Tajikistan', 'https://www.worldometers.info/images/flags/original/tj.webp', 'Asia'),
('TKM', 'Turkmenistan', 'https://www.worldometers.info/images/flags/original/tm.webp', 'Asia'),
('TLS', 'Timor-Leste', 'https://www.worldometers.info/images/flags/original/tl.webp', 'Asia'),
('TPE', 'Chinese Taipei', 'https://www.worldometers.info/images/flags/original/tw.webp', 'Asia'),
('UZB', 'Uzbekistan', 'https://www.worldometers.info/images/flags/original/uz.webp', 'Asia'),
('VIE', 'Vietnam', 'https://www.worldometers.info/images/flags/original/vn.webp', 'Asia'),
('YEM', 'Yemen', 'https://www.worldometers.info/images/flags/original/ye.webp', 'Asia'),
-- Europe
('ALB', 'Albania', 'https://www.worldometers.info/images/flags/original/al.webp', 'Europe'),
('AND', 'Andorra', 'https://www.worldometers.info/images/flags/original/ad.webp', 'Europe'),
('ARM', 'Armenia', 'https://www.worldometers.info/images/flags/original/am.webp', 'Europe'),
('AUT', 'Austria', 'https://www.worldometers.info/images/flags/original/at.webp', 'Europe'),
('AZE', 'Azerbaijan', 'https://www.worldometers.info/images/flags/original/az.webp', 'Europe'),
('BEL', 'Belgium', 'https://www.worldometers.info/images/flags/original/be.webp', 'Europe'),
('BIH', 'Bosnia and Herzegovina', 'https://www.worldometers.info/images/flags/original/ba.webp', 'Europe'),
('BLR', 'Belarus', 'https://www.worldometers.info/images/flags/original/by.webp', 'Europe'),
('BUL', 'Bulgaria', 'https://www.worldometers.info/images/flags/original/bg.webp', 'Europe'),
('CRO', 'Croatia', 'https://www.worldometers.info/images/flags/original/hr.webp', 'Europe'),
('CYP', 'Cyprus', 'https://www.worldometers.info/images/flags/original/cy.webp', 'Europe'),
('CZE', 'Czech Republic', 'https://www.worldometers.info/images/flags/original/cz.webp', 'Europe'),
('DEN', 'Denmark', 'https://www.worldometers.info/images/flags/original/dk.webp', 'Europe'),
('ESP', 'Spain', 'https://www.worldometers.info/images/flags/original/es.webp', 'Europe'),
('EST', 'Estonia', 'https://www.worldometers.info/images/flags/original/ee.webp', 'Europe'),
('FIN', 'Finland', 'https://www.worldometers.info/images/flags/original/fi.webp', 'Europe'),
('FRA', 'France', 'https://www.worldometers.info/images/flags/original/fr.webp', 'Europe'),
('GBR', 'Great Britain', 'https://www.worldometers.info/images/flags/original/gb.webp', 'Europe'),
('GEO', 'Georgia', 'https://www.worldometers.info/images/flags/original/ge.webp', 'Europe'),
('GER', 'Germany', 'https://www.worldometers.info/images/flags/original/de.webp', 'Europe'),
('GRE', 'Greece', 'https://www.worldometers.info/images/flags/original/gr.webp', 'Europe'),
('HUN', 'Hungary', 'https://www.worldometers.info/images/flags/original/hu.webp', 'Europe'),
('IRL', 'Ireland', 'https://www.worldometers.info/images/flags/original/ie.webp', 'Europe'),
('ISL', 'Iceland', 'https://www.worldometers.info/images/flags/original/is.webp', 'Europe'),
('ISR', 'Israel', 'https://www.worldometers.info/images/flags/original/il.webp', 'Europe'),
('ITA', 'Italy', 'https://www.worldometers.info/images/flags/original/it.webp', 'Europe'),
('KOS', 'Kosovo', 'https://www.worldometers.info/images/flags/original/xk.webp', 'Europe'),
('LAT', 'Latvia', 'https://www.worldometers.info/images/flags/original/lv.webp', 'Europe'),
('LIE', 'Liechtenstein', 'https://www.worldometers.info/images/flags/original/li.webp', 'Europe'),
('LIT', 'Lithuania', 'https://www.worldometers.info/images/flags/original/lt.webp', 'Europe'),
('LUX', 'Luxembourg', 'https://www.worldometers.info/images/flags/original/lu.webp', 'Europe'),
('MDA', 'Moldova', 'https://www.worldometers.info/images/flags/original/md.webp', 'Europe'),
('MKD', 'North Macedonia', 'https://www.worldometers.info/images/flags/original/mk.webp', 'Europe'),
('MLT', 'Malta', 'https://www.worldometers.info/images/flags/original/mt.webp', 'Europe'),
('MNE', 'Montenegro', 'https://www.worldometers.info/images/flags/original/me.webp', 'Europe'),
('MON', 'Monaco', 'https://www.worldometers.info/images/flags/original/mc.webp', 'Europe'),
('NED', 'Netherlands', 'https://www.worldometers.info/images/flags/original/nl.webp', 'Europe'),
('NOR', 'Norway', 'https://www.worldometers.info/images/flags/original/no.webp', 'Europe'),
('POL', 'Poland', 'https://www.worldometers.info/images/flags/original/pl.webp', 'Europe'),
('POR', 'Portugal', 'https://www.worldometers.info/images/flags/original/pt.webp', 'Europe'),
('ROU', 'Romania', 'https://www.worldometers.info/images/flags/original/ro.webp', 'Europe'),
('RUS', 'Russia', 'https://www.worldometers.info/images/flags/original/ru.webp', 'Europe'),
('SLO', 'Slovenia', 'https://www.worldometers.info/images/flags/original/si.webp', 'Europe'),
('SMR', 'San Marino', 'https://www.worldometers.info/images/flags/original/sm.webp', 'Europe'),
('SRB', 'Serbia', 'https://www.worldometers.info/images/flags/original/rs.webp', 'Europe'),
('SUI', 'Switzerland', 'https://www.worldometers.info/images/flags/original/ch.webp', 'Europe'),
('SVK', 'Slovakia', 'https://www.worldometers.info/images/flags/original/sk.webp', 'Europe'),
('SWE', 'Sweden', 'https://www.worldometers.info/images/flags/original/se.webp', 'Europe'),
('TUR', 'Turkey', 'https://www.worldometers.info/images/flags/original/tr.webp', 'Europe'),
('UKR', 'Ukraine', 'https://www.worldometers.info/images/flags/original/ua.webp', 'Europe'),
-- North America
('ANT', 'Antigua and Barbuda', 'https://www.worldometers.info/images/flags/original/ag.webp', 'North America'),
('ARU', 'Aruba', 'https://www.worldometers.info/images/flags/original/aw.webp', 'North America'),
('BAH', 'Bahamas', 'https://www.worldometers.info/images/flags/original/bs.webp', 'North America'),
('BAR', 'Barbados', 'https://www.worldometers.info/images/flags/original/bb.webp', 'North America'),
('BIZ', 'Belize', 'https://www.worldometers.info/images/flags/original/bz.webp', 'North America'),
('BMU', 'Bermuda', 'https://www.worldometers.info/images/flags/original/bm.webp', 'North America'),
('CAN', 'Canada', 'https://www.worldometers.info/images/flags/original/ca.webp', 'North America'),
('CAY', 'Cayman Islands', 'https://www.worldometers.info/images/flags/original/ky.webp', 'North America'),
('CRC', 'Costa Rica', 'https://www.worldometers.info/images/flags/original/cr.webp', 'North America'),
('CUB', 'Cuba', 'https://www.worldometers.info/images/flags/original/cu.webp', 'North America'),
('DOM', 'Dominican Republic', 'https://www.worldometers.info/images/flags/original/do.webp', 'North America'),
('ESA', 'El Salvador', 'https://www.worldometers.info/images/flags/original/sv.webp', 'North America'),
('GRN', 'Grenada', 'https://www.worldometers.info/images/flags/original/gd.webp', 'North America'),
('GUA', 'Guatemala', 'https://www.worldometers.info/images/flags/original/gt.webp', 'North America'),
('HAI', 'Haiti', 'https://www.worldometers.info/images/flags/original/ht.webp', 'North America'),
('HON', 'Honduras', 'https://www.worldometers.info/images/flags/original/hn.webp', 'North America'),
('IVB', 'British Virgin Islands', 'https://www.worldometers.info/images/flags/original/vg.webp', 'North America'),
('ISV', 'US Virgin Islands', 'https://www.worldometers.info/images/flags/original/vi.webp', 'North America'),
('JAM', 'Jamaica', 'https://www.worldometers.info/images/flags/original/jm.webp', 'North America'),
('LCA', 'Saint Lucia', 'https://www.worldometers.info/images/flags/original/lc.webp', 'North America'),
('MEX', 'Mexico', 'https://www.worldometers.info/images/flags/original/mx.webp', 'North America'),
('NCA', 'Nicaragua', 'https://www.worldometers.info/images/flags/original/ni.webp', 'North America'),
('PAN', 'Panama', 'https://www.worldometers.info/images/flags/original/pa.webp', 'North America'),
('PUR', 'Puerto Rico', 'https://www.worldometers.info/images/flags/original/pr.webp', 'North America'),
('SKN', 'Saint Kitts and Nevis', 'https://www.worldometers.info/images/flags/original/kn.webp', 'North America'),
('TTO', 'Trinidad and Tobago', 'https://www.worldometers.info/images/flags/original/tt.webp', 'North America'),
('USA', 'United States of America', 'https://www.worldometers.info/images/flags/original/us.webp', 'North America'),
('VIN', 'Saint Vincent and the Grenadines', 'https://www.worldometers.info/images/flags/original/vc.webp', 'North America'),
-- South America
('ARG', 'Argentina', 'https://www.worldometers.info/images/flags/original/ar.webp', 'South America'),
('BOL', 'Bolivia', 'https://www.worldometers.info/images/flags/original/bo.webp', 'South America'),
('BRA', 'Brazil', 'https://www.worldometers.info/images/flags/original/br.webp', 'South America'),
('CHI', 'Chile', 'https://www.worldometers.info/images/flags/original/cl.webp', 'South America'),
('COL', 'Colombia', 'https://www.worldometers.info/images/flags/original/co.webp', 'South America'),
('ECU', 'Ecuador', 'https://www.worldometers.info/images/flags/original/ec.webp', 'South America'),
('GUY', 'Guyana', 'https://www.worldometers.info/images/flags/original/gy.webp', 'South America'),
('PAR', 'Paraguay', 'https://www.worldometers.info/images/flags/original/py.webp', 'South America'),
('PER', 'Peru', 'https://www.worldometers.info/images/flags/original/pe.webp', 'South America'),
('SUR', 'Suriname', 'https://www.worldometers.info/images/flags/original/sr.webp', 'South America'),
('URU', 'Uruguay', 'https://www.worldometers.info/images/flags/original/uy.webp', 'South America'),
('VEN', 'Venezuela', 'https://www.worldometers.info/images/flags/original/ve.webp', 'South America'),
-- Oceania
('ASA', 'American Samoa', 'https://www.worldometers.info/images/flags/original/as.webp', 'Oceania'),
('AUS', 'Australia', 'https://www.worldometers.info/images/flags/original/au.webp', 'Oceania'),
('COK', 'Cook Islands', 'https://www.worldometers.info/images/flags/original/ck.webp', 'Oceania'),
('FIJ', 'Fiji', 'https://www.worldometers.info/images/flags/original/fj.webp', 'Oceania'),
('FSM', 'Micronesia', 'https://www.worldometers.info/images/flags/original/fm.webp', 'Oceania'),
('GUM', 'Guam', 'https://www.worldometers.info/images/flags/original/gu.webp', 'Oceania'),
('KIR', 'Kiribati', 'https://www.worldometers.info/images/flags/original/ki.webp', 'Oceania'),
('MHL', 'Marshall Islands', 'https://www.worldometers.info/images/flags/original/mh.webp', 'Oceania'),
('NRU', 'Nauru', 'https://www.worldometers.info/images/flags/original/nr.webp', 'Oceania'),
('NZL', 'New Zealand', 'https://www.worldometers.info/images/flags/original/nz.webp', 'Oceania'),
('PAL', 'Palau', 'https://www.worldometers.info/images/flags/original/pw.webp', 'Oceania'),
('PNG', 'Papua New Guinea', 'https://www.worldometers.info/images/flags/original/pg.webp', 'Oceania'),
('SAM', 'Samoa', 'https://www.worldometers.info/images/flags/original/ws.webp', 'Oceania'),
('SOL', 'Solomon Islands', 'https://www.worldometers.info/images/flags/original/sb.webp', 'Oceania'),
('TGA', 'Tonga', 'https://www.worldometers.info/images/flags/original/to.webp', 'Oceania'),
('TUV', 'Tuvalu', 'https://www.worldometers.info/images/flags/original/tv.webp', 'Oceania'),
('VAN', 'Vanuatu', 'https://www.worldometers.info/images/flags/original/vu.webp', 'Oceania');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `event`
--

LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;
INSERT INTO `event` (`sport`, `format`, `gender_category`, `venue_id`) VALUES
('Tennis',       'Singles',        'Male',   1),
('Tennis',       'Singles',        'Female', 1),
('Tennis',       'Mixed Doubles',  'Mixed',  1),
('Field Hockey', 'Tournament',     'Male',   2),
('Field Hockey', 'Tournament',     'Female', 2);
/*!40000 ALTER TABLE `event` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `game`
--

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` (`sport`, `format`, `gender_category`, `game_number`, `date`) VALUES
('Tennis', 'Singles', 'Male', 'SEMI FINAL 1', '2024-08-01'),
('Tennis', 'Singles', 'Male', 'SEMI FINAL 2', '2024-08-01'),
('Tennis', 'Singles', 'Male', 'BRONZE MATCH', '2024-08-03'),
('Tennis', 'Singles', 'Male', 'FINAL',        '2024-08-04'),
('Tennis', 'Singles', 'Female', 'SEMI FINAL 1', '2024-08-01'),
('Tennis', 'Singles', 'Female', 'SEMI FINAL 2', '2024-08-01'),
('Tennis', 'Singles', 'Female', 'BRONZE MATCH', '2024-08-03'),
('Tennis', 'Singles', 'Female', 'FINAL',        '2024-08-03'),
('Tennis', 'Mixed Doubles', 'Mixed', 'SEMI FINAL 1', '2024-08-02'),
('Tennis', 'Mixed Doubles', 'Mixed', 'SEMI FINAL 2', '2024-08-02'),
('Tennis', 'Mixed Doubles', 'Mixed', 'BRONZE MATCH', '2024-08-04'),
('Tennis', 'Mixed Doubles', 'Mixed', 'FINAL',        '2024-08-04'),
('Field Hockey', 'Tournament', 'Male', 'SEMI FINAL 1', '2024-08-06'),
('Field Hockey', 'Tournament', 'Male', 'SEMI FINAL 2', '2024-08-06'),
('Field Hockey', 'Tournament', 'Male', 'BRONZE MATCH', '2024-08-08'),
('Field Hockey', 'Tournament', 'Male', 'FINAL',        '2024-08-08'),
('Field Hockey', 'Tournament', 'Female', 'SEMI FINAL 1', '2024-08-06'),
('Field Hockey', 'Tournament', 'Female', 'SEMI FINAL 2', '2024-08-06'),
('Field Hockey', 'Tournament', 'Female', 'BRONZE MATCH', '2024-08-09'),
('Field Hockey', 'Tournament', 'Female', 'FINAL',        '2024-08-09');
/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `individual_event`
--

LOCK TABLES `individual_event` WRITE;
/*!40000 ALTER TABLE `individual_event` DISABLE KEYS */;
INSERT INTO `individual_event` (`sport`, `format`, `gender_category`) VALUES
('Tennis', 'Singles', 'Male'),
('Tennis', 'Singles', 'Female');
/*!40000 ALTER TABLE `individual_event` ENABLE KEYS */;
UNLOCK TABLES;

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
  CONSTRAINT `fk_member_of_team_full` FOREIGN KEY (`team_id`, `country_code`) REFERENCES `team` (`team_id`, `country_code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_of`
--

LOCK TABLES `member_of` WRITE;
/*!40000 ALTER TABLE `member_of` DISABLE KEYS */;
INSERT INTO `member_of` (`athlete_registration_number`, `country_code`, `team_id`) VALUES
(9,  'CZE', 9),
(10, 'CZE', 9),
(11, 'CHN', 10),
(12, 'CHN', 10),
(4,  'CAN', 11),
(13, 'CAN', 11),
(14, 'NED', 12),
(15, 'NED', 12),
(16, 'NED', 1),
(17, 'NED', 1),
(18, 'NED', 1),
(19, 'NED', 1),
(20, 'NED', 1),
(21, 'NED', 1),
(22, 'NED', 1),
(23, 'NED', 1),
(24, 'NED', 1),
(25, 'NED', 1),
(26, 'NED', 1),
(27, 'GER', 2),
(28, 'GER', 2),
(29, 'GER', 2),
(30, 'GER', 2),
(31, 'GER', 2),
(32, 'GER', 2),
(33, 'GER', 2),
(34, 'GER', 2),
(35, 'GER', 2),
(36, 'GER', 2),
(37, 'GER', 2),
(38, 'IND', 3),
(39, 'IND', 3),
(40, 'IND', 3),
(41, 'IND', 3),
(42, 'IND', 3),
(43, 'IND', 3),
(44, 'IND', 3),
(45, 'IND', 3),
(46, 'IND', 3),
(47, 'IND', 3),
(48, 'IND', 3),
(49, 'ESP', 4),
(50, 'ESP', 4),
(51, 'ESP', 4),
(52, 'ESP', 4),
(53, 'ESP', 4),
(54, 'ESP', 4),
(55, 'ESP', 4),
(56, 'ESP', 4),
(57, 'ESP', 4),
(58, 'ESP', 4),
(59, 'ESP', 4),
(60, 'NED', 5),
(61, 'NED', 5),
(62, 'NED', 5),
(63, 'NED', 5),
(64, 'NED', 5),
(65, 'NED', 5),
(66, 'NED', 5),
(67, 'NED', 5),
(68, 'NED', 5),
(69, 'NED', 5),
(70, 'NED', 5),
(71, 'CHN', 6),
(72, 'CHN', 6),
(73, 'CHN', 6),
(74, 'CHN', 6),
(75, 'CHN', 6),
(76, 'CHN', 6),
(77, 'CHN', 6),
(78, 'CHN', 6),
(79, 'CHN', 6),
(80, 'CHN', 6),
(81, 'CHN', 6),
(82, 'ARG', 7),
(83, 'ARG', 7),
(84, 'ARG', 7),
(85, 'ARG', 7),
(86, 'ARG', 7),
(87, 'ARG', 7),
(88, 'ARG', 7),
(89, 'ARG', 7),
(90, 'ARG', 7),
(91, 'ARG', 7),
(92, 'ARG', 7),
(93,  'BEL', 8),
(94,  'BEL', 8),
(95,  'BEL', 8),
(96,  'BEL', 8),
(97,  'BEL', 8),
(98,  'BEL', 8),
(99,  'BEL', 8),
(100, 'BEL', 8),
(101, 'BEL', 8),
(102, 'BEL', 8),
(103, 'BEL', 8);
/*!40000 ALTER TABLE `member_of` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `sport`
--

LOCK TABLES `sport` WRITE;
/*!40000 ALTER TABLE `sport` DISABLE KEYS */;
INSERT INTO `sport` (`name`, `type`) VALUES
('Aquatics', 'Outdoor'),
('Archery', 'Outdoor'),
('Athletics', 'Outdoor'),
('Badminton', 'Indoor'),
('Basketball', 'Indoor'),
('Boxing', 'Indoor'),
('Breaking', 'Indoor'),
('Canoe', 'Outdoor'),
('Cycling', 'Outdoor'),
('Equestrian', 'Outdoor'),
('Fencing', 'Indoor'),
('Field Hockey', 'Outdoor'),
('Golf', 'Outdoor'),
('Gymnastics', 'Indoor'),
('Handball', 'Indoor'),
('Judo', 'Indoor'),
('Lawn Tennis', 'Outdoor'),
('Modern Pentathlon', 'Indoor'),
('Rowing', 'Outdoor'),
('Rugby Sevens', 'Outdoor'),
('Sailing', 'Outdoor'),
('Shooting', 'Outdoor'),
('Skateboarding', 'Outdoor'),
('Sport Climbing', 'Indoor'),
('Surfing', 'Outdoor'),
('Table Tennis', 'Indoor'),
('Taekwondo', 'Indoor'),
('Tennis', 'Outdoor'),
('Triathlon', 'Outdoor'),
('Volleyball', 'Indoor'),
('Weightlifting', 'Indoor'),
('Wrestling', 'Indoor');
/*!40000 ALTER TABLE `sport` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` (`team_id`, `country_code`, `number_of_players`) VALUES
(1,  'NED', 11),
(2,  'GER', 11),
(3,  'IND', 11),
(4,  'ESP', 11),
(5,  'NED', 11),
(6,  'CHN', 11),
(7,  'ARG', 11),
(8,  'BEL', 11),
(9,  'CZE', 2),
(10, 'CHN', 2),
(11, 'CAN', 2),
(12, 'NED', 2);
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_event`
--

LOCK TABLES `team_event` WRITE;
/*!40000 ALTER TABLE `team_event` DISABLE KEYS */;
INSERT INTO `team_event` (`sport`, `format`, `gender_category`, `team_size`) VALUES
('Tennis',       'Mixed Doubles', 'Mixed',  2),
('Field Hockey', 'Tournament',    'Male',   11),
('Field Hockey', 'Tournament',    'Female', 11);
/*!40000 ALTER TABLE `team_event` ENABLE KEYS */;
UNLOCK TABLES;

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
  CONSTRAINT `fk_team_participation_team_full` FOREIGN KEY (`team_id`, `country_code`) REFERENCES `team` (`team_id`, `country_code`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_team_participation_game_full` FOREIGN KEY (`sport`, `format`, `gender_category`, `game_number`) REFERENCES `game` (`sport`, `format`, `gender_category`, `game_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_participation`
--

LOCK TABLES `team_participation` WRITE;
/*!40000 ALTER TABLE `team_participation` DISABLE KEYS */;
INSERT INTO `team_participation` (`country_code`, `team_id`, `sport`, `format`, `gender_category`, `game_number`, `score`, `medal`) VALUES
('CZE', 9,  'Tennis', 'Mixed Doubles', 'Mixed', 'SEMI FINAL 1', 2.00, NULL),
('NED', 12, 'Tennis', 'Mixed Doubles', 'Mixed', 'SEMI FINAL 1', 0.00, NULL),
('CHN', 10, 'Tennis', 'Mixed Doubles', 'Mixed', 'SEMI FINAL 2', 2.00, NULL),
('CAN', 11, 'Tennis', 'Mixed Doubles', 'Mixed', 'SEMI FINAL 2', 1.00, NULL),
('CAN', 11, 'Tennis', 'Mixed Doubles', 'Mixed', 'BRONZE MATCH', 2.00, 'Bronze'),
('NED', 12, 'Tennis', 'Mixed Doubles', 'Mixed', 'BRONZE MATCH', 1.00, NULL),
('CZE', 9,  'Tennis', 'Mixed Doubles', 'Mixed', 'FINAL', 2.00, 'Gold'),
('CHN', 10, 'Tennis', 'Mixed Doubles', 'Mixed', 'FINAL', 1.00, 'Silver'),
('NED', 1, 'Field Hockey', 'Tournament', 'Male', 'SEMI FINAL 1', 2.00, NULL),
('IND', 3, 'Field Hockey', 'Tournament', 'Male', 'SEMI FINAL 1', 2.00, NULL),
('GER', 2, 'Field Hockey', 'Tournament', 'Male', 'SEMI FINAL 2', 3.00, NULL),
('ESP', 4, 'Field Hockey', 'Tournament', 'Male', 'SEMI FINAL 2', 1.00, NULL),
('IND', 3, 'Field Hockey', 'Tournament', 'Male', 'BRONZE MATCH', 2.00, 'Bronze'),
('ESP', 4, 'Field Hockey', 'Tournament', 'Male', 'BRONZE MATCH', 1.00, NULL),
('NED', 1, 'Field Hockey', 'Tournament', 'Male', 'FINAL', 3.00, 'Gold'),
('GER', 2, 'Field Hockey', 'Tournament', 'Male', 'FINAL', 2.00, 'Silver'),
('NED', 5, 'Field Hockey', 'Tournament', 'Female', 'SEMI FINAL 1', 3.00, NULL),
('BEL', 8, 'Field Hockey', 'Tournament', 'Female', 'SEMI FINAL 1', 0.00, NULL),
('CHN', 6, 'Field Hockey', 'Tournament', 'Female', 'SEMI FINAL 2', 2.00, NULL),
('ARG', 7, 'Field Hockey', 'Tournament', 'Female', 'SEMI FINAL 2', 1.00, NULL),
('ARG', 7, 'Field Hockey', 'Tournament', 'Female', 'BRONZE MATCH', 3.00, 'Bronze'),
('BEL', 8, 'Field Hockey', 'Tournament', 'Female', 'BRONZE MATCH', 2.00, NULL),
('NED', 5, 'Field Hockey', 'Tournament', 'Female', 'FINAL', 1.00, 'Gold'),
('CHN', 6, 'Field Hockey', 'Tournament', 'Female', 'FINAL', 1.00, 'Silver');
/*!40000 ALTER TABLE `team_participation` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `venue`
--

LOCK TABLES `venue` WRITE;
/*!40000 ALTER TABLE `venue` DISABLE KEYS */;
INSERT INTO `venue` (`venue_id`, `name`, `capacity`, `city`, `country`) VALUES
(1, 'Stade Roland Garros',    15000, 'Paris', 'France'),
(2, 'Stade Yves-du-Manoir',   15000, 'Paris', 'France');
/*!40000 ALTER TABLE `venue` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-12 16:45:33
