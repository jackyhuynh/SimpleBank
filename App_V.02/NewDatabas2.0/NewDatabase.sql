create database credit_card_analysis2;
use credit_card_analysis2;

create table category(
	category_id int not null auto_increment,
    category_name varchar(30),
    primary key (category_id)
)auto_increment=1;


create table user_details(
	user_id int not null auto_increment, 
    name_on_card varchar(50),
    address varchar(200),
    user_ssn varchar(20), 
    date_of_birth date,
    login_username varchar(20),
    login_password varchar(30),
    primary key (user_id)
)auto_increment=1;

create table card_details(
	card_id int not null auto_increment,
    user_id_fk int,
    credit_card_number varchar(20),
    expiration_date date,
    primary key (card_id),
	foreign key (user_id_fk) references user_details(user_id)
)auto_increment=1;

create table locations(
	location_id int not null auto_increment,
    location_name varchar(100),
    location_latitude varchar(20),
    location_longitude varchar(20),
    location_address varchar(100),
    primary key (location_id)
)auto_increment=1;

create table user_transaction_user_id_1(
	transaction_id int not null auto_increment,
    card_id_fk int,
    category_id_fk int,
    locationid_id_fk int,
    amount double,
	date_of_transaction date,
    time_of_transaction time,
    transaction_type enum('Store', 'Online'),
    primary key (transaction_id),
    foreign key (card_id_fk) references card_details(card_id),
    foreign key (category_id_fk) references category(category_id),
    foreign key (locationid_id_fk) references locations(location_id)
)auto_increment=1;

alter table category add column deleted int default 1;
alter table user_details add column deleted int default 1;
alter table card_details add column deleted int default 1;
alter table locations add column deleted int default 1;
alter table user_transaction_user_id_1 add column deleted int default 1;
