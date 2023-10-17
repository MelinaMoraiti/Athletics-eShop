-- MariaDB dump 10.19  Distrib 10.4.24-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: sports_eshop
-- ------------------------------------------------------
-- Server version	10.4.24-MariaDB

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
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `CATEGORY_ID` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CATEGORY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'SHOES'),(2,'APPAREL'),(3,'equipment');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `customer_ID` int(11) NOT NULL AUTO_INCREMENT,
  `customer_first_name` varchar(50) DEFAULT NULL,
  `customer_last_name` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`customer_ID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (10,'melina','melina','melina@email.com','$2b$10$t8HmCqjZTVpZeZO2P6ngSO0IQO4QRujdfgMEh5pjdPQa6hPN1gN2G'),(27,'Employee','Employee','Employee@Employee.com','$2b$10$6oqGOVB7qqocjyHP2s5UUuRwEubUVE2GtoL6uUhW6oQU8yl62cVjm'),(29,'admin','admin','admin@admin.com','$2b$10$FqrP/ifhUrIPGi7TSNq6BeY1L3lT/D0bDEFUD0Ua8Z5OyxpYsvkMS'),(30,'user','user','user@email.com','$2b$10$V/J5og5qdFcIubD.URveVe5xyaN7F.UZj2xfN3YX5nris1NGkEdUG');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (4,7,1),(4,9,1),(7,10,1),(7,14,1),(7,15,1);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `CUSTOMER_ID` int(11) DEFAULT NULL,
  `ORDER_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `TOTAL_COST` decimal(10,2) DEFAULT NULL,
  `ADDRESS` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `CUSTOMER_ID` (`CUSTOMER_ID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `customers` (`customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (3,10,'2023-08-19 13:31:45',NULL,NULL),(4,27,'2023-08-19 13:56:58',NULL,NULL),(7,30,'2023-08-24 08:20:33',252.49,'MyAddress');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `product_ID` int(11) NOT NULL AUTO_INCREMENT,
  `category_ID` int(11) DEFAULT NULL,
  `product_name` varchar(60) DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `avg_rating` float(2,1) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`product_ID`),
  KEY `category_ID` (`category_ID`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_ID`) REFERENCES `categories` (`CATEGORY_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (2,1,'Athletic Shoe 1',99.90,'',NULL,''),(3,1,'Athletic Shoe 2',130.00,'',5.0,''),(4,1,'Athletic Shoe 3',90.00,'Color: Mist/Blazing Coral',NULL,''),(5,1,'Athletic Shoe 4',143.50,'Designed to help create a softer and smoother running experience. Color: Slate Grey / Champagne',4.0,''),(6,1,'Athletic Shoe 5',157.21,'Technologies: Gel, Trusstic, FF Blast+, Ahar, Ortholite, Color: Soothing Sea / Sea Glass',NULL,''),(7,3,'Jump Rope',13.00,' Lightweight and adjustable jump rope for cardio workouts and improving agility.',5.0,''),(8,3,'MotivationPro Yoga Mat',12.49,'Premium non-slip yoga mat with extra cushioning for comfortable practice.',4.0,''),(9,3,'PlasticStrong Plastic Kettlebell 12kg',28.60,'Cast plastic kettlebell for strength training and dynamic exercises.',4.5,''),(10,3,'Dumbbell Set 6kg',54.00,'Set of adjustable dumbbells with weight plates, suitable for various strength training exercises.',4.8,''),(11,1,'Athletic Shoe 6',143.50,'A stable and energized running experience designed for overpronators.',NULL,''),(13,1,'Athletic Shoe 7',133.00,'Regular Fit, Lace Up, Linear Energy Push, Boost Midsole, Stretchweb Outsole',NULL,''),(14,2,'Zipped Hooded Tech-Fleece Sweatshirt',67.49,'Crafted from premium tech-fleece fabric, it offers cozy comfort for any occasion. The full-zip design, attached hood, and practical pockets make it a versatile addition to your wardrobe.',NULL,''),(15,1,'Athletic Shoe 8',131.00,'Color: Eggnog / Passion Fruit',NULL,''),(16,3,'Folding Treadmill',496.00,'High-quality foldable treadmill with adjustable incline and built-in programs.',NULL,''),(17,3,'Anti-Burst Exercise Ball',13.62,'Anti-burst exercise ball for core strengthening, balance, and flexibility workouts. Specifications: PVC, 55cm, 1kg, Pink Color.',NULL,'');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `rating_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `review` text DEFAULT NULL,
  `rating_date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`rating_id`),
  KEY `product_id` (`product_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_ID`),
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES (1,5,10,4,NULL,'2023-08-18 13:00:35'),(3,5,27,5,NULL,'2023-08-18 13:01:08'),(4,3,27,5,NULL,'2023-08-19 10:42:47'),(5,10,27,5,NULL,'2023-08-19 16:34:34'),(6,10,10,4,NULL,'2023-08-19 16:34:46'),(8,10,27,5,NULL,'2023-08-19 16:36:04'),(9,9,27,5,NULL,'2023-08-19 16:39:12'),(10,9,10,5,NULL,'2023-08-19 16:39:20'),(12,9,29,4,NULL,'2023-08-19 16:40:29'),(13,7,29,5,NULL,'2023-08-19 16:41:33');
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RATINGS_insert
     AFTER INSERT ON RATINGS
     FOR EACH ROW
     BEGIN
     UPDATE PRODUCTS 
      SET avg_rating = 
     (SELECT ifnull(avg(rating),0)
     FROM ratings
     WHERE ratings.product_ID= products.product_ID)
     where product_ID=NEW.product_ID;     
     END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RATINGS_update
     AFTER UPDATE ON RATINGS
     FOR EACH ROW
     BEGIN
     UPDATE PRODUCTS
     SET AVG_RATING = 
	(SELECT ifnull(avg(rating),0)
     FROM ratings
     WHERE ratings.product_ID= products.product_ID)
     WHERE PRODUCT_ID IN(OLD.PRODUCT_ID,NEW.PRODUCT_ID);
     END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER RATINGS_delete
    AFTER DELETE ON RATINGS
    FOR EACH ROW
    BEGIN
    UPDATE PRODUCTS
    SET AVG_RATING =
    (SELECT ifnull(avg(rating),0)
     FROM ratings
     WHERE ratings.product_ID= products.product_ID)
    WHERE PRODUCT_ID= OLD.PRODUCT_ID;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-17 18:16:38
