use credit_card_analysis2;

##INSERT STATEMENTS

insert into category(category_name) values ('Supermarket'), ('Merchendise'), ('Gasoline'), ('Utilities'), ('Services'), 
('Restaurants'), ('Pharmacy'), ('Travel'), ('Contracted Services'), ('Miscellaneous'), ('Veterinary'), ('Agricultural'), ('Entertainment'),
('Retail Outlets'), ('Transportation'), ('Clothing'), ('Bussiness Services'), ('Professional Services'), 
('Membership Services'), ('Government Services'), ('Lodging');

insert into user_details(name_on_card, address, user_ssn, date_of_birth, login_username, login_password, income) 
values('Miles Davis', '123 E Fort Wayne Street, Warsaw, IN', '1234567890', '1984-01-16','davis_miles', 'password123', 3000),
('Stan Wright', '56 N Colosseum Blvd, Fort Wayne, IN', '8899776644', '1963-11-07', 'stanwright', 'password123',  4000), 
('Hugh J', '451 Walter Way, New York, NY', '3344665500','1977-05-05', 'jhugh', 'password123',  2500),
('Jane Doe', '78 Apartment D, Sunset Street, Detroit, MI', '5012369874', '1993-03-16', 'doe-jane', 'password123', 10000);

insert into card_details(user_id_fk, credit_card_number, expiration_date, name_of_card) values 
(1, '9988776655443322', '2021-07-07', 'Visa Card 1 '),
(1, '3322114455669988', '2022-01-01', 'Discovery Card'),
(1, '1234114455669988', '2022-01-01', 'Chase Freedom');

insert into card_details(user_id_fk, credit_card_number, expiration_date, name_of_card) values 
(1, '1244114455669988', '2022-01-15', 'Amreican Express Blue Cash'),
(1, '9900114455669988', '2022-10-01', 'NFCU Debit'),
(2, '5566449977883322', '2023-05-30', 'Mastercard 1'),
(3, '9865321245784679', '2021-12-30', 'Visa'),
(4, '5957515358525456', '2022-06-16', 'Chase'),
(4, '3573693213438919', '2025-01-01', 'Chase 2');

insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Walmart', 41.271593744625605, -85.85662050266357, '2501 Walton Blvd, Warsaw, IN 46582');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Walmart', 41.128204039881574, -85.13785651616233, '5311 Coldwater Rd, Fort Wayne, IN 46825');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Kroger', 41.13341999837766, -85.06425317270948, '6002 St Joe Center Rd, Fort Wayne, IN 46835');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Kroger', 41.23966020298573, -85.82673778917074,'2211 E Center St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Lassus Handy Dandy', 41.24635724998368, -85.82424384499369,'777 Parker St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('BP', 41.059638355675155, -85.21906204684748,'6044 W Jefferson Blvd, Fort Wayne, IN 46804');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('NIPSCO', 41.24449936723772, -85.85569869388958, '004-043, #409, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('NIPSCO', 41.110455850908906, -85.19726587568114, '3725 Hillegas Rd, Fort Wayne, IN 46808');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Indiana American Water Company-Warsaw Operations', 41.26727971390907, -85.86011635848693,'2420 Hidden Lake Dr Rd, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Fort Wayne Water Department', 41.079101877901756, -85.13710490267006,'200 E Berry St #130, Fort Wayne, IN 46802');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('McDonalds', 41.24079039963746, -85.85321564684139,'315 N Detroit St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('McDonalds', 41.118337031499806, -85.18301550266874, '3010 W Coliseum Blvd, Fort Wayne, IN 46808');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('CVS', 41.23892700843284, -85.85234720081716, '100 N Detroit St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('CVS', 41.17784048486054, -85.13196197383137, '770 E Dupont Rd, Fort Wayne, IN 46825');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Phillips Plumbing Service', 41.212069626848546, -85.8883977603363, '1492 S Wausau St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Plumbing Services Inc', 41.034206950331125, -85.20790249057039,'2234 N Clinton St, Fort Wayne, IN 46805');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Hampton Inn', 41.23758371290977, -85.82047550266472, '115 Robmar Dr, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Quality Inn', 41.1399723015457, -85.16071700456253, '1734 West Washington Center Ro, Fort Wayne, IN 46818');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Khols', 41.27858166191291, -85.85523484684009, '590 W 300 N, Warsaw, IN 46582');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Old Navy',41.12273900427999, -85.13132520351523,'721 Northcrest Shopping Center, Fort Wayne, IN 46805');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Macys',41.11537065374534, -85.13953086033956, '4201 Coldwater Rd Ste 1, Fort Wayne, IN 46805');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Enterprise car rental', 41.25646273409801, -85.8574957408239,'215 N Lake St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Fort wayne art gallery', 41.076920852745616, -85.13677444332434, '210 E Jefferson Blvd, Fort Wayne, IN 46802');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Treadway Pool Supplies',41.27115832124475, -85.86400482576265,'1421 N Detroit St, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Harrison Elementary School',41.28424990732051, -85.82555744415559, '1300 Husky Trail, Warsaw, IN 46582');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Carnegie Boulevard KinderCare',41.079567305945424, -85.24598025003839, '7856 Carnegie Blvd, Fort Wayne, IN 46804');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Car Wash',41.13277000017322, -85.13492713150363,'Fort Wayne, IN 46825');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Sears Appliance Repair', 41.116338585025055, -85.14030372965665, '4201 Coldwater Rd, Fort Wayne, IN 46805');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Habeggers Furniture', 41.11399416560009, -85.13423124710768, '4004 Coldwater Rd, Fort Wayne, IN 46805');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('AMC Movies', 41.07687289654161, -85.19913366365347, '4250 W Jefferson Blvd, Fort Wayne, IN 46804');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('North Pointe Cinema', 41.25245543290216, -85.8242935449935,'1060 Mariners Dr, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Op Nails', 41.23764328209243, -85.81858489319247, '201 Eastlake Dr, Warsaw, IN 46580');
insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Skyline Garage', 41.08490179188166, -85.14234399277866, '220 W Wayne St, Fort Wayne, IN 46802');
