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

-- Dump completed on 2025-04-05  8:33:59
