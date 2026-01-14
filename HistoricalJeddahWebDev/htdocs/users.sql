-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql109.infinityfree.com
-- Generation Time: Dec 08, 2025 at 03:48 AM
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
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `fullname`, `email`, `password_hash`, `created_at`) VALUES
(1, 'Khaloody', 'gofey97966@operades.com', '$2y$10$UyJeIXEQHfq4gxhhUwxnZuRzaPcPBisTKHrN8q5b1vrWzyro61hwS', '2025-12-01 20:17:11'),
(2, 'Ahmadi', 'ahmadi@gmail.com', '$2y$10$VzxgSmy1px6ffBPPoi.U4ekFhUTkCAnKyyQPfls.NnXveRaTr1UUy', '2025-12-01 20:22:08'),
(3, 'anhdnas', 'W@GN.COM', '$2y$10$00X3aYfNDuxUz6uX5/dhnOxrk38H/0q.1X6qlrZs75Fg48vE5QSIi', '2025-12-01 20:30:47'),
(4, 'diresness', 'sadas@g.com', '$2y$10$r14DPnfc8KkWE6gIeRnyNeT2wQpNNdF.FXhyLKa9ONJkGj.EMS5Fu', '2025-12-01 20:31:56'),
(5, 'wow', 'sad@gm.com', '$2y$10$mHBWLJK/rBvC/9FFT2DoCOkvNEsYNZxSjuZOjQIc4.Yi3qo38ftRi', '2025-12-01 20:32:42'),
(6, 'Khaloody Hamd', 'kk@kk.com', '$2y$10$WaHpqckQnBj7kPFAZRnY4.mNsxi5.HumkK8pu8x..VHBfn/f1mzba', '2025-12-06 14:48:58'),
(7, 'Ahmed', 'ahmed@gmail.com', '$2y$10$w6aDxCvdMJyOhXoAiuOnEOUcxR56AYhjpO5BV3pINHR0QtQj6Qlae', '2025-12-07 19:30:08'),
(8, 'Mona', 'mona@gmail.com', '$2y$10$CJKG1eBRvwKtmKy.ziX3fOAQ/Lotu85ca45H6LhNIDWIRfLsTud.2', '2025-12-07 19:30:37'),
(9, 'Saleh', 'saleh@gmail.com', '$2y$10$Qa4NqIfetDbnITccWny8fOweUphEQ.cxBAodJZNehpIQO8j2JK562', '2025-12-07 19:30:52'),
(10, 'Lina', 'lina@gmail.com', '$2y$10$VE/zPP7nGYIAGQ4e7kV6xes1XM6BBNqCEVUvqMHFgucnzSQjoaL8K', '2025-12-07 19:31:05'),
(11, 'Yasser', 'yasser@gmail.com', '$2y$10$YzJgnA7SSipIaz/U57ITieWA0tP54cz885yjNYoxGgXawn.60j7D6', '2025-12-07 19:31:16');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
