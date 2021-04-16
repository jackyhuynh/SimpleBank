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
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `location_name` varchar(100) DEFAULT NULL,
  `location_latitude` varchar(20) DEFAULT NULL,
  `location_longitude` varchar(20) DEFAULT NULL,
  `location_address` varchar(100) DEFAULT NULL,
  `deleted` int DEFAULT '1',
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Walmart','41.271593744625605','-85.85662050266357','2501 Walton Blvd, Warsaw, IN 46582',1),(2,'Walmart','41.128204039881574','-85.13785651616233','5311 Coldwater Rd, Fort Wayne, IN 46825',1),(3,'Kroger','41.13341999837766','-85.06425317270948','6002 St Joe Center Rd, Fort Wayne, IN 46835',1),(4,'Kroger','41.23966020298573','-85.82673778917074','2211 E Center St, Warsaw, IN 46580',1),(5,'Lassus Handy Dandy','41.24635724998368','-85.82424384499369','777 Parker St, Warsaw, IN 46580',1),(6,'BP','41.059638355675155','-85.21906204684748','6044 W Jefferson Blvd, Fort Wayne, IN 46804',1),(7,'NIPSCO','41.24449936723772','-85.85569869388958','004-043, #409, Warsaw, IN 46580',1),(8,'NIPSCO','41.110455850908906','-85.19726587568114','3725 Hillegas Rd, Fort Wayne, IN 46808',1),(9,'Indiana American Water Company-Warsaw Operations','41.26727971390907','-85.86011635848693','2420 Hidden Lake Dr Rd, Warsaw, IN 46580',1),(10,'Fort Wayne Water Department','41.079101877901756','-85.13710490267006','200 E Berry St #130, Fort Wayne, IN 46802',1),(11,'McDonalds','41.24079039963746','-85.85321564684139','315 N Detroit St, Warsaw, IN 46580',1),(12,'McDonalds','41.118337031499806','-85.18301550266874','3010 W Coliseum Blvd, Fort Wayne, IN 46808',1),(13,'CVS','41.23892700843284','-85.85234720081716','100 N Detroit St, Warsaw, IN 46580',1),(14,'CVS','41.17784048486054','-85.13196197383137','770 E Dupont Rd, Fort Wayne, IN 46825',1),(15,'Phillips Plumbing Service','41.212069626848546','-85.8883977603363','1492 S Wausau St, Warsaw, IN 46580',1),(16,'Plumbing Services Inc','41.034206950331125','-85.20790249057039','2234 N Clinton St, Fort Wayne, IN 46805',1),(17,'Hampton Inn','41.23758371290977','-85.82047550266472','115 Robmar Dr, Warsaw, IN 46580',1),(18,'Quality Inn','41.1399723015457','-85.16071700456253','1734 West Washington Center Ro, Fort Wayne, IN 46818',1),(19,'Kohls','41.27858166191291','-85.85523484684009','590 W 300 N, Warsaw, IN 46582',1),(20,'Old Navy','41.12273900427999','-85.13132520351523','721 Northcrest Shopping Center, Fort Wayne, IN 46805',1),(21,'Macys','41.11537065374534','-85.13953086033956','4201 Coldwater Rd Ste 1, Fort Wayne, IN 46805',1),(22,'Enterprise car rental','41.25646273409801','-85.8574957408239','215 N Lake St, Warsaw, IN 46580',1),(23,'Fort wayne art gallery','41.076920852745616','-85.13677444332434','210 E Jefferson Blvd, Fort Wayne, IN 46802',1),(24,'Treadway Pool Supplies','41.27115832124475','-85.86400482576265','1421 N Detroit St, Warsaw, IN 46580',1),(25,'Harrison Elementary School','41.28424990732051','-85.82555744415559','1300 Husky Trail, Warsaw, IN 46582',1),(26,'Carnegie Boulevard KinderCare','41.079567305945424','-85.24598025003839','7856 Carnegie Blvd, Fort Wayne, IN 46804',1),(27,'Car Wash','41.13277000017322','-85.13492713150363','Fort Wayne, IN 46825',1),(28,'Sears Appliance Repair','41.116338585025055','-85.14030372965665','4201 Coldwater Rd, Fort Wayne, IN 46805',1),(29,'Habeggers Furniture','41.11399416560009','-85.13423124710768','4004 Coldwater Rd, Fort Wayne, IN 46805',1),(30,'AMC Movies','41.07687289654161','-85.19913366365347','4250 W Jefferson Blvd, Fort Wayne, IN 46804',1),(31,'North Pointe Cinema','41.25245543290216','-85.8242935449935','1060 Mariners Dr, Warsaw, IN 46580',1),(32,'Op Nails','41.23764328209243','-85.81858489319247','201 Eastlake Dr, Warsaw, IN 46580',1),(33,'Skyline Garage','41.08490179188166','-85.14234399277866','220 W Wayne St, Fort Wayne, IN 46802',1);
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-16 12:40:10
