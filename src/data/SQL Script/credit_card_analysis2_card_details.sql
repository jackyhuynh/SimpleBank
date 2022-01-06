-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: credit_card_analysis2
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `card_details`
--

DROP TABLE IF EXISTS `card_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `card_details` (
  `card_id` int NOT NULL AUTO_INCREMENT,
  `user_id_fk` int DEFAULT NULL,
  `credit_card_number` varchar(20) DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `deleted` int DEFAULT '1',
  `name_of_card` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`card_id`),
  KEY `user_id_fk` (`user_id_fk`),
  CONSTRAINT `card_details_ibfk_1` FOREIGN KEY (`user_id_fk`) REFERENCES `user_details` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `card_details`
--

LOCK TABLES `card_details` WRITE;
/*!40000 ALTER TABLE `card_details` DISABLE KEYS */;
INSERT INTO `card_details` VALUES (1,1,'9988776655443322','2021-07-07',1,'Visa Card 1 '),(2,1,'3322114455669988','2022-01-01',1,'Discovery Card'),(3,1,'1234114455669988','2022-01-01',1,'Chase Freedom'),(4,1,'1244114455669988','2022-01-15',1,'Amreican Express Blue Cash'),(5,1,'9900114455669988','2022-10-01',1,'NFCU Debit'),(6,2,'5566449977883322','2023-05-30',1,'Mastercard 1'),(7,3,'9865321245784679','2021-12-30',1,'Visa'),(8,4,'5957515358525456','2022-06-16',1,'Chase'),(9,4,'3573693213438919','2025-01-01',1,'Chase 2');
/*!40000 ALTER TABLE `card_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-25 13:16:14
