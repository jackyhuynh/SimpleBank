create database credit_card_analysis;
use credit_card_analysis;

create table category(
	category_id int not null auto_increment,
    category_name varchar(30),
    primary key (category_id)
)auto_increment=1;


create table sub_category(
	sub_category_id int not null auto_increment,
    category_id_fk int,
    sub_category_store_name varchar(50),
    primary key (sub_category_id),
    foreign key (category_id_fk) references category(category_id)
)auto_increment=1;

##Add total income of the user
create table user_details(
	user_id int not null auto_increment, 
    name_on_card varchar(50),
    address varchar(200),
    user_ssn varchar(20), 
    date_of_birth date,
    primary key (user_id)
)auto_increment=1;

##SSN is taken as varchar, it can be converted to numeric in business logic section

create table login_credentials(
	login_id int not null auto_increment,
    user_id_fk int,
    login_username varchar(20),
    login_password varchar(30),
    primary key (login_id),
    foreign key (user_id_fk) references user_details(user_id)
)auto_increment=1;

create table card_details(
	card_id int not null auto_increment,
    user_id_fk int,
    credit_card_number varchar(20),
    expiration_date date,
    primary key (card_id),
	foreign key (user_id_fk) references user_details(user_id)
)auto_increment=1;


## We should add sub_category to a location as it tells what will be the default product sold at the location.
create table locations(
	location_id int not null auto_increment,
    sub_category_fk int,
    location_name varchar(100),
    location_latitude varchar(20),
    location_longitude varchar(20),
    location_address varchar(100),
    primary key (location_id),
    foreign key (sub_category_fk) references sub_category(sub_category_id)
)auto_increment=1;

create table user_transaction_user_id_1(
	transaction_id int not null auto_increment,
    card_id_fk int,
    sub_category_id_fk int,
    locationid_id_fk int,
    amount double,
	date_of_transaction date,
    time_of_transaction time,
    transaction_type enum('Store', 'Online'),
    primary key (transaction_id),
    foreign key (card_id_fk) references card_details(card_id),
    foreign key (sub_category_id_fk) references sub_category(sub_category_id),
    foreign key (locationid_id_fk) references locations(location_id)
)auto_increment=1;

CREATE TABLE `users` (
  `ID` int NOT NULL,
  `USERID` varchar(45) NOT NULL,
  `PASSWORD` varchar(45) DEFAULT NULL,
  `CREATED_DATE` datetime DEFAULT NULL,
  `UPDATED_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`,`USERID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

