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
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `schedule_id` int(11) NOT NULL,
  `day` varchar(20) NOT NULL,
  `time_slot` varchar(50) NOT NULL,
  `event` varchar(150) NOT NULL,
  `guide_name` varchar(100) DEFAULT NULL,
  `guide_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `schedule`
--

INSERT INTO `schedule` (`schedule_id`, `day`, `time_slot`, `event`, `guide_name`, `guide_id`) VALUES
(11, 'Sunday', '8:00 AM - 11:00 AM', 'Al-Balad Walking Tour', 'Ahmed', 7),
(12, 'Sunday', '1:00 PM - 4:00 PM', 'Corniche Photography Tour', 'Mona', 8),
(13, 'Monday', '9:00 AM - 12:00 PM', 'Floating Mosque Visit', 'Saleh', 9),
(14, 'Tuesday', '2:00 PM - 5:00 PM', 'Red Sea Mall Shopping Tour', 'Lina', 10),
(15, 'Wednesday', '6:00 PM - 9:00 PM', 'King Fahd Fountain Night Tour', 'Yasser', 11);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `fk_schedule_user` (`guide_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `schedule`
--
ALTER TABLE `schedule`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `fk_schedule_user` FOREIGN KEY (`guide_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
