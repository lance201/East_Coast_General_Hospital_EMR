--
-- Table structure for table `Patient`
--
DROP TABLE IF EXISTS `Patient`;
CREATE TABLE `Patient` (
  `patient_id` int(11) NOT NULL AUTO_INCREMENT,
  `social_security` int(9) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `date_of_birth` date,
  `address` varchar(255),
  `insurance` varchar(255),
  `phone_number` varchar(255),
  `primary_doctor` varchar(255),
   PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Nurse`
--
INSERT INTO `Patient` VALUES 
(1, '123456789', 'Doe', 'John', '2001-01-01', 'Mulberry Lane', 'Aetna', '3334445555', 'Dr. Smith'),
(2, '987654321', 'Doe', 'Jane', '2002-02-02', 'Ocean Avenue', 'Blue Cross', '3334446666', 'Dr. Ross'),
(3, '135797531', 'Stewart', 'James', '1950-01-02', 'Hollywood Blvd', 'Anthem', '7778886666', 'Dr. Johnston');

--
-- Table structure for table `Nurse`
--
DROP TABLE IF EXISTS `Nurse`;
CREATE TABLE `Nurse` (
  `nurse_id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `department_name` varchar(255) NOT NULL,
  `phone_number` varchar(255),
   PRIMARY KEY (`nurse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Nurse`
--
INSERT INTO `Nurse` VALUES 
(1, 'Green', 'Annie', 'Emergency', '4446665555'),
(2, 'King', 'Lauren', 'Oncology', '4446665555'),
(3, 'Robertson', 'Marie', 'Pediatrics', '3336665555');

--
-- Table structure for table `Doctor`
--
DROP TABLE IF EXISTS `Doctor`;
CREATE TABLE `Doctor` (
  `doctor_id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `specialty` varchar(255) NOT NULL,
  `department_name` varchar(255) NOT NULL,
  `phone_number` varchar(255),
   PRIMARY KEY (`doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Doctor`
--
INSERT INTO `Doctor` VALUES 
(1, 'Tyler Moore', 'Mary', 'Hem/Onc', 'Oncology', '3337775555'),
(2, 'Williams', 'Jean', 'Pediatrics', 'Pediatrics', '4447775555'),
(3, 'Smith', 'Robert', 'Emergency', 'Emergency', '5557775555');

--
-- Table structure for table `Room`
--
DROP TABLE IF EXISTS `Room`;
CREATE TABLE `Room` (
  `room_id` int(11) NOT NULL,
  `floor` int(11) NOT NULL,
  `department_name` varchar(255),
   PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Room`
--
INSERT INTO `Room` VALUES 
(1, '3', 'Emergency'),
(2, '2', 'Pediatrics'),
(3, '1', 'Oncology');

--
-- Table structure for table `Department`
--
DROP TABLE IF EXISTS `Department`;
CREATE TABLE `Department` (
  `department_name` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  PRIMARY KEY (`department_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Department`
--
INSERT INTO `Department` VALUES 
('Pediatrics', '4447775555'),('Emergency', '1112223333'),('Oncology', '5556667777');;

--
-- Table structure for table `Requisition`
--
DROP TABLE IF EXISTS `Requisition`;
CREATE TABLE `Requisition` (
  `requisition_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_name` varchar(255) NOT NULL,
  `result` varchar(255) NOT NULL,
  PRIMARY KEY (`requisition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Requisition`
--
INSERT INTO `Requisition` VALUES 
(1, 'Troponin', 'Positive'),
(2, 'MRI', 'Positive'),
(3, 'EKG', 'Positive');

--
-- Table structure for table `Visit`
--
DROP TABLE IF EXISTS `Visit`;
CREATE TABLE `Visit` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `height` varchar(255) NOT NULL,
  `weight` varchar(255) NOT NULL,
  `chief_complaint` varchar(255) NOT NULL,
  `vital_sign` varchar(255) NOT NULL,
  `physical_exam` varchar(255) NOT NULL,
  `requisition_id` int(11) DEFAULT NULL,
  `treatment` varchar(255),
  `diagnosis` varchar(255),
   PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Visit`
--
INSERT INTO `Visit` VALUES 
(1, 1, 1, 1, '2021-11-10', 72, 150, 'Chest Pain', 'Stable', 'Abnormal', 1, 'Nitroglycerin', 'ACS'),
(2, 2, 2, 2, '2021-10-10', 80, 123, 'Headache', 'Stable', 'Abnormal', 2, 'Pending', 'Pending'),
(3, 3, 3, 3, '2021-09-09', 77, 153, 'Stomachache', 'Stable', 'Abnormal', 3, 'Pending', 'Pending');

--
-- Table structure for table `Nurse_Visit`
--
DROP TABLE IF EXISTS `Nurse_Visit`;
CREATE TABLE `Nurse_Visit` (
  `record_id` int(11) NOT NULL,
  `nurse_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Nurse_Visit`
--
INSERT INTO `Nurse_Visit` VALUES 
(1, 1),
(2, 2),
(3, 3);


--
-- Indexes for table `Patient`
--
ALTER TABLE `Patient`
    ADD UNIQUE KEY `patient_id` (`patient_id`),
    ADD UNIQUE KEY `social_security` (`social_security`);

--
-- Indexes for table `Nurse`
--
ALTER TABLE `Nurse`
    ADD UNIQUE KEY `nurse_id` (`nurse_id`),
    ADD CONSTRAINT `Nurse_ibfk_1` FOREIGN KEY (`department_name`) 
    REFERENCES `Department` (`department_name`) ON DELETE CASCADE;

--
-- Indexes for table `Doctor`
--
ALTER TABLE `Doctor`
    ADD UNIQUE KEY `doctor_id` (`doctor_id`),
    ADD CONSTRAINT `Doctor_ibfk_1` FOREIGN KEY (`department_name`) 
    REFERENCES `Department` (`department_name`) ON DELETE CASCADE;

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
    ADD UNIQUE KEY `room_id` (`room_id`),
    ADD CONSTRAINT `Room_ibfk_1` FOREIGN KEY (`department_name`) 
    REFERENCES `Department` (`department_name`) ON DELETE CASCADE;

--
-- Indexes for table `Department`
--
ALTER TABLE `Department`
    ADD UNIQUE KEY `department_name` (`department_name`);

--
-- Indexes for table `Requisition`
--
ALTER TABLE `Requisition`
    ADD UNIQUE KEY `requisition_id` (`requisition_id`);

--
-- Indexes for table `Visit`
--
ALTER TABLE `Visit`
    ADD UNIQUE KEY `record_id` (`record_id`),
    ADD CONSTRAINT `Visit_ibfk_1` FOREIGN KEY (`room_id`)
    REFERENCES `Room` (`room_id`) ON DELETE CASCADE,
    ADD CONSTRAINT `Visit_ibfk_2` FOREIGN KEY (`doctor_id`)
    REFERENCES `Doctor` (`doctor_id`) ON DELETE CASCADE,
    ADD CONSTRAINT `Visit_ibfk_3` FOREIGN KEY (`patient_id`)
    REFERENCES `Patient` (`patient_id`) ON DELETE CASCADE,
    ADD CONSTRAINT `Visit_ibfk_4` FOREIGN KEY (`requisition_id`)
    REFERENCES `Requisition` (`requisition_id`) ON DELETE CASCADE;