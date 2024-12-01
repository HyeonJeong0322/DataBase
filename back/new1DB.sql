-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: new1
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `membership_status` varchar(50) DEFAULT 'normal',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'John Doe','010-1234-5678','johndoe@example.com','normal','2024-11-28 13:30:27'),(2,'Jane Smith','010-2345-6789','janesmith@example.com','premium','2024-11-28 13:30:27'),(3,'Sam Brown','010-3456-7890','sambrown@example.com','normal','2024-11-28 13:30:27'),(4,'Loy',NULL,NULL,'normal','2024-11-30 23:55:47');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food_ingredients`
--

DROP TABLE IF EXISTS `food_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `food_id` int NOT NULL COMMENT '음식 ID',
  `ingredient_id` int NOT NULL COMMENT '재료 ID',
  `quantity` decimal(10,2) NOT NULL COMMENT '사용할 재료의 ',
  PRIMARY KEY (`id`),
  KEY `ingredient_id` (`ingredient_id`),
  KEY `idx_food_id_ingredient_id` (`food_id`,`ingredient_id`),
  CONSTRAINT `food_ingredients_ibfk_1` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`),
  CONSTRAINT `food_ingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food_ingredients`
--

LOCK TABLES `food_ingredients` WRITE;
/*!40000 ALTER TABLE `food_ingredients` DISABLE KEYS */;
INSERT INTO `food_ingredients` VALUES (6,1,1,0.20),(7,1,2,0.10),(8,2,3,0.30),(9,2,4,5.00),(10,3,5,0.05);
/*!40000 ALTER TABLE `food_ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foods`
--

DROP TABLE IF EXISTS `foods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '음식 이름',
  `price` decimal(10,2) NOT NULL COMMENT '음식 가격',
  `description` text COMMENT '음식 설명',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foods`
--

LOCK TABLES `foods` WRITE;
/*!40000 ALTER TABLE `foods` DISABLE KEYS */;
INSERT INTO `foods` VALUES (1,'Tomato Salad',10.00,'A fresh salad made with tomatoes, lettuce, and cheese','2024-11-28 13:30:27'),(2,'Chicken Pizza',15.00,'Pizza topped with chicken, cheese, and vegetables','2024-11-28 13:30:27'),(3,'Olive Oil Dressing',5.00,'Olive oil dressing for salads','2024-11-28 13:30:27');
/*!40000 ALTER TABLE `foods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `storage_method` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients`
--

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT INTO `ingredients` VALUES (1,'Tomato','Vegetable','kg','Store in cool, dry place','2024-11-28 13:30:27'),(2,'Cheese','Dairy','kg','Keep refrigerated','2024-11-28 13:30:27'),(3,'Lettuce','Vegetable','kg','Store in cool, dry place','2024-11-28 13:30:27'),(4,'Chicken','Meat','kg','Keep refrigerated','2024-11-28 13:30:27'),(5,'Olive Oil','Oil','Litre','Store in cool, dark place','2024-11-28 13:30:27'),(6,'tomato','vegetable','kg','in ref','2024-11-28 13:42:53');
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_records`
--

DROP TABLE IF EXISTS `purchase_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ingredient_id` int NOT NULL,
  `supplier_id` int NOT NULL,
  `purchase_date` date NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ingredient_id` (`ingredient_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `idx_purchase_date` (`purchase_date`),
  CONSTRAINT `purchase_records_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`),
  CONSTRAINT `purchase_records_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_records`
--

LOCK TABLES `purchase_records` WRITE;
/*!40000 ALTER TABLE `purchase_records` DISABLE KEYS */;
INSERT INTO `purchase_records` VALUES (1,1,1,'2024-11-01',50.00,2.50,'2024-12-01','2024-11-28 13:30:27'),(2,2,2,'2024-11-05',30.00,5.00,'2025-01-01','2024-11-28 13:30:27'),(3,3,1,'2024-11-10',20.00,3.00,'2024-12-15','2024-11-28 13:30:27'),(4,4,3,'2024-11-15',100.00,8.00,'2025-02-01','2024-11-28 13:30:27'),(5,5,2,'2024-11-20',10.00,12.00,'2025-03-01','2024-11-28 13:30:27');
/*!40000 ALTER TABLE `purchase_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `sale_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_sale_date` (`sale_date`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (1,1,'2024-11-28 13:30:27',30.00,'2024-11-28 13:30:27'),(2,2,'2024-11-28 13:30:27',50.00,'2024-11-28 13:30:27'),(3,3,'2024-11-28 13:30:27',20.00,'2024-11-28 13:30:27'),(8,1,'2024-11-30 15:30:29',5.00,'2024-11-30 15:30:29'),(9,1,'2024-11-30 15:39:40',15.00,'2024-11-30 15:39:40'),(10,1,'2024-11-30 15:49:11',10.00,'2024-11-30 15:49:11'),(11,1,'2024-11-30 23:32:57',10.00,'2024-11-30 23:32:57'),(13,4,'2024-11-30 23:55:47',15.00,'2024-11-30 23:55:47'),(14,4,'2024-11-30 15:00:00',30.00,'2024-12-01 03:11:28');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ingredient_id` int NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `received_date` date NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT '정상',
  `used_quantity` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ingredient_id` (`ingredient_id`),
  KEY `idx_supplier_id` (`supplier_id`),
  CONSTRAINT `fk_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock`
--

LOCK TABLES `stock` WRITE;
/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
INSERT INTO `stock` VALUES (1,1,49.60,'2024-11-01','2024-12-01','imminent',0.00,'2024-11-28 13:30:27',1),(2,2,29.80,'2024-11-05','2025-01-01','정상',0.00,'2024-11-28 13:30:27',1),(3,3,19.40,'2024-11-10','2024-12-15','정상',0.00,'2024-11-28 13:30:27',1),(4,4,99.00,'2024-11-15','2025-02-01','정상',0.00,'2024-11-28 13:30:27',1),(5,5,9.95,'2024-11-20','2025-03-01','정상',0.00,'2024-11-28 13:30:27',1),(6,1,0.50,'2024-12-01','2024-12-01','imminent',0.00,'2024-11-30 23:40:55',1),(7,1,5.00,'2024-12-01','2024-12-01','imminent',0.00,'2024-12-01 00:27:50',1),(8,1,10.00,'2024-12-20','2024-12-19','정상',0.00,'2024-12-01 01:50:03',1),(16,2,2.00,'2024-12-01','2024-12-31','정상',0.00,'2024-12-01 04:10:44',2),(17,2,4.00,'2024-12-01','2024-12-31','정상',0.00,'2024-12-01 04:10:53',2),(18,4,4.00,'2024-12-01','2024-12-31','정상',0.00,'2024-12-01 04:11:01',3),(19,4,10.00,'2024-12-01','2026-12-24','정상',0.00,'2024-12-01 04:27:10',3),(20,1,7.00,'2024-12-01','2024-12-19','정상',0.00,'2024-12-01 09:45:29',3),(21,1,3.00,'2024-12-01','2024-12-20','정상',0.00,'2024-12-01 10:18:19',3),(22,1,3.00,'2024-12-01','2024-12-20','정상',0.00,'2024-12-01 10:18:20',3),(23,1,3.00,'2024-12-01','2024-12-20','정상',0.00,'2024-12-01 10:18:21',3),(24,1,3.00,'2024-12-01','2024-12-20','정상',0.00,'2024-12-01 10:18:22',3),(25,1,3.00,'2024-12-01','2024-12-20','정상',0.00,'2024-12-01 10:18:25',3),(26,1,1.00,'2024-12-01','2024-12-28','정상',0.00,'2024-12-01 10:46:19',3),(27,4,1.00,'2024-12-01','2024-12-28','정상',0.00,'2024-12-01 10:46:27',3),(28,4,1.00,'2024-12-01','2024-12-26','정상',0.00,'2024-12-01 10:47:57',3),(29,3,1.00,'2024-12-01','2024-12-26','정상',0.00,'2024-12-01 10:50:49',1),(30,1,10.00,'2024-12-01','2025-12-01','정상',0.00,'2024-12-01 10:52:12',3),(31,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:47',1),(32,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:48',1),(33,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:48',1),(34,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:49',1),(35,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:49',1),(36,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:49',1),(37,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:49',1),(38,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:49',1),(39,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:50',1),(40,3,1.00,'2024-12-01','2024-12-27','정상',0.00,'2024-12-01 10:54:58',1),(41,3,1.00,'2024-12-01','2024-12-24','정상',0.00,'2024-12-01 10:56:43',1),(42,3,10.00,'2024-12-01','2024-12-24','정상',0.00,'2024-12-01 10:57:06',1),(43,2,1.00,'2024-12-01','2024-12-18','정상',0.00,'2024-12-01 11:03:19',2),(44,2,7.00,'2024-12-01','2024-12-19','정상',0.00,'2024-12-01 11:12:22',2),(45,2,7.00,'2024-12-01','2024-12-19','정상',0.00,'2024-12-01 11:13:12',2),(46,2,7.00,'2024-12-01','2024-12-19','정상',0.00,'2024-12-01 11:14:21',2),(47,1,5.00,'2024-12-01','2024-12-26','정상',0.00,'2024-12-01 11:16:34',3),(48,2,1.00,'2024-12-01','2024-12-24','정상',0.00,'2024-12-01 11:19:49',2);
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_expiring_stock` BEFORE UPDATE ON `stock` FOR EACH ROW BEGIN
    IF NEW.expiration_date < CURDATE() + INTERVAL 7 DAY THEN
        SET NEW.status = 'imminent';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `supplier_ingredients`
--

DROP TABLE IF EXISTS `supplier_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int NOT NULL,
  `ingredient_id` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `supplier_ingredients_ibfk_2` (`ingredient_id`),
  CONSTRAINT `supplier_ingredients_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  CONSTRAINT `supplier_ingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_ingredients`
--

LOCK TABLES `supplier_ingredients` WRITE;
/*!40000 ALTER TABLE `supplier_ingredients` DISABLE KEYS */;
INSERT INTO `supplier_ingredients` VALUES (1,1,1,5.00),(2,1,3,3.00),(3,2,2,6.00),(4,3,4,5.00),(5,1,5,2.00),(6,3,1,3.00),(7,2,4,6.00);
/*!40000 ALTER TABLE `supplier_ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `address` text,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Fresh Farms','010-1234-5678','123 Green Valley, City','freshfarms@example.com','2024-11-28 13:30:27'),(2,'Cheese World','010-2345-6789','456 Dairy St, City','cheeseworld@example.com','2024-11-28 13:30:27'),(3,'Meat Supply Co.','010-3456-7890','789 Meat Rd, City','meatsupply@example.com','2024-11-28 13:30:27'),(4,'any','010-1231-1231','korea','any@naver.com','2024-11-28 13:43:22');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_records`
--

DROP TABLE IF EXISTS `usage_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usage_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ingredient_id` int NOT NULL,
  `usage_date` date NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ingredient_id` (`ingredient_id`),
  CONSTRAINT `usage_records_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_records`
--

LOCK TABLES `usage_records` WRITE;
/*!40000 ALTER TABLE `usage_records` DISABLE KEYS */;
INSERT INTO `usage_records` VALUES (1,1,'2024-11-25',5.00,'Salad Preparation','2024-11-28 13:30:27'),(2,2,'2024-11-26',2.00,'Cheese Pizza','2024-11-28 13:30:27'),(3,3,'2024-11-27',3.00,'Salad Preparation','2024-11-28 13:30:27'),(4,4,'2024-11-28',10.00,'Chicken Stir Fry','2024-11-28 13:30:27'),(5,5,'2024-11-29',1.00,'Olive Oil for Dressing','2024-11-28 13:30:27'),(6,1,'2024-12-01',0.20,'음식 주문','2024-11-30 15:49:11'),(7,2,'2024-12-01',0.10,'음식 주문','2024-11-30 15:49:11'),(8,1,'2024-12-01',0.20,'음식 주문','2024-11-30 23:32:57'),(9,2,'2024-12-01',0.10,'음식 주문','2024-11-30 23:32:57'),(10,1,'2024-12-01',0.20,'음식 주문','2024-11-30 23:52:51'),(11,2,'2024-12-01',0.10,'음식 주문','2024-11-30 23:52:51'),(12,3,'2024-12-01',0.30,'음식 주문','2024-11-30 23:55:48'),(13,4,'2024-12-01',0.50,'음식 주문','2024-11-30 23:55:48'),(14,3,'2024-12-01',0.60,'음식 주문','2024-12-01 03:11:28'),(15,4,'2024-12-01',1.00,'음식 주문','2024-12-01 03:11:28');
/*!40000 ALTER TABLE `usage_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'new1'
--

--
-- Dumping routines for database 'new1'
--
/*!50003 DROP FUNCTION IF EXISTS `deduct_stock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `deduct_stock`(ingredient_id INT, used_quantity DECIMAL(10, 2)) RETURNS tinyint(1)
    MODIFIES SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE current_stock DECIMAL(10, 2);

    -- 현재 재고  조회
    SELECT quantity - used_quantity INTO current_stock
    FROM stock
    WHERE ingredient_id = ingredient_id;  -- 여기서 ingredient_id와 컬럼명이 충돌하는 문제 해결

    -- 재고 부족 시 FALSE 
    IF current_stock < 0 THEN
        RETURN FALSE;
    END IF;

    -- 재고 업데이트
    UPDATE stock
    SET quantity = current_stock
    WHERE ingredient_id = ingredient_id;

    -- 재고 차감 성공 시 TRUE 
    RETURN TRUE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddFood` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddFood`(IN food_name VARCHAR(255), IN price DECIMAL, IN description TEXT)
BEGIN
    INSERT INTO foods (name, price, description, created_at)
    VALUES (food_name, price, description, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddRecipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRecipe`(IN food_name VARCHAR(255), IN ingredient_id INT, IN quantity DECIMAL)
BEGIN
    INSERT INTO food_ingredients (food_id, ingredient_id, quantity)
    SELECT f.id, ingredient_id, quantity FROM foods f WHERE f.name = food_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_stock_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_stock_procedure`(
    IN ingredient_id INT,
    IN quantity DECIMAL(10, 2),
    IN received_date DATE,
    IN expiration_date DATE
)
BEGIN
    DECLARE supplier_id INT;

    -- 존재하지 않는 식자재 ID인지 확인
    IF NOT EXISTS (SELECT 1 FROM ingredients WHERE id = ingredient_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '존재하지 않는 식자재 ID입니다.';
    END IF;

    -- 가장 저렴한 공급자 찾기
    SELECT si.supplier_id
    INTO supplier_id
    FROM supplier_ingredients si
    WHERE si.ingredient_id = ingredient_id
    ORDER BY si.unit_price ASC
    LIMIT 1;

    -- 공급자가 없으면 종료
    IF supplier_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '이 식자재를 공급하는 공급자가 없습니다.';
    END IF;

    -- 재고 추가
    INSERT INTO stock (ingredient_id, quantity, received_date, expiration_date, supplier_id, created_at)
    VALUES (ingredient_id, quantity, received_date, expiration_date, supplier_id, NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFoodRecipes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFoodRecipes`(IN food_name VARCHAR(255))
BEGIN
    SELECT i.name, fi.quantity, i.unit
    FROM food_ingredients fi
    JOIN ingredients i ON fi.ingredient_id = i.id
    JOIN foods f ON fi.food_id = f.id
    WHERE f.name = food_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetStockStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStockStatus`(IN food_name VARCHAR(255))
BEGIN
    SELECT s.ingredient_id, i.name, s.quantity, s.expiration_date
    FROM stock s
    JOIN ingredients i ON s.ingredient_id = i.id
    WHERE i.name IN (
        SELECT i.name
        FROM food_ingredients fi
        JOIN ingredients i ON fi.ingredient_id = i.id
        JOIN foods f ON fi.food_id = f.id
        WHERE f.name = food_name
    )
    ORDER BY s.ingredient_id ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_stock_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_stock_list`()
BEGIN
    SELECT s.id, s.ingredient_id, i.name, s.quantity, s.received_date, s.expiration_date, su.name AS supplier_name
    FROM stock s
    JOIN ingredients i ON s.ingredient_id = i.id
    LEFT JOIN suppliers su ON s.supplier_id = su.id
    ORDER BY s.id ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_sale` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_sale`(IN p_customer_id INT, IN p_food_id INT, IN p_quantity INT)
BEGIN
    DECLARE total_amount DECIMAL(10, 2);
    DECLARE ingredient_id INT;
    DECLARE ingredient_quantity DECIMAL(10, 2);
    DECLARE current_stock DECIMAL(10, 2);

    -- 음식 가격을 조회하여 총 금액 계산
    SELECT price INTO total_amount
    FROM foods
    WHERE id = p_food_id;  -- p_food_id로 파라미터 구분

    -- 총 매출 계산
    SET total_amount = total_amount * p_quantity;

    -- 판매 기록 추가
    INSERT INTO sales (customer_id, sale_date, total_amount)
    VALUES (p_customer_id, CURRENT_TIMESTAMP, total_amount);

    -- 음식에 사용 재료의 재고를 차감 (커서 대신 JOIN 사용)
    -- 재고 부족을 확인하고 차감하는 로직
    UPDATE stock s
    JOIN food_ingredients fi ON s.ingredient_id = fi.ingredient_id
    SET s.quantity = s.quantity - (fi.quantity * p_quantity)
    WHERE fi.food_id = p_food_id
    AND s.quantity >= fi.quantity * p_quantity;  -- 재고 부족 시 업데이트 않도록 조건 추가

    -- 재고 부족 시 예외 처리
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'out of stock';
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateRecipe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRecipe`(IN food_name VARCHAR(255), IN ingredient_id INT, IN quantity DECIMAL)
BEGIN
    UPDATE food_ingredients
    SET quantity = quantity
    WHERE food_id = (SELECT id FROM foods WHERE name = food_name)
    AND ingredient_id = ingredient_id;
END ;;
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

-- Dump completed on 2024-12-01 20:29:06
