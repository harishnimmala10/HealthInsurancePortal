-- phpMyAdmin SQL Dump
-- version 4.4.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2015 at 12:47 AM
-- Server version: 5.6.26
-- PHP Version: 5.6.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `healthinsurance1`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `enrol`(IN `pol` INT, IN `cus` INT, IN `amnt` INT, IN `cname` VARCHAR(40), IN `cnum` CHAR(16), IN `cexp` VARCHAR(5), IN `cvv` CHAR(4), IN `custname` VARCHAR(25))
    NO SQL
BEGIN
SET @date = CURDATE();
SET @val = mypremium(pol,custname);

IF(@val = amnt)
THEN

INSERT INTO enrollment VALUES(cus,pol,CURDATE(),
                              DATE_ADD(CURDATE(), INTERVAL 1 YEAR),
                              cname,cnum,cexp,cvv);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_of_doc`(IN `cust` INT)
    NO SQL
BEGIN

SELECT H.hospital_name as Hospital_Name,CONCAT(H.addr_line_1,',',H.city) AS Hospital_Addr, D.first_name as Doctor_Name,D.phone_no as Doctor_Phone,D.specialization as Doctor_Specialization
FROM hospital as H,affiliation as A, enrollment as E, customer as C, doctor as D
WHERE C.customer_id = E.customer_id AND
E.policy_id = A.policy_id AND
A.hospital_id = H.hospital_id AND
H.hospital_id = D.hospital_id AND
LOWER(C.addr_city) = LOWER(H.city) AND
C.customer_id = cust;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_of_hosp`(IN `cust` INT)
    NO SQL
BEGIN

SELECT H.hospital_name,H.addr_line_1,H.addr_line_2, H.phone_no 
FROM hospital as H,affiliation as A, enrollment as E, customer as C
WHERE C.customer_id = E.customer_id AND
E.policy_id = A.policy_id AND
A.hospital_id = H.hospital_id AND
LOWER(C.addr_city) = LOWER(H.city) AND
C.customer_id = cust;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pol_change`(IN `polid` INT, IN `adminid` INT, IN `polname` VARCHAR(80), IN `prem` INT, IN `maxpe` INT, IN `annmax` INT, IN `ded` INT, IN `car` INT, IN `tob` INT, IN `diab` INT, IN `age` INT)
    NO SQL
BEGIN
SET @dat = CURRENT_TIMESTAMP();

UPDATE policy SET 
policy.policy_name = polname,
policy.premium = prem,
policy.max_per_event = maxpe,
policy.annual_max = annmax,
policy.deductible = ded,
policy.cardio = car,
policy.tobacco = tob,
policy.diabetic = diab,
policy.min_age = age
WHERE
policy.policy_id = polid;

INSERT INTO policymanager(policy_id,last_modified,admin_id) 
VALUES(polid,@dat,adminid); 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_admin`(IN `un` VARCHAR(25), IN `pw` VARCHAR(25), IN `fn` VARCHAR(25), IN `ln` VARCHAR(25), IN `email` VARCHAR(25), IN `phnno` VARCHAR(15))
    NO SQL
BEGIN

INSERT INTO users(user_name,user_password,type) VALUES
(un,pw,2);

INSERT INTO administrator(user_name,email,phone_no,first_name,                       					last_name)
VALUES
(un,email,phnno,fn,ln);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_customer`(IN `uname` VARCHAR(20), IN `email` VARCHAR(25), IN `dob` DATE, IN `fn` VARCHAR(25), IN `ln` VARCHAR(25), IN `ad1` VARCHAR(100), IN `ad2` VARCHAR(100), IN `adc` VARCHAR(20), IN `ads` VARCHAR(20), IN `adz` CHAR(5), IN `ph` VARCHAR(15), IN `dia` INT, IN `car` INT, IN `tob` INT, IN `pwd` VARCHAR(25))
    NO SQL
BEGIN

INSERT INTO users(user_name,user_password,type) VALUES
(uname,pwd,1);

INSERT INTO customer(user_name,email,dob,first_name,                       					last_name,addr_line_1,addr_line_2,                                           addr_city,addr_state,addr_zip_code,                                         phone,diabetes,cardio,tobacco)
VALUES
(uname,email,dob,fn,ln,ad1,ad2,adc,ads,adz,ph,dia,car,tob);

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `mypremium`(`pol` INT, `cust` VARCHAR(20)) RETURNS int(11)
    NO SQL
BEGIN

DECLARE prem INT;

DECLARE val INT;
DECLARE val_flag INT;

DECLARE val1 INT;
DECLARE val1_flag INT;

DECLARE val2 INT;
DECLARE val2_flag INT;


SELECT premium into prem FROM policy where policy_id = pol;

SELECT tobacco into val_flag FROM customer where user_name = cust;
SELECT tobacco into val FROM policy where policy_id = pol;

SELECT diabetes into val1_flag FROM customer where user_name = cust;
SELECT diabetic into val1 FROM policy where policy_id = pol;

SELECT cardio into val2_flag FROM customer where user_name = cust;
SELECT cardio into val2 FROM policy where policy_id = pol;

if(val_flag = 1 ) THEN 
set prem := prem +val;
END IF;

if(val1_flag = 1 ) THEN 
set prem := prem +val1;
END IF;

if(val2_flag = 1 ) THEN 
set prem := prem +val2;
END IF;

RETURN prem;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `administrator`
--

CREATE TABLE IF NOT EXISTS `administrator` (
  `admin_id` int(11) NOT NULL,
  `user_name` varchar(25) DEFAULT NULL,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `email` varchar(25) NOT NULL,
  `phone_no` varchar(15) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `administrator`
--

INSERT INTO `administrator` (`admin_id`, `user_name`, `first_name`, `last_name`, `email`, `phone_no`) VALUES
(8, 'admin_1', 'Shreya', 'Pilli', 'pilli@gmail.com', '7048997645'),
(9, 'admin_2', 'Tom', 'Adem', 'adem@gmail.com', '9098976543'),
(10, 'admin_3', 'Sachin', 'Hillfigure', 'hillfigure@gmail.com', '9907685463'),
(11, 'admin_4', 'Obama', 'Barak', 'barak@gmail.com', '7098765643'),
(12, 'admin_5', 'Mark', 'Zukenburg', 'zukenburg@gmail.com', '9987096543');

-- --------------------------------------------------------

--
-- Table structure for table `affiliation`
--

CREATE TABLE IF NOT EXISTS `affiliation` (
  `policy_id` int(11) NOT NULL,
  `hospital_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `affiliation`
--

INSERT INTO `affiliation` (`policy_id`, `hospital_id`) VALUES
(4, 5),
(5, 5),
(4, 6),
(5, 6),
(8, 7),
(8, 8),
(6, 9),
(6, 10),
(8, 10),
(6, 11),
(7, 11),
(8, 11),
(6, 12),
(7, 12),
(6, 13),
(7, 13),
(8, 13),
(7, 14),
(8, 14),
(4, 15);

-- --------------------------------------------------------

--
-- Stand-in structure for view `aff_hospitals`
--
CREATE TABLE IF NOT EXISTS `aff_hospitals` (
`policy_id` int(11)
,`policy_name` varchar(80)
,`hospital_id` int(11)
,`hospital_name` varchar(20)
,`hospital_addr` varchar(100)
,`zip_code` char(5)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ass_doctor`
--
CREATE TABLE IF NOT EXISTS `ass_doctor` (
`doctor_id` int(11)
,`doctor_name` varchar(25)
,`specialization` varchar(20)
,`hospital_id` int(11)
,`hospital_name` varchar(20)
,`hospital_addr` varchar(100)
,`zip_code` char(5)
);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE IF NOT EXISTS `customer` (
  `customer_id` int(11) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `email` varchar(25) NOT NULL,
  `dob` date NOT NULL,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) DEFAULT NULL,
  `addr_line_1` varchar(100) NOT NULL,
  `addr_line_2` varchar(100) DEFAULT NULL,
  `addr_city` varchar(20) NOT NULL,
  `addr_state` varchar(20) NOT NULL,
  `addr_zip_code` char(5) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `diabetes` tinyint(1) NOT NULL,
  `cardio` tinyint(1) NOT NULL,
  `tobacco` tinyint(1) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `user_name`, `email`, `dob`, `first_name`, `last_name`, `addr_line_1`, `addr_line_2`, `addr_city`, `addr_state`, `addr_zip_code`, `phone`, `diabetes`, `cardio`, `tobacco`) VALUES
(10, 'customer_1', 'reddy@gmail.com', '1970-11-05', 'Ram', 'Reddy', '9304D', 'kittansett dr', 'Charlotte', 'NC', '28262', '9086754321', 0, 0, 0),
(11, 'customer_2', 'puli@gmail.com', '1980-07-07', 'Aditya', 'Puli', '9201', 'University Blvd', 'Charlotte', 'NC', '28223', '9087654321', 0, 0, 0),
(12, 'customer_3', 'mekala@gmail.com', '1964-11-09', 'Swetha', 'Mekala', '121', 'John Dr', 'Raleigh', 'NC', '27603', '9807654532', 0, 1, 0),
(13, 'customer_4', 'mehta@gmail.com', '1975-01-12', 'Kiran', 'Mehta', 'North Tryon ', 'Street', 'Atlanta', 'GA', '30301', '9987654321', 0, 0, 1),
(14, 'customer_5', 'Shetty@gmail.com', '1990-06-15', 'Sweety', 'Shetty', '1223', 'City Blvd', 'Atlanta', 'Georgia', '30302', '7067865432', 1, 0, 0),
(15, 'customer_6', 'Khan', '1992-08-30', 'Akshay', 'Khan', '432', 'HarrisBlvd', 'Charlestone', 'SC', '29401', '9807654567', 0, 1, 1),
(16, 'Customer_7', 'khanna@gmail.com', '1965-09-11', 'Shruti', 'Khanna', '42', 'Upstreet', 'Denver', 'CO', '80123', '6413425678', 1, 1, 1),
(17, 'customer_8', 'Tendulkar', '1956-03-17', 'Sakshi', 'Tendulkar', '34', 'DownStreet', 'Denver', 'CO', '80207', '9807654531', 1, 1, 0),
(18, 'customer_9', 'dhoni@gmail.com', '1969-09-29', 'Kranti', 'Dhoni', '21', 'Mountainville', 'JerseyCity', 'NJ', '07097', '7890987654', 1, 1, 1),
(19, 'Customer_10', 'clinton@gmail.com', '1977-05-11', 'Henry', 'Clinton', '09', 'Pineville', 'JersyCity', 'NJ', '07303', '6045674321', 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE IF NOT EXISTS `doctor` (
  `doctor_id` int(11) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  `email` varchar(25) NOT NULL,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `phone_no` varchar(15) NOT NULL,
  `specialization` varchar(20) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`doctor_id`, `hospital_id`, `email`, `first_name`, `last_name`, `phone_no`, `specialization`) VALUES
(3, 5, 'malhotra@gmail.com', 'Krish', 'Malhotra', '8907876545', 'General Medicine'),
(4, 15, 'karri@gmail.com', 'pichai', 'karri', '8907865454', 'General Medicine'),
(5, 5, 'sheshu@gmail.com', 'raj', 'sheshu', '9807654343', 'Cardiologist'),
(6, 6, 'nuli', 'Sid', 'nuli', 'Sid Nuli', 'General Medicine'),
(7, 9, 'mastan', 'abbas', 'mastan', '9087654343', 'Cardiologist'),
(8, 7, 'watson@gmail.com', 'emy', 'watson', '8796546789', 'Oncologist'),
(9, 8, 'potter@gmail.com', 'Harry', 'potter', '6789086545', 'Diabetician'),
(10, 10, 'wash@gmail.com', 'George', 'Wash', '8976545342', 'Cardiologist'),
(11, 10, 'Muthu@gmail.com', 'Murali', 'Muthu', '8907868989', 'Oncologist'),
(12, 11, 'simham@gmail.com', 'pichi', 'simham', '8907675656', 'Cardiologist'),
(13, 11, 'kumar@gmail.com', 'Ras', 'kumar', '6564567890', 'Diabetician'),
(14, 11, 'sever@gmail.com', 'Lia', 'sever', '7896754543', 'Oncologist'),
(15, 12, 'badham', 'manas', 'bhadam', '7896547878', 'Cardiologist'),
(16, 12, 'maddi', 'san', 'maddi', '8997965665', 'Diabetician'),
(17, 13, 'peddi@gmail.com', 'sangi', 'peddi', '8907865645', 'Cardiologist'),
(18, 13, 'kint@gmail.com', 'Chen', 'kint', '7865464321', 'Diabetician'),
(19, 13, 'quad@gmail.com', 'silly', 'quad', '7865465678', 'Oncologist'),
(20, 14, 'guddu@gmail.com', 'Sam', 'Guddu', '7675434533', 'Oncologist'),
(21, 14, 'selli@gmail.com', 'posh', 'selli', '7896542332', 'Diabetician');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment`
--

CREATE TABLE IF NOT EXISTS `enrollment` (
  `customer_id` int(11) NOT NULL,
  `policy_id` int(11) NOT NULL,
  `enroll_date` date NOT NULL,
  `due_date` date NOT NULL,
  `cc_name` varchar(40) NOT NULL,
  `cc_num` char(16) NOT NULL,
  `cc_expiry` varchar(5) NOT NULL,
  `cc_cvv` char(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `enrollment`
--

INSERT INTO `enrollment` (`customer_id`, `policy_id`, `enroll_date`, `due_date`, `cc_name`, `cc_num`, `cc_expiry`, `cc_cvv`) VALUES
(10, 4, '2014-09-12', '2016-09-12', 'Reddy', '789876765432', '08/19', '545'),
(11, 5, '2015-01-31', '2016-01-31', 'puli', '890976565432', '08/20', '897'),
(12, 6, '2015-02-26', '2016-02-26', 'Mekala', '786545432312', '09/18', '890'),
(13, 8, '2015-03-23', '2016-03-23', 'Mehta', '786545678907', '09/22', '789'),
(14, 7, '2015-03-16', '2016-03-16', 'Shetty', '789089765432', '08/21', '657'),
(15, 6, '2015-09-05', '2016-09-06', 'Khan', '456789765432', '09/23', '876'),
(15, 8, '2015-08-09', '2016-08-09', 'Khan', '456789765432', '09/23', '876'),
(16, 6, '2015-01-31', '2016-01-31', 'Khanna', '656456786543', '03/17', '675'),
(16, 7, '2015-05-09', '2016-05-09', 'Khanna', '656456786543', '03/17', '675'),
(16, 8, '2015-09-11', '2016-09-11', 'Khanna', '656456786543', '03/17', '675'),
(17, 6, '2015-02-26', '2016-02-26', 'Tendulkar', '765456787654', '09/19', '875'),
(17, 7, '2015-09-12', '2016-09-12', 'Tendulkar', '765456787654', '09/19', '875'),
(18, 6, '2015-05-09', '2016-05-09', 'Dhoni', '433456545678', '01/19', '324'),
(18, 7, '2015-05-23', '2016-05-23', 'Dhoni', '433456545678', '01/19', '324'),
(18, 8, '2015-07-18', '2016-07-18', 'Dhoni', '433456545678', '01/19', '324'),
(19, 7, '2015-05-23', '2016-05-23', 'Clinton', '657546675643', '07/21', '453'),
(19, 8, '2014-08-12', '2016-08-12', 'Clinton', '657546675643', '07/21', '453');

-- --------------------------------------------------------

--
-- Table structure for table `hospital`
--

CREATE TABLE IF NOT EXISTS `hospital` (
  `hospital_id` int(11) NOT NULL,
  `hospital_name` varchar(20) NOT NULL,
  `phone_no` varchar(25) NOT NULL,
  `addr_line_1` varchar(100) NOT NULL,
  `addr_line_2` varchar(100) DEFAULT NULL,
  `state` varchar(20) NOT NULL,
  `city` varchar(20) NOT NULL,
  `zip_code` char(5) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `hospital`
--

INSERT INTO `hospital` (`hospital_id`, `hospital_name`, `phone_no`, `addr_line_1`, `addr_line_2`, `state`, `city`, `zip_code`) VALUES
(5, 'CarolinaHealthCenter', '7049986543', '124', 'NorthStreet', 'NC', 'charlotte', '28262'),
(6, 'CharlotteMediCare', '9908785646', '9506', 'Batrenkreek Rd', 'NC', 'Charlotte', '28223'),
(7, 'GeorgiaMedicalCenter', '3045653434', '45', 'Kelry Drive', 'GA', 'Atlanta', '30301'),
(8, 'AtlantaHealthcare', '6043453454', '56', 'Akrick Dr', 'GA', 'Atlanta', '30302'),
(9, 'RaleighHealthCenter', '7089786565', '99', 'South Street', 'NC', 'Raleigh', '27603'),
(10, 'CharlestonMedicalCar', '9087896776', 'Mary Road', 'Uptown', 'SC', 'Charleston', '29401'),
(11, 'ColoradMedicCare', '9087654321', '786', 'Downtown', 'CO', 'Denver', '80123'),
(12, 'DenverHealthCenter', '8097867654', '89', 'Jacky Road', 'CO', 'Denver', '80207'),
(13, 'JerseyHospitals', '9076549080', '901', 'Pineville', 'NJ', 'JerseyCity', '07097'),
(14, 'CityMedics', '890765432', '9807', 'Upstreet', 'NJ', 'JerseyCity', '07303'),
(15, 'NorthCaroHealth', '7048765467', 'Kirk Dr', 'Tryon Rd', 'NC', 'Charlotte', '28262');

-- --------------------------------------------------------

--
-- Table structure for table `policy`
--

CREATE TABLE IF NOT EXISTS `policy` (
  `policy_id` int(11) NOT NULL,
  `policy_name` varchar(80) NOT NULL,
  `premium` int(10) NOT NULL,
  `max_per_event` int(10) NOT NULL,
  `annual_max` int(10) NOT NULL,
  `deductible` int(10) NOT NULL,
  `cardio` int(10) DEFAULT NULL,
  `tobacco` int(10) DEFAULT NULL,
  `diabetic` int(10) DEFAULT NULL,
  `min_age` int(5) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `policy`
--

INSERT INTO `policy` (`policy_id`, `policy_name`, `premium`, `max_per_event`, `annual_max`, `deductible`, `cardio`, `tobacco`, `diabetic`, `min_age`) VALUES
(4, 'GenericHealthInsurance', 1000, 20000, 40000, 100, 52, 50, 50, 20),
(5, 'MediCare', 500, 1000, 5000, 100, 75, 75, 70, 20),
(6, 'CardioCare', 2000, 30000, 50000, 120, 150, 50, 75, 20),
(7, 'DiabeticCare', 2000, 10000, 30000, 100, 75, 50, 200, 20),
(8, 'CancerHealthInsurance', 5000, 10000, 20000, 100, 75, 125, 50, 20);

--
-- Triggers `policy`
--
DELIMITER $$
CREATE TRIGGER `pol_log_update` AFTER UPDATE ON `policy`
 FOR EACH ROW BEGIN
SET @today = CURRENT_TIMESTAMP();

INSERT INTO policylog (policyid,changetime,policy_name,premium,max_per_event,annual_max,deductible,cardio,tobacco,diabetic,min_age)
 VALUES 
(OLD.policy_id,@today,OLD.policy_name,OLD.premium,OLD.max_per_event,OLD.annual_max,OLD.deductible,OLD.cardio,OLD.tobacco,OLD.diabetic,OLD.min_age);


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `policylog`
--

CREATE TABLE IF NOT EXISTS `policylog` (
  `logid` int(11) NOT NULL,
  `policyid` int(11) NOT NULL,
  `changetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `policy_name` varchar(80) NOT NULL,
  `premium` int(10) NOT NULL,
  `max_per_event` int(10) NOT NULL,
  `annual_max` int(10) NOT NULL,
  `deductible` int(10) NOT NULL,
  `cardio` int(10) NOT NULL,
  `tobacco` int(10) NOT NULL,
  `diabetic` int(10) NOT NULL,
  `min_age` int(5) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `policylog`
--

INSERT INTO `policylog` (`logid`, `policyid`, `changetime`, `policy_name`, `premium`, `max_per_event`, `annual_max`, `deductible`, `cardio`, `tobacco`, `diabetic`, `min_age`) VALUES
(1, 4, '2015-12-10 23:23:17', 'GenericHealthInsurance', 1000, 20000, 40000, 100, 50, 50, 50, 20);

-- --------------------------------------------------------

--
-- Table structure for table `policymanager`
--

CREATE TABLE IF NOT EXISTS `policymanager` (
  `policy_id` int(11) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `admin_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `policymanager`
--

INSERT INTO `policymanager` (`policy_id`, `last_modified`, `admin_id`) VALUES
(4, '2015-12-06 02:04:45', 8),
(6, '2015-12-06 02:06:24', 8),
(4, '2015-12-06 02:05:27', 9),
(5, '2015-12-06 02:05:38', 9),
(8, '2015-12-06 02:07:05', 9),
(5, '2015-12-06 02:05:47', 10),
(6, '2015-12-06 02:05:57', 11),
(7, '2015-12-06 02:06:46', 11),
(7, '2015-12-06 02:06:37', 12),
(8, '2015-12-06 02:06:56', 12);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_name` varchar(25) NOT NULL,
  `user_password` varchar(25) NOT NULL,
  `type` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_name`, `user_password`, `type`) VALUES
('admin_1', 'pilli', 2),
('admin_2', 'Adem', 2),
('admin_3', 'Hillfigure', 2),
('admin_4', 'Barak', 2),
('admin_5', 'Zukenburg', 2),
('customer_1', 'Reddy', 1),
('Customer_10', 'Clinton', 1),
('customer_11', 'pilli', 1),
('customer_2', 'Puli', 1),
('customer_3', 'Mekala', 1),
('customer_4', 'Mehta', 1),
('customer_5', 'Shetty', 1),
('customer_6', 'khan', 1),
('Customer_7', 'khanna', 1),
('customer_8', 'Tendulkar', 1),
('customer_9', 'Dhoni', 1);

-- --------------------------------------------------------

--
-- Structure for view `aff_hospitals`
--
DROP TABLE IF EXISTS `aff_hospitals`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `aff_hospitals` AS select `p`.`policy_id` AS `policy_id`,`p`.`policy_name` AS `policy_name`,`h`.`hospital_id` AS `hospital_id`,`h`.`hospital_name` AS `hospital_name`,`h`.`addr_line_1` AS `hospital_addr`,`h`.`zip_code` AS `zip_code` from ((`hospital` `h` join `policy` `p`) join `affiliation` `a`) where ((`a`.`hospital_id` = `h`.`hospital_id`) and (`a`.`policy_id` = `p`.`policy_id`)) order by `p`.`policy_id`,`h`.`hospital_id`;

-- --------------------------------------------------------

--
-- Structure for view `ass_doctor`
--
DROP TABLE IF EXISTS `ass_doctor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ass_doctor` AS select `d`.`doctor_id` AS `doctor_id`,`d`.`first_name` AS `doctor_name`,`d`.`specialization` AS `specialization`,`h`.`hospital_id` AS `hospital_id`,`h`.`hospital_name` AS `hospital_name`,`h`.`addr_line_1` AS `hospital_addr`,`h`.`zip_code` AS `zip_code` from (`hospital` `h` join `doctor` `d`) where (`h`.`hospital_id` = `d`.`hospital_id`) order by `h`.`hospital_id`;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administrator`
--
ALTER TABLE `administrator`
  ADD PRIMARY KEY (`admin_id`),
  ADD KEY `user_name` (`user_name`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `affiliation`
--
ALTER TABLE `affiliation`
  ADD PRIMARY KEY (`policy_id`,`hospital_id`),
  ADD KEY `hospital_id` (`hospital_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `user_name` (`user_name`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`doctor_id`),
  ADD KEY `hospital_id` (`hospital_id`),
  ADD KEY `last_name` (`last_name`);

--
-- Indexes for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD PRIMARY KEY (`customer_id`,`policy_id`),
  ADD KEY `policy_id` (`policy_id`);

--
-- Indexes for table `hospital`
--
ALTER TABLE `hospital`
  ADD PRIMARY KEY (`hospital_id`),
  ADD UNIQUE KEY `hospital_name` (`hospital_name`);

--
-- Indexes for table `policy`
--
ALTER TABLE `policy`
  ADD PRIMARY KEY (`policy_id`),
  ADD UNIQUE KEY `policy_name` (`policy_name`);

--
-- Indexes for table `policylog`
--
ALTER TABLE `policylog`
  ADD PRIMARY KEY (`logid`);

--
-- Indexes for table `policymanager`
--
ALTER TABLE `policymanager`
  ADD PRIMARY KEY (`policy_id`,`last_modified`,`admin_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `administrator`
--
ALTER TABLE `administrator`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `doctor`
--
ALTER TABLE `doctor`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `hospital`
--
ALTER TABLE `hospital`
  MODIFY `hospital_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `policy`
--
ALTER TABLE `policy`
  MODIFY `policy_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `policylog`
--
ALTER TABLE `policylog`
  MODIFY `logid` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `administrator`
--
ALTER TABLE `administrator`
  ADD CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`user_name`) REFERENCES `users` (`user_name`);

--
-- Constraints for table `affiliation`
--
ALTER TABLE `affiliation`
  ADD CONSTRAINT `affiliation_ibfk_1` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`policy_id`),
  ADD CONSTRAINT `affiliation_ibfk_2` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`user_name`) REFERENCES `users` (`user_name`);

--
-- Constraints for table `doctor`
--
ALTER TABLE `doctor`
  ADD CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`);

--
-- Constraints for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`policy_id`),
  ADD CONSTRAINT `enrollment_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `policymanager`
--
ALTER TABLE `policymanager`
  ADD CONSTRAINT `policymanager_ibfk_1` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`policy_id`),
  ADD CONSTRAINT `policymanager_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `administrator` (`admin_id`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `due_check` ON SCHEDULE EVERY 1 MINUTE STARTS '2015-12-07 22:12:17' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
DECLARE var DATE;
DECLARE pid INT;
DECLARE cid INT;
DECLARE flag INT DEFAULT FALSE;
DECLARE today DATE;

DECLARE curs CURSOR FOR SELECT customer_id, policy_id, due_date FROM enrollment;
SET today = CURDATE();

OPEN curs;
read_loop : LOOP
FETCH curs into cid,pid,var;

if flag THEN 
LEAVE read_loop;
end if;

if(var = today) THEN
DELETE FROM enrollment WHERE customer_id = cid AND policy_id = pid;
end if;

END LOOP;
CLOSE curs;


END$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
