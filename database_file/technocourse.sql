-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 03, 2025 at 05:45 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `technocourse`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_enrollments` ()   BEGIN
  DECLARE i INT DEFAULT 10;  -- starting enrollment id
  DECLARE rand_student INT;
  DECLARE rand_course INT;
  
  WHILE i <= 250 DO
    -- Select a random valid studentid from the students table
    SELECT studentid INTO rand_student
    FROM students
    ORDER BY RAND()
    LIMIT 1;
    
    -- Similarly, select a random valid courseid from the courses table
    SELECT courseid INTO rand_course
    FROM courses
    ORDER BY RAND()
    LIMIT 1;
    
    INSERT INTO enrollments (studentid, courseid, enrollment_date, payment_status)
    VALUES (
      rand_student,
      rand_course,
      DATE_ADD('2025-03-01', INTERVAL FLOOR(RAND()*60) DAY),
      IF(RAND() > 0.5, 'Paid', 'Unpaid')
    );
    SET i = i + 1;
  END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_payments` ()   BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE rand_enrollment INT;
  WHILE i <= 100 DO
    -- Select a random valid enrollmentid from the enrollments table
    SELECT enrollmentid INTO rand_enrollment 
    FROM enrollments 
    ORDER BY RAND() LIMIT 1;
    
    INSERT INTO payments (enrollmentid, payment_date, amount, payment_method, payment_status)
    VALUES (
      rand_enrollment,
      DATE_ADD('2025-03-01', INTERVAL FLOOR(RAND()*60) DAY),
      ROUND(500000 + RAND() * 2000000, 2),
      CASE WHEN RAND() > 0.5 THEN 'Credit Card' ELSE 'Bank Transfer' END,
      'Paid'
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `courseid` int(11) NOT NULL,
  `instructorid` int(11) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`courseid`, `instructorid`, `title`, `description`, `category`, `price`, `capacity`, `start_date`, `end_date`) VALUES
(1, 1, 'Introduction to Python Programming', 'A beginner course to learn Python programming from scratch.', 'IT', 1500000.00, 50, '2025-04-01 08:00:00', '2025-06-30 17:00:00'),
(2, 1, 'Web Application Development', 'Learn how to create web applications using HTML, CSS, and JavaScript.', 'IT', 2000000.00, 40, '2025-05-01 08:00:00', '2025-07-31 17:00:00'),
(3, 2, 'Fundamentals of Cybersecurity', 'Understand basic concepts and techniques to protect against cyber attacks.', 'IT', 1800000.00, 45, '2025-04-15 08:00:00', '2025-07-15 17:00:00'),
(4, 3, 'SQL Database Management', 'An intensive course to master SQL and database management.', 'IT', 1700000.00, 35, '2025-03-20 08:00:00', '2025-06-20 17:00:00'),
(5, 3, 'Data Science and Machine Learning', 'Learn data analysis and apply machine learning algorithms.', 'IT', 2500000.00, 30, '2025-06-01 08:00:00', '2025-09-01 17:00:00'),
(6, 3, 'How to Basic: AWS', 'AWS Basic Knowledge Training', 'Cloud', 500000.00, 25, '2025-04-02 20:30:00', '2025-04-02 21:30:00'),
(7, 1, 'Azure Hero', 'Learn using azure', 'Cloud', 1500000.00, 20, '2025-04-02 09:45:00', '2025-04-02 20:28:00'),
(8, 1, 'Hello World!', 'Learn Programming the Easiest Ways', 'Programming', 200000.00, 15, '2025-04-04 11:45:00', '2025-04-02 14:30:00'),
(9, 1, 'Business Fundamentals', 'Learn the core principles of business management.', 'Business', 1000000.00, 30, '2025-07-01 09:00:00', '2025-09-01 17:00:00'),
(10, 2, 'Digital Marketing Essentials', 'An overview of digital marketing strategies.', 'Marketing', 800000.00, 25, '2025-07-15 09:00:00', '2025-10-15 17:00:00'),
(11, 3, 'Graphic Design Basics', 'Introduction to graphic design using Adobe tools and modern techniques.', 'Design', 1200000.00, 20, '2025-08-01 09:00:00', '2025-10-01 17:00:00'),
(12, 1, 'Project Management Professional', 'Training course for project management certification with practical insights.', 'Management', 1500000.00, 35, '2025-08-15 09:00:00', '2025-11-15 17:00:00'),
(13, 2, 'Advanced Data Analytics', 'Deep dive into advanced data analytics techniques and tools.', 'Data Science', 2000000.00, 40, '2025-09-01 09:00:00', '2025-12-01 17:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `course_materials`
--

CREATE TABLE `course_materials` (
  `materialid` int(11) NOT NULL,
  `courseid` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `content_url` varchar(255) DEFAULT NULL,
  `material_type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `course_materials`
--

INSERT INTO `course_materials` (`materialid`, `courseid`, `title`, `content_url`, `material_type`) VALUES
(1, 1, 'Python Introduction Module', 'https://technocourse.com/materials/python-intro.pdf', 'pdf'),
(2, 1, 'Basic Python Video Tutorial', 'https://technocourse.com/videos/python-basics.mp4', 'video'),
(3, 2, 'Web Development Module', 'https://technocourse.com/materials/web-dev.pdf', 'pdf'),
(4, 2, 'HTML & CSS Quiz', 'https://technocourse.com/quizzes/html-css-quiz', 'quiz'),
(5, 3, 'Network Security Guide', 'https://technocourse.com/materials/cybersecurity-guide.pdf', 'pdf'),
(6, 3, 'Cyber Attack and Prevention Video', 'https://technocourse.com/videos/cybersecurity.mp4', 'video'),
(7, 4, 'Basic SQL Tutorial', 'https://technocourse.com/materials/sql-tutorial.pdf', 'pdf'),
(8, 4, 'SQL Query Quiz', 'https://technocourse.com/quizzes/sql-quiz', 'quiz'),
(9, 5, 'Data Science Module', 'https://technocourse.com/materials/data-science.pdf', 'pdf'),
(10, 5, 'Introduction to Machine Learning Video', 'https://technocourse.com/videos/ml-intro.mp4', 'video'),
(11, 5, 'Machine Learning Algorithm Quiz', 'https://technocourse.com/quizzes/ml-quiz', 'quiz');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollmentid` int(11) NOT NULL,
  `studentid` int(11) DEFAULT NULL,
  `courseid` int(11) DEFAULT NULL,
  `enrollment_date` datetime DEFAULT current_timestamp(),
  `payment_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`enrollmentid`, `studentid`, `courseid`, `enrollment_date`, `payment_status`) VALUES
(1, 1, 1, '2025-03-25 09:00:00', 'Paid'),
(2, 2, 1, '2025-03-26 10:30:00', 'Paid'),
(3, 3, 2, '2025-03-27 11:00:00', 'Unpaid'),
(4, 4, 3, '2025-03-28 12:00:00', 'Paid'),
(5, 5, 4, '2025-03-29 13:00:00', 'Paid'),
(6, 6, 5, '2025-03-30 14:00:00', 'Unpaid'),
(7, 1, 3, '2025-03-31 09:30:00', 'Paid'),
(8, 2, 4, '2025-04-01 10:00:00', 'Paid'),
(9, 3, 5, '2025-04-02 11:00:00', 'Unpaid'),
(11, 11, 1, '2025-04-06 00:00:00', 'Paid'),
(12, 3, 8, '2025-04-02 00:00:00', 'Unpaid'),
(13, 12, 3, '2025-03-10 00:00:00', 'Paid'),
(14, 9, 3, '2025-03-10 00:00:00', 'Paid'),
(15, 10, 5, '2025-03-01 00:00:00', 'Paid'),
(16, 15, 7, '2025-04-20 00:00:00', 'Paid'),
(17, 9, 8, '2025-04-09 00:00:00', 'Unpaid'),
(18, 14, 7, '2025-03-30 00:00:00', 'Paid'),
(19, 11, 4, '2025-03-25 00:00:00', 'Paid'),
(20, 5, 1, '2025-04-09 00:00:00', 'Unpaid'),
(21, 4, 4, '2025-03-20 00:00:00', 'Unpaid'),
(22, 7, 6, '2025-03-22 00:00:00', 'Unpaid'),
(23, 16, 6, '2025-04-24 00:00:00', 'Unpaid'),
(24, 2, 2, '2025-03-18 00:00:00', 'Paid'),
(25, 9, 1, '2025-04-12 00:00:00', 'Unpaid'),
(26, 5, 3, '2025-03-23 00:00:00', 'Paid'),
(27, 8, 6, '2025-03-26 00:00:00', 'Unpaid'),
(28, 14, 2, '2025-03-29 00:00:00', 'Unpaid'),
(29, 4, 4, '2025-04-23 00:00:00', 'Paid'),
(30, 4, 8, '2025-04-24 00:00:00', 'Paid'),
(31, 14, 5, '2025-03-16 00:00:00', 'Unpaid'),
(32, 13, 2, '2025-04-11 00:00:00', 'Unpaid'),
(33, 4, 8, '2025-04-05 00:00:00', 'Paid'),
(34, 12, 2, '2025-03-14 00:00:00', 'Paid'),
(35, 3, 8, '2025-03-01 00:00:00', 'Unpaid'),
(36, 11, 5, '2025-04-23 00:00:00', 'Paid'),
(37, 1, 6, '2025-04-10 00:00:00', 'Unpaid'),
(38, 16, 6, '2025-04-03 00:00:00', 'Paid'),
(39, 12, 3, '2025-04-22 00:00:00', 'Paid'),
(40, 12, 4, '2025-03-01 00:00:00', 'Unpaid'),
(41, 13, 5, '2025-03-13 00:00:00', 'Paid'),
(42, 14, 8, '2025-03-03 00:00:00', 'Unpaid'),
(43, 11, 8, '2025-03-21 00:00:00', 'Unpaid'),
(44, 13, 4, '2025-04-27 00:00:00', 'Paid'),
(45, 9, 6, '2025-04-28 00:00:00', 'Unpaid'),
(46, 14, 4, '2025-04-11 00:00:00', 'Unpaid'),
(47, 15, 8, '2025-04-26 00:00:00', 'Unpaid'),
(48, 6, 2, '2025-04-02 00:00:00', 'Paid'),
(49, 14, 5, '2025-04-03 00:00:00', 'Unpaid'),
(50, 13, 1, '2025-04-07 00:00:00', 'Unpaid'),
(51, 5, 7, '2025-03-22 00:00:00', 'Paid'),
(52, 4, 8, '2025-03-04 00:00:00', 'Paid'),
(53, 10, 5, '2025-03-24 00:00:00', 'Paid'),
(54, 3, 1, '2025-03-16 00:00:00', 'Unpaid'),
(55, 4, 8, '2025-03-11 00:00:00', 'Paid'),
(56, 2, 7, '2025-04-18 00:00:00', 'Paid'),
(57, 8, 6, '2025-03-20 00:00:00', 'Paid'),
(58, 16, 3, '2025-04-21 00:00:00', 'Paid'),
(59, 4, 5, '2025-03-06 00:00:00', 'Paid'),
(60, 7, 4, '2025-04-28 00:00:00', 'Unpaid'),
(61, 8, 2, '2025-03-04 00:00:00', 'Paid'),
(62, 6, 7, '2025-04-05 00:00:00', 'Unpaid'),
(63, 13, 5, '2025-04-05 00:00:00', 'Unpaid'),
(64, 6, 3, '2025-03-30 00:00:00', 'Paid'),
(65, 16, 2, '2025-04-19 00:00:00', 'Paid'),
(66, 12, 7, '2025-03-08 00:00:00', 'Paid'),
(67, 8, 4, '2025-03-21 00:00:00', 'Unpaid'),
(68, 8, 5, '2025-03-29 00:00:00', 'Paid'),
(69, 7, 8, '2025-04-15 00:00:00', 'Unpaid'),
(70, 7, 7, '2025-04-01 00:00:00', 'Paid'),
(71, 13, 8, '2025-03-06 00:00:00', 'Paid'),
(72, 3, 1, '2025-03-07 00:00:00', 'Unpaid'),
(73, 12, 1, '2025-03-02 00:00:00', 'Paid'),
(74, 15, 1, '2025-04-23 00:00:00', 'Unpaid'),
(75, 6, 3, '2025-03-07 00:00:00', 'Unpaid'),
(76, 6, 5, '2025-03-06 00:00:00', 'Unpaid'),
(77, 16, 6, '2025-04-04 00:00:00', 'Paid'),
(78, 14, 8, '2025-03-24 00:00:00', 'Unpaid'),
(79, 3, 4, '2025-04-10 00:00:00', 'Paid'),
(80, 16, 2, '2025-04-04 00:00:00', 'Unpaid'),
(81, 7, 1, '2025-04-02 00:00:00', 'Paid'),
(82, 16, 2, '2025-04-29 00:00:00', 'Unpaid'),
(83, 10, 6, '2025-03-10 00:00:00', 'Unpaid'),
(84, 4, 3, '2025-04-22 00:00:00', 'Paid'),
(85, 2, 4, '2025-03-18 00:00:00', 'Paid'),
(86, 4, 7, '2025-03-15 00:00:00', 'Paid'),
(87, 9, 4, '2025-04-12 00:00:00', 'Paid'),
(88, 3, 7, '2025-03-19 00:00:00', 'Paid'),
(89, 2, 5, '2025-04-01 00:00:00', 'Unpaid'),
(90, 1, 6, '2025-03-13 00:00:00', 'Paid'),
(91, 14, 6, '2025-03-10 00:00:00', 'Paid'),
(92, 8, 8, '2025-04-14 00:00:00', 'Paid'),
(93, 9, 6, '2025-03-12 00:00:00', 'Paid'),
(94, 7, 5, '2025-04-20 00:00:00', 'Paid'),
(95, 6, 4, '2025-04-13 00:00:00', 'Paid'),
(96, 1, 6, '2025-04-06 00:00:00', 'Paid'),
(97, 5, 1, '2025-03-05 00:00:00', 'Unpaid'),
(98, 9, 7, '2025-03-17 00:00:00', 'Paid'),
(99, 10, 1, '2025-03-28 00:00:00', 'Unpaid'),
(100, 16, 5, '2025-03-10 00:00:00', 'Paid'),
(101, 13, 5, '2025-04-22 00:00:00', 'Paid'),
(102, 13, 6, '2025-04-26 00:00:00', 'Paid'),
(103, 14, 6, '2025-03-16 00:00:00', 'Unpaid'),
(104, 3, 6, '2025-03-09 00:00:00', 'Paid'),
(105, 15, 6, '2025-04-17 00:00:00', 'Paid'),
(106, 11, 6, '2025-04-10 00:00:00', 'Unpaid'),
(107, 5, 4, '2025-03-21 00:00:00', 'Paid'),
(108, 13, 7, '2025-04-28 00:00:00', 'Unpaid'),
(109, 13, 7, '2025-04-16 00:00:00', 'Paid'),
(110, 5, 4, '2025-04-02 00:00:00', 'Unpaid'),
(111, 5, 3, '2025-03-25 00:00:00', 'Unpaid'),
(112, 15, 2, '2025-03-07 00:00:00', 'Paid'),
(113, 1, 6, '2025-04-01 00:00:00', 'Unpaid'),
(114, 11, 8, '2025-03-29 00:00:00', 'Unpaid'),
(115, 15, 8, '2025-03-20 00:00:00', 'Paid'),
(116, 11, 5, '2025-03-11 00:00:00', 'Unpaid'),
(117, 7, 5, '2025-03-25 00:00:00', 'Unpaid'),
(118, 16, 7, '2025-03-20 00:00:00', 'Paid'),
(119, 13, 8, '2025-04-20 00:00:00', 'Unpaid'),
(120, 11, 8, '2025-03-31 00:00:00', 'Paid'),
(121, 4, 2, '2025-04-07 00:00:00', 'Unpaid'),
(122, 13, 7, '2025-03-15 00:00:00', 'Unpaid'),
(123, 1, 1, '2025-03-14 00:00:00', 'Unpaid'),
(124, 8, 3, '2025-03-23 00:00:00', 'Unpaid'),
(125, 12, 1, '2025-04-02 00:00:00', 'Paid'),
(126, 10, 5, '2025-04-22 00:00:00', 'Unpaid'),
(127, 9, 7, '2025-03-14 00:00:00', 'Unpaid'),
(128, 4, 3, '2025-04-09 00:00:00', 'Paid'),
(129, 2, 4, '2025-03-07 00:00:00', 'Unpaid'),
(130, 3, 3, '2025-03-11 00:00:00', 'Unpaid'),
(131, 13, 6, '2025-03-11 00:00:00', 'Paid'),
(132, 13, 4, '2025-04-09 00:00:00', 'Paid'),
(133, 8, 4, '2025-04-19 00:00:00', 'Unpaid'),
(134, 13, 4, '2025-04-23 00:00:00', 'Paid'),
(135, 15, 1, '2025-04-01 00:00:00', 'Paid'),
(136, 14, 8, '2025-04-20 00:00:00', 'Paid'),
(137, 7, 8, '2025-03-14 00:00:00', 'Unpaid'),
(138, 8, 5, '2025-03-03 00:00:00', 'Paid'),
(139, 16, 6, '2025-04-29 00:00:00', 'Paid'),
(140, 11, 8, '2025-04-28 00:00:00', 'Unpaid'),
(141, 1, 2, '2025-04-29 00:00:00', 'Unpaid'),
(142, 3, 4, '2025-04-27 00:00:00', 'Unpaid'),
(143, 8, 3, '2025-03-17 00:00:00', 'Unpaid'),
(144, 15, 1, '2025-04-12 00:00:00', 'Paid'),
(145, 14, 8, '2025-04-04 00:00:00', 'Paid'),
(146, 2, 1, '2025-04-21 00:00:00', 'Paid'),
(147, 8, 2, '2025-03-08 00:00:00', 'Unpaid'),
(148, 15, 7, '2025-03-30 00:00:00', 'Unpaid'),
(149, 7, 5, '2025-03-01 00:00:00', 'Unpaid'),
(150, 5, 3, '2025-04-13 00:00:00', 'Paid'),
(151, 5, 7, '2025-04-18 00:00:00', 'Paid'),
(152, 3, 8, '2025-04-02 00:00:00', 'Paid'),
(153, 15, 1, '2025-03-02 00:00:00', 'Unpaid'),
(154, 12, 4, '2025-03-17 00:00:00', 'Paid'),
(155, 13, 7, '2025-03-04 00:00:00', 'Unpaid'),
(156, 3, 3, '2025-04-26 00:00:00', 'Unpaid'),
(157, 14, 3, '2025-04-06 00:00:00', 'Paid'),
(158, 11, 3, '2025-04-08 00:00:00', 'Unpaid'),
(159, 16, 3, '2025-04-22 00:00:00', 'Unpaid'),
(160, 2, 8, '2025-03-05 00:00:00', 'Paid'),
(161, 16, 7, '2025-03-27 00:00:00', 'Unpaid'),
(162, 15, 4, '2025-04-05 00:00:00', 'Paid'),
(163, 6, 1, '2025-03-12 00:00:00', 'Unpaid'),
(164, 2, 2, '2025-03-31 00:00:00', 'Unpaid'),
(165, 8, 7, '2025-03-03 00:00:00', 'Unpaid'),
(166, 7, 3, '2025-03-11 00:00:00', 'Unpaid'),
(167, 7, 2, '2025-04-02 00:00:00', 'Paid'),
(168, 1, 5, '2025-03-15 00:00:00', 'Unpaid'),
(169, 12, 1, '2025-04-21 00:00:00', 'Unpaid'),
(170, 1, 5, '2025-04-09 00:00:00', 'Paid'),
(171, 1, 3, '2025-04-18 00:00:00', 'Paid'),
(172, 16, 6, '2025-03-07 00:00:00', 'Paid'),
(173, 5, 2, '2025-04-28 00:00:00', 'Paid'),
(174, 16, 8, '2025-04-11 00:00:00', 'Paid'),
(175, 3, 8, '2025-03-09 00:00:00', 'Paid'),
(176, 16, 4, '2025-03-21 00:00:00', 'Paid'),
(177, 14, 4, '2025-03-21 00:00:00', 'Paid'),
(178, 15, 6, '2025-03-12 00:00:00', 'Unpaid'),
(179, 2, 5, '2025-03-24 00:00:00', 'Unpaid'),
(180, 14, 1, '2025-04-17 00:00:00', 'Paid'),
(181, 11, 2, '2025-03-11 00:00:00', 'Unpaid'),
(182, 15, 1, '2025-03-24 00:00:00', 'Unpaid'),
(183, 7, 6, '2025-03-01 00:00:00', 'Paid'),
(184, 9, 8, '2025-04-16 00:00:00', 'Unpaid'),
(185, 1, 8, '2025-04-13 00:00:00', 'Unpaid'),
(186, 3, 4, '2025-04-26 00:00:00', 'Unpaid'),
(187, 2, 6, '2025-04-16 00:00:00', 'Paid'),
(188, 6, 8, '2025-03-15 00:00:00', 'Unpaid'),
(189, 11, 5, '2025-04-22 00:00:00', 'Unpaid'),
(190, 8, 3, '2025-04-22 00:00:00', 'Paid'),
(191, 9, 5, '2025-03-28 00:00:00', 'Unpaid'),
(192, 14, 4, '2025-03-17 00:00:00', 'Paid'),
(193, 6, 6, '2025-03-26 00:00:00', 'Paid'),
(194, 15, 3, '2025-04-09 00:00:00', 'Unpaid'),
(195, 3, 8, '2025-03-23 00:00:00', 'Unpaid'),
(196, 9, 4, '2025-03-25 00:00:00', 'Paid'),
(197, 15, 8, '2025-04-23 00:00:00', 'Paid'),
(198, 10, 1, '2025-03-21 00:00:00', 'Unpaid'),
(199, 4, 6, '2025-04-04 00:00:00', 'Unpaid'),
(200, 13, 2, '2025-03-29 00:00:00', 'Paid'),
(201, 14, 8, '2025-03-21 00:00:00', 'Paid'),
(202, 6, 8, '2025-03-04 00:00:00', 'Paid'),
(203, 6, 1, '2025-03-01 00:00:00', 'Unpaid'),
(204, 11, 5, '2025-03-02 00:00:00', 'Unpaid'),
(205, 3, 2, '2025-03-23 00:00:00', 'Unpaid'),
(206, 6, 4, '2025-03-03 00:00:00', 'Unpaid'),
(207, 15, 6, '2025-04-27 00:00:00', 'Paid'),
(208, 10, 3, '2025-04-05 00:00:00', 'Paid'),
(209, 2, 7, '2025-03-22 00:00:00', 'Paid'),
(210, 7, 4, '2025-03-10 00:00:00', 'Unpaid'),
(211, 3, 5, '2025-03-25 00:00:00', 'Paid'),
(212, 2, 5, '2025-03-22 00:00:00', 'Unpaid'),
(213, 15, 8, '2025-04-04 00:00:00', 'Paid'),
(214, 14, 2, '2025-03-10 00:00:00', 'Paid'),
(215, 6, 8, '2025-04-14 00:00:00', 'Paid'),
(216, 8, 4, '2025-03-06 00:00:00', 'Unpaid'),
(217, 10, 1, '2025-04-23 00:00:00', 'Unpaid'),
(218, 15, 1, '2025-04-24 00:00:00', 'Unpaid'),
(219, 2, 5, '2025-03-02 00:00:00', 'Unpaid'),
(220, 14, 3, '2025-03-18 00:00:00', 'Unpaid'),
(221, 5, 1, '2025-03-05 00:00:00', 'Paid'),
(222, 12, 6, '2025-04-03 00:00:00', 'Unpaid'),
(223, 14, 5, '2025-03-12 00:00:00', 'Paid'),
(224, 2, 7, '2025-04-22 00:00:00', 'Unpaid'),
(225, 7, 5, '2025-03-19 00:00:00', 'Unpaid'),
(226, 16, 3, '2025-03-15 00:00:00', 'Unpaid'),
(227, 14, 5, '2025-03-23 00:00:00', 'Paid'),
(228, 1, 6, '2025-03-15 00:00:00', 'Paid'),
(229, 4, 2, '2025-04-26 00:00:00', 'Unpaid'),
(230, 10, 6, '2025-04-15 00:00:00', 'Paid'),
(231, 16, 6, '2025-04-16 00:00:00', 'Paid'),
(232, 1, 7, '2025-04-18 00:00:00', 'Paid'),
(233, 3, 7, '2025-04-11 00:00:00', 'Unpaid'),
(234, 1, 5, '2025-03-27 00:00:00', 'Paid'),
(235, 16, 1, '2025-04-26 00:00:00', 'Paid'),
(236, 14, 7, '2025-04-14 00:00:00', 'Paid'),
(237, 16, 4, '2025-03-30 00:00:00', 'Unpaid'),
(238, 13, 1, '2025-03-09 00:00:00', 'Paid'),
(239, 11, 8, '2025-03-30 00:00:00', 'Unpaid'),
(240, 9, 6, '2025-04-01 00:00:00', 'Unpaid'),
(241, 12, 8, '2025-03-27 00:00:00', 'Unpaid'),
(242, 5, 5, '2025-04-16 00:00:00', 'Paid'),
(243, 10, 8, '2025-04-08 00:00:00', 'Paid'),
(244, 8, 2, '2025-03-21 00:00:00', 'Unpaid'),
(245, 16, 8, '2025-04-14 00:00:00', 'Unpaid'),
(246, 2, 7, '2025-04-29 00:00:00', 'Paid'),
(247, 4, 1, '2025-03-14 00:00:00', 'Paid'),
(248, 1, 1, '2025-03-15 00:00:00', 'Paid'),
(249, 5, 8, '2025-04-21 00:00:00', 'Unpaid'),
(250, 10, 7, '2025-03-16 00:00:00', 'Paid'),
(251, 6, 8, '2025-04-07 00:00:00', 'Paid');

-- --------------------------------------------------------

--
-- Table structure for table `instructors`
--

CREATE TABLE `instructors` (
  `instructorid` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `bio` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `instructors`
--

INSERT INTO `instructors` (`instructorid`, `firstname`, `lastname`, `email`, `bio`) VALUES
(1, 'Michael', 'Johnson', 'michael.johnson@technocourse.com', 'Expert in software development with 10 years of experience.'),
(2, 'Emily', 'Davis', 'emily.davis@technocourse.com', 'Experienced instructor in cybersecurity.'),
(3, 'Robert', 'Brown', 'robert.brown@technocourse.com', 'Specialist in databases and data analysis.'),
(4, 'Alice', 'Cooper', 'alice.cooper@technocourse.com', 'Passionate about IT and creative teaching.'),
(5, 'Bob', 'Marley', 'bob.marley@technocourse.com', 'Expert in cloud computing and infrastructure.'),
(6, 'Charlie', 'Chaplin', 'charlie.chaplin@technocourse.com', 'Modern web development specialist.'),
(7, 'Diana', 'Prince', 'diana.prince@technocourse.com', 'Focused on cybersecurity and ethical hacking.'),
(8, 'Edward', 'Norton', 'edward.norton@technocourse.com', 'Database and SQL guru with years of experience.'),
(9, 'Fiona', 'Apple', 'fiona.apple@technocourse.com', 'Data science and analytics expert.'),
(10, 'George', 'Clooney', 'george.clooney@technocourse.com', 'Seasoned cloud technologies instructor.');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `paymentid` int(11) NOT NULL,
  `enrollmentid` int(11) DEFAULT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`paymentid`, `enrollmentid`, `payment_date`, `amount`, `payment_method`, `payment_status`) VALUES
(2, 2, '2025-03-26 11:00:00', 1500000.00, 'Credit Card', 'Paid'),
(3, 4, '2025-03-28 12:30:00', 1800000.00, 'Bank Transfer', 'Paid'),
(4, 5, '2025-03-29 13:30:00', 1700000.00, 'Debit Card', 'Paid'),
(6, 8, '2025-04-01 10:30:00', 1700000.00, 'Credit Card', 'Paid'),
(7, 7, '2025-04-14 00:00:00', 2324823.66, 'Bank Transfer', 'Paid'),
(8, 8, '2025-04-28 00:00:00', 2137799.88, 'Bank Transfer', 'Paid'),
(9, 9, '2025-03-30 00:00:00', 2253754.65, 'Credit Card', 'Paid'),
(11, 4, '2025-03-13 00:00:00', 1353786.34, 'Credit Card', 'Paid'),
(12, 7, '2025-03-05 00:00:00', 1111438.14, 'Bank Transfer', 'Paid'),
(13, 9, '2025-03-29 00:00:00', 1708695.50, 'Credit Card', 'Paid'),
(14, 1, '2025-03-14 00:00:00', 1286269.67, 'Bank Transfer', 'Paid'),
(15, 9, '2025-03-09 00:00:00', 1259405.49, 'Bank Transfer', 'Paid'),
(16, 6, '2025-04-20 00:00:00', 2038226.34, 'Bank Transfer', 'Paid'),
(17, 2, '2025-04-05 00:00:00', 1134736.40, 'Credit Card', 'Paid'),
(18, 1, '2025-04-06 00:00:00', 943226.00, 'Bank Transfer', 'Paid'),
(19, 4, '2025-03-05 00:00:00', 1546901.25, 'Bank Transfer', 'Paid'),
(20, 4, '2025-03-21 00:00:00', 1884286.08, 'Bank Transfer', 'Paid'),
(21, 9, '2025-03-17 00:00:00', 2242197.12, 'Credit Card', 'Paid'),
(22, 3, '2025-04-17 00:00:00', 1936746.42, 'Bank Transfer', 'Paid'),
(23, 2, '2025-03-17 00:00:00', 821270.91, 'Credit Card', 'Paid'),
(24, 9, '2025-03-29 00:00:00', 1252338.26, 'Bank Transfer', 'Paid'),
(25, 7, '2025-03-18 00:00:00', 2064482.66, 'Bank Transfer', 'Paid'),
(26, 7, '2025-03-03 00:00:00', 2075019.49, 'Credit Card', 'Paid'),
(27, 9, '2025-03-04 00:00:00', 1836372.42, 'Bank Transfer', 'Paid'),
(28, 5, '2025-04-19 00:00:00', 1206393.29, 'Bank Transfer', 'Paid'),
(29, 3, '2025-04-08 00:00:00', 1848397.38, 'Bank Transfer', 'Paid'),
(30, 5, '2025-03-08 00:00:00', 1155967.84, 'Bank Transfer', 'Paid'),
(31, 5, '2025-04-29 00:00:00', 1581461.24, 'Credit Card', 'Paid'),
(32, 9, '2025-04-06 00:00:00', 2062491.16, 'Bank Transfer', 'Paid'),
(33, 1, '2025-04-10 00:00:00', 2137400.34, 'Bank Transfer', 'Paid'),
(34, 7, '2025-04-01 00:00:00', 1368482.85, 'Credit Card', 'Paid'),
(35, 5, '2025-04-12 00:00:00', 1757053.95, 'Credit Card', 'Paid'),
(36, 5, '2025-03-04 00:00:00', 513499.84, 'Credit Card', 'Paid'),
(37, 9, '2025-03-15 00:00:00', 1092677.84, 'Credit Card', 'Paid'),
(38, 1, '2025-03-17 00:00:00', 1936253.68, 'Credit Card', 'Paid'),
(39, 6, '2025-04-19 00:00:00', 1788359.46, 'Credit Card', 'Paid'),
(40, 8, '2025-03-13 00:00:00', 505675.76, 'Bank Transfer', 'Paid'),
(41, 1, '2025-03-16 00:00:00', 2041633.16, 'Bank Transfer', 'Paid'),
(42, 1, '2025-03-22 00:00:00', 1722457.24, 'Credit Card', 'Paid'),
(43, 1, '2025-03-15 00:00:00', 2494909.47, 'Bank Transfer', 'Paid'),
(44, 8, '2025-04-23 00:00:00', 2046908.58, 'Bank Transfer', 'Paid'),
(45, 4, '2025-03-03 00:00:00', 1852132.29, 'Bank Transfer', 'Paid'),
(46, 9, '2025-04-16 00:00:00', 618704.80, 'Credit Card', 'Paid'),
(47, 9, '2025-03-04 00:00:00', 1237999.23, 'Credit Card', 'Paid'),
(48, 8, '2025-04-22 00:00:00', 1869871.22, 'Credit Card', 'Paid'),
(49, 6, '2025-04-12 00:00:00', 1234395.03, 'Credit Card', 'Paid'),
(50, 5, '2025-04-23 00:00:00', 608350.72, 'Credit Card', 'Paid'),
(51, 2, '2025-03-11 00:00:00', 625927.82, 'Credit Card', 'Paid'),
(52, 4, '2025-04-12 00:00:00', 692216.91, 'Bank Transfer', 'Paid'),
(53, 3, '2025-04-13 00:00:00', 2093382.33, 'Credit Card', 'Paid'),
(54, 9, '2025-04-07 00:00:00', 2379512.20, 'Credit Card', 'Paid'),
(55, 2, '2025-03-30 00:00:00', 1604619.25, 'Bank Transfer', 'Paid'),
(56, 5, '2025-03-20 00:00:00', 1391250.16, 'Bank Transfer', 'Paid'),
(57, 7, '2025-04-13 00:00:00', 960143.60, 'Credit Card', 'Paid'),
(58, 5, '2025-03-13 00:00:00', 1632734.47, 'Bank Transfer', 'Paid'),
(59, 7, '2025-04-24 00:00:00', 1089335.12, 'Credit Card', 'Paid'),
(60, 6, '2025-03-02 00:00:00', 580398.34, 'Bank Transfer', 'Paid'),
(61, 2, '2025-03-08 00:00:00', 2137834.88, 'Credit Card', 'Paid'),
(62, 3, '2025-03-26 00:00:00', 1077111.37, 'Bank Transfer', 'Paid'),
(63, 9, '2025-03-12 00:00:00', 2008031.55, 'Bank Transfer', 'Paid'),
(64, 4, '2025-03-07 00:00:00', 1979495.87, 'Bank Transfer', 'Paid'),
(65, 8, '2025-03-02 00:00:00', 1369764.48, 'Bank Transfer', 'Paid'),
(66, 1, '2025-03-31 00:00:00', 2101483.74, 'Bank Transfer', 'Paid'),
(67, 7, '2025-04-22 00:00:00', 1737904.04, 'Bank Transfer', 'Paid'),
(68, 6, '2025-04-13 00:00:00', 1720797.80, 'Credit Card', 'Paid'),
(69, 2, '2025-03-25 00:00:00', 2157565.19, 'Credit Card', 'Paid'),
(70, 2, '2025-04-26 00:00:00', 837800.49, 'Bank Transfer', 'Paid'),
(71, 9, '2025-03-13 00:00:00', 1651889.30, 'Bank Transfer', 'Paid'),
(72, 5, '2025-04-20 00:00:00', 1103961.76, 'Credit Card', 'Paid'),
(73, 3, '2025-03-30 00:00:00', 1444713.90, 'Credit Card', 'Paid'),
(74, 7, '2025-03-19 00:00:00', 1272709.68, 'Bank Transfer', 'Paid'),
(75, 2, '2025-04-25 00:00:00', 1550219.23, 'Credit Card', 'Paid'),
(76, 5, '2025-04-02 00:00:00', 513103.56, 'Bank Transfer', 'Paid'),
(77, 9, '2025-03-13 00:00:00', 1263941.63, 'Bank Transfer', 'Paid'),
(78, 7, '2025-04-17 00:00:00', 1541529.49, 'Bank Transfer', 'Paid'),
(79, 9, '2025-03-21 00:00:00', 2269177.00, 'Bank Transfer', 'Paid'),
(80, 4, '2025-04-28 00:00:00', 1887661.56, 'Credit Card', 'Paid'),
(81, 7, '2025-03-31 00:00:00', 591254.92, 'Credit Card', 'Paid'),
(82, 7, '2025-04-11 00:00:00', 1864298.24, 'Bank Transfer', 'Paid'),
(83, 4, '2025-03-09 00:00:00', 2475526.62, 'Credit Card', 'Paid'),
(84, 9, '2025-04-19 00:00:00', 1581716.32, 'Bank Transfer', 'Paid'),
(85, 4, '2025-04-16 00:00:00', 2486858.65, 'Credit Card', 'Paid'),
(86, 4, '2025-03-23 00:00:00', 1025035.98, 'Bank Transfer', 'Paid'),
(87, 6, '2025-03-16 00:00:00', 1081680.48, 'Credit Card', 'Paid'),
(88, 8, '2025-04-24 00:00:00', 2188229.61, 'Bank Transfer', 'Paid'),
(89, 7, '2025-04-10 00:00:00', 2155453.42, 'Bank Transfer', 'Paid'),
(90, 8, '2025-04-04 00:00:00', 873823.21, 'Bank Transfer', 'Paid'),
(91, 3, '2025-04-03 00:00:00', 2197346.89, 'Credit Card', 'Paid'),
(92, 9, '2025-03-20 00:00:00', 1290946.36, 'Bank Transfer', 'Paid'),
(93, 9, '2025-04-18 00:00:00', 1100344.33, 'Bank Transfer', 'Paid'),
(94, 9, '2025-03-08 00:00:00', 552710.92, 'Credit Card', 'Paid'),
(95, 8, '2025-03-18 00:00:00', 1801051.32, 'Bank Transfer', 'Paid'),
(96, 8, '2025-04-16 00:00:00', 2369152.09, 'Bank Transfer', 'Paid'),
(97, 3, '2025-04-19 00:00:00', 1738885.98, 'Credit Card', 'Paid'),
(98, 3, '2025-04-02 00:00:00', 760676.64, 'Bank Transfer', 'Paid'),
(99, 2, '2025-03-23 00:00:00', 1513928.72, 'Bank Transfer', 'Paid'),
(100, 3, '2025-04-07 00:00:00', 1831025.84, 'Bank Transfer', 'Paid'),
(101, 5, '2025-03-15 00:00:00', 1635006.38, 'Bank Transfer', 'Paid'),
(102, 5, '2025-04-19 00:00:00', 1159250.97, 'Bank Transfer', 'Paid'),
(103, 2, '2025-03-04 00:00:00', 575657.57, 'Credit Card', 'Paid'),
(104, 5, '2025-03-20 00:00:00', 1920031.98, 'Credit Card', 'Paid'),
(105, 5, '2025-03-11 00:00:00', 1574776.58, 'Bank Transfer', 'Paid'),
(106, 3, '2025-04-02 00:00:00', 1734290.01, 'Bank Transfer', 'Paid'),
(107, 9, '2025-04-26 00:00:00', 1774548.93, 'Bank Transfer', 'Paid'),
(108, 8, '2025-04-14 00:00:00', 809842.60, 'Credit Card', 'Paid'),
(109, 1, '2025-04-28 00:00:00', 820646.84, 'Credit Card', 'Paid'),
(110, 8, '2025-04-05 00:00:00', 835686.14, 'Bank Transfer', 'Paid');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `reviewid` int(11) NOT NULL,
  `courseid` int(11) DEFAULT NULL,
  `studentid` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `review_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`reviewid`, `courseid`, `studentid`, `rating`, `comment`, `review_date`) VALUES
(1, 1, 1, 5, 'The material was presented very clearly and was easy to understand.', '2025-04-05 10:00:00'),
(2, 1, 2, 4, 'A great course for beginners to learn Python.', '2025-04-06 11:00:00'),
(3, 2, 3, 5, 'Very practical course with real-life examples.', '2025-04-07 12:00:00'),
(4, 3, 4, 4, 'The cybersecurity course was comprehensive, though more case studies would help.', '2025-04-08 13:00:00'),
(5, 4, 5, 5, 'The SQL tutorial was detailed and useful for daily tasks.', '2025-04-09 14:00:00'),
(6, 5, 6, 4, 'The Data Science and Machine Learning material was challenging yet interesting.', '2025-04-10 15:00:00'),
(7, 1, 1, 5, 'Excellent course, very clear and informative!', '2025-04-05 10:00:00'),
(8, 2, 2, 4, 'Good practical examples and engaging content.', '2025-04-06 11:00:00'),
(9, 3, 3, 3, 'Average course, could use more detailed explanations.', '2025-04-07 12:00:00'),
(10, 4, 4, 5, 'The instructor was very knowledgeable and patient.', '2025-04-08 13:00:00'),
(11, 5, 5, 4, 'I learned a lot, although the pace was a bit fast at times.', '2025-04-09 14:00:00'),
(12, 1, 6, 5, 'Fantastic beginner course, I feel much more confident now.', '2025-04-10 15:00:00'),
(13, 2, 7, 3, 'Content was good but could benefit from more real-life examples.', '2025-04-11 16:00:00'),
(14, 3, 8, 4, 'Well-structured and thorough explanation of complex topics.', '2025-04-12 17:00:00'),
(15, 4, 9, 5, 'Highly recommend this course to anyone interested in SQL.', '2025-04-13 18:00:00'),
(16, 5, 10, 4, 'Practical course with plenty of useful examples.', '2025-04-14 19:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `studentid` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `registration_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`studentid`, `firstname`, `lastname`, `email`, `registration_date`) VALUES
(1, 'Andrew', 'Smith', 'andrew.smith@gmail', '2025-02-10 09:00:00'),
(2, 'Sarah', 'Williams', 'sarah.williams@technocourse.com', '2025-02-12 10:00:00'),
(3, 'David', 'Miller', 'david.miller@technocourse.com', '2025-02-15 11:30:00'),
(4, 'Laura', 'Wilson', 'laura.wilson@technocourse.com', '2025-02-18 14:00:00'),
(5, 'Mark', 'Taylor', 'mark.taylor@technocourse.com', '2025-02-20 15:30:00'),
(6, 'Olivia', 'Anderson', 'olivia.anderson@technocourse.com', '2025-02-22 16:00:00'),
(7, 'John', 'Doe', 'john.doe@example.com', '2025-03-01 09:00:00'),
(8, 'Jane', 'Smith', 'jane.smith@example.com', '2025-03-02 10:00:00'),
(9, 'Alice', 'Johnson', 'alice.johnson@example.com', '2025-03-03 11:00:00'),
(10, 'Bob', 'Brown', 'bob.brown@example.com', '2025-03-04 12:00:00'),
(11, 'Charlie', 'Davis', 'charlie.davis@example.com', '2025-03-05 13:00:00'),
(12, 'Diana', 'Evans', 'diana.evans@example.com', '2025-03-06 14:00:00'),
(13, 'Eric', 'Garcia', 'eric.garcia@example.com', '2025-03-07 15:00:00'),
(14, 'Fiona', 'Martinez', 'fiona.martinez@example.com', '2025-03-08 16:00:00'),
(15, 'George', 'Lopez', 'george.lopez@example.com', '2025-03-09 17:00:00'),
(16, 'Helen', 'Wilson', 'helen.wilson@example.com', '2025-03-10 18:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`) VALUES
(1, 'rahfia', 'admin123', 'rahfia@technocourse.com'),
(2, 'admin', 'admin', 'admin@technocourse.com'),
(3, 'fajri', 'fajri123', 'fajri@technocourse.com'),
(4, 'zikra', 'zikra123', 'zikra@technocourse.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`courseid`),
  ADD KEY `instructorid` (`instructorid`);

--
-- Indexes for table `course_materials`
--
ALTER TABLE `course_materials`
  ADD PRIMARY KEY (`materialid`),
  ADD KEY `courseid` (`courseid`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollmentid`),
  ADD KEY `studentid` (`studentid`),
  ADD KEY `courseid` (`courseid`);

--
-- Indexes for table `instructors`
--
ALTER TABLE `instructors`
  ADD PRIMARY KEY (`instructorid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`paymentid`),
  ADD KEY `enrollmentid` (`enrollmentid`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`reviewid`),
  ADD KEY `courseid` (`courseid`),
  ADD KEY `studentid` (`studentid`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`studentid`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `courseid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `course_materials`
--
ALTER TABLE `course_materials`
  MODIFY `materialid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollmentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=252;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `instructorid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `paymentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `reviewid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `studentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`instructorid`) REFERENCES `instructors` (`instructorid`);

--
-- Constraints for table `course_materials`
--
ALTER TABLE `course_materials`
  ADD CONSTRAINT `course_materials_ibfk_1` FOREIGN KEY (`courseid`) REFERENCES `courses` (`courseid`);

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`studentid`) REFERENCES `students` (`studentid`),
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`courseid`) REFERENCES `courses` (`courseid`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`enrollmentid`) REFERENCES `enrollments` (`enrollmentid`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`courseid`) REFERENCES `courses` (`courseid`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`studentid`) REFERENCES `students` (`studentid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
