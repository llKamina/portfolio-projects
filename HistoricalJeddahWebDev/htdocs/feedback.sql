-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql109.infinityfree.com
-- Generation Time: Dec 08, 2025 at 03:49 AM
-- Server version: 11.4.7-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_40559812_exploredb`
--

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `visit_type` varchar(50) DEFAULT NULL,
  `interests` varchar(200) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `name`, `email`, `gender`, `visit_type`, `interests`, `rating`, `comments`, `submitted_at`) VALUES
(1, 'ahmed alrasheedi', 'aaw2000@gmail.com', 'Male', 'Tourist', 'Food, Culture, Beaches', 5, 'excellent', '2025-12-01 20:00:41'),
(4, 'a', 'a@a.com', 'Male', 'Tourist', 'Food', 1, '1', '2025-12-06 17:09:26'),
(6, 'Sanitary Ware & Plumbing', 'kal0118@stu.kau.edu.sa', 'Female', 'Tourist', 'Culture', 3, '3', '2025-12-06 17:15:28'),
(7, 'Kasedea', 'aa@g.com', 'Female', 'Tourist', 'Culture', 1, '2', '2025-12-06 17:17:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
