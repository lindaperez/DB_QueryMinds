CREATE DATABASE  IF NOT EXISTS `neu_db_project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `neu_db_project`;
-- MySQL dump 10.13  Distrib 8.0.41, for macos15 (x86_64)
--
-- Host: 34.169.163.169    Database: neu_db_project
-- ------------------------------------------------------
-- Server version	8.0.37-google

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `ANSWER`
--

DROP TABLE IF EXISTS `ANSWER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ANSWER` (
  `id_answer` int NOT NULL AUTO_INCREMENT,
  `id_student` int NOT NULL,
  `id_exercise` int NOT NULL,
  `v_answer` text,
  `n_score` decimal(5,2) DEFAULT NULL,
  `b_iscorrect` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_answer`,`id_student`,`id_exercise`),
  KEY `id_student` (`id_student`),
  KEY `id_exercise` (`id_exercise`),
  CONSTRAINT `ANSWER_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`) ON DELETE RESTRICT,
  CONSTRAINT `ANSWER_ibfk_2` FOREIGN KEY (`id_exercise`) REFERENCES `EXERCISE` (`id_exercise`) ON DELETE CASCADE,
  CONSTRAINT `ANSWER_chk_1` CHECK (((`n_score` >= 0.00) and (`n_score` <= 100.00))),
  CONSTRAINT `ANSWER_chk_2` CHECK ((`b_iscorrect` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ANSWER`
--

LOCK TABLES `ANSWER` WRITE;
/*!40000 ALTER TABLE `ANSWER` DISABLE KEYS */;
INSERT INTO `ANSWER` VALUES (1,48,12,'',100.00,1),(2,48,13,'print',100.00,1),(3,48,15,'True',0.00,0),(4,47,12,'',100.00,1),(5,47,13,'print',100.00,1),(6,47,15,'False',100.00,1),(7,47,16,'I chose PostgreSQL because it offers powerful features like advanced indexing, full-text search, and strong support for complex queries and data integrity. It’s open-source, highly reliable, and works well across platforms, making it a great choice for both development and production environments. Its standards compliance and flexibility make it ideal for learning and real-world applications.',0.00,0),(8,47,4,'SELECT * FROM orders WHERE YEAR(order_date) = 2024   AND total_amount < 100;',0.00,0),(9,47,5,'-- Table: instructors CREATE TABLE instructors (     id INT PRIMARY KEY,     name VARCHAR(255) NOT NULL );  -- Table: students CREATE TABLE students (     id INT PRIMARY KEY,     name VARCHAR(255) NOT NULL,     email VARCHAR(255) UNIQUE NOT NULL );  -- Table: courses CREATE TABLE courses (     id INT PRIMARY KEY,     title VARCHAR(255) NOT NULL,     instructor_id INT,     FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE SET NULL );  -- Table: enrollments CREATE TABLE enrollments (     student_id INT,     course_id INT,     enrollment_date DATE NOT NULL,     PRIMARY KEY (student_id, course_id),     FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,     FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE );',0.00,0),(10,47,17,'SELECT * FROM students WHERE major = \'Computer Sci\';',100.00,1),(11,49,12,'',0.00,0),(12,49,13,'print',100.00,1),(13,49,15,'true',0.00,0);
/*!40000 ALTER TABLE `ANSWER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ANSWER_MULTIPLE_OPTION`
--

DROP TABLE IF EXISTS `ANSWER_MULTIPLE_OPTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ANSWER_MULTIPLE_OPTION` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_option` int DEFAULT NULL,
  `id_answer` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_option` (`id_option`),
  KEY `id_answer` (`id_answer`),
  CONSTRAINT `ANSWER_MULTIPLE_OPTION_ibfk_1` FOREIGN KEY (`id_option`) REFERENCES `MULTIPLE_OPTION` (`id_option`) ON DELETE RESTRICT,
  CONSTRAINT `ANSWER_MULTIPLE_OPTION_ibfk_2` FOREIGN KEY (`id_answer`) REFERENCES `ANSWER` (`id_answer`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ANSWER_MULTIPLE_OPTION`
--

LOCK TABLES `ANSWER_MULTIPLE_OPTION` WRITE;
/*!40000 ALTER TABLE `ANSWER_MULTIPLE_OPTION` DISABLE KEYS */;
INSERT INTO `ANSWER_MULTIPLE_OPTION` VALUES (1,19,1),(2,19,4),(3,21,11);
/*!40000 ALTER TABLE `ANSWER_MULTIPLE_OPTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ATTEMPT`
--

DROP TABLE IF EXISTS `ATTEMPT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ATTEMPT` (
  `id_answer` int NOT NULL,
  `id_option` int NOT NULL,
  `d_began` datetime NOT NULL,
  `d_finished` datetime NOT NULL,
  `n_attempt_number` int DEFAULT NULL,
  `id` int NOT NULL,
  PRIMARY KEY (`id_answer`,`id_option`,`id`),
  KEY `id_option` (`id_option`),
  KEY `idx_attempt_answer` (`id_answer`),
  CONSTRAINT `ATTEMPT_ibfk_1` FOREIGN KEY (`id_answer`) REFERENCES `ANSWER` (`id_answer`) ON DELETE RESTRICT,
  CONSTRAINT `ATTEMPT_ibfk_2` FOREIGN KEY (`id_option`) REFERENCES `MULTIPLE_OPTION` (`id_option`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ATTEMPT`
--

LOCK TABLES `ATTEMPT` WRITE;
/*!40000 ALTER TABLE `ATTEMPT` DISABLE KEYS */;
/*!40000 ALTER TABLE `ATTEMPT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CHAPTER_EVALUATION`
--

DROP TABLE IF EXISTS `CHAPTER_EVALUATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CHAPTER_EVALUATION` (
  `id_learningchapter` int NOT NULL,
  `id_evaluation` int NOT NULL,
  PRIMARY KEY (`id_learningchapter`,`id_evaluation`),
  KEY `id_evaluation` (`id_evaluation`),
  CONSTRAINT `CHAPTER_EVALUATION_ibfk_1` FOREIGN KEY (`id_learningchapter`) REFERENCES `LEARNING_CHAPTER` (`id_learningchapter`) ON DELETE CASCADE,
  CONSTRAINT `CHAPTER_EVALUATION_ibfk_2` FOREIGN KEY (`id_evaluation`) REFERENCES `EVALUATION` (`id_evaluation`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CHAPTER_EVALUATION`
--

LOCK TABLES `CHAPTER_EVALUATION` WRITE;
/*!40000 ALTER TABLE `CHAPTER_EVALUATION` DISABLE KEYS */;
INSERT INTO `CHAPTER_EVALUATION` VALUES (1,1),(1,2);
/*!40000 ALTER TABLE `CHAPTER_EVALUATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CHAPTER_EXERCISE`
--

DROP TABLE IF EXISTS `CHAPTER_EXERCISE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CHAPTER_EXERCISE` (
  `id_learningchapter` int NOT NULL,
  `id_exercise` int NOT NULL,
  PRIMARY KEY (`id_learningchapter`,`id_exercise`),
  KEY `id_exercise` (`id_exercise`),
  CONSTRAINT `CHAPTER_EXERCISE_ibfk_1` FOREIGN KEY (`id_learningchapter`) REFERENCES `LEARNING_CHAPTER` (`id_learningchapter`) ON DELETE CASCADE,
  CONSTRAINT `CHAPTER_EXERCISE_ibfk_2` FOREIGN KEY (`id_exercise`) REFERENCES `EXERCISE` (`id_exercise`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CHAPTER_EXERCISE`
--

LOCK TABLES `CHAPTER_EXERCISE` WRITE;
/*!40000 ALTER TABLE `CHAPTER_EXERCISE` DISABLE KEYS */;
INSERT INTO `CHAPTER_EXERCISE` VALUES (3,4),(4,5),(1,12),(1,13),(1,15),(2,16),(5,17);
/*!40000 ALTER TABLE `CHAPTER_EXERCISE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CHAPTER_STUDENT`
--

DROP TABLE IF EXISTS `CHAPTER_STUDENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CHAPTER_STUDENT` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_student` int DEFAULT NULL,
  `id_learningchapter` int DEFAULT NULL,
  `n_score` decimal(5,2) DEFAULT NULL,
  `n_ranking` int NOT NULL,
  `d_begin` date NOT NULL,
  `d_finish` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_student` (`id_student`),
  KEY `id_learningchapter` (`id_learningchapter`),
  CONSTRAINT `CHAPTER_STUDENT_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`) ON DELETE CASCADE,
  CONSTRAINT `CHAPTER_STUDENT_ibfk_2` FOREIGN KEY (`id_learningchapter`) REFERENCES `LEARNING_CHAPTER` (`id_learningchapter`) ON DELETE CASCADE,
  CONSTRAINT `CHAPTER_STUDENT_chk_1` CHECK (((`n_score` >= 0.00) and (`n_score` <= 100.00)))
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CHAPTER_STUDENT`
--

LOCK TABLES `CHAPTER_STUDENT` WRITE;
/*!40000 ALTER TABLE `CHAPTER_STUDENT` DISABLE KEYS */;
INSERT INTO `CHAPTER_STUDENT` VALUES (45,32,1,0.00,0,'2025-04-05',NULL),(46,32,2,0.00,0,'2025-04-05',NULL),(47,32,3,0.00,0,'2025-04-05',NULL),(48,32,4,0.00,0,'2025-04-05',NULL),(49,32,5,0.00,0,'2025-04-05',NULL),(50,33,1,0.00,0,'2025-04-05',NULL),(51,33,2,0.00,0,'2025-04-05',NULL),(52,33,3,0.00,0,'2025-04-05',NULL),(53,33,4,0.00,0,'2025-04-05',NULL),(54,33,5,0.00,0,'2025-04-05',NULL),(55,38,1,0.00,0,'2025-04-05',NULL),(56,38,2,0.00,0,'2025-04-05',NULL),(57,38,3,0.00,0,'2025-04-05',NULL),(58,38,4,0.00,0,'2025-04-05',NULL),(59,38,5,0.00,0,'2025-04-05',NULL),(60,46,1,0.00,0,'2025-04-05',NULL),(61,46,2,0.00,0,'2025-04-05',NULL),(62,46,3,0.00,0,'2025-04-05',NULL),(63,46,4,0.00,0,'2025-04-05',NULL),(64,46,5,0.00,0,'2025-04-05',NULL),(65,47,1,100.00,0,'2025-04-05','2025-04-05'),(66,47,2,80.00,0,'2025-04-05','2025-04-05'),(67,47,3,90.00,0,'2025-04-05','2025-04-05'),(68,47,4,100.00,0,'2025-04-05','2025-04-05'),(69,47,5,100.00,0,'2025-04-05','2025-04-05'),(70,48,1,100.00,0,'2025-04-05','2025-04-05'),(71,48,2,0.00,0,'2025-04-05',NULL),(72,48,3,0.00,0,'2025-04-05',NULL),(73,48,4,0.00,0,'2025-04-05',NULL),(74,48,5,0.00,0,'2025-04-05',NULL),(75,49,1,0.00,0,'2025-04-05','2025-04-05'),(76,49,2,0.00,0,'2025-04-05',NULL),(77,49,3,0.00,0,'2025-04-05',NULL),(78,49,4,0.00,0,'2025-04-05',NULL),(79,49,5,0.00,0,'2025-04-05',NULL);
/*!40000 ALTER TABLE `CHAPTER_STUDENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COURSE`
--

DROP TABLE IF EXISTS `COURSE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COURSE` (
  `id_course` int NOT NULL AUTO_INCREMENT,
  `id_instructor` int NOT NULL,
  `v_subject` varchar(255) NOT NULL,
  `d_created` date NOT NULL,
  `d_starting_at` date NOT NULL,
  `d_finishing_at` date NOT NULL,
  PRIMARY KEY (`id_course`),
  KEY `idx_course_instructor` (`id_instructor`),
  CONSTRAINT `COURSE_ibfk_1` FOREIGN KEY (`id_instructor`) REFERENCES `INSTRUCTOR` (`id_instructor`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COURSE`
--

LOCK TABLES `COURSE` WRITE;
/*!40000 ALTER TABLE `COURSE` DISABLE KEYS */;
INSERT INTO `COURSE` VALUES (1,1,'Data Science 101','2024-01-01','2024-02-01','2024-06-01'),(2,2,'Advanced Mathematics','2024-02-01','2024-03-01','2024-07-01'),(3,3,'Physics for Engineers','2024-03-01','2024-04-01','2024-08-01'),(4,4,'Web Development','2024-04-01','2024-05-01','2024-09-01'),(5,5,'Cybersecurity Fundamentals','2024-05-01','2024-06-01','2024-10-01'),(6,7,'Introduction to SQL','2025-01-15','2025-01-20','2025-06-01'),(7,2,'Advanced SQL','2025-01-16','2025-01-20','2025-06-01'),(8,3,'Big Data 101','2025-01-17','2025-01-22','2025-06-15'),(9,4,'Cloud DB Essentials','2025-01-18','2025-01-25','2025-07-01'),(10,5,'Data Structures & DB','2025-01-19','2025-01-28','2025-07-10'),(11,6,'Conceptual Modeling','2025-01-20','2025-01-30','2025-07-15'),(12,7,'ETL and Pipelines','2025-01-21','2025-02-01','2025-08-01'),(13,8,'Testing Databases','2025-01-22','2025-02-02','2025-08-10'),(14,9,'SQL Optimization','2025-01-23','2025-02-03','2025-08-15'),(15,9,'Database Admin Basics','2025-01-24','2025-02-04','2025-08-20');
/*!40000 ALTER TABLE `COURSE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COURSE_LEARNCHAPTER`
--

DROP TABLE IF EXISTS `COURSE_LEARNCHAPTER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COURSE_LEARNCHAPTER` (
  `id_course` int NOT NULL,
  `id_learningchapter` int NOT NULL,
  PRIMARY KEY (`id_course`,`id_learningchapter`),
  KEY `id_learningchapter` (`id_learningchapter`),
  CONSTRAINT `COURSE_LEARNCHAPTER_ibfk_1` FOREIGN KEY (`id_course`) REFERENCES `COURSE` (`id_course`) ON DELETE RESTRICT,
  CONSTRAINT `COURSE_LEARNCHAPTER_ibfk_2` FOREIGN KEY (`id_learningchapter`) REFERENCES `LEARNING_CHAPTER` (`id_learningchapter`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COURSE_LEARNCHAPTER`
--

LOCK TABLES `COURSE_LEARNCHAPTER` WRITE;
/*!40000 ALTER TABLE `COURSE_LEARNCHAPTER` DISABLE KEYS */;
INSERT INTO `COURSE_LEARNCHAPTER` VALUES (6,1),(6,2),(6,3),(6,4),(6,5);
/*!40000 ALTER TABLE `COURSE_LEARNCHAPTER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DIFFICULTY_LEVEL`
--

DROP TABLE IF EXISTS `DIFFICULTY_LEVEL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DIFFICULTY_LEVEL` (
  `id_difficultylevel` int NOT NULL AUTO_INCREMENT,
  `v_title` varchar(20) NOT NULL,
  `v_description` text NOT NULL,
  PRIMARY KEY (`id_difficultylevel`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DIFFICULTY_LEVEL`
--

LOCK TABLES `DIFFICULTY_LEVEL` WRITE;
/*!40000 ALTER TABLE `DIFFICULTY_LEVEL` DISABLE KEYS */;
INSERT INTO `DIFFICULTY_LEVEL` VALUES (1,'Easy','Basic level exercises for beginners'),(2,'Moderate','Intermediate level exercises for learners'),(3,'Hard','Challenging exercises for advanced users'),(4,'Expert','Highly advanced problems requiring deep understanding'),(5,'Fundamental','Core database principles and queries'),(6,'Performance','Optimization and indexing challenges'),(7,'Security','Database security and access control issues'),(8,'Replication','Replication and distributed database scenarios');
/*!40000 ALTER TABLE `DIFFICULTY_LEVEL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EVALUATION`
--

DROP TABLE IF EXISTS `EVALUATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EVALUATION` (
  `id_evaluation` int NOT NULL AUTO_INCREMENT,
  `f_weight` decimal(5,2) NOT NULL,
  `d_deadline` date NOT NULL,
  PRIMARY KEY (`id_evaluation`),
  CONSTRAINT `EVALUATION_chk_1` CHECK (((`f_weight` >= 0.00) and (`f_weight` <= 100.00)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EVALUATION`
--

LOCK TABLES `EVALUATION` WRITE;
/*!40000 ALTER TABLE `EVALUATION` DISABLE KEYS */;
INSERT INTO `EVALUATION` VALUES (1,10.00,'2025-06-22'),(2,10.00,'2025-04-19');
/*!40000 ALTER TABLE `EVALUATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EVALUATION_EXERCISE`
--

DROP TABLE IF EXISTS `EVALUATION_EXERCISE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EVALUATION_EXERCISE` (
  `id_evaluation` int NOT NULL,
  `id_exercise` int NOT NULL,
  PRIMARY KEY (`id_evaluation`,`id_exercise`),
  KEY `id_exercise` (`id_exercise`),
  CONSTRAINT `EVALUATION_EXERCISE_ibfk_1` FOREIGN KEY (`id_evaluation`) REFERENCES `EVALUATION` (`id_evaluation`) ON DELETE CASCADE,
  CONSTRAINT `EVALUATION_EXERCISE_ibfk_2` FOREIGN KEY (`id_exercise`) REFERENCES `EXERCISE` (`id_exercise`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EVALUATION_EXERCISE`
--

LOCK TABLES `EVALUATION_EXERCISE` WRITE;
/*!40000 ALTER TABLE `EVALUATION_EXERCISE` DISABLE KEYS */;
/*!40000 ALTER TABLE `EVALUATION_EXERCISE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EXERCISE`
--

DROP TABLE IF EXISTS `EXERCISE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EXERCISE` (
  `id_exercise` int NOT NULL AUTO_INCREMENT,
  `f_weight` decimal(5,2) NOT NULL,
  `d_deadline` date NOT NULL,
  `id_difficultylevel` int NOT NULL,
  `n_max_attempts` int NOT NULL DEFAULT '3',
  `description` text NOT NULL,
  PRIMARY KEY (`id_exercise`),
  KEY `idx_exercise_difficulty` (`id_difficultylevel`),
  CONSTRAINT `EXERCISE_ibfk_1` FOREIGN KEY (`id_difficultylevel`) REFERENCES `DIFFICULTY_LEVEL` (`id_difficultylevel`) ON DELETE RESTRICT,
  CONSTRAINT `EXERCISE_chk_1` CHECK (((`f_weight` >= 0.00) and (`f_weight` <= 100.00))),
  CONSTRAINT `EXERCISE_chk_2` CHECK ((`n_max_attempts` >= 1))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EXERCISE`
--

LOCK TABLES `EXERCISE` WRITE;
/*!40000 ALTER TABLE `EXERCISE` DISABLE KEYS */;
INSERT INTO `EXERCISE` VALUES (1,6.00,'2025-04-08',1,3,'SELECT Customers.name, Orders.order_dateFROM CustomersINNER JOIN Orders ON Customers.customer_id = Orders.customer_id;'),(2,5.00,'2025-04-09',1,3,'Use table Aliases:\r\n\r\nSELECT name, order_date\r\nFROM Customers \r\nINNER JOIN Orders  ON customer_id = customer_id;'),(3,10.00,'2025-04-18',1,3,'You are given a table named employees with the following columns:\r\n\r\nid (INT)\r\nname (VARCHAR)\r\ndepartment (VARCHAR)\r\nsalary (INT)\r\nWrite an SQL query to find the names and salaries of employees who work in the \'Engineering\' department and earn more than 70000.'),(4,5.00,'2025-04-02',1,3,'You are given a table named orders with the following columns:\r\n\r\norder_id (INT)\r\ncustomer_name (VARCHAR)\r\norder_date (DATE)\r\ntotal_amount (DECIMAL)\r\nWrite an SQL query to find all orders placed in the year 2024 where the total amount is less than 100.'),(5,20.00,'2025-04-19',2,3,'Question:\r\nYou are given the following database schema:\r\n\r\nTable: students\r\n\r\nid (INT, Primary Key)\r\nname (VARCHAR)\r\nemail (VARCHAR)\r\nTable: courses\r\n\r\nid (INT, Primary Key)\r\ntitle (VARCHAR)\r\ninstructor_id (INT, Foreign Key to instructors.id)\r\nTable: instructors\r\n\r\nid (INT, Primary Key)\r\nname (VARCHAR)\r\nTable: enrollments\r\n\r\nstudent_id (INT, Foreign Key to students.id)\r\ncourse_id (INT, Foreign Key to courses.id)\r\nenrollment_date (DATE)'),(6,3.00,'2025-04-09',3,3,'Exercise 3'),(7,5.00,'2025-04-25',2,5,'Exercise 5'),(8,2.00,'2025-04-01',3,3,'Hey how are you'),(9,3.00,'2025-04-19',2,3,'sdfsdf'),(10,2.00,'2025-04-25',1,1,'<h4><strong>Exercise 1: Multiple Choice</strong></h4>\r\n\r\n<p><strong>Question:</strong><br />\r\nWhich of the following is a valid variable name in Python?</p>\r\n\r\n<p><strong>Options:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>A.&nbsp;<code>2</code></p>\r\n	</li>\r\n	<li>\r\n	<p>B.&nbsp;</p>\r\n	</li>\r\n	<li>\r\n	<p>C.&nbsp;</p>\r\n	</li>\r\n	<li>\r\n	<p>D.&nbsp;</p>\r\n	</li>\r\n</ul>'),(11,10.00,'2025-04-18',2,1,'<h3>✅ Example: Chapter 1 &ndash;&nbsp;<em>Introduction to Programming</em></h3>\r\n\r\n<h4><strong>Exercise 1: Multiple Choice</strong></h4>\r\n\r\n<p><strong>Question:</strong><br />\r\nWhich of the following is a valid variable name in Python?</p>\r\n\r\n<p><strong>Options:</strong></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>A.&nbsp;<code>2variable</code></p>\r\n	</li>\r\n	<li>\r\n	<p>B.&nbsp;<code>variable_name</code></p>\r\n	</li>\r\n	<li>\r\n	<p>C.&nbsp;<code>variable-name</code></p>\r\n	</li>\r\n	<li>\r\n	<p>D.&nbsp;<code>@variable</code></p>\r\n	</li>\r\n</ul>'),(12,2.00,'2025-04-25',1,1,'Multiple Choice\r\nQuestion: Which of the following is a valid variable name in Python?'),(13,2.00,'2025-04-25',1,1,'Code Completion\r\nQuestion: Fill in the blank to print \"Hello, world\" in Python:\r\npython\r\nCopyEdit\r\n_____(\"Hello, world\")'),(14,2.00,'2025-04-18',1,3,'sdfdsf'),(15,2.00,'2025-04-25',1,1,'Exercise 3: True or False\r\nQuestion: Python is a statically-typed programming language.'),(16,2.00,'2025-05-09',2,1,'Choose one of the following database systems to use for the remainder of this course:\r\n* MySQL\r\n* PostgreSQL\r\n* SQLite\r\n❓ Question: Why did you choose this system? Write 2–3 sentences explaining your choice based on features, platform, ease of use, or other factors.'),(17,2.00,'2025-05-30',1,1,'Return all students majoring in \"Computer Sci\".');
/*!40000 ALTER TABLE `EXERCISE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EXERCISE_LLM`
--

DROP TABLE IF EXISTS `EXERCISE_LLM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EXERCISE_LLM` (
  `id_exercise_llm` int NOT NULL AUTO_INCREMENT,
  `f_weight` decimal(5,2) NOT NULL,
  `d_deadline` date NOT NULL,
  `id_difficultylevel` int DEFAULT '1',
  `n_max_attempts` int DEFAULT '1',
  `topic` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_exercise_llm`),
  CONSTRAINT `EXERCISE_LLM_chk_1` CHECK (((`f_weight` >= 0.00) and (`f_weight` <= 100.00)))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EXERCISE_LLM`
--

LOCK TABLES `EXERCISE_LLM` WRITE;
/*!40000 ALTER TABLE `EXERCISE_LLM` DISABLE KEYS */;
INSERT INTO `EXERCISE_LLM` VALUES (1,1.00,'2025-04-15',1,1,'Partition By'),(2,1.00,'2025-04-20',1,1,'Group By'),(3,1.00,'2025-04-25',1,1,'With'),(4,0.01,'2025-03-31',1,1,'partition by'),(5,0.01,'2025-03-31',1,1,'Group by'),(6,0.01,'2025-03-31',1,1,'Partition By'),(7,0.01,'2025-03-31',1,1,'Partition By'),(8,0.01,'2025-03-31',1,1,'Partition By'),(9,0.01,'2025-03-31',1,1,'Partition By'),(10,0.01,'2025-04-01',1,1,'With'),(11,0.01,'2025-04-02',1,1,'With'),(12,0.01,'2025-04-03',1,1,'with'),(13,0.01,'2025-04-03',1,1,'Partition By'),(14,0.01,'2025-04-03',1,1,'With');
/*!40000 ALTER TABLE `EXERCISE_LLM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `INSTRUCTOR`
--

DROP TABLE IF EXISTS `INSTRUCTOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INSTRUCTOR` (
  `id_instructor` int NOT NULL AUTO_INCREMENT,
  `id_user` int DEFAULT NULL,
  `n_phone` varchar(20) DEFAULT NULL,
  `v_specialty` varchar(255) NOT NULL,
  `v_bio` text NOT NULL,
  PRIMARY KEY (`id_instructor`),
  UNIQUE KEY `id_user` (`id_user`),
  KEY `idx_instructor_user` (`id_user`),
  CONSTRAINT `INSTRUCTOR_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INSTRUCTOR`
--

LOCK TABLES `INSTRUCTOR` WRITE;
/*!40000 ALTER TABLE `INSTRUCTOR` DISABLE KEYS */;
INSERT INTO `INSTRUCTOR` VALUES (1,2,NULL,'Computer Science','Expert in AI and Machine Learning'),(2,4,NULL,'Mathematics','Experienced in Calculus and Statistics'),(3,5,'5551234567','Databases and Distributed Systems','Passionate about Quantum Computers, LLMS, Web Semantics.'),(4,3,NULL,'Software Engineering','Full Stack Developer'),(5,1,NULL,'Cybersecurity','Specialist in Ethical Hacking'),(6,28,'','',''),(7,37,'4084215651','Database Management Systems','Dr. Linda Perez is a passionate database systems instructor with over 10 years of experience teaching relational databases, SQL, and data modeling at both university and industry levels. She holds a Ph.D. in Computer Science with a focus on distributed database systems and has worked with technologies such as MySQL, PostgreSQL, Oracle, and MongoDB.\r\nElena specializes in teaching advanced SQL, database design, normalization, and query optimization. She believes in making complex data concepts approachable through real-world examples and hands-on projects. Her courses are known for blending theory with practical tools, helping students build strong foundations in modern data management.\r\nOutside of teaching, Elena collaborates with startups on building scalable data pipelines and contributes to open-source data tools. She’s passionate about helping students become confident data professionals and brings energy, clarity, and real-world relevance to every class she teaches.'),(8,47,NULL,'DS','Im a cool corgi');
/*!40000 ALTER TABLE `INSTRUCTOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LEARNING_CHAPTER`
--

DROP TABLE IF EXISTS `LEARNING_CHAPTER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LEARNING_CHAPTER` (
  `id_learningchapter` int NOT NULL AUTO_INCREMENT,
  `id_instructor` int NOT NULL,
  `d_created_at` date NOT NULL,
  `v_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `d_deadline` date DEFAULT NULL,
  `f_weight` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id_learningchapter`),
  KEY `idx_chapter_instructor` (`id_instructor`),
  CONSTRAINT `LEARNING_CHAPTER_ibfk_1` FOREIGN KEY (`id_instructor`) REFERENCES `INSTRUCTOR` (`id_instructor`) ON DELETE RESTRICT,
  CONSTRAINT `LEARNING_CHAPTER_chk_1` CHECK (((`f_weight` >= 0.00) and (`f_weight` <= 100.00)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LEARNING_CHAPTER`
--

LOCK TABLES `LEARNING_CHAPTER` WRITE;
/*!40000 ALTER TABLE `LEARNING_CHAPTER` DISABLE KEYS */;
INSERT INTO `LEARNING_CHAPTER` VALUES (1,7,'2025-04-05','<h2>Introduction to Relational Databases</h2>\r\n\r\n<hr />\r\n<h3>1.1 What is a Relational Database?</h3>\r\n\r\n<p>A&nbsp;<strong>relational database</strong>&nbsp;is a type of database that stores and provides access to data points that are related to one another. Data in a relational database is organized into&nbsp;<strong>tables</strong>, which consist of&nbsp;<strong>rows</strong>&nbsp;and&nbsp;<strong>columns</strong>. Each table represents an entity (such as a customer or an order), and each row represents a record of that entity.</p>\r\n\r\n<p>Relational databases are powerful because they reduce data redundancy and support flexible querying through SQL &mdash; the Structured Query Language.</p>\r\n\r\n<hr />\r\n<h3>1.2 The Structure of a Table</h3>\r\n\r\n<p>A&nbsp;<strong>table</strong>&nbsp;in a relational database resembles a spreadsheet. For example:</p>\r\n\r\n<p><strong>Customers</strong></p>\r\n\r\n<table>\r\n	<thead>\r\n		<tr>\r\n			<th>id</th>\r\n			<th>name</th>\r\n			<th>email</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>1</td>\r\n			<td>Alice Smith</td>\r\n			<td>alice@example.com</td>\r\n		</tr>\r\n		<tr>\r\n			<td>2</td>\r\n			<td>Bob Johnson</td>\r\n			<td>bob@example.com</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>- Each&nbsp;<strong>column</strong>&nbsp;(e.g.,&nbsp;<code>name</code>,&nbsp;<code>email</code>) represents an attribute.</p>\r\n\r\n<p>- Each&nbsp;<strong>row</strong>&nbsp;represents an individual record (e.g., Alice Smith).</p>\r\n\r\n<hr />\r\n<h3>1.3 Keys and Relationships</h3>\r\n\r\n<ul>\r\n	<li>\r\n	<p>A&nbsp;<strong>primary key</strong>&nbsp;uniquely identifies each record in a table.</p>\r\n	</li>\r\n	<li>\r\n	<p>A&nbsp;<strong>foreign key</strong>&nbsp;creates a link between two tables.</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Let&rsquo;s say we have two tables:&nbsp;<code>Customers</code>&nbsp;and&nbsp;<code>Orders</code>. Each order should reference the customer who placed it.</p>\r\n\r\n<p><strong>Orders</strong></p>\r\n\r\n<table>\r\n	<thead>\r\n		<tr>\r\n			<th>id</th>\r\n			<th>customer_id</th>\r\n			<th>total_amount</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>1</td>\r\n			<td>1</td>\r\n			<td>199.99</td>\r\n		</tr>\r\n		<tr>\r\n			<td>2</td>\r\n			<td>2</td>\r\n			<td>89.50</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>In this case,&nbsp;<code>customer_id</code>&nbsp;is a foreign key pointing to the&nbsp;<code>Customers.id</code>.</p>\r\n\r\n<p>This relationship ensures that:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Orders are always tied to valid customers</p>\r\n	</li>\r\n	<li>\r\n	<p>You can query data&nbsp;<em>across</em>&nbsp;multiple tables</p>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>1.4 Why Relational Databases?</h3>\r\n\r\n<p>Relational databases are:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>Reliable</strong>&nbsp;&mdash; With ACID transactions ensuring data consistency</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Efficient</strong>&nbsp;&mdash; Thanks to indexing and normalization</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Flexible</strong>&nbsp;&mdash; SQL allows complex querying and joins</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Scalable</strong>&nbsp;&mdash; Suitable for small apps to enterprise systems</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>They are widely used in finance, education, e-commerce, healthcare, and nearly every data-driven industry.</p>\r\n\r\n<hr />\r\n<h3>1.5 Common Relational Database Systems</h3>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>MySQL</strong>&nbsp;&ndash; Open-source and widely used</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>PostgreSQL</strong>&nbsp;&ndash; Open-source and standards-compliant</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Oracle DB</strong>&nbsp;&ndash; Powerful and feature-rich for enterprise use</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>SQL Server</strong>&nbsp;&ndash; Microsoft&rsquo;s commercial RDBMS</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>SQLite</strong>&nbsp;&ndash; Lightweight and embedded, great for mobile apps</p>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>1.6 Summary</h3>\r\n\r\n<p>Relational databases organize data in structured tables with defined relationships. Understanding how tables, keys, and relationships work is the foundation of learning SQL and managing structured data effectively.</p>\r\n\r\n<hr />\r\n<p>?&nbsp;<strong>Next Chapter</strong>:<br />\r\n➡️&nbsp;<em>Chapter 2: Installing and Connecting to a Database</em></p>','2025-06-12',10.00),(2,7,'2025-04-05','<h2>Installing and Connecting to a Database</h2>\r\n\r\n<hr />\r\n<h3>2.1 Introduction</h3>\r\n\r\n<p>Before you can write SQL queries, you need access to a database system. This chapter guides you through installing a relational database and connecting to it from a client interface. We will focus on open-source systems such as MySQL and PostgreSQL, but the general concepts apply to most RDBMS.</p>\r\n\r\n<hr />\r\n<h3>2.2 Choosing a Database</h3>\r\n\r\n<p>For learning purposes, the following options are highly recommended:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>MySQL</strong>&nbsp;&ndash; Popular and lightweight</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>PostgreSQL</strong>&nbsp;&ndash; Robust and standards-compliant</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>SQLite</strong>&nbsp;&ndash; Minimal setup; great for embedded apps</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Each has community editions that are free to install and use.</p>\r\n\r\n<hr />\r\n<h3>2.3 Installing the Database System</h3>\r\n\r\n<p><strong>MySQL Example:</strong></p>\r\n\r\n<ol>\r\n	<li>\r\n	<p>Go to&nbsp;<a href=\"https://dev.mysql.com/downloads/\" rel=\"noopener\" target=\"_new\">https://dev.mysql.com/downloads/</a></p>\r\n	</li>\r\n	<li>\r\n	<p>Download the MySQL Community Server</p>\r\n	</li>\r\n	<li>\r\n	<p>Use the installer to configure root password, port (3306), and storage engine</p>\r\n	</li>\r\n</ol>\r\n\r\n<p><strong>PostgreSQL Example:</strong></p>\r\n\r\n<ol>\r\n	<li>\r\n	<p>Visit&nbsp;<a href=\"https://www.postgresql.org/download/\" rel=\"noopener\" target=\"_new\">https://www.postgresql.org/download/</a></p>\r\n	</li>\r\n	<li>\r\n	<p>Download the installer for your OS</p>\r\n	</li>\r\n	<li>\r\n	<p>During setup, configure password, default port (5432), and superuser account</p>\r\n	</li>\r\n</ol>\r\n\r\n<hr />\r\n<h3>2.4 Connecting to the Database</h3>\r\n\r\n<p>You can connect using:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>Command-Line Tools</strong></p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>MySQL:&nbsp;<code>mysql -u root -p</code></p>\r\n		</li>\r\n		<li>\r\n		<p>PostgreSQL:&nbsp;<code>psql -U postgres</code></p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p><strong>Graphical Tools</strong></p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>MySQL Workbench</p>\r\n		</li>\r\n		<li>\r\n		<p>pgAdmin</p>\r\n		</li>\r\n		<li>\r\n		<p>DBeaver (supports both)</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p><strong>Code (optional for devs)</strong></p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>Python: using libraries like&nbsp;<code>mysql-connector</code>&nbsp;or&nbsp;<code>psycopg2</code></p>\r\n		</li>\r\n		<li>\r\n		<p>JavaScript: using&nbsp;<code>pg</code>&nbsp;or&nbsp;<code>mysql2</code>&nbsp;packages</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>2.5 Testing the Connection</h3>\r\n\r\n<p>After installation and configuration, test the connection by:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Logging in using CLI or GUI</p>\r\n	</li>\r\n	<li>\r\n	<p>Running a simple query:&nbsp;<code>SELECT VERSION();</code></p>\r\n	</li>\r\n	<li>\r\n	<p>Creating a test database:&nbsp;<code>CREATE DATABASE sql_course;</code></p>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>2.6 Summary</h3>\r\n\r\n<p>You now have a database server running and are able to connect to it using both terminal and graphical tools. This foundation allows you to start building tables and writing queries in upcoming chapters.</p>\r\n\r\n<hr />\r\n<p>?&nbsp;<strong>Next Chapter:</strong><br />\r\n➡️&nbsp;<em>Chapter 3: Understanding Tables, Rows, and Columns</em></p>','2025-05-09',10.00),(3,7,'2025-04-05','<h2>Understanding Tables, Rows, and Columns</h2>\r\n\r\n<hr />\r\n<h3>3.1 Introduction to Tables</h3>\r\n\r\n<p>In a relational database, data is stored in&nbsp;<strong>tables</strong>, which are the core structure for organizing information. Think of a table as a spreadsheet, where:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Each&nbsp;<strong>row</strong>&nbsp;represents a unique record (an instance of an entity)</p>\r\n	</li>\r\n	<li>\r\n	<p>Each&nbsp;<strong>column</strong>&nbsp;represents a field (a specific attribute of that entity)</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Every table has a&nbsp;<strong>name</strong>&nbsp;and a well-defined&nbsp;<strong>schema</strong>, which defines its structure (field names, data types, constraints).</p>\r\n\r\n<hr />\r\n<h3>3.2 Rows: Representing Records</h3>\r\n\r\n<p>A&nbsp;<strong>row</strong>&nbsp;in a table is a single record that holds values for each of the defined columns. For example:</p>\r\n\r\n<p><strong>students</strong></p>\r\n\r\n<table>\r\n	<thead>\r\n		<tr>\r\n			<th>id</th>\r\n			<th>name</th>\r\n			<th>email</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td>1</td>\r\n			<td>Alice Smith</td>\r\n			<td>alice@example.com</td>\r\n		</tr>\r\n		<tr>\r\n			<td>2</td>\r\n			<td>Bob Johnson</td>\r\n			<td>bob@example.com</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>In this table:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Each row corresponds to one student.</p>\r\n	</li>\r\n	<li>\r\n	<p>Row 1 holds the data for Alice, and Row 2 for Bob.</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Rows are stored without any inherent order unless explicitly sorted during queries.</p>\r\n\r\n<hr />\r\n<h3>3.3 Columns: Defining Attributes</h3>\r\n\r\n<p><strong>Columns</strong>&nbsp;define the structure of a table. Each column has:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>A&nbsp;<strong>name</strong>&nbsp;(e.g.,&nbsp;<code>id</code>,&nbsp;<code>name</code>,&nbsp;<code>email</code>)</p>\r\n	</li>\r\n	<li>\r\n	<p>A&nbsp;<strong>data type</strong>&nbsp;(e.g.,&nbsp;<code>INT</code>,&nbsp;<code>VARCHAR</code>,&nbsp;<code>DATE</code>)</p>\r\n	</li>\r\n	<li>\r\n	<p>Optional&nbsp;<strong>constraints</strong>&nbsp;(e.g.,&nbsp;<code>NOT NULL</code>,&nbsp;<code>UNIQUE</code>)</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>All rows in a table share the same columns &mdash; ensuring data consistency.</p>\r\n\r\n<hr />\r\n<h3>3.4 Data Types</h3>\r\n\r\n<p>Columns are assigned a&nbsp;<strong>data type</strong>&nbsp;that determines the kind of values they can store. Common data types include:</p>\r\n\r\n<table>\r\n	<thead>\r\n		<tr>\r\n			<th>Type</th>\r\n			<th>Example</th>\r\n			<th>Usage</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td><code>INT</code></td>\r\n			<td>42</td>\r\n			<td>Whole numbers</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>VARCHAR</code></td>\r\n			<td>&#39;Alice Smith&#39;</td>\r\n			<td>Strings (variable length)</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>DATE</code></td>\r\n			<td>&#39;2025-04-04&#39;</td>\r\n			<td>Calendar dates</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>DECIMAL</code></td>\r\n			<td>199.99</td>\r\n			<td>Fixed-precision numbers</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>BOOLEAN</code></td>\r\n			<td>TRUE / FALSE</td>\r\n			<td>Binary logic (0 or 1)</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>Choosing the right data type is essential for performance, accuracy, and storage efficiency.</p>\r\n\r\n<hr />\r\n<h3>3.5 Creating a Table</h3>\r\n\r\n<p>You can create a table in SQL using the&nbsp;<code>CREATE TABLE</code>&nbsp;command. Example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>CREATE TABLE students ( id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE ); </code></p>\r\n\r\n<p>This defines a table with three columns, where:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><code>id</code>&nbsp;is the primary key</p>\r\n	</li>\r\n	<li>\r\n	<p><code>name</code>&nbsp;cannot be null</p>\r\n	</li>\r\n	<li>\r\n	<p><code>email</code>&nbsp;must be unique</p>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>3.6 Modifying Tables</h3>\r\n\r\n<p>After creating a table, you can modify it using&nbsp;<code>ALTER TABLE</code>. For example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>ALTER TABLE students ADD COLUMN age INT; </code></p>\r\n\r\n<p>This adds an&nbsp;<code>age</code>&nbsp;column to the existing&nbsp;<code>students</code>&nbsp;table.</p>\r\n\r\n<hr />\r\n<h3>3.7 Deleting Tables</h3>\r\n\r\n<p>To delete a table (careful!):</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>DROP TABLE students; </code></p>\r\n\r\n<p>This command&nbsp;<strong>removes the entire table and its data</strong>.</p>\r\n\r\n<hr />\r\n<h3>3.8 Summary</h3>\r\n\r\n<p>Tables are the foundation of relational databases. Understanding how rows and columns interact &mdash; and how to define them using proper data types and constraints &mdash; is critical for effective database design.</p>\r\n\r\n<hr />\r\n<p>?&nbsp;<strong>Next Chapter:</strong><br />\r\n➡️&nbsp;<em>Chapter 4: Basic SELECT Statements</em></p>','2025-05-16',10.00),(4,7,'2025-04-05','<h2>Basic SELECT Statements</h2>\r\n\r\n<hr />\r\n<h3>4.1 Introduction</h3>\r\n\r\n<p>The&nbsp;<code>SELECT</code>&nbsp;statement is the most fundamental SQL command &mdash; it allows you to&nbsp;<strong>retrieve data</strong>&nbsp;from a table. This chapter introduces the basic syntax of&nbsp;<code>SELECT</code>, explores how to fetch specific columns, and shows how to rename, filter, and format your results.</p>\r\n\r\n<hr />\r\n<h3>4.2 The Basic SELECT Syntax</h3>\r\n\r\n<p>The simplest form of a&nbsp;<code>SELECT</code>&nbsp;statement looks like this:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT column1, column2 FROM table_name; </code></p>\r\n\r\n<p>Example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name, email FROM students; </code></p>\r\n\r\n<p>This retrieves the&nbsp;<code>name</code>&nbsp;and&nbsp;<code>email</code>&nbsp;columns for every row in the&nbsp;<code>students</code>&nbsp;table.</p>\r\n\r\n<hr />\r\n<h3>4.3 Selecting All Columns</h3>\r\n\r\n<p>To retrieve&nbsp;<em>every column</em>&nbsp;in a table, use the asterisk&nbsp;<code>*</code>:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM students; </code></p>\r\n\r\n<p>Use this carefully &mdash; in production, it&#39;s more efficient to only request the columns you need.</p>\r\n\r\n<hr />\r\n<h3>4.4 Using Aliases (<code>AS</code>)</h3>\r\n\r\n<p>You can rename columns in your result using the&nbsp;<code>AS</code>&nbsp;keyword:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name AS student_name, email AS contact_email FROM students; </code></p>\r\n\r\n<p>This makes the output easier to read or better suited for reports.</p>\r\n\r\n<hr />\r\n<h3>4.5 Using Expressions in SELECT</h3>\r\n\r\n<p>You can include calculations or expressions:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name, 2025 - birth_year AS age FROM students; </code></p>\r\n\r\n<p>Or concatenate values:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT CONCAT(first_name, &#39; &#39;, last_name) AS full_name FROM students; </code></p>\r\n\r\n<hr />\r\n<h3>4.6 Filtering with WHERE</h3>\r\n\r\n<p>To limit the rows returned, use the&nbsp;<code>WHERE</code>&nbsp;clause:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name FROM students WHERE age &gt;= 18; </code></p>\r\n\r\n<p>You can use various operators:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><code>=</code>,&nbsp;<code>!=</code>,&nbsp;<code>&lt;&gt;</code>&nbsp;(not equal)</p>\r\n	</li>\r\n	<li>\r\n	<p><code>&gt;</code>,&nbsp;<code>&lt;</code>,&nbsp;<code>&gt;=</code>,&nbsp;<code>&lt;=</code></p>\r\n	</li>\r\n	<li>\r\n	<p><code>LIKE</code>&nbsp;(for pattern matching)</p>\r\n	</li>\r\n	<li>\r\n	<p><code>IN</code>&nbsp;(for list filtering)</p>\r\n	</li>\r\n	<li>\r\n	<p><code>BETWEEN</code>&nbsp;(for range checks)</p>\r\n	</li>\r\n	<li>\r\n	<p><code>IS NULL</code>,&nbsp;<code>IS NOT NULL</code></p>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>4.7 Sorting Results with ORDER BY</h3>\r\n\r\n<p>To sort the result:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name, age FROM students ORDER BY age DESC; </code></p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Use&nbsp;<code>ASC</code>&nbsp;for ascending (default)</p>\r\n	</li>\r\n	<li>\r\n	<p>Use&nbsp;<code>DESC</code>&nbsp;for descending</p>\r\n	</li>\r\n</ul>\r\n\r\n<hr />\r\n<h3>4.8 Limiting Results with LIMIT</h3>\r\n\r\n<p>You can return only a certain number of rows:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM students LIMIT 5; </code></p>\r\n\r\n<p>Or for pagination:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM students LIMIT 5 OFFSET 10; </code></p>\r\n\r\n<hr />\r\n<h3>4.9 Combining Clauses</h3>\r\n\r\n<p>All together:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name, email FROM students WHERE age &gt; 20 ORDER BY name LIMIT 10; </code></p>\r\n\r\n<hr />\r\n<h3>4.10 Summary</h3>\r\n\r\n<p>The&nbsp;<code>SELECT</code>&nbsp;statement is the heart of SQL. Understanding how to retrieve specific data &mdash; with conditions, ordering, and limits &mdash; prepares you for more advanced queries involving joins and aggregations.</p>\r\n\r\n<hr />\r\n<p>?&nbsp;<strong>Next Chapter:</strong><br />\r\n➡️&nbsp;<em>Chapter 5: Filtering with WHERE</em></p>','2025-05-23',10.00),(5,7,'2025-04-05','<h2>Filtering with WHERE</h2>\r\n\r\n<hr />\r\n<h3>5.1 Introduction</h3>\r\n\r\n<p>The&nbsp;<code>WHERE</code>&nbsp;clause is a powerful tool in SQL that allows you to&nbsp;<strong>filter rows</strong>&nbsp;based on specific conditions. Without it, a query will return every row in a table. With&nbsp;<code>WHERE</code>, you can target exactly the data you need.</p>\r\n\r\n<hr />\r\n<h3>5.2 Basic Syntax</h3>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT column1, column2 FROM table_name WHERE condition; </code></p>\r\n\r\n<p>Example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT name, age FROM students WHERE age &gt;= 18; </code></p>\r\n\r\n<p>This retrieves only students who are 18 or older.</p>\r\n\r\n<hr />\r\n<h3>5.3 Comparison Operators</h3>\r\n\r\n<p>You can use standard comparison operators to define conditions:</p>\r\n\r\n<table>\r\n	<thead>\r\n		<tr>\r\n			<th>Operator</th>\r\n			<th>Meaning</th>\r\n		</tr>\r\n	</thead>\r\n	<tbody>\r\n		<tr>\r\n			<td><code>=</code></td>\r\n			<td>Equal to</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>!=</code>&nbsp;or&nbsp;<code>&lt;&gt;</code></td>\r\n			<td>Not equal to</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>&lt;</code></td>\r\n			<td>Less than</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>&lt;=</code></td>\r\n			<td>Less than or equal</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>&gt;</code></td>\r\n			<td>Greater than</td>\r\n		</tr>\r\n		<tr>\r\n			<td><code>&gt;=</code></td>\r\n			<td>Greater than or equal</td>\r\n		</tr>\r\n	</tbody>\r\n</table>\r\n\r\n<p>Example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM books WHERE price &lt; 20; </code></p>\r\n\r\n<hr />\r\n<h3>5.4 Logical Operators</h3>\r\n\r\n<p>You can combine multiple conditions using logical operators:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><code>AND</code>&nbsp;&ndash; all conditions must be true</p>\r\n	</li>\r\n	<li>\r\n	<p><code>OR</code>&nbsp;&ndash; at least one condition must be true</p>\r\n	</li>\r\n	<li>\r\n	<p><code>NOT</code>&nbsp;&ndash; negates a condition</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM students WHERE age &gt;= 18 AND enrolled = TRUE; </code></p>\r\n\r\n<hr />\r\n<h3>5.5 The IN Operator</h3>\r\n\r\n<p>Use&nbsp;<code>IN</code>&nbsp;to filter by a list of values:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM courses WHERE category IN (&#39;Data Science&#39;, &#39;SQL&#39;, &#39;Python&#39;); </code></p>\r\n\r\n<hr />\r\n<h3>5.6 The BETWEEN Operator</h3>\r\n\r\n<p><code>BETWEEN</code>&nbsp;checks if a value falls within a range:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM orders WHERE order_date BETWEEN &#39;2024-01-01&#39; AND &#39;2024-12-31&#39;; </code></p>\r\n\r\n<p>This includes both the start and end dates.</p>\r\n\r\n<hr />\r\n<h3>5.7 The LIKE Operator</h3>\r\n\r\n<p>Use&nbsp;<code>LIKE</code>&nbsp;for pattern matching with wildcards:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><code>%</code>&nbsp;= any number of characters</p>\r\n	</li>\r\n	<li>\r\n	<p><code>_</code>&nbsp;= a single character</p>\r\n	</li>\r\n</ul>\r\n\r\n<p>Example:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM users WHERE email LIKE &#39;%@gmail.com&#39;; </code></p>\r\n\r\n<hr />\r\n<h3>5.8 Checking for NULL</h3>\r\n\r\n<p>To check for&nbsp;<code>NULL</code>&nbsp;values:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM students WHERE phone_number IS NULL; </code></p>\r\n\r\n<p>Use&nbsp;<code>IS NOT NULL</code>&nbsp;to check for non-empty fields.</p>\r\n\r\n<hr />\r\n<h3>5.9 Complex Conditions</h3>\r\n\r\n<p>You can combine multiple conditions and use parentheses to control logic:</p>\r\n\r\n<pre>\r\n\r\n&nbsp;</pre>\r\n\r\n<p>sql</p>\r\n\r\n<p>CopyEdit</p>\r\n\r\n<p><code>SELECT * FROM employees WHERE (department = &#39;HR&#39; OR department = &#39;Finance&#39;) AND active = TRUE; </code></p>\r\n\r\n<hr />\r\n<h3>5.10 Summary</h3>\r\n\r\n<p>The&nbsp;<code>WHERE</code>&nbsp;clause enables you to retrieve only the data you need. Mastering filters and condition logic is essential for working efficiently with large datasets and writing accurate reports.</p>\r\n\r\n<hr />\r\n<p>?&nbsp;<strong>Next Chapter:</strong><br />\r\n➡️&nbsp;<em>Chapter 6: Sorting and Limiting Results (ORDER BY &amp; LIMIT)</em></p>','2025-05-30',10.00);
/*!40000 ALTER TABLE `LEARNING_CHAPTER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MESSAGE`
--

DROP TABLE IF EXISTS `MESSAGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MESSAGE` (
  `id_message` int NOT NULL AUTO_INCREMENT,
  `id_sender` int NOT NULL,
  `id_receiver` int NOT NULL,
  `v_text` text,
  `d_sent_at` datetime NOT NULL,
  `n_read_status` tinyint DEFAULT '0',
  PRIMARY KEY (`id_message`),
  KEY `idx_message_sender` (`id_sender`),
  KEY `idx_message_receiver` (`id_receiver`),
  KEY `idx_message_text` (`v_text`(100)),
  CONSTRAINT `MESSAGE_ibfk_1` FOREIGN KEY (`id_sender`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `MESSAGE_ibfk_2` FOREIGN KEY (`id_receiver`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `MESSAGE_chk_1` CHECK ((`n_read_status` in (0,1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MESSAGE`
--

LOCK TABLES `MESSAGE` WRITE;
/*!40000 ALTER TABLE `MESSAGE` DISABLE KEYS */;
/*!40000 ALTER TABLE `MESSAGE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MULTIPLE_OPTION`
--

DROP TABLE IF EXISTS `MULTIPLE_OPTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MULTIPLE_OPTION` (
  `id_option` int NOT NULL AUTO_INCREMENT,
  `id_exercise` int DEFAULT NULL,
  `b_iscorrect` tinyint(1) DEFAULT NULL,
  `v_option` text NOT NULL,
  PRIMARY KEY (`id_option`),
  KEY `id_exercise` (`id_exercise`),
  CONSTRAINT `MULTIPLE_OPTION_ibfk_1` FOREIGN KEY (`id_exercise`) REFERENCES `EXERCISE` (`id_exercise`) ON DELETE RESTRICT,
  CONSTRAINT `MULTIPLE_OPTION_chk_1` CHECK ((`b_iscorrect` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MULTIPLE_OPTION`
--

LOCK TABLES `MULTIPLE_OPTION` WRITE;
/*!40000 ALTER TABLE `MULTIPLE_OPTION` DISABLE KEYS */;
INSERT INTO `MULTIPLE_OPTION` VALUES (1,1,0,'Alice   2023-05-01'),(2,1,0,'Alice.  2023-05-01 Alice	2023-05-01 Bob	2023-05-03'),(3,1,1,'Alice   2023-05-01 Bob	2023-05-03'),(4,1,0,'Bob 2023-05-03'),(5,2,1,'SELECT c.name, o.order_date FROM Customers c INNER JOIN Orders o ON c.customer_id = o.customer_id;'),(6,3,1,'SELECT name, salary FROM employees WHERE department = \'Engineering\' AND salary > 70000;'),(7,4,1,'SELECT *  FROM orders WHERE YEAR(order_date) = 2024 AND total_amount < 100;'),(8,5,1,'SELECT      students.name AS student_name,     courses.title AS course_title,     enrollments.enrollment_date FROM enrollments JOIN students ON enrollments.student_id = students.id JOIN courses ON enrollments.course_id = courses.id JOIN instructors ON courses.instructor_id = instructors.id WHERE instructors.name = \'Dr. Smith\';'),(9,6,1,'Answer_3'),(10,7,1,'ANSWER_5'),(11,8,0,'asdf'),(12,9,1,'pdf'),(13,10,0,'2variable'),(14,10,1,'variable_name'),(15,10,0,'variable-name'),(16,10,0,'@variable'),(17,11,1,'adadsasd'),(18,12,0,'2variable'),(19,12,1,'variable_name'),(20,12,0,'variable-name'),(21,12,0,'@variable'),(22,13,1,'print'),(23,14,1,'sfsd'),(24,15,1,'False'),(25,16,1,'True'),(26,17,1,'SELECT * FROM students WHERE major = \'Computer Sci\';');
/*!40000 ALTER TABLE `MULTIPLE_OPTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STUDENT`
--

DROP TABLE IF EXISTS `STUDENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDENT` (
  `id_student` int NOT NULL AUTO_INCREMENT,
  `id_user` int DEFAULT NULL,
  `n_gpa` decimal(3,2) DEFAULT NULL,
  `d_starting_date` date NOT NULL,
  `d_join_date` date NOT NULL,
  PRIMARY KEY (`id_student`),
  UNIQUE KEY `id_user` (`id_user`),
  KEY `idx_student_user` (`id_user`),
  CONSTRAINT `STUDENT_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `STUDENT_chk_1` CHECK ((`n_gpa` between 0.00 and 4.00))
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STUDENT`
--

LOCK TABLES `STUDENT` WRITE;
/*!40000 ALTER TABLE `STUDENT` DISABLE KEYS */;
INSERT INTO `STUDENT` VALUES (32,22,3.80,'2025-04-05','2025-04-05'),(33,23,3.20,'2025-04-05','2025-04-05'),(38,29,3.80,'2025-04-05','2025-04-05'),(46,38,3.50,'2025-04-05','2025-04-05'),(47,39,3.97,'2025-04-05','2025-04-05'),(48,40,3.69,'2025-04-05','2025-04-05'),(49,42,0.00,'2025-04-05','2025-04-05'),(50,44,0.00,'2025-04-05','2025-04-05'),(51,45,0.00,'2025-04-05','2025-04-05');
/*!40000 ALTER TABLE `STUDENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STUDENT_COURSE`
--

DROP TABLE IF EXISTS `STUDENT_COURSE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDENT_COURSE` (
  `id_student` int NOT NULL,
  `id_course` int NOT NULL,
  PRIMARY KEY (`id_student`,`id_course`),
  KEY `id_course` (`id_course`),
  CONSTRAINT `STUDENT_COURSE_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`) ON DELETE RESTRICT,
  CONSTRAINT `STUDENT_COURSE_ibfk_2` FOREIGN KEY (`id_course`) REFERENCES `COURSE` (`id_course`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STUDENT_COURSE`
--

LOCK TABLES `STUDENT_COURSE` WRITE;
/*!40000 ALTER TABLE `STUDENT_COURSE` DISABLE KEYS */;
INSERT INTO `STUDENT_COURSE` VALUES (47,6),(49,6);
/*!40000 ALTER TABLE `STUDENT_COURSE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STUDENT_EVALUATION`
--

DROP TABLE IF EXISTS `STUDENT_EVALUATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDENT_EVALUATION` (
  `id_student` int NOT NULL,
  `id_evaluation` int NOT NULL,
  `f_score` decimal(5,2) NOT NULL,
  `d_begins` date DEFAULT NULL,
  `d_finish` date DEFAULT NULL,
  `n_score_percentage` decimal(5,2) GENERATED ALWAYS AS ((`f_score` * 100)) VIRTUAL,
  PRIMARY KEY (`id_student`,`id_evaluation`),
  KEY `id_evaluation` (`id_evaluation`),
  CONSTRAINT `fk_student_eval` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`) ON DELETE CASCADE,
  CONSTRAINT `fk_student_evaluation` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`) ON DELETE CASCADE,
  CONSTRAINT `STUDENT_EVALUATION_ibfk_1` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`) ON DELETE CASCADE,
  CONSTRAINT `STUDENT_EVALUATION_ibfk_2` FOREIGN KEY (`id_evaluation`) REFERENCES `EVALUATION` (`id_evaluation`) ON DELETE CASCADE,
  CONSTRAINT `STUDENT_EVALUATION_chk_1` CHECK (((`f_score` >= 0.00) and (`f_score` <= 100.00)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STUDENT_EVALUATION`
--

LOCK TABLES `STUDENT_EVALUATION` WRITE;
/*!40000 ALTER TABLE `STUDENT_EVALUATION` DISABLE KEYS */;
/*!40000 ALTER TABLE `STUDENT_EVALUATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STUDENT_EVALUATION_LLM`
--

DROP TABLE IF EXISTS `STUDENT_EVALUATION_LLM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDENT_EVALUATION_LLM` (
  `id_student` int NOT NULL,
  `id_exercise_llm` int NOT NULL,
  `f_score` decimal(5,2) NOT NULL,
  `d_begins` date DEFAULT NULL,
  `d_finish` date DEFAULT NULL,
  PRIMARY KEY (`id_student`,`id_exercise_llm`),
  KEY `id_exercise_llm` (`id_exercise_llm`),
  CONSTRAINT `STUDENT_EVALUATION_LLM_ibfk_1` FOREIGN KEY (`id_exercise_llm`) REFERENCES `EXERCISE_LLM` (`id_exercise_llm`) ON DELETE CASCADE,
  CONSTRAINT `STUDENT_EVALUATION_LLM_chk_1` CHECK (((`f_score` >= 0.00) and (`f_score` <= 100.00)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STUDENT_EVALUATION_LLM`
--

LOCK TABLES `STUDENT_EVALUATION_LLM` WRITE;
/*!40000 ALTER TABLE `STUDENT_EVALUATION_LLM` DISABLE KEYS */;
INSERT INTO `STUDENT_EVALUATION_LLM` VALUES (19,13,100.00,'2025-04-03','2025-04-03'),(19,14,76.67,'2025-04-03','2025-04-03'),(30,1,85.00,'2025-03-30','2025-03-30'),(30,2,92.50,'2025-03-29','2025-03-29'),(30,4,66.67,'2025-03-31','2025-03-31'),(30,5,100.00,'2025-03-31','2025-03-31'),(30,6,83.33,'2025-03-31','2025-03-31'),(30,7,80.00,'2025-03-31','2025-03-31'),(30,8,53.33,'2025-03-31','2025-03-31'),(30,9,70.00,'2025-03-31','2025-03-31'),(30,10,66.67,'2025-04-01','2025-04-01'),(30,11,83.33,'2025-04-02','2025-04-02'),(30,12,33.33,'2025-04-03','2025-04-03'),(31,3,90.00,'2025-03-30','2025-03-30'),(32,1,85.00,'2025-03-28','2025-03-28'),(32,2,80.00,'2025-03-27','2025-03-27'),(33,1,75.00,'2025-04-05','2025-04-05');
/*!40000 ALTER TABLE `STUDENT_EVALUATION_LLM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_PROFILE`
--

DROP TABLE IF EXISTS `USER_PROFILE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_PROFILE` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PROFILE`
--

LOCK TABLES `USER_PROFILE` WRITE;
/*!40000 ALTER TABLE `USER_PROFILE` DISABLE KEYS */;
INSERT INTO `USER_PROFILE` VALUES (1,'instructor',37),(2,'student',38),(3,'student',39),(4,'student',40),(5,'student',42);
/*!40000 ALTER TABLE `USER_PROFILE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add instructor',7,'add_instructor'),(26,'Can change instructor',7,'change_instructor'),(27,'Can delete instructor',7,'delete_instructor'),(28,'Can view instructor',7,'view_instructor'),(29,'Can add student',8,'add_student'),(30,'Can change student',8,'change_student'),(31,'Can delete student',8,'delete_student'),(32,'Can view student',8,'view_student'),(33,'Can add user profile',9,'add_userprofile'),(34,'Can change user profile',9,'change_userprofile'),(35,'Can delete user profile',9,'delete_userprofile'),(36,'Can view user profile',9,'view_userprofile'),(37,'Can add chapter evaluation',10,'add_chapterevaluation'),(38,'Can change chapter evaluation',10,'change_chapterevaluation'),(39,'Can delete chapter evaluation',10,'delete_chapterevaluation'),(40,'Can view chapter evaluation',10,'view_chapterevaluation'),(41,'Can add chapter exercise',11,'add_chapterexercise'),(42,'Can change chapter exercise',11,'change_chapterexercise'),(43,'Can delete chapter exercise',11,'delete_chapterexercise'),(44,'Can view chapter exercise',11,'view_chapterexercise'),(45,'Can add difficulty level',12,'add_difficultylevel'),(46,'Can change difficulty level',12,'change_difficultylevel'),(47,'Can delete difficulty level',12,'delete_difficultylevel'),(48,'Can view difficulty level',12,'view_difficultylevel'),(49,'Can add evaluation',13,'add_evaluation'),(50,'Can change evaluation',13,'change_evaluation'),(51,'Can delete evaluation',13,'delete_evaluation'),(52,'Can view evaluation',13,'view_evaluation'),(53,'Can add evaluation exercise',14,'add_evaluationexercise'),(54,'Can change evaluation exercise',14,'change_evaluationexercise'),(55,'Can delete evaluation exercise',14,'delete_evaluationexercise'),(56,'Can view evaluation exercise',14,'view_evaluationexercise'),(57,'Can add learning chapter',15,'add_learningchapter'),(58,'Can change learning chapter',15,'change_learningchapter'),(59,'Can delete learning chapter',15,'delete_learningchapter'),(60,'Can view learning chapter',15,'view_learningchapter'),(61,'Can add multiple option',16,'add_multipleoption'),(62,'Can change multiple option',16,'change_multipleoption'),(63,'Can delete multiple option',16,'delete_multipleoption'),(64,'Can view multiple option',16,'view_multipleoption'),(65,'Can add course',17,'add_course'),(66,'Can change course',17,'change_course'),(67,'Can delete course',17,'delete_course'),(68,'Can view course',17,'view_course'),(69,'Can add answer',18,'add_answer'),(70,'Can change answer',18,'change_answer'),(71,'Can delete answer',18,'delete_answer'),(72,'Can view answer',18,'view_answer'),(73,'Can add exercise',19,'add_exercise'),(74,'Can change exercise',19,'change_exercise'),(75,'Can delete exercise',19,'delete_exercise'),(76,'Can view exercise',19,'view_exercise'),(77,'Can add student course',20,'add_studentcourse'),(78,'Can change student course',20,'change_studentcourse'),(79,'Can delete student course',20,'delete_studentcourse'),(80,'Can view student course',20,'view_studentcourse'),(81,'Can add course learn chapter',21,'add_courselearnchapter'),(82,'Can change course learn chapter',21,'change_courselearnchapter'),(83,'Can delete course learn chapter',21,'delete_courselearnchapter'),(84,'Can view course learn chapter',21,'view_courselearnchapter'),(85,'Can add chapter student',22,'add_chapterstudent'),(86,'Can change chapter student',22,'change_chapterstudent'),(87,'Can delete chapter student',22,'delete_chapterstudent'),(88,'Can view chapter student',22,'view_chapterstudent'),(89,'Can add answer multiple option',23,'add_answermultipleoption'),(90,'Can change answer multiple option',23,'change_answermultipleoption'),(91,'Can delete answer multiple option',23,'delete_answermultipleoption'),(92,'Can view answer multiple option',23,'view_answermultipleoption'),(93,'Can add student evaluation',24,'add_studentevaluation'),(94,'Can change student evaluation',24,'change_studentevaluation'),(95,'Can delete student evaluation',24,'delete_studentevaluation'),(96,'Can view student evaluation',24,'view_studentevaluation'),(97,'Can add attempt',25,'add_attempt'),(98,'Can change attempt',25,'change_attempt'),(99,'Can delete attempt',25,'delete_attempt'),(100,'Can view attempt',25,'view_attempt'),(101,'Can add message',26,'add_message'),(102,'Can change message',26,'change_message'),(103,'Can delete message',26,'delete_message'),(104,'Can view message',26,'view_message'),(105,'Can add auth user',27,'add_authuser'),(106,'Can change auth user',27,'change_authuser'),(107,'Can delete auth user',27,'delete_authuser'),(108,'Can view auth user',27,'view_authuser');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$600000$yN1wOQDFcxxiT0zmPHB49x$zylx6oDFW5GZvVZ7HtUa9pnm33LOiOq8y+osUcdtQKk=','2025-04-05 07:43:36.587096',1,'super_user_django','','','lplindaperez10@gmail.com',1,1,'2025-02-13 23:23:36.876865'),(2,'pbkdf2_sha256$600000$ApuKuA3z6ElQuek3WWh93A$zVqUPtY6aaZHsHMhAMpCuEeTRRyTgJzADVljeNVCBnQ=','2025-03-24 17:44:20.928709',0,'lindalpp','','','rosmery.p.p@gmail.com',0,1,'2025-03-24 17:44:03.932740'),(3,'pbkdf2_sha256$600000$YfVpmfI0JxN6o4IfNfF0b7$8M6+/Il+qiP9nQ/W4Rjs8bvGNbJL0rGASiHR55ZZx54=',NULL,0,'','Dorian','Lee','rosmery.p.p@gmail.com',0,1,'2025-03-24 20:40:55.217975'),(5,'pbkdf2_sha256$600000$en3r2fGVqUErF1MRSTXWGZ$i2iA16zKhquN3VIKMqeCvkqOIPTGBx5fd70ZKHzZ1QA=','2025-04-05 05:14:53.159876',0,'lauraLee','Laura','Lee Maux','lauraleemaux@gmail.com',0,1,'2025-03-24 20:45:45.734908'),(6,'pbkdf2_sha256$600000$q1iBkxDahxDvB5WalAmhLm$U1Rf2uEW2hRaTRzRktzB6+RdzshlVbLQb+U4HxZraeQ=',NULL,0,'victorBlax','Victor','Blax','lplinblax@gmail.com',0,1,'2025-03-25 00:15:54.261720'),(7,'pbkdf2_sha256$600000$qAE2ACjPa38iDUpluwmnAE$TkC+xu6FzdJBQK5meI2Z0uFlP//6Gtjq5v/XqO/QMs0=',NULL,0,'James','James','James','james@gmail.com',0,1,'2025-03-25 00:16:49.613542'),(8,'pbkdf2_sha256$600000$eVqtWkFX2H4nasPTVhDLnq$gK5/69ad5JfhZnNbK+y6dOxbRhlDmG9ZVmWBstmD6Bw=','2025-03-28 22:15:05.684780',0,'FeriyaFox','Feiyan','Fox Foxyx','FeriyaFox@gmail.com',0,1,'2025-03-25 00:29:04.202449'),(9,'pbkdf2_sha256$600000$rD29r2LFlXv0od0QgHx29w$xh12ViHgg4PwWrtaSARPsJC527iRHXvXUCywMuMv/FU=',NULL,0,'FiloMena','Filomena','Torres','filomena@gmail.com',0,1,'2025-03-25 04:23:35.701807'),(10,'pbkdf2_sha256$600000$M84N1ut0BThfhj44wbxjJs$DczWwPSX+0QltLg9nsG36fiQn2zVOKCZe/M61TXXi1k=',NULL,0,'FillBrown','Fill','Brown','Fillbrown@gmail.com',0,1,'2025-03-25 04:27:21.762917'),(11,'pbkdf2_sha256$600000$EMXbK9qQvjs6fW2Sri1vZt$+m78ox/8oFjA5vZG4fGgqF6y9fhdeltRtw+wFe4KWf0=',NULL,0,'FillBrown2','Fill','Brown','Fillbrown@gmail.com',0,1,'2025-03-25 04:28:17.774372'),(12,'pbkdf2_sha256$600000$QHmd147Mik4L0gMmaG3yd9$0Iapvku4fLLzItpEgk/K6Bhyp3wwLax/IOuP34F9PVM=',NULL,0,'FillBrown3','Fill','Brown','Fillbrown@gmail.com',0,1,'2025-03-25 05:04:44.366478'),(13,'pbkdf2_sha256$600000$QuRzT9IiFaoOmFES9DD8Jl$7aQm+gkfdt0N1VHCPOqKz6vL2E5vlg+kyu6y+oDiGXA=',NULL,0,'FillBrown4','Fill','Brown','Fillbrown@gmail.com',0,1,'2025-03-25 05:06:12.554025'),(14,'pbkdf2_sha256$600000$7sW56MPyKy1R1tgjH3RKMc$N58ZWO3pD2jqE/Lrwm4YqnZxqBRZYP5m7QbMChK58bs=',NULL,0,'FillBrown5','Fill','Brown','Fillbrown@gmail.com',0,1,'2025-03-25 05:06:42.281862'),(15,'pbkdf2_sha256$600000$5QCNoDqeUP7tNLZvOcY1ZN$qEr4+LQ2O8ctWgPZa5K9NsVyZHWmnDDZTwL4kowfG2g=','2025-04-04 19:55:14.160880',0,'StudenLastname','Rose','Pears','rosmery.p.p@gmail.com',0,1,'2025-03-25 05:09:51.767282'),(16,'pbkdf2_sha256$600000$NCvhvt9XPNzERCHROKFya1$HutjqObE7wg0Qv+zGKJUJudI0KplC1Muu/kQqYNXk/Y=',NULL,0,'adminadmin','admin1','adminLast','rosmery.p.p@gmail.com',0,1,'2025-03-25 05:10:12.338337'),(17,'pbkdf2_sha256$600000$EW0Kx58fTr1oKRM8N9jGCX$C9cNOX2Qo0YYrFBUL9qn/K7RI0PCumLLWDdB3I9tlA0=',NULL,0,'lindaperez10','Linda','Perez','lindaperez10@gmail.com',0,1,'2025-03-25 05:14:57.555500'),(18,'pbkdf2_sha256$600000$bXsXToPuYoNzPZnsndcD1z$EiW8B1W8JZKEUuQXsRIUCmec06UKsN6qvQFDp364Bdc=','2025-03-28 20:54:33.952942',0,'MartaCol','Marta','Colomina','rosmery.p.p@gmail.com',0,1,'2025-03-25 05:23:20.065201'),(19,'pbkdf2_sha256$600000$SMLoUVfQP61UpPRO5eWp9e$4YfbMWriQRghSTHLzO9SxItfZxF6N2TQ0ouzPuUD89w=','2025-04-04 23:22:36.038558',0,'GustShoon','Gustavo','Smith','GustavoSmith@gmail.com',0,1,'2025-03-29 03:59:01.662706'),(20,'pbkdf2_sha256$600000$wTduHv92HKHihQvbSht29s$pK7XYNG3dijn/bFKixiL9mc1lsjuvLa5cJpGLKUEo/M=','2025-04-05 07:22:31.426418',0,'user123','Johnny','Dicksons','user123@gmail.com',0,1,'2025-04-03 06:45:23.655429'),(21,'pbkdf2_sha256$600000$Cs8UMdLsjKE8wNuovEyw90$81WJRpLG64842478O2Bdr1qv283wxMTd0D3C4TjSqEA=','2025-04-05 06:14:32.743793',0,'AdelineRod','Adeline','Rodriguez','adelinerod@gmaill.com',0,1,'2025-04-05 01:59:43.467551'),(22,'pbkdf2_sha256$600000$n5e9Glo87vBEHfEtPKoG0Q$N5LzJRL4lu9IuClGgjIT6DdkGjX54FAvG3sbkr+slZU=','2025-04-05 06:32:44.808817',0,'AdelineSmith','Adeline','Smith','adelinesmith@gmail.com',0,1,'2025-04-05 02:01:08.493835'),(23,'pbkdf2_sha256$600000$CfV3L4jyrWwxAYmjvUZrjI$CINK8rZE+IKWAPjrLGGjIArjo+szUL4DJJgZ/WdIEW8=','2025-04-05 06:33:17.522597',0,'AngBrown','Angelica','Brown','angbrwo@gmaill.com',0,1,'2025-04-05 02:05:31.264385'),(24,'pbkdf2_sha256$600000$VLAlEOLPxIQ9aVP2UDRW6g$5f/vLK7QoCqTSNJ847scX9tJHx5Dzp6tT+seAr4MpUg=',NULL,0,'Regist','Regist','Regist','Regist@gmailc.om',0,1,'2025-04-05 02:10:08.770500'),(25,'pbkdf2_sha256$600000$9BIjgvCH90Js94Z2EWqHKg$1GuOwbeL0dBw7UzlgJ5TnDvbEdAj8eRlCyHXul6bQXo=',NULL,0,'Regist2','Regist2','Regist2','Regist2@gmailc.om',0,1,'2025-04-05 02:12:16.181802'),(26,'pbkdf2_sha256$600000$8WX9urzqmw1iAq6nFYHXWd$w7nK6UpUemIN4GBGjXgbIedCy4vwm92K2PAIbPXMQkQ=',NULL,0,'Reg4','Reg4','Reg4','Reg4@gmail.com',0,1,'2025-04-05 02:14:15.915000'),(27,'pbkdf2_sha256$600000$9XMfdhhNOBaJ9MisIytVqg$4xHQxPBs9LcsDKow3NYrwX5Cs0rRaAfEqSdHk7Zzdy8=','2025-04-05 02:16:18.739375',0,'Reg9','Reg9','Reg9','Reg9@gmail.com',0,1,'2025-04-05 02:16:03.156464'),(28,'pbkdf2_sha256$600000$L5P08hKPOJ9D8SQy3rZRou$OETuJR/6kdSNVDrgEEJP+udl4bJambxL/DCT67v+bDA=','2025-04-05 02:16:50.125588',0,'Int1','Int1','Int1','Int1@mgia.com',0,1,'2025-04-05 02:16:42.561177'),(29,'pbkdf2_sha256$600000$L54yfbAGAxHrwnokG34APq$bvJodH4xPft6bH3lRZ1qjNIk3H05E9CW6Qpczb8KD8E=','2025-04-05 06:33:39.424489',0,'stephgeor','Stephany','Georgebesh','stepgeo@gmail.com',0,1,'2025-04-05 02:21:59.289602'),(30,'pbkdf2_sha256$600000$2DE5YKTHfCgSnDkzjeLS2s$dLGBxbenDSLDR7KDoBffq1NTURFrdQ/jSCVo9xu2D0Q=',NULL,0,'Reg10','Reg10','Reg10','Reg10@mgial.com',0,1,'2025-04-05 02:31:12.363673'),(31,'pbkdf2_sha256$600000$6cJMhfz9vvOnMWO8QHbHPL$WdSpWvIzzBv5VCFMh/aDd4Rkq3NT7UFB+n3N78Ms5Pw=',NULL,0,'re11','re11','re11','re11@gmail.com',0,1,'2025-04-05 02:36:58.337475'),(32,'pbkdf2_sha256$600000$ztJmCSTFx1hHTv3tzSCsQb$2IHMgmmssnSjQtqlA0dUFGil5KfpVXWSVVSIVMBK2l8=',NULL,0,'re12','re12','re12','re12@gmail.com',0,1,'2025-04-05 02:38:32.729961'),(33,'pbkdf2_sha256$600000$ydiifShVCdNjHN3TwXKwAv$fJoxGYHilBzRsDYbp+ATO5b6MnOPsnJ7/4mVkYXjP50=',NULL,0,'re13','re13','re13','reg13@gmail.com',0,1,'2025-04-05 02:42:36.990234'),(34,'pbkdf2_sha256$600000$bOPwRkI5GMKCgcWUw8UMBq$rqYVLwI+9QjRFGcGPZCREP5e2aolnwyWUlNyYCgbZUc=',NULL,0,'re14','re14','re14','re14@gmail.com',0,1,'2025-04-05 02:45:59.174934'),(35,'pbkdf2_sha256$600000$4VsP61maQ5zdqOIdUKNKTE$Lf9WjWdVDKvpvlnlTkqLiP6WIEDKu/VwDGIK9eS/zMM=',NULL,0,'re15','re15','re15','re15@gmail.com',0,1,'2025-04-05 02:47:04.624722'),(36,'pbkdf2_sha256$600000$rGaRcx0Upv30R9opZ9gjvI$/pFTIuGD/OlQIH+wgSpvEHLy7WwRdTr4gTfIIRaSsnE=',NULL,0,'re16','re16','re16','re16@gmail.com',0,1,'2025-04-05 02:55:23.895465'),(37,'pbkdf2_sha256$600000$zb2IMH0Nm0Ju6iC327EicK$EvguD7k/ZSGb5bOG1LdoloGhNnUkfdi4+N+fmBGF4+k=','2025-04-05 07:52:03.150695',0,'lindaperez','Linda','Perez','rosmery.p.p@gmail.com',0,1,'2025-04-05 03:49:15.321945'),(38,'pbkdf2_sha256$600000$wwYy8454dbmQsxjoOSro21$xTNgIIWWJwWneUU1WY/fHibKdYcU6m2BSRnqnUWnwXg=',NULL,0,'GustStudent','Gustavo','Alvares','gustalv@gmail.com',0,1,'2025-04-05 05:12:35.007363'),(39,'pbkdf2_sha256$600000$6UdRtcxdmK0qbK7D7DVMBJ$GKmdcZ+pt36ZquDZMEayhnaPg+c8H79oTUbuWWxON8o=','2025-04-05 07:36:07.582577',0,'FeiZhou','Feiyan','Zhou','FeiZhou@gmail.com',0,1,'2025-04-05 05:13:37.971546'),(40,'pbkdf2_sha256$600000$DsfzBHAiG3GZyobYI6c2o7$1i5tQHDgBhMgSDyCew0NDqxs6DbDXGfniD46yA+Dh+M=','2025-04-05 06:19:01.681197',0,'AngelaSmith','Angela','Smith','AngelaSmith@gmail.com',0,1,'2025-04-05 05:14:41.713438'),(41,'pbkdf2_sha256$600000$7tvLPjiGKnXWzeI2V4fExO$oz6A0oZsTY/OqJ8VSwc9aLDRo+FNJVv5EtCxycKbDTE=','2025-04-05 09:34:21.074331',0,'123User','123User','User','123User@gmail.com',0,1,'2025-04-05 06:34:57.549096'),(42,'pbkdf2_sha256$600000$7bRH5pjiPrfyv1LjYAv9Fv$FDyNa3DxBtN96lWe/ZCirvHMG4eJGy4m9zHV+ge0NyA=','2025-04-05 07:50:48.806347',0,'QingLiu','Qingyang','Liu','QingLiu@gmail.com',0,1,'2025-04-05 07:50:41.026984'),(43,'pbkdf2_sha256$600000$PbGVI6puO1eZlaCyvfmtMx$JVuf/bXTcsS2UJQsNS0J5esYMemm3TFkKb+es07pz/w=',NULL,0,'jdavis','James','Davis','jdavis@lakers.com',0,1,'2025-04-05 09:37:10.759748'),(44,'pbkdf2_sha256$600000$udbV5b8lRXBFWE8leApxME$VTjCruz/r7Q0TQKOkfB77Vm9i7ean70GvPzlBZ96qV8=','2025-04-05 09:41:09.090893',0,'jdavid','james','David','jdavid@lakers.com',0,1,'2025-04-05 09:41:03.707774'),(45,'pbkdf2_sha256$600000$JOmRuCH1bqpumR0cndJ0qx$aT9xCgh8cReOZCglk6uR/ndUjBRFydFWb+FWP0S7x5o=','2025-04-05 10:20:07.089414',0,'davidj','Davidson','James','dj@lakers.com',0,1,'2025-04-05 09:44:01.025785'),(46,'pbkdf2_sha256$600000$fuptEVMbkdHyjcvg50eDHh$MVBUsxYdI8dzrpWexqsFpRWAaSx7y3od7NNdIlovOCY=',NULL,0,'markj','Mark','Johnson','markj@neu.edu',0,1,'2025-04-05 09:53:46.852698'),(47,'pbkdf2_sha256$600000$8REBDy0XTkpHaTlQ3QXXtL$jFGee+d2gktakPH/vn7r8duwGdJI6/itb8+gfH9k2/w=','2025-04-05 10:24:04.376350',0,'markb','Martin','Brown','mb345@neu.edu',0,1,'2025-04-05 09:58:02.350414');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(18,'myapp','answer'),(23,'myapp','answermultipleoption'),(25,'myapp','attempt'),(27,'myapp','authuser'),(10,'myapp','chapterevaluation'),(11,'myapp','chapterexercise'),(22,'myapp','chapterstudent'),(17,'myapp','course'),(21,'myapp','courselearnchapter'),(12,'myapp','difficultylevel'),(13,'myapp','evaluation'),(14,'myapp','evaluationexercise'),(19,'myapp','exercise'),(7,'myapp','instructor'),(15,'myapp','learningchapter'),(26,'myapp','message'),(16,'myapp','multipleoption'),(8,'myapp','student'),(20,'myapp','studentcourse'),(24,'myapp','studentevaluation'),(9,'myapp','userprofile'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-02-13 23:16:50.473515'),(2,'auth','0001_initial','2025-02-13 23:16:53.122392'),(3,'admin','0001_initial','2025-02-13 23:16:53.672848'),(4,'admin','0002_logentry_remove_auto_add','2025-02-13 23:16:53.744026'),(5,'admin','0003_logentry_add_action_flag_choices','2025-02-13 23:16:53.800069'),(6,'contenttypes','0002_remove_content_type_name','2025-02-13 23:16:54.098582'),(7,'auth','0002_alter_permission_name_max_length','2025-02-13 23:16:54.291694'),(8,'auth','0003_alter_user_email_max_length','2025-02-13 23:16:54.409656'),(9,'auth','0004_alter_user_username_opts','2025-02-13 23:16:54.446864'),(10,'auth','0005_alter_user_last_login_null','2025-02-13 23:16:54.617611'),(11,'auth','0006_require_contenttypes_0002','2025-02-13 23:16:54.714839'),(12,'auth','0007_alter_validators_add_error_messages','2025-02-13 23:16:54.782193'),(13,'auth','0008_alter_user_username_max_length','2025-02-13 23:16:54.982351'),(14,'auth','0009_alter_user_last_name_max_length','2025-02-13 23:16:55.221404'),(15,'auth','0010_alter_group_name_max_length','2025-02-13 23:16:55.297320'),(16,'auth','0011_update_proxy_permissions','2025-02-13 23:16:55.413519'),(17,'auth','0012_alter_user_first_name_max_length','2025-02-13 23:16:55.616562'),(18,'sessions','0001_initial','2025-02-13 23:16:55.798486'),(29,'myapp','0003_message','2025-04-03 06:50:28.280432'),(30,'myapp','0004_message_subject','2025-04-03 07:08:38.466986'),(63,'myapp','0001_initial','2025-04-05 03:47:12.101262'),(64,'myapp','0002_chapterevaluation_chapterexercise_difficultylevel_and_more','2025-04-05 03:47:12.941542'),(65,'myapp','0003_alter_learningchapter_options','2025-04-05 03:47:13.016310'),(66,'myapp','0004_alter_learningchapter_options_studentcourse_and_more','2025-04-05 03:47:15.664472'),(67,'myapp','0005_studentevaluation','2025-04-05 03:47:16.341065'),(68,'myapp','0006_alter_course_options','2025-04-05 03:47:16.419670'),(69,'myapp','0007_alter_course_table','2025-04-05 03:47:16.498631'),(70,'myapp','0008_attempt','2025-04-05 03:47:17.102234'),(71,'myapp','0009_alter_studentcourse_options','2025-04-05 03:47:17.181293'),(72,'myapp','0010_alter_studentcourse_table','2025-04-05 03:47:17.263396'),(73,'myapp','0011_alter_studentevaluation_options','2025-04-05 03:47:17.346568'),(74,'myapp','0012_alter_answer_v_answer_alter_studentevaluation_table','2025-04-05 03:47:17.544902'),(75,'myapp','0013_alter_answermultipleoption_answer_and_more','2025-04-05 03:47:17.636436'),(76,'myapp','0014_remove_answer_submitted_at','2025-04-05 03:47:17.778686'),(77,'myapp','0015_alter_answer_options_and_more','2025-04-05 03:47:17.876503'),(78,'myapp','0016_alter_answer_table_alter_answermultipleoption_table_and_more','2025-04-05 03:47:17.971133'),(79,'myapp','0017_alter_chapterstudent_options','2025-04-05 03:47:18.050738'),(80,'myapp','0018_alter_chapterstudent_options','2025-04-05 03:47:18.209799'),(81,'myapp','0019_alter_userprofile_options_alter_userprofile_table','2025-04-05 03:47:18.355596'),(82,'myapp','0002_auto_20250405_0342','2025-04-05 04:13:42.643944'),(83,'myapp','0003_alter_message_subject','2025-04-05 04:34:10.753601');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0556ctyfbb6tsmg8fcagjlhgk8mj1bp9','.eJxVjEEOwiAQRe_C2hCEgQGX7nsGMsNQWzVtUtqV8e7apAvd_vfef6lM2zrkrdUlj6IuyqvT78ZUHnXagdxpus26zNO6jKx3RR-06W6W-rwe7t_BQG341ohGyKATCGQSI0QUz5QQA4FzPnmMDortqbeRIAU5M0OwFqIvwl69P8TCNyU:1tyG7h:b48g1YzMx69LJxBVPKBTxvRuPb1_aJ4WINk4MkeqvyE','2025-04-11 20:16:13.858006'),('2aj1s5o8qbph4tpukiyqv2d83v0d5ukx','.eJxVjMEOwiAQRP-FsyF0WZB69O43kGWXStXQpLQn47_bJj3oaZJ5b-atIq1LiWvLcxxFXVSnTr9dIn7mugN5UL1Pmqe6zGPSu6IP2vRtkvy6Hu7fQaFWtjVyQhEgBxCcsdYHgkxo-px6G4QshC0MQ4eCzogweR54sHQGRJ_U5wva3Tfp:1tj9Dk:oz3_smOv25jUVMZTNUuw_Y3Kia6VHuKtEBBxYSp79g0','2025-03-01 03:52:00.467699'),('30v8zpix4i32yz1ogxk45eqrcap5t2tv','eyJrZXl3b3JkIjoid2l0aCJ9:1u0F3z:ti3F72nD6yBifgWMguzsJY--xv5GGpxip8Mka11ZuPY','2025-04-17 07:32:35.747654'),('3ycejf13g9lf5ur6z6l6gdixkcxmiuy5','.eJxVjEEOwiAQRe_C2hCEgQGX7nsGMsNQWzVtUtqV8e7apAvd_vfef6lM2zrkrdUlj6IuyqvT78ZUHnXagdxpus26zNO6jKx3RR-06W6W-rwe7t_BQG341ohGyKATCGQSI0QUz5QQA4FzPnmMDortqbeRIAU5M0OwFqIvwl69P8TCNyU:1tyHb0:znD_ubcAb4iofeDsqoW_8kOqQZYKRnPXXmsBpx0CrrI','2025-04-11 21:50:34.430219'),('3zmysn87xdjpc57am9cywsnubpors2dg','.eJxVjEEOwiAQRe_C2hBghkJduvcMBIZBqoYmpV0Z765NutDtf-_9lwhxW2vYOi9hyuIs0InT75giPbjtJN9ju82S5rYuU5K7Ig_a5XXO_Lwc7t9Bjb1-a1Z6cB4oumyRiVihZWu1Io9gkimjK2YkZwp6kyMUAsgMPiHqgYHF-wMGyzgO:1u10J4:cRLF5BZqvp5ZGEMrO_h1FQC8PleuL6WmS60c9tfSYNw','2025-04-19 09:59:18.205639'),('4vnpkbjlbjzk8x1pf79jiv6ntf9mzqzx','e30:1txJkb:MjoljMrVd2E7VZqmPePUkOYYK5h68iwq3Dovmo16jq4','2025-04-09 05:56:29.388677'),('7b053my09tdvvjkkauy9c9up0bdjiusn','.eJzNVVFP2zAQ_itWnkAKyHYSO2HapEI7hjRga0FoWqZiJw6KBoE1KRpC_Pfd2U1xJkBo28N4gPPl7vzdd9-Z-6BT7fc22Pl6H9RlsMPCoKu7SxPsBPkyNpXOlwlXjDCycTbLtthmEAalaYtFfdPV180qrDAQVkmWLzMhONhGSfBXcZkv01SkGMPBFlwl8DWOFdoxhd-SZhBTlVBBGgMxSWQqsBOeDutElHK4vP1xCZeen5-DkTezycfJ3gkZH8xODo7AUNutUd28LvPm_fT4kOzVjblSRIW9pfPm7MNkOiGj3dnGOppsEd3bm-QtYXkzOhpDtWphDJ4JHvX6mDfH0_FkSna_PN74Jm8AFSA0P28uVaPW9EBzmSVAzT5_xI4NcJBqgzxxnvW9xiYV4GdG9XyICNmSIo3BTnSGHFPgpqpoAUxTZiMLYEjoMkY7jXzODsZ9dlIanBCNIA8GVOEMuMA7I8XwD0JKokINKfdD_bEIKRIcoMSirHrlMFdQvPqukcRIgc1i7hB8EsUSfWmF3zPe21YKD6FTLH9Gsdwplj-l2IEOdVH1gGSkEITW2LC0rbqvMDycAdIkJLOe2F6EWQlD5btcN8Ukw9kkBQO_MBHW4bR6WcOKbYNu7swCtBSSvCHuB9zm1jTdvFSdCdfu2enhhuLbF-rKtHObB8IdzYjvmLfX80otVqswKrr6tu7uoGLoHXi_EP79oHEovj6utsFHQt7ZkEdH3uxPj08_2ZUYdDJI-1-W5HHQVmdxWtja2ipIDEft1C5L3IVU4778vWRclsO1wu7JRNBIY66kv2k9ekbrkdN69LTWvTX1oVEuLbl6CDzJLN0OlAPCGbULnb2s4AvTlGYRklLdhVagFwtVGivL7rpTlysh7qO39fTi5XkPq-f9I9XoKhtCd_-I3DszaN5O358UlNUYH-PrxKnACkU8fK-cEqTO5L-g1VWG95MiHmpeh_Pl9_Hbwy9acHgK:1txJVr:SQgUwNMlb_67jwQwiB5BRU_69-daRFT0Ad50ORhtL4w','2025-04-09 05:41:15.618793'),('9eg94apvr13i6llb9ounooj1sjum0f6g','.eJxVjDsOwjAQBe_iGlnrzfojSnrOYPmzxgFkS3FSIe4OkVJA-2bmvYQP21r9NnjxcxZnocXpd4shPbjtIN9Du3WZeluXOcpdkQcd8tozPy-H-3dQw6jfGh0QgplUUiGDdZCyZmSLDI6S0tOEXAxTIGRTqCiOqJnAmqghURHvD8FQN1s:1u0t9S:25nZSBXD62_BMSEJuni9xaZz6R9ZShNQ5k2kAjhn2s4','2025-04-19 02:20:54.932555'),('a6jzu9yklnxhi3n4r8u9m0uh5k5jb2mo','.eJxVjDsOwjAQBe_iGlkxxhtDSZ8zWLv7bBxAiZRPhbg7REoB7ZuZ9zKJ16Wmdc5T6mEuxrfm8DsK6yMPG8Gdh9todRyWqRe7KXans-1G5Od1d_8OKs_1W5dIKsfWRfIC9SWikAMXjSFn9qy5KDkBJOqpPTdNcAQmCAEIMZj3B0iBOcM:1u0xDb:la3wOOZ4768U8ZeKM9080oX9lZcVFGCpA_lGnvlAkGI','2025-04-19 06:41:27.800204'),('b2q53e532o4yw11kakf8t2il5bhezdh6','.eJxVjDsOwjAQBe_iGllRxNobSnrOEO1br3EAOVI-VcTdIVIKaN_MvM31si6lX2eb-iG5i2N3-t0g-rS6g_SQeh-9jnWZBvhd8Qed_W1M9roe7t9Bkbl8a7MQYoQxoISIqAZVRkecgmTTxs6ENhIRd9oKmBq2gGScM6K49wcpIDmo:1txUhZ:PGL77PluGaVR6md_6XPl5o_YzYkycZbn2mqkzWpakIo','2025-04-09 17:38:05.633821'),('cyea4qvcnv9juq9og08ue0kdgtff5sni','.eJxVjEEOwiAQRe_C2hBghkJduvcMBIZBqoYmpV0Z765NutDtf-_9lwhxW2vYOi9hyuIs0InT75giPbjtJN9ju82S5rYuU5K7Ig_a5XXO_Lwc7t9Bjb1-a1Z6cB4oumyRiVihZWu1Io9gkimjK2YkZwp6kyMUAsgMPiHqgYHF-wMGyzgO:1u10h2:mdvOCO_BR79ku_t_o_aK5d6jkvXsqrFKWUPBLb20P8U','2025-04-19 10:24:04.426813'),('cyigvcadji7mm6dhkmdlmyxphi7iiljv','eyJrZXl3b3JkIjoiV2l0aCJ9:1tzk02:h6fAsz9B7DoZp7CHOupe6ohPGsRpvRW5xbwXGPZUG1I','2025-04-02 22:22:26.385465'),('e2r1gs58tz1cdbylsaowcw7fxo20hljr','.eJxVjMEOwiAQRP-FsyF0WZB69O43kGWXStXQpLQn47_bJj3oaZJ5b-atIq1LiWvLcxxFXVSnTr9dIn7mugN5UL1Pmqe6zGPSu6IP2vRtkvy6Hu7fQaFWtjVyQhEgBxCcsdYHgkxo-px6G4QshC0MQ4eCzogweR54sHQGRJ_U5wva3Tfp:1twXqV:1pECxjpE8P6xpbhmeKAhQRDeGS_oVyHomohQhEq9Du0','2025-04-07 02:47:23.272714'),('g0hwdxwtcl1gvu6xuz263shvsh3upqk3','.eJxVjEEOwiAQRe_C2hCEgQGX7nsGMsNQWzVtUtqV8e7apAvd_vfef6lM2zrkrdUlj6IuyqvT78ZUHnXagdxpus26zNO6jKx3RR-06W6W-rwe7t_BQG341ohGyKATCGQSI0QUz5QQA4FzPnmMDortqbeRIAU5M0OwFqIvwl69P8TCNyU:1twqR1:Jxgs2Sd-8QgfAL62E8slYa9ZZXDaXpeT9lhwf6V6Hjc','2025-04-07 22:38:19.201594'),('g8o8xd21o4c59mnitk8p5jk3tsl47dj6','eyJrZXl3b3JkIjoid2l0aCJ9:1u0O6N:xnAUI0ajSI6Oz4rqCbQRFVDU8STCeE-N0vgLQDvcbuU','2025-04-17 17:11:39.845133'),('m31s0w9xl5qna2ipheaap8aussj7b2es','e30:1txCgv:Q52N1AJRdPlEWYg4hknM2BVr1RQq0gkjy1Iq8rYWzag','2025-04-08 22:24:13.042438'),('mwlxg6elhrq8n0a0cqfj8zakms5tzmag','.eJxVjDsOwjAQBe_iGllrG3-gpOcM1u56gwPIkeKkQtwdIqWA9s3Me6mM61Lz2mXOY1FnZU7q8DsS8kPaRsod223SPLVlHklvit5p19epyPOyu38HFXv91t6adPQuEnCgIRbjPBghW9imJDBIBPICRMkyO7YhUnDAGMkjuWjU-wP_NDga:1u0Zku:XlY1cDoC5nWoac-YwiQ5p3eAQ1eIApIuf645l_zmsDo','2025-04-18 05:38:16.287914'),('p4nnu9ul1ab28vpiqib7p3buiu1h16qx','.eJxVjDsOwjAQBe_iGlkxxhtDSZ8zWLv7bBxAiZRPhbg7REoB7ZuZ9zKJ16Wmdc5T6mEuxrfm8DsK6yMPG8Gdh9todRyWqRe7KXans-1G5Od1d_8OKs_1W5dIKsfWRfIC9SWikAMXjSFn9qy5KDkBJOqpPTdNcAQmCAEIMZj3B0iBOcM:1u0yJv:e5r9LRLEiChGSRqhZQyoQMWWdz8e_hXyHmw79-RYZSw','2025-04-19 07:52:03.186778'),('tkj2c7h2c00t5zp5dvfajqucwixn6m2a','.eJxlkM9KAzEQxl9lyElhtw_QsxfBooh6EZFpdrqbNsmsycR1KX13J9sqgseE78_vm6OxA8r74LJwms369WgSezJrUzIl0xjLUSiKfkwqBJfhZo-xZ3NqfqWYs_pRVX_1Z111IAyuH1pPn-Rhoi3sEgaaOB1gSk5UDy7CwywDR5BaQ9FySdhThoSj66CrXh6DRgPGDqwnjA2Mqgkozqoguz6u4FZgx97zlDWJYMMd-fbF0dQ-URg9CgEmOzghK9rgYUQFSHFJVdbJqWEGXd9pUIJtcb5zsYdujhi0qPLjOHpntZdjXsHP0Gh9UYzFIq0u2hFqh_7kYgdAPUQE3u61uU3kF7sCBE2rBVf3j5tryHMWCg1gUfwol5YGnh_vIHERVTYVLGQYFNkv78oeOFGjYYea5fSEmOdlweV0lPQifN4DlvUW9PVvDHwUZw9-XpnT2-kb58LEZg:1txBEH:Rsa2vaC3BJrE4Vz9Cb1Ccoo8XC7WWdGgrndjoEG4Y18','2025-04-08 20:50:33.434399'),('u1jngqmskw3kpqupfkkhblgy39ye0kcg','e30:1txwDj:m1SAJo6Uk5BtdgGhOX6aRx3V037jyRIgKoBOlaCR8mo','2025-04-10 23:01:07.651097'),('v7ot0ysxt5matfdf0y2vk1sd9otdinwz','.eJxVjEEOwiAQRe_C2hCEgQGX7nsGMsNQWzVtUtqV8e7apAvd_vfef6lM2zrkrdUlj6IuyqvT78ZUHnXagdxpus26zNO6jKx3RR-06W6W-rwe7t_BQG341ohGyKATCGQSI0QUz5QQA4FzPnmMDortqbeRIAU5M0OwFqIvwl69P8TCNyU:1tyIdV:-FdiYqeBpzYeKZ6Bka6bEEzjZ0MAqp0ziT8b6wqjv8c','2025-04-11 22:57:13.964115'),('vvtabo62znfedm5oiflfyvs3rp2jpe4o','.eJxVjMEOwiAQRP-FsyF0WZB69O43kGWXStXQpLQn47_bJj3oaZJ5b-atIq1LiWvLcxxFXVSnTr9dIn7mugN5UL1Pmqe6zGPSu6IP2vRtkvy6Hu7fQaFWtjVyQhEgBxCcsdYHgkxo-px6G4QshC0MQ4eCzogweR54sHQGRJ_U5wva3Tfp:1tj94n:WRrQVDMt6qXHG66zdEw4-XJFO5Qm1_fF2CJca-W6rUc','2025-03-01 03:42:45.362594'),('wsx77f38pv66t7uddxcih2b6acynkrkq','.eJxVjMEOwiAQRP-FsyF0WZB69O43kGWXStXQpLQn47_bJj3oaZJ5b-atIq1LiWvLcxxFXVSnTr9dIn7mugN5UL1Pmqe6zGPSu6IP2vRtkvy6Hu7fQaFWtjVyQhEgBxCcsdYHgkxo-px6G4QshC0MQ4eCzogweR54sHQGRJ_U5wva3Tfp:1tk5f1:RSdGN2iutybyak6ztPMYIIDGywm1UlA4wMLrK6We0k0','2025-03-03 18:16:03.637885'),('zl45b3sb9x0fffskgcf70vjpaeaxt6us','.eJxVjEEOgjAQRe_StWmmZQasS_ecgcxMW4saSCisjHdXEha6_e-9_zIDb2sZtpqWYYzmYhDN6XcU1keadhLvPN1mq_O0LqPYXbEHrbafY3peD_fvoHAt37qBrJSBoCUfMHVeI7eAmcFlPafGCQdF8KSSGZ0jEgnCyF1Gj9Ca9wcHpjgU:1u101V:AnwdTgXkzHzzUEVOTFz8dwqrQa6HyrG2nHY3B5DVJvQ','2025-04-19 09:41:09.146267');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_answer`
--

DROP TABLE IF EXISTS `myapp_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_answer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `v_answer` longtext COLLATE utf8mb4_unicode_ci,
  `n_score` decimal(5,2) DEFAULT NULL,
  `b_iscorrect` tinyint(1) DEFAULT NULL,
  `exercise_id` int NOT NULL,
  `student_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_answer_exercise_id_8c90c4a5_fk_EXERCISE_id_exercise` (`exercise_id`),
  KEY `myapp_answer_student_id_64622d3a_fk_STUDENT_id_student` (`student_id`),
  CONSTRAINT `myapp_answer_exercise_id_8c90c4a5_fk_EXERCISE_id_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `EXERCISE` (`id_exercise`),
  CONSTRAINT `myapp_answer_student_id_64622d3a_fk_STUDENT_id_student` FOREIGN KEY (`student_id`) REFERENCES `STUDENT` (`id_student`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_answer`
--

LOCK TABLES `myapp_answer` WRITE;
/*!40000 ALTER TABLE `myapp_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_answermultipleoption`
--

DROP TABLE IF EXISTS `myapp_answermultipleoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_answermultipleoption` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_answer` int NOT NULL,
  `id_option` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myapp_answermultipleoption_id_option_id_answer_fc51a0d9_uniq` (`id_option`,`id_answer`),
  KEY `myapp_answermultipleoption_id_answer_45bf3f74_fk_myapp_answer_id` (`id_answer`),
  CONSTRAINT `myapp_answermultiple_id_option_720665c0_fk_MULTIPLE_` FOREIGN KEY (`id_option`) REFERENCES `MULTIPLE_OPTION` (`id_option`),
  CONSTRAINT `myapp_answermultipleoption_id_answer_45bf3f74_fk_myapp_answer_id` FOREIGN KEY (`id_answer`) REFERENCES `myapp_answer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_answermultipleoption`
--

LOCK TABLES `myapp_answermultipleoption` WRITE;
/*!40000 ALTER TABLE `myapp_answermultipleoption` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_answermultipleoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_attempt`
--

DROP TABLE IF EXISTS `myapp_attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_attempt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `d_began` datetime(6) NOT NULL,
  `d_finished` datetime(6) NOT NULL,
  `n_attempt_number` int NOT NULL,
  `id_answer` int NOT NULL,
  `id_option` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myapp_attempt_id_answer_id_option_4c91d273_uniq` (`id_answer`,`id_option`),
  KEY `myapp_attempt_id_option_9834d10d_fk_MULTIPLE_OPTION_id_option` (`id_option`),
  CONSTRAINT `myapp_attempt_id_answer_37a69ff1_fk_myapp_answer_id` FOREIGN KEY (`id_answer`) REFERENCES `myapp_answer` (`id`),
  CONSTRAINT `myapp_attempt_id_option_9834d10d_fk_MULTIPLE_OPTION_id_option` FOREIGN KEY (`id_option`) REFERENCES `MULTIPLE_OPTION` (`id_option`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_attempt`
--

LOCK TABLES `myapp_attempt` WRITE;
/*!40000 ALTER TABLE `myapp_attempt` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_attempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_chapterstudent`
--

DROP TABLE IF EXISTS `myapp_chapterstudent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_chapterstudent` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `n_score` decimal(5,2) DEFAULT NULL,
  `n_ranking` int NOT NULL,
  `d_begin` date NOT NULL,
  `d_finish` date DEFAULT NULL,
  `id_learningchapter` int NOT NULL,
  `id_student` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myapp_chapterstudent_id_student_id_learningchapter_88571610_uniq` (`id_student`,`id_learningchapter`),
  KEY `myapp_chapterstudent_id_learningchapter_f62ba8ff_fk_LEARNING_` (`id_learningchapter`),
  CONSTRAINT `myapp_chapterstudent_id_learningchapter_f62ba8ff_fk_LEARNING_` FOREIGN KEY (`id_learningchapter`) REFERENCES `LEARNING_CHAPTER` (`id_learningchapter`),
  CONSTRAINT `myapp_chapterstudent_id_student_76a082fd_fk_STUDENT_id_student` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_chapterstudent`
--

LOCK TABLES `myapp_chapterstudent` WRITE;
/*!40000 ALTER TABLE `myapp_chapterstudent` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_chapterstudent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_course`
--

DROP TABLE IF EXISTS `myapp_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_course` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` date NOT NULL,
  `starting_at` date NOT NULL,
  `finishing_at` date NOT NULL,
  `instructor_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_course_instructor_id_e9c2d6e9_fk_INSTRUCTOR_id_instructor` (`instructor_id`),
  CONSTRAINT `myapp_course_instructor_id_e9c2d6e9_fk_INSTRUCTOR_id_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `INSTRUCTOR` (`id_instructor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_course`
--

LOCK TABLES `myapp_course` WRITE;
/*!40000 ALTER TABLE `myapp_course` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_courselearnchapter`
--

DROP TABLE IF EXISTS `myapp_courselearnchapter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_courselearnchapter` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `chapter_id` int NOT NULL,
  `course_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myapp_courselearnchapter_course_id_chapter_id_c9134a14_uniq` (`course_id`,`chapter_id`),
  KEY `myapp_courselearncha_chapter_id_ddc44991_fk_LEARNING_` (`chapter_id`),
  CONSTRAINT `myapp_courselearncha_chapter_id_ddc44991_fk_LEARNING_` FOREIGN KEY (`chapter_id`) REFERENCES `LEARNING_CHAPTER` (`id_learningchapter`),
  CONSTRAINT `myapp_courselearnchapter_course_id_2b390993_fk_myapp_course_id` FOREIGN KEY (`course_id`) REFERENCES `myapp_course` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_courselearnchapter`
--

LOCK TABLES `myapp_courselearnchapter` WRITE;
/*!40000 ALTER TABLE `myapp_courselearnchapter` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_courselearnchapter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_message`
--

DROP TABLE IF EXISTS `myapp_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sender` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `receiver` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_message`
--

LOCK TABLES `myapp_message` WRITE;
/*!40000 ALTER TABLE `myapp_message` DISABLE KEYS */;
INSERT INTO `myapp_message` VALUES (1,'user123','user123','Test','Hello!',0,'2025-04-05 05:26:27'),(2,'123User','user123','123','123',0,'2025-04-05 06:37:08'),(3,'123User','123User','','123',0,'2025-04-05 06:37:17'),(4,'123User','user123','','hi',0,'2025-04-05 06:43:39'),(5,'123User','123User','','12121',0,'2025-04-05 06:55:50'),(6,'123User','123User','','12121',0,'2025-04-05 06:55:50'),(7,'123User','123User','','121',0,'2025-04-05 06:55:58'),(8,'123User','123User','','121',0,'2025-04-05 06:55:58'),(9,'123User','123User','','L12',0,'2025-04-05 06:56:13'),(10,'123User','123User','','L12',0,'2025-04-05 06:56:13'),(11,'123User','user123','','Jsca1',0,'2025-04-05 06:58:32'),(12,'123User','user123','','Jsca1',0,'2025-04-05 06:58:32'),(13,'123User','user123','','asdas',0,'2025-04-05 06:59:06'),(14,'123User','user123','','asdas',0,'2025-04-05 06:59:06'),(15,'123User','user123','','121',0,'2025-04-05 06:59:32'),(16,'123User','123User','','sadas',0,'2025-04-05 06:59:47'),(17,'123User','user123','','asda',0,'2025-04-05 07:20:24'),(18,'123User','123User','','ASSA',0,'2025-04-05 07:20:57'),(19,'123User','123User','','asdas',0,'2025-04-05 07:21:12'),(20,'123User','123User','','asdas',0,'2025-04-05 07:21:12'),(21,'user123','123User','','asasda',0,'2025-04-05 07:22:47'),(22,'123User','user123','','Hi',0,'2025-04-05 08:12:19'),(23,'davidj','user123','Questions about HW7','Hi! Do you know whats due date for HW7? I cant seem to find it on canvas!',0,'2025-04-05 09:45:47'),(24,'user123','davidj','','Oh i think its due first Sunday of April',0,'2025-04-05 09:46:55'),(25,'davidj','user123','','Cool thanks',0,'2025-04-05 09:50:19'),(26,'markb','davidj','Research Project','Hi, David! I have received you research proposal and it looks interesting. Could we set up a time to discuss further?',0,'2025-04-05 10:01:32'),(27,'davidj','markb','','Yes sir! I\'m available all day tomorrow!',0,'2025-04-05 10:01:55'),(28,'markb','davidj','','Great! See you during my office hour at 10?',0,'2025-04-05 10:02:43'),(29,'davidj','markb','','Sounds good!',0,'2025-04-05 10:08:39'),(30,'markb','davidj','','Perfect!',0,'2025-04-05 10:08:55');
/*!40000 ALTER TABLE `myapp_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_studentcourse`
--

DROP TABLE IF EXISTS `myapp_studentcourse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_studentcourse` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `course_id` bigint NOT NULL,
  `student_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myapp_studentcourse_student_id_course_id_1e23a645_uniq` (`student_id`,`course_id`),
  KEY `myapp_studentcourse_course_id_1fe7e76c_fk_myapp_course_id` (`course_id`),
  CONSTRAINT `myapp_studentcourse_course_id_1fe7e76c_fk_myapp_course_id` FOREIGN KEY (`course_id`) REFERENCES `myapp_course` (`id`),
  CONSTRAINT `myapp_studentcourse_student_id_13e61b58_fk_STUDENT_id_student` FOREIGN KEY (`student_id`) REFERENCES `STUDENT` (`id_student`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_studentcourse`
--

LOCK TABLES `myapp_studentcourse` WRITE;
/*!40000 ALTER TABLE `myapp_studentcourse` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_studentcourse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_studentevaluation`
--

DROP TABLE IF EXISTS `myapp_studentevaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_studentevaluation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `f_score` decimal(5,2) NOT NULL,
  `d_begins` date DEFAULT NULL,
  `d_finish` date DEFAULT NULL,
  `id_evaluation` int NOT NULL,
  `id_student` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `myapp_studentevaluation_id_student_id_evaluation_3be393e4_uniq` (`id_student`,`id_evaluation`),
  KEY `myapp_studentevaluat_id_evaluation_8bd22a4f_fk_EVALUATIO` (`id_evaluation`),
  CONSTRAINT `myapp_studentevaluat_id_evaluation_8bd22a4f_fk_EVALUATIO` FOREIGN KEY (`id_evaluation`) REFERENCES `EVALUATION` (`id_evaluation`),
  CONSTRAINT `myapp_studentevaluat_id_student_0cb076be_fk_STUDENT_i` FOREIGN KEY (`id_student`) REFERENCES `STUDENT` (`id_student`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_studentevaluation`
--

LOCK TABLES `myapp_studentevaluation` WRITE;
/*!40000 ALTER TABLE `myapp_studentevaluation` DISABLE KEYS */;
/*!40000 ALTER TABLE `myapp_studentevaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `myapp_userprofile`
--

DROP TABLE IF EXISTS `myapp_userprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `myapp_userprofile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `user_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `userprofile_user_fk` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `myapp_userprofile`
--

LOCK TABLES `myapp_userprofile` WRITE;
/*!40000 ALTER TABLE `myapp_userprofile` DISABLE KEYS */;
INSERT INTO `myapp_userprofile` VALUES (1,1,''),(2,2,''),(3,3,''),(4,5,''),(5,6,''),(6,7,''),(7,8,''),(8,9,''),(9,10,''),(10,11,''),(11,12,''),(12,13,''),(13,14,''),(14,15,''),(15,16,''),(16,17,''),(17,18,''),(18,19,''),(19,20,'student'),(20,21,''),(21,22,''),(22,23,''),(23,24,''),(24,25,''),(25,26,''),(26,27,''),(27,28,''),(28,29,''),(29,30,''),(30,31,''),(31,32,''),(32,33,''),(33,34,''),(34,35,''),(35,36,''),(36,37,''),(37,38,''),(38,39,''),(39,40,''),(40,41,'student'),(41,43,'student'),(42,44,'student'),(43,45,'student'),(44,46,'instructor'),(45,47,'instructor');
/*!40000 ALTER TABLE `myapp_userprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'neu_db_project'
--

--
-- Dumping routines for database 'neu_db_project'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-05  8:35:48
