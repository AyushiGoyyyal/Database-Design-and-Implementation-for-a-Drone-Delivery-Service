-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team 9
-- Aishwarya Shenoy (ashenoy61) 
-- Ayushi Goyal (agoyal337)
-- Krishna Raj (kraj34)
-- Vamsi Verma (vkalidindi9)
-- Shiven Barbare (sbarbare3)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
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

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_rating is null or ip_credit is null then
		leave sp_main;
	end if;
    if not exists (select uname from users where uname=ip_uname) then
		insert into users values (ip_uname,ip_first_name,ip_last_name,ip_address,ip_birthdate);
        insert into customers values (ip_uname,ip_rating,ip_credit);
	end if;
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_taxID is null or ip_service is null 
		or ip_salary is null or ip_licenseID is null or ip_experience is null then
			leave sp_main;
	end if;
    if not exists (select uname from users where uname=ip_uname)
		and not exists (select taxID from employees where taxID=ip_taxID)
        and not exists (select licenseID from drone_pilots where licenseID=ip_licenseID)
	then
			insert into users values (ip_uname,ip_first_name,ip_last_name,ip_address,ip_birthdate);
            insert into employees values (ip_uname,ip_taxID,ip_service,ip_salary);
            insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);
	end if;
end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	if ip_barcode is null or ip_pname is null or ip_weight is null then
		leave sp_main;
	end if;
	if not exists (select barcode from products where barcode=ip_barcode) then
		insert into products values (ip_barcode, ip_pname, ip_weight);
	end if;
end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
	if ip_storeID is null or ip_droneTag is null or ip_capacity is null or ip_remaining_trips is null or ip_pilot is null then
		leave sp_main;
	end if;
    if exists (select storeID from stores where storeID=ip_storeID)
		and not exists (select storeID,droneTag from drones where storeID=ip_storeID and droneTag=ip_droneTag)
        and not exists (select pilot from drones where pilot=ip_pilot)
        and exists (select uname from drone_pilots where uname=ip_pilot)
        and ip_capacity>0 and ip_remaining_trips>=0
	then
		insert into drones values (ip_storeID,ip_droneTag,ip_capacity,ip_remaining_trips,ip_pilot);
	end if;
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	if ip_money < 0 then leave sp_main;
    end if;
    update customers set credit = credit+ip_money where uname=ip_uname;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
    if ip_incoming_pilot is null or ip_outgoing_pilot is null then leave sp_main;
    end if;
	if not exists (select uname from drone_pilots where uname = ip_incoming_pilot)
       and exists (select pilot from drones where pilot = ip_incoming_pilot)
       and not exists (select pilot from drones where pilot = ip_outgoing_pilot)
       then leave sp_main;
       end if;
       update drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
    if ip_refueled_trips < 0 then leave sp_main;
    end if;
    update drones set remaining_trips = remaining_trips+ip_refueled_trips where storeID=ip_drone_store and droneTag=ip_drone_tag;
end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	declare ip_credit int;
    declare drone_capacity int;
    declare prod_weight int;
    
	if ip_orderID is null or ip_sold_on is null or ip_purchased_by is null or ip_carrier_store is null or ip_carrier_tag is null 
		or ip_barcode is null or ip_price is null or ip_quantity is null
	then
		leave sp_main;
	end if;
    if not exists (select orderId from orders where orderId=ip_orderID)
		and exists (select uname from customers where uname=ip_purchased_by)
        and exists (select storeID, droneTag from drones where storeID=ip_carrier_store and droneTag=ip_carrier_tag)
        and exists (select barcode from products where barcode=ip_barcode)
        and ip_price>=0 and ip_quantity>0
	then
		select credit into ip_credit from customers where uname=ip_purchased_by;
        select capacity into drone_capacity from drones where storeID=ip_carrier_store and droneTag=ip_carrier_tag;
        select weight into prod_weight from products where barcode=ip_barcode;
        if ip_credit >= ip_price*ip_quantity and drone_capacity >= ip_quantity*prod_weight
        then
			insert into orders values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
            insert into order_lines values (ip_orderID,ip_barcode,ip_price,ip_quantity);
		end if;
	end if;
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	DECLARE ip_custID VARCHAR(40);
    DECLARE ip_customer_credit INT;
	DECLARE ip_droneTag INT;
	DECLARE ip_carrier_store VARCHAR(40);
    DECLARE ip_drone_capacity INT;
    DECLARE ip_weight INT;
    DECLARE ip_exis_weight INT;
    DECLARE ip_exis_order_cost DECIMAL(10,2);
	-- Check if the orderid/barcode exists
    if ip_orderID is null or ip_barcode is null or ip_price is null or ip_quantity is null 
	then leave sp_main;
	end if;
    
	IF NOT EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
		LEAVE sp_main;
	END IF;
    IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = ip_barcode) THEN
		LEAVE sp_main;
	END IF;
    
    -- Check if the it's already part of order_line through orderid & barcode check, then exit witout update
    IF EXISTS (SELECT 1 FROM order_lines WHERE orderID = ip_orderID and barcode = ip_barcode ) THEN
		LEAVE sp_main;
	END IF;
    
    -- check if price is non-negative, and the quantity is positive.
   IF ip_price < 0 OR ip_quantity <= 0 THEN
		LEAVE sp_main;
	END IF;
    
    -- get custId
    SELECT purchased_by, carrier_tag, carrier_store
	INTO ip_custID, ip_droneTag, ip_carrier_store FROM orders WHERE orderID = ip_orderID;
    
    -- get customer_credit
    SELECT credit INTO ip_customer_credit FROM customers WHERE uname = ip_custID;
    
    -- get drone_capacity
    SELECT capacity INTO ip_drone_capacity FROM drones 
    where droneTag = ip_droneTag and storeID=ip_carrier_store;
    
    -- get ip_weight
    SELECT weight into ip_weight  FROM products WHERE barcode = ip_barcode;
    
    -- get weight of existing order as of now
    SELECT sum(a.weight*b.quantity) into ip_exis_weight
    from products as a
    inner join order_lines as b
    on a.barcode=b.barcode
    and b.orderID=ip_orderID;
    
     -- get cost of existing order as of now
    SELECT sum(price*quantity) into ip_exis_order_cost
    from order_lines 
    where orderID=ip_orderID;
    -- check customer has enough credits to purchase the products being added to the order
    IF ip_customer_credit < ((ip_price*ip_quantity) + ip_exis_order_cost)  THEN
		LEAVE sp_main;
	END IF;
    
    -- check if The drone has enough lifting capacity to carry the products being added.
	IF ip_drone_capacity < (ip_weight*ip_quantity + ip_exis_weight) THEN
		LEAVE sp_main;
	END IF;
    
    -- adding to order_lines
    INSERT INTO ORDER_LINES (orderID, barcode, price, quantity)
    VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
	-- place your solution here
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin

	DECLARE ip_droneTag INT;
	DECLARE ip_carrier_store VARCHAR(40);
	DECLARE ip_remaining_trips INT;
	DECLARE ip_custID VARCHAR(40);
	DECLARE ip_sold_on DATE;
    DECLARE ip_cost DECIMAL(10,2);
    DECLARE ip_pilotID VARCHAR(40);

	-- Check if the order exists
	IF NOT EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
		LEAVE sp_main;
	END IF;

	-- Retrieve order details
	SELECT sold_on, purchased_by, carrier_tag, carrier_store
	INTO ip_sold_on, ip_custID, ip_droneTag, ip_carrier_store
	FROM orders
	WHERE orderID = ip_orderID;

	-- Retrieve remaining trips from the associated drone
	SELECT remaining_trips,pilot INTO ip_remaining_trips,ip_pilotID FROM drones 
    WHERE droneTag = ip_droneTag and storeID=ip_carrier_store;

	-- Check if the drone has enough trips left
	IF ip_remaining_trips < 1 THEN
		LEAVE sp_main;
	END IF;
    
    -- Retrieve costs from order lines
	SELECT sum(price*quantity) INTO ip_cost FROM order_lines 
    WHERE orderID = ip_orderID
    group by orderID;
     
     -- update the credit of customer
	UPDATE customers
    SET credit = credit - ip_cost
    WHERE uname = ip_custID;
    
    -- update the store revenue
	UPDATE stores
    SET revenue = revenue + ip_cost
    WHERE storeID = ip_carrier_store;
     
     -- reducing drone remaining trips by 1
	UPDATE drones
    SET remaining_trips = remaining_trips - 1
    WHERE droneTag = ip_droneTag and storeID=ip_carrier_store;
    
    -- increasing pilot experience by 1
    UPDATE drone_pilots
    SET experience = experience + 1
    WHERE uname = ip_pilotID;
    
    -- increasing cust rating by 1
	IF ip_cost > 25 THEN
		UPDATE customers
		SET rating = rating + 1
		WHERE uname = ip_custID AND rating < 5;
	END IF;
    
    -- records of the order are otherwise removed from the system
     delete from order_lines where orderID=ip_orderID;
     delete from orders where orderID=ip_orderID;
     
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare ip_rating int;
    declare ip_uname varchar(40);
	if ip_orderID is null then
		leave sp_main;
	end if;
    if exists (select orderID from orders where orderID=ip_orderID) then
		select rating into ip_rating from customers join orders on uname=purchased_by where orderID=ip_orderID;
        select uname into ip_uname from customers join orders on uname=purchased_by where orderID=ip_orderID;
        # update rating
		update customers set rating=rating-1 where uname=ip_uname and rating>1; 
		# delete orders otherwise
		delete from order_lines where orderID=ip_orderID;
        delete from orders where orderID=ip_orderID;
	end if;
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as
-- replace this select query with your solution
select 'users' as category, count(distinct(uname)) as total from users
union all
select 'customers', count(distinct(uname)) from customers
union all
select 'employees', count(distinct(uname)) from employees
union all
select 'customer_employer_overlap', count(distinct(employees.uname)) from employees join customers on employees.uname = customers.uname
union all
select 'drone_pilots', count(distinct(uname)) from drone_pilots
union all
select 'store_workers', count(distinct(uname)) from store_workers
union all
select 'other_employee_roles', (select count(distinct(uname)) from employees) - ((select count(distinct(uname)) from drone_pilots) + (select count(distinct(uname)) from store_workers));

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- replace this select query with your solution
select customers.uname, rating, credit, coalesce(sum(price*quantity),0) from customers left join orders on customers.uname = orders.purchased_by 
left join order_lines on orders.orderID = order_lines.orderID 
group by customers.uname;

-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
with traffic as
(select d.storeID 'drone_serves_store', d.droneTag 'drone_tag', d.pilot, d.capacity 'total_weight_allowed', sum(l.quantity*p.weight) 'current_weight', 
	d.remaining_trips 'deliveries_allowed', count(distinct o.orderID) 'deliveries_in_progress'
from ((orders o join order_lines l on o.orderID=l.orderID) 
	join products p on l.barcode=p.barcode) 
    right join drones d on (storeId,droneTag)=(carrier_store,carrier_tag) 
group by d.storeId,d.droneTag)
select drone_serves_store, drone_tag, pilot,total_weight_allowed, ifnull(current_weight,0), deliveries_allowed, deliveries_in_progress
from traffic;
#select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7' from drones;

-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
-- replace this select query with your solution
with popularity as 
(select products.barcode 'barcode',pname 'product_name',weight 'weight',min(price) 'lowest_price',
	max(price) 'highest_price',min(quantity) 'lowest_quantity',max(quantity) 'highest_quantity',
    sum(quantity) 'total_quantity' 
from order_lines right join products
on products.barcode=order_lines.barcode
group by barcode)
select barcode, product_name, weight, lowest_price,highest_price, 
	ifnull(lowest_quantity,0), ifnull(highest_quantity,0), ifnull(total_quantity,0) 
from popularity;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
SELECT 
    uname,
    licenseID,
    storeID AS drone_serves_store,
    droneTag AS drone_tag,
    experience AS successful_deliveries,
    IFNULL(pending_deliveries,0)
FROM 
    drone_pilots 
LEFT JOIN 
    drones ON drone_pilots.uname = drones.pilot 
LEFT JOIN 
    (SELECT 
         COUNT(orderID) AS pending_deliveries,
         carrier_tag,
         carrier_store 
     FROM 
         orders 
     GROUP BY 
         carrier_tag, 
         carrier_store) ord ON drones.droneTag = ord.carrier_tag 
                            AND drones.storeID = ord.carrier_store;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
select storeID, sname, manager, revenue, sum(price*quantity), count(distinct(orders.orderID)) from stores join orders on stores.storeID = orders.carrier_store 
left join order_lines on orders.orderID = order_lines.orderID group by storeID;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
select orders.orderID, sum(price*quantity), count(order_lines.barcode), sum(weight*quantity), group_concat(pname) 
from orders left join order_lines on orders.orderID = order_lines.orderID 
left join products on order_lines.barcode = products.barcode 
group by orders.orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
	if ip_uname is null or not exists (select uname from customers where uname=ip_uname) or not exists (select uname from users where uname=ip_uname) then 
		leave sp_main; 
    end if;
	if not exists (select purchased_by from orders where purchased_by=ip_uname) then
		delete from customers where uname=ip_uname;
	end if;
	if not exists (select uname from employees where uname=ip_uname) then
		delete from users where uname=ip_uname;
    end if;
end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	if not exists (select uname from drone_pilots where uname=ip_uname) then leave sp_main; end if;
    if exists (select pilot from drones where pilot=ip_uname) then leave sp_main;end if;
    if exists (select uname from customers where uname=ip_uname) then
		delete from drone_pilots where uname=ip_uname;
        delete from employees where uname=ip_uname;
	else
		delete from drone_pilots where uname=ip_uname;
		delete from employees where uname=ip_uname;
		delete from users where uname=ip_uname;
    end if;
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	if not exists (select distinct barcode from order_lines where barcode=ip_barcode) then
		delete from products where barcode=ip_barcode;
	end if;
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	if not exists (select carrier_store,carrier_tag from orders where carrier_store=ip_storeID and carrier_tag=ip_droneTag) then
		delete from drones where storeID=ip_storeID and droneTag=ip_droneTag;
	end if;
end //
delimiter ;
