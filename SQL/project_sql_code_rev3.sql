/* Type of SQL : MySQL */
/* This script file creates the following tables:	*/
/* QUALIFICATIONS, COURSE, CANDIDATES, JOB_HISTORY, TRAINING_SESSIONS, */
/* BRIDGE_CAN_Q, BRIDGE_CAN_CRS, BRIDGE_CAN_TS, BRIDGE_CAN_OPEN, */
/* BRIDGE_OPEN_CMP, OPENINGS, COMPANIES, SESSION_ENROLLMENT */

DROP DATABASE IF EXISTS TEC_COMPANY;
CREATE DATABASE TEC_COMPANY;
USE TEC_COMPANY;	

/* dropped q_code PK; only attributes w/ int data types can be PK's */
CREATE TABLE IF NOT EXISTS QUALIFICATIONS(
Q_CODE VARCHAR(30) PRIMARY KEY,
Q_DESC VARCHAR(256)
);

/* data for QUALIFICATIONS table*/
INSERT INTO QUALIFICATIONS VALUES ('SEC-45', 'Secretarial work; candidate must type at least 45 words per minute');	
INSERT INTO QUALIFICATIONS VALUES ('SEC-60', 'Secretarial work; candidate must type at least 60 words per minute');
INSERT INTO QUALIFICATIONS VALUES ('CLERK', 'General clerkin work');	
INSERT INTO QUALIFICATIONS VALUES ('PRG-PY', 'Programmer, Python');
INSERT INTO QUALIFICATIONS VALUES ('PRG-C+++', 'Programmer, C++');
INSERT INTO QUALIFICATIONS VALUES ('DBA-ORA', 'Database Administrator, Oracle');
INSERT INTO QUALIFICATIONS VALUES ('DBA-DB2', 'Database Administrator, IBM DB2');
INSERT INTO QUALIFICATIONS VALUES ('DBA-SQLSERV', 'Database Administrator, MS SQL Server');
INSERT INTO QUALIFICATIONS VALUES ('SYS-1', 'Systems Analyst, Level 1');
INSERT INTO QUALIFICATIONS VALUES ('SYS-2', 'Systems Analyst, Level 2');
INSERT INTO QUALIFICATIONS VALUES ('NW-CIS', 'Network Administrator, Cisco experience');
INSERT INTO QUALIFICATIONS VALUES ('WD-CF', 'Web Developer, ColdFusion');

/* dropped can_lname PK; only attributes w/ int data types can be PK's */
CREATE TABLE IF NOT EXISTS CANDIDATES(
CAN_NUM INT PRIMARY KEY AUTO_INCREMENT,
CAN_FNAME VARCHAR(256),
CAN_MNAME VARCHAR(256),
CAN_LNAME VARCHAR(256),
Q_CODE VARCHAR(30),
JH_CODE INT,
OPEN_CODE INT
);

CREATE TABLE IF NOT EXISTS COURSE(
CRS_CODE INT PRIMARY KEY AUTO_INCREMENT,
Q_CODE VARCHAR(30),
CAN_NUM INT,
CRS_FEE INT,
CRS_Q_REQ VARCHAR(30),
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (Q_CODE) REFERENCES QUALIFICATIONS (Q_CODE),
FOREIGN KEY (CRS_Q_REQ) REFERENCES QUALIFICATIONS (Q_CODE)
);

CREATE TABLE IF NOT EXISTS TRAINING_SESSIONS(
TS_CODE INT PRIMARY KEY AUTO_INCREMENT,
CRS_CODE INT,
CAN_NUM INT,
TS_START_DATE DATE,
TS_END_DATE DATE,
FOREIGN KEY (CRS_CODE) REFERENCES COURSE (CRS_CODE)
);

/* dropped ts_code FK; FK'S must refer to a PK in another table. */
CREATE TABLE IF NOT EXISTS TRAINING_SESSIONS(
CAN_NUM INT,
TS_CODE INT PRIMARY KEY,
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (TS_CODE) REFERENCES TRAINING_SESSIONS (TS_CODE)
);

CREATE TABLE IF NOT EXISTS QUALIFIED_CANIDATES(
CAN_NUM INT,
Q_CODE VARCHAR(30),
PRIMARY KEY (CAN_NUM, Q_CODE),
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (Q_CODE) REFERENCES QUALIFICATIONS (Q_CODE)
);

CREATE TABLE IF NOT EXISTS COURSE_ENROLEMENT(
CAN_NUM INT,
CRS_CODE INT,
PRIMARY KEY (CAN_NUM, CRS_CODE),
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (CRS_CODE) REFERENCES COURSE (CRS_CODE)
);

CREATE TABLE IF NOT EXISTS SESSION_ENROLEMENT(
CAN_NUM INT,
TS_CODE INT,
PRIMARY KEY (CAN_NUM, TS_CODE),
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (TS_CODE) REFERENCES TRAINING_SESSIONS (TS_CODE)
);

CREATE TABLE IF NOT EXISTS OPENINGS(
OPEN_CODE INT AUTO_INCREMENT,
Q_CODE VARCHAR(30) ,
FOREIGN KEY (Q_CODE) REFERENCES QUALIFICATIONS (Q_CODE),
CMP_CODE INT,
-- FOREIGN KEY (CMP_CODE) REFERENCES COMPANIES (CMP_CODE),
OPEN_START_DATE DATE,
OPEN_EST_END_DATE DATE,
OPEN_HOURLY_PAY INT,
PRIMARY KEY (OPEN_CODE, Q_CODE) 
);

CREATE TABLE IF NOT EXISTS FILLED_OPENINGS(
CAN_NUM INT,
OPEN_CODE INT,
PRIMARY KEY (CAN_NUM, OPEN_CODE),
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (OPEN_CODE) REFERENCES OPENINGS (OPEN_CODE)
);

/* dropped can_lname FK; FK'S must refer to a PK in another table. */
CREATE TABLE IF NOT EXISTS JOB_HISTORY(
JH_CODE INT PRIMARY KEY AUTO_INCREMENT,
CAN_NUM INT,
JH_START_DATE DATE,
JH_END_DATE DATE,
JH_HOURLY_PAY INT,
OPEN_CODE INT,
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
FOREIGN KEY (OPEN_CODE) REFERENCES OPENINGS (OPEN_CODE)
);

/* added cmp_name attribute */
/* dropped cmp_name PK; only attributes w/ int data types can be PK's */
CREATE TABLE IF NOT EXISTS COMPANIES(
CMP_CODE INT PRIMARY KEY AUTO_INCREMENT,
CMP_NAME VARCHAR(40),
CMP_NUM INT
);

/* dropped cmp_name FK; FK'S must refer to a PK in another table. */
CREATE TABLE IF NOT EXISTS PLACEMENT(
OPEN_CODE INT,
CAN_NUM INT,
JH_CODE INT,
PL_TOTAL_HOURS INT,
CMP_NUM INT,
FOREIGN KEY (OPEN_CODE) REFERENCES OPENINGS (OPEN_CODE),
FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM)
);

ALTER TABLE CANDIDATES
ADD FOREIGN KEY (JH_CODE) REFERENCES JOB_HISTORY (JH_CODE),
ADD FOREIGN KEY (OPEN_CODE) REFERENCES OPENINGS (OPEN_CODE),
AUTO_INCREMENT = 1001;

ALTER TABLE JOB_HISTORY
ADD FOREIGN KEY (OPEN_CODE) REFERENCES OPENINGS (OPEN_CODE),
AUTO_INCREMENT = 4001;

ALTER TABLE OPENINGS
ADD FOREIGN KEY (CMP_CODE) REFERENCES COMPANIES (CMP_CODE);

ALTER TABLE TRAINING_SESSIONS
ADD FOREIGN KEY (CAN_NUM) REFERENCES CANDIDATES (CAN_NUM),
AUTO_INCREMENT = 3001;

ALTER TABLE QUALIFIED_CANIDATES
ADD FOREIGN KEY (Q_CODE) REFERENCES QUALIFICATIONS (Q_CODE);

ALTER TABLE COURSE
ADD FOREIGN KEY (Q_CODE) REFERENCES QUALIFICATIONS (Q_CODE),
AUTO_INCREMENT = 2001;


