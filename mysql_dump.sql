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
  CONSTRAINT `fk_member_of_team_full` FOREIGN KEY (`team_id`, `country_code`) REFERENCES `team` (`team_id`, `country_code`) ON DELETE CASCADE ON UPDATE CASCADE
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
  CONSTRAINT `fk_team_participation_team_full` FOREIGN KEY (`team_id`, `country_code`) REFERENCES `team` (`team_id`, `country_code`) ON DELETE CASCADE ON UPDATE CASCADE,
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
