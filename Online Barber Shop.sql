CREATE DATABASE  IF NOT EXISTS `salonsystem` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `salonsystem`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: salonsystem
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `tbladmin`
--

DROP TABLE IF EXISTS `tbladmin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbladmin` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AdminName` char(50) DEFAULT NULL,
  `UserName` char(50) DEFAULT NULL,
  `MobileNumber` bigint DEFAULT NULL,
  `Email` varchar(200) DEFAULT NULL,
  `Password` varchar(200) DEFAULT NULL,
  `AdminRegdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbladmin`
--

LOCK TABLES `tbladmin` WRITE;
/*!40000 ALTER TABLE `tbladmin` DISABLE KEYS */;
INSERT INTO `tbladmin` VALUES (1,'moatasim','admin',300303,'admin@gmail.com','admin','2024-12-04 19:00:00');
/*!40000 ALTER TABLE `tbladmin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblappointment`
--

DROP TABLE IF EXISTS `tblappointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblappointment` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int DEFAULT NULL,
  `AptTimeID` int DEFAULT NULL,
  `AptDate` date DEFAULT NULL,
  `Remarks` varchar(250) DEFAULT NULL,
  `EmployeeID` int DEFAULT NULL,
  `Total` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID_idx` (`AptTimeID`),
  KEY `ID_idx2` (`EmployeeID`),
  KEY `ID_idx1` (`CustomerID`),
  CONSTRAINT `ID` FOREIGN KEY (`AptTimeID`) REFERENCES `tbltimeslots` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblappointment`
--

LOCK TABLES `tblappointment` WRITE;
/*!40000 ALTER TABLE `tblappointment` DISABLE KEYS */;
INSERT INTO `tblappointment` VALUES (23,8,1,'2024-06-26','satisfied',5,''),(24,2,1,'2024-06-27','satisfied',4,''),(25,11,3,'2024-06-28','satisfied',4,''),(26,8,2,'2024-06-26','',5,''),(27,8,1,'2024-06-27','some issues',6,''),(28,8,2,'2024-06-27','',4,''),(29,8,1,'2024-07-01','',6,''),(30,8,1,'2024-07-06','satisfied',6,''),(31,8,1,'2024-07-06','',4,''),(32,8,1,'2024-07-06','',5,''),(33,8,2,'2024-07-08','',6,''),(34,8,1,'2024-07-16','',6,''),(35,8,1,'2024-07-09','',8,''),(36,8,2,'2024-07-09','',6,''),(37,8,1,'2024-07-09','',5,''),(38,8,3,'2024-09-19','',6,''),(39,8,1,'2024-11-16','',5,''),(40,8,1,'2024-11-17','',5,'0'),(41,8,2,'2024-11-17','',5,'0'),(42,8,3,'2024-11-17','',5,'0'),(43,8,1,'2024-11-18','',5,'0'),(44,8,4,'2024-11-17','',5,'0'),(45,8,2,'2024-11-18','',5,'0'),(46,8,4,'2024-11-18','',5,'0'),(47,8,1,'2024-11-19','',5,'0'),(48,8,2,'2024-11-19','',5,'0'),(49,8,1,'2024-11-18','',6,'0'),(50,8,3,'2024-11-18','',5,'0'),(51,8,1,'2024-11-28','',5,'225'),(52,8,2,'2024-11-18','',6,'225'),(53,8,1,'2024-11-22','',5,'225'),(54,8,3,'2024-11-19','',5,'225'),(55,8,1,'2024-11-26','',5,'250'),(56,8,1,'2024-11-18','',8,'250'),(57,8,1,'2024-11-20','',5,'250'),(58,8,3,'2024-11-18','',6,'225'),(59,8,2,'2024-11-22','',5,'250'),(60,8,1,'2024-12-02','',6,'250'),(61,8,3,'2024-11-29','',5,'250'),(62,8,4,'2024-11-22','',5,'250'),(63,8,2,'2024-11-25','',5,'250'),(64,8,3,'2024-11-20','',5,'800'),(65,8,4,'2024-11-19','',5,'800'),(66,8,1,'2024-11-27','',5,'800'),(67,8,2,'2024-11-24','',5,'800'),(68,8,1,'2024-11-26','',6,'720'),(69,8,2,'2024-11-20','',5,'720'),(70,8,4,'2024-11-18','',6,'225'),(71,8,4,'2024-11-18','',6,'225'),(72,8,1,'2024-11-29','',5,'250'),(73,8,1,'2024-11-30','',5,'250'),(74,8,1,'2024-11-27','',7,'250'),(75,8,2,'2024-11-24','',8,'250'),(76,8,1,'2024-11-27','',6,'250');
/*!40000 ALTER TABLE `tblappointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblbilling`
--

DROP TABLE IF EXISTS `tblbilling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblbilling` (
  `ServiceID` int NOT NULL,
  `InvoiceID` int NOT NULL,
  KEY `ServiceID_idx` (`ServiceID`),
  KEY `fk_InvoieID_billing_idx` (`InvoiceID`),
  CONSTRAINT `fk_InvoieID_billing` FOREIGN KEY (`InvoiceID`) REFERENCES `tblinvoice` (`ID`),
  CONSTRAINT `fk_ServiceID` FOREIGN KEY (`ServiceID`) REFERENCES `tblservices` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblbilling`
--

LOCK TABLES `tblbilling` WRITE;
/*!40000 ALTER TABLE `tblbilling` DISABLE KEYS */;
INSERT INTO `tblbilling` VALUES (10,16),(23,17),(24,17),(11,18),(12,18),(10,19),(10,20),(10,21),(11,21),(10,22),(11,22),(10,23),(11,23),(7,24),(7,25),(8,25),(7,26),(8,26),(7,27),(8,27),(23,28),(24,28),(7,29),(8,29),(7,30),(11,30),(8,31),(9,31),(8,32),(8,33),(8,34),(8,35),(8,36),(8,37),(8,38),(8,39),(8,40),(8,41),(8,42),(8,43),(8,44),(8,45),(8,46),(8,47),(8,48),(8,49),(8,50),(8,51),(8,52),(8,53),(8,54),(8,55),(8,56),(8,57),(9,57),(8,58),(9,58),(8,59),(9,59),(8,60),(9,60),(8,61),(9,61),(8,62),(9,62),(8,63),(8,64),(8,65),(8,66),(8,67),(8,68),(8,69);
/*!40000 ALTER TABLE `tblbilling` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblcustomers`
--

DROP TABLE IF EXISTS `tblcustomers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblcustomers` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(120) NOT NULL,
  `Email` varchar(200) NOT NULL,
  `MobileNumber` bigint NOT NULL,
  `username` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `CreditPoints` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblcustomers`
--

LOCK TABLES `tblcustomers` WRITE;
/*!40000 ALTER TABLE `tblcustomers` DISABLE KEYS */;
INSERT INTO `tblcustomers` VALUES (2,'Rahul Singh','singh@gmail.com',5565565656,'rahul12','rahul89','5'),(5,'Test user','testuser@gmail.com',1234567890,'testuser12','456r3','0'),(6,'Manish','manish@gmail.com',9879879798,'manish12','343','0'),(7,'Anuj kumar','ak@gmail.com',1234567899,'anuj89','farzam','0'),(8,'farzam','farzam@gmail.com',90909816,'farzam12','newpass','216'),(9,'moatasim','moatasi@gmail.com',90909816,'moatasim12','newpass','0'),(10,'safeer','safeer@gmaail.com',12342311,'safeer12','newpass','0'),(11,'fartam','fartaM@gmail.com',90909816,'fateam90','newpass','0'),(12,'hassqn','hassan@gmail.com',77777161,'hassan12','newpass','0'),(13,'newcustomer','newcustomer@gmail.com',8462801781,'newcust','newpass','0'),(14,'newcustomer2','newcustomer2@gmail.com',90909816,'newcust2','newpass','0'),(15,'newcust3','newcust3@gmail.com',12342311,'newcust4','newpass','0'),(16,'newcust34','newcust4@gmail.com',456452621,'newcust5','newpass','0'),(17,'newcust7','newcust@gmail.com',8462801781,'newcust56','newpass','0'),(18,'newcust74','moatasimqureshi@yahoo.com',90909816,'farzam122','newpass','0'),(19,'fahad','fahad2gmail.com',3303949540,'fahad12','newpass','51');
/*!40000 ALTER TABLE `tblcustomers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblemployee`
--

DROP TABLE IF EXISTS `tblemployee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblemployee` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EmpName` varchar(45) NOT NULL,
  `EmpNumber` bigint NOT NULL,
  `EmpEmail` varchar(50) NOT NULL,
  `Salary` int NOT NULL,
  `AppointDate` date DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblemployee`
--

LOCK TABLES `tblemployee` WRITE;
/*!40000 ALTER TABLE `tblemployee` DISABLE KEYS */;
INSERT INTO `tblemployee` VALUES (1,'testuser1',300102322,'testuser1@gmail.com',45000,'2024-06-21','Resgined'),(2,'testuser2',300121202,'testuser2@gmail.com',45000,'2024-06-21','Resigned'),(3,'testuser5',300102,'testuser3@gmail.com',45000,'2024-06-21','Resigned'),(4,'testuser4',300102322,'testuser4@gmail.com',45000,'2024-06-21','Resigned'),(5,'Ihtisham Ali Qureshi',3342109055,'ihtishamali07@gmail.com',15001,'2024-06-21','Present'),(6,'Farzam Nasir',330387614,'farzam@gmail.com',50000,'2024-06-26','Present'),(7,'Ahmed',3332444295,'ahmed@gmail.com',1000,'2024-06-26','Present'),(8,'newem',9389291,'newemp@gmail.com',12000,'2024-07-04','Present');
/*!40000 ALTER TABLE `tblemployee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblinvoice`
--

DROP TABLE IF EXISTS `tblinvoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblinvoice` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AppointmentID` int NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `id` (`ID`),
  KEY `id_idx` (`AppointmentID`),
  CONSTRAINT `ID_invoice` FOREIGN KEY (`AppointmentID`) REFERENCES `tblappointment` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblinvoice`
--

LOCK TABLES `tblinvoice` WRITE;
/*!40000 ALTER TABLE `tblinvoice` DISABLE KEYS */;
INSERT INTO `tblinvoice` VALUES (16,23),(17,24),(18,25),(19,26),(20,27),(21,28),(22,29),(23,30),(24,31),(25,32),(26,33),(27,34),(28,35),(29,36),(30,37),(31,38),(32,39),(33,40),(34,41),(35,42),(36,43),(37,44),(38,45),(39,46),(40,47),(41,48),(42,49),(43,50),(44,51),(45,52),(46,53),(47,54),(48,55),(49,56),(50,57),(51,58),(52,59),(53,60),(54,61),(55,62),(56,63),(57,64),(58,65),(59,66),(60,67),(61,68),(62,69),(63,70),(64,71),(65,72),(66,73),(67,74),(68,75),(69,76);
/*!40000 ALTER TABLE `tblinvoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tblservices`
--

DROP TABLE IF EXISTS `tblservices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tblservices` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ServiceName` varchar(200) DEFAULT NULL,
  `Description` mediumtext,
  `Cost` int DEFAULT NULL,
  `IsActive` varchar(45) NOT NULL,
  `ServiceCredit` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tblservices`
--

LOCK TABLES `tblservices` WRITE;
/*!40000 ALTER TABLE `tblservices` DISABLE KEYS */;
INSERT INTO `tblservices` VALUES (7,'normal','NULL',121,'0','5'),(8,'Hair Cut','A hairstyle, hairdo, or haircut refers to the styling of hair, usually on the human scalp. Sometimes, this could also mean an editing of facial or body hair',250,'1','13'),(9,'Style Haircut','A hairstyle, hairdo, or haircut refers to the styling of hair, usually on the human scalp. Sometimes, this could also mean an editing of facial or body hair',550,'1','4'),(10,'Hair shave','A hairstyle, hairdo, or haircut refers to the styling of hair, usually on the human scalp. Sometimes, this could also mean an editing of facial or body hair',450,'0','4'),(11,'Loreal Hair Color(Full)','hgfhgj',1100,'1','4'),(12,'Body Spa','It is full body spa including hair wash',150,'1','4'),(15,'ABC','gjhgjhgbkhhioljhoioi',2000,'1','6'),(21,'XYZ','hello boy',7000,'1','3'),(22,'asasas','sasasasas',1212,'1','4'),(23,'head','head is very good',40,'1','2'),(24,'heeloo','saassasas',123,'1','10'),(25,'tin','hibhihihih',12212121,'1',''),(26,'shave','shaving',90,'1','10'),(28,'menicure','adada',400,'1','9'),(29,'helloo','yxxyxyx',90,'1','9'),(30,'hauir jjj','asassa',21,'0','9'),(31,'newservice','this is new',400,'1','10'),(32,'nerservice2','yes this is new',500,'0','10');
/*!40000 ALTER TABLE `tblservices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbltimeslots`
--

DROP TABLE IF EXISTS `tbltimeslots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbltimeslots` (
  `ID` int NOT NULL,
  `TimeSlots` time NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbltimeslots`
--

LOCK TABLES `tbltimeslots` WRITE;
/*!40000 ALTER TABLE `tbltimeslots` DISABLE KEYS */;
INSERT INTO `tbltimeslots` VALUES (1,'14:00:00'),(2,'16:00:00'),(3,'18:00:00'),(4,'20:00:00');
/*!40000 ALTER TABLE `tbltimeslots` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-17 11:21:29
