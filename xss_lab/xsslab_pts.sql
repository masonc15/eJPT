-- phpMyAdmin SQL Dump
-- version 4.1.4
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Gen 30, 2015 alle 17:28
-- Versione del server: 5.6.15-log
-- PHP Version: 5.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `xsslab.pts`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `article`
--

CREATE TABLE IF NOT EXISTS `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `cat` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dump dei dati per la tabella `article`
--

INSERT INTO `article` (`id`, `title`, `content`, `cat`) VALUES
(1, 'Google Cuts Back On Android Security Fixes - Source: BBC News', 'Android users could be left without fixes for bugs for a long time, warn security experts. Millions of Android users could be at risk as Google cuts back on security updates for older versions of its smartphone operating system. The risk arises because Google has stopped producing security updates for parts of those older versions. About 60% of all Android users, those on Android 4.3 or older, will be affected by the change. The researchers who uncovered the policy change said it was "great news for criminals".', 1),
(2, 'Skype for iOS is looking for a few good users - Source: cnet', 'Microsoft wants your help making Skype work better on your iOS device.\r\n\r\nAs it rolled out a new version of Skype for iPhone Wednesday, the company invited people who''d like to provide feedback on Skype for iOS to join a new pre-release program. Those who do will get access to early versions of Skype before they''re released to the public in return for offering your comments and criticisms. You can learn more about the program via its webpage.\r\n', 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `object` text NOT NULL,
  `message` text NOT NULL,
  `cat` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29 ;

--
-- Dump dei dati per la tabella `comments`
--

INSERT INTO `comments` (`id`, `uid`, `object`, `message`, `cat`) VALUES
(1, 1, 'Great!', 'This is really nice post!', 1),
(16, 2, 'Wow', 'They will regret this!', 1),
(17, 1, 'Microsoft and iOS?', 'I don''t think this is a very good idea', 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `feedbacks`
--

CREATE TABLE IF NOT EXISTS `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dump dei dati per la tabella `feedbacks`
--

INSERT INTO `feedbacks` (`id`, `name`, `email`, `content`) VALUES
(1, 'Mick. LeeMoore', 'asd@asd.it', 'They are the best. '),
(3, 'Mary Rose', 'm.rose@gmail.com', 'Keep up the good work guys. You are amazing!! ');

-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text NOT NULL,
  `password` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dump dei dati per la tabella `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', 'password'),
(2, 'john', '1234'),
(3, 'pts', 'pts'),
(4, 'attacker', 'attacker');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
