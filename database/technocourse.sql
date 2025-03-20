-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 20, 2025 at 04:41 AM
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
(5, 3, 'Data Science and Machine Learning', 'Learn data analysis and apply machine learning algorithms.', 'IT', 2500000.00, 30, '2025-06-01 08:00:00', '2025-09-01 17:00:00');

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
(9, 3, 5, '2025-04-02 11:00:00', 'Unpaid');

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
(3, 'Robert', 'Brown', 'robert.brown@technocourse.com', 'Specialist in databases and data analysis.');

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
(1, 1, '2025-03-25 09:30:00', 1500000.00, 'Bank Transfer', 'Paid'),
(2, 2, '2025-03-26 11:00:00', 1500000.00, 'Credit Card', 'Paid'),
(3, 4, '2025-03-28 12:30:00', 1800000.00, 'Bank Transfer', 'Paid'),
(4, 5, '2025-03-29 13:30:00', 1700000.00, 'Debit Card', 'Paid'),
(5, 7, '2025-03-31 10:00:00', 1800000.00, 'Bank Transfer', 'Paid'),
(6, 8, '2025-04-01 10:30:00', 1700000.00, 'Credit Card', 'Paid');

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
(6, 5, 6, 4, 'The Data Science and Machine Learning material was challenging yet interesting.', '2025-04-10 15:00:00');

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
(1, 'Andrew', 'Smith', 'andrew.smith@technocourse.com', '2025-02-10 09:00:00'),
(2, 'Sarah', 'Williams', 'sarah.williams@technocourse.com', '2025-02-12 10:00:00'),
(3, 'David', 'Miller', 'david.miller@technocourse.com', '2025-02-15 11:30:00'),
(4, 'Laura', 'Wilson', 'laura.wilson@technocourse.com', '2025-02-18 14:00:00'),
(5, 'Mark', 'Taylor', 'mark.taylor@technocourse.com', '2025-02-20 15:30:00'),
(6, 'Olivia', 'Anderson', 'olivia.anderson@technocourse.com', '2025-02-22 16:00:00');

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
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `courseid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `course_materials`
--
ALTER TABLE `course_materials`
  MODIFY `materialid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollmentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `instructorid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `paymentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `reviewid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `studentid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
