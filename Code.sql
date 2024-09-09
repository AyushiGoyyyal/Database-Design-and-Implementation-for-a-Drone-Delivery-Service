-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 19, 2024 @ 12:00am EST

-- Team 9
-- Aishwarya Shenoy (ashenoy61) 
-- Ayushi Goyal (agoyal337)
-- Krishna Raj (kraj34)
-- Vamsi Verma (vkalidindi9)
-- Shiven Barbare (sbarbare3)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

/* Create statements */

-- user
DROP TABLE IF EXISTS user;
CREATE TABLE user (
uname VARCHAR(40) NOT NULL,
fname VARCHAR(100) NOT NULL,
lname VARCHAR(100) NOT NULL,
birthdate DATE,
address VARCHAR(500) NOT NULL,
PRIMARY KEY (uname)
);

-- customer
DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
uname VARCHAR(40) NOT NULL,
credit INT CHECK (credit>=0),
rating INT CHECK (rating in (1,2,3,4,5)),
PRIMARY KEY (uname),
CONSTRAINT fk1 FOREIGN KEY (uname) REFERENCES user (uname)
);

-- employee
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
taxID VARCHAR(11) NOT NULL UNIQUE CHECK (taxID LIKE '___-__-____'),
service integer NOT NULL,
uname VARCHAR(40) NOT NULL,
salary INT NOT NULL,
PRIMARY KEY (uname),
CONSTRAINT fk2 FOREIGN KEY (uname) REFERENCES user (uname)
);

-- drone_pilot
DROP TABLE IF EXISTS drone_pilot;
CREATE TABLE drone_pilot (
licenseID VARCHAR(255) NOT NULL UNIQUE, 
experience INT NOT NULL,
uname VARCHAR(40) NOT NULL,
PRIMARY KEY (uname),
CONSTRAINT fk3 FOREIGN KEY (uname) REFERENCES employee (uname)
);

-- store_worker
DROP TABLE IF EXISTS store_worker;
CREATE TABLE store_worker (
uname VARCHAR(40) NOT NULL,
PRIMARY KEY (uname),
CONSTRAINT fk4 FOREIGN KEY (uname) REFERENCES user (uname)
);
 
-- store
DROP TABLE IF EXISTS store;
CREATE TABLE store (
storeID VARCHAR(40) NOT NULL,
revenue INT CHECK (revenue >= 0),
sname VARCHAR(100) NOT NULL,
manager VARCHAR(200) NOT NULL,
PRIMARY KEY (storeID),
CONSTRAINT fk5 FOREIGN KEY (manager) REFERENCES store_worker (uname)
);

-- product
DROP TABLE IF EXISTS product;
CREATE TABLE product (
barcode VARCHAR(40) NOT NULL,
pname VARCHAR(40) NOT NULL,
weight INT NOT NULL CHECK (weight > 0),
PRIMARY KEY (barcode)
);

-- drone
DROP TABLE IF EXISTS drone;
CREATE TABLE drone ( 
droneTag VARCHAR(40) NOT NULL,
rem_trips INT CHECK (rem_trips >=0) NOT NULL,
capacity INT CHECK (capacity > 0) NOT NULL,
storeID VARCHAR(40) NOT NULL,
uname VARCHAR(40) NOT NULL,
PRIMARY KEY (storeID,dronetag),
CONSTRAINT fk8 FOREIGN KEY (uname) REFERENCES user (uname),
CONSTRAINT fk9 FOREIGN KEY (storeID) REFERENCES store (storeID));
 
-- employ
DROP TABLE IF EXISTS employ;
CREATE TABLE employ (
storeID VARCHAR(40) NOT NULL,
worker_uname VARCHAR(40) NOT NULL,
CONSTRAINT fk10 FOREIGN KEY (worker_uname) REFERENCES user (uname),
CONSTRAINT fk11 FOREIGN KEY (storeID) REFERENCES store (storeID));

-- orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
orderID VARCHAR(40) NOT NULL,
sold_on DATE NOT NULL,
requested_by VARCHAR(40) NOT NULL,
delivery_store VARCHAR(40) NOT NULL,
delivery_drone VARCHAR(40) NOT NULL,
PRIMARY KEY (orderID),
CONSTRAINT fk6 FOREIGN KEY (requested_by) REFERENCES customer (uname),
CONSTRAINT fk7 FOREIGN KEY (delivery_store,delivery_drone) REFERENCES drone (storeID, droneTag)
);

-- contain
DROP TABLE IF EXISTS contain;
CREATE TABLE contain (
orderID VARCHAR(40),
product_barcode VARCHAR(40),
price INT CHECK (price >= 0),
quantity INT CHECK (quantity >= 0),
PRIMARY KEY (orderID, product_barcode),
CONSTRAINT fk12 FOREIGN KEY (orderID) REFERENCES orders (orderID),
CONSTRAINT fk13 FOREIGN KEY (product_barcode) REFERENCES product (barcode)
);

/* Insert statements */

-- user inserts
INSERT INTO user VALUES 
('awilson5','Aaron','Wilson','1963-11-11','220 Peachtree Street'),
('csoares8','Claire','Soares','1965-09-03','706 Living Stone Way'),
('echarles19','Ella','Charles','1974-05-06','22 Peachtree Street'),
('eross10','Erica','Ross','1975-04-02','22 Peachtree Street'),
('hstark16','Harmon','Stark','1971-10-27','53 Tanker Top Lane'),
('jstone5','Jared','Stone','1961-01-06','101 Five Finger Way'),
('lrodriguez5','Lina','Rodriguez','1975-04-02','360 Corkscrew Circle'),
('sprince6','Sarah','Prince','1968-06-15','22 Peachtree Street'),
('tmccall5','Trey', 'McCall','1973-03-19','360 Corkscrew Circle');

-- customer inserts
INSERT INTO customer VALUES 
('awilson5',100,2),
('jstone5',40,4),
('lrodriguez5',60,4),
('sprince6',30,5);

-- employee inserts
INSERT INTO employee VALUES 
('111-11-1111', 9, 'awilson5', 46000),
('888-88-8888', 26, 'csoares8', 57000),
('777-77-7777', 3, 'echarles19', 27000),
('444-44-4444', 10, 'eross10', 61000),
('555-55-5555', 20, 'hstark16', 59000),
('222-22-2222', 20, 'lrodriguez5', 58000),
('333-33-3333',29,'tmccall5', 33000);

-- sw inserts
INSERT INTO store_worker VALUES 
('hstark16'),
('eross10'),
('echarles19');
 
 -- store inserts
INSERT INTO store VALUES 
('pub', 200, 'Publix', 'hstark16'),
('krg', 300, 'Kroger', 'echarles19');

-- pilot inserts
INSERT INTO drone_pilot VALUES
('314159', 41, 'awilson5'),
('287182', 67, 'lrodriguez5'),
('181633', 10, 'tmccall5');

-- product inserts
INSERT INTO product VALUES 
('ap_9T25E36L', 'antipasto platter', 4),
('pr_3C6A9R', 'pot roast', 6),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ss_2D4E6L', 'shrimp salad', 3);

-- drone inserts
INSERT INTO drone VALUES
('1',3,10,'pub','hstark16'),
('1',4,15,'krg','echarles19'),
('2',2,20,'pub','tmccall5');

-- orders inserts
INSERT INTO orders
VALUES 
('pub_303', '2021-05-23', 'sprince6', 'pub', '1'),
('krg_217', '2021-05-23', 'jstone5', 'krg', '1'),
('pub_306', '2021-05-22', 'awilson5', 'pub', '2'),
('pub_305', '2021-05-22', 'sprince6', 'pub', '2');

-- contain inserts
INSERT INTO contain VALUES
('pub_303','ap_9T25E36L',4, 1),
('krg_217','pr_3C6A9R',15, 2),
('pub_306','hs_5E7L23M',3,2),
('pub_305','clc_4T9U25X', 3,2);

-- employ inserts
INSERT INTO employ VALUES
('pub', 'awilson5'),
('pub', 'csoares8'),
('krg', 'echarles19'),
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'lrodriguez5'),
('pub', 'tmccall5');