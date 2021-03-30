use credit_card_analysis;

insert into category(category_name) values ('Supermarket'), ('Merchendise'), ('Gasoline'), ('Utilities'), ('Services'), 
('Restaurants'), ('Pharmacy'), ('Travel'), ('Contracted Services'), ('Miscellaneous'), ('Veterinary'), ('Agricultural'), ('Entertainment'),
('Retail Outlets'), ('Transportation'), ('Clothing'), ('Bussiness Services'), ('Professional Services'), 
('Membership Services'), ('Government Services'), ('Lodging');

insert into sub_category(category_id_fk, sub_category_store_name) value (1, 'Walmart'), (1, 'Martins'), (1, 'Kroger'),
(2,'Walmart'), (2, 'Menards'), (2, 'Sams Club'),
(3, 'Lassus Handy Dandy'), (3, 'Marathon'), (3, 'Pilot'), (4, 'BP'),
(4, 'NIPSCO'), (5, 'Municipality Water Services'),
(5, 'Comcast'), (5, 'H2O wireless'),
(6, 'McDonalds'), (6, 'Arbys'), (6,'Boathouse club'), (6, 'Panda Express'),
(7, 'CVS'), (7, 'Walgreen'),
(8, 'Air France'), (8, 'Delta'), (8, 'AMtrack'),
(9, 'Phillips Plumbing Service'), (9, 'Plumbing Services Inc'), (9, 'Roofing'),
(10, 'Antique Shops'), (10, 'Nightclubs'), (10, 'Religious'), 
(11, 'Veternary Services'), (13, 'HBO'), (13, 'Netflix'),
(14, 'Walmart'), (14, 'Walmart'), (14, 'Kayes Jewellary'), (14, 'Jared'),
(15, 'Car Rentals'), (16, 'Kohls'), (16, 'Dicks Sporting Good'), (21, 'Fairfeild by Marriot');

insert into user_details(name_on_card, address, user_ssn, date_of_birth) values('Miles Davis', '123 E Fort Wayne Street, Warsaw, IN', '1234567890', '1984-01-16'),
('Stan Wright', '56 N Colosseum Blvd, Fort Wayne, IN', '8899776644', '1963-11-07'), 
('Hugh J', '451 Walter Way, New York, NY', '3344665500','1977-05-05'),
('Jane Doe', '78 Apartment D, Sunset Street, Detroit, MI', '5012369874', '1993-03-16');

insert into login_credentials(user_id_fk, login_username, login_password) values (1, 'davis_miles', 'password123'),
(2, 'stanwright', 'password123'),
(3, 'jhugh', 'password123'),
(4, 'doe-jane', 'password123');
    
insert into card_details(user_id_fk, credit_card_number, expiration_date) values 
(1, '9988776655443322', '2021-07-07'),
(2, '3322114455669988', '2022-01-01'),
(2, '5566449977883322', '2023-05-30'),
(3, '9865321245784679', '2021-12-30'),
(4, '5957515358525456', '2022-06-16'),
(4, '3573693213438919', '2025-01-01');

## CONFIRM THE SUB_CATEGORY_FK
insert into locations(sub_category_fk, location_name, location_latitude, location_longitude, location_address) values 
(2, 'Walmart', 41.271593744625605, -85.85662050266357, '2501 Walton Blvd, Warsaw, IN 46582'),
(2, 'Walmart', 41.128204039881574, -85.13785651616233, '5311 Coldwater Rd, Fort Wayne, IN 46825'),
(1, 'Kroger', 41.13341999837766, -85.06425317270948, '6002 St Joe Center Rd, Fort Wayne, IN 46835'),
(1, 'Kroger', 41.23966020298573, -85.82673778917074,'2211 E Center St, Warsaw, IN 46580'),
(3,'Lassus Handy Dandy', 41.24635724998368, -85.82424384499369,'777 Parker St, Warsaw, IN 46580'),
(3,'BP', 41.059638355675155, -85.21906204684748,'6044 W Jefferson Blvd, Fort Wayne, IN 46804'),
(11, 'NIPSCO', 41.24449936723772, -85.85569869388958, '004-043, #409, Warsaw, IN 46580'),
(11, 'NIPSCO', 41.110455850908906, -85.19726587568114, '3725 Hillegas Rd, Fort Wayne, IN 46808'),
(11, 'Indiana American Water Company-Warsaw Operations', 41.26727971390907, -85.86011635848693,'2420 Hidden Lake Dr Rd, Warsaw, IN 46580'),
(11, 'Fort Wayne Water Department', 41.079101877901756, -85.13710490267006,'200 E Berry St #130, Fort Wayne, IN 46802'),
(15, 'McDonalds', 41.24079039963746, -85.85321564684139,'315 N Detroit St, Warsaw, IN 46580'),
(15, 'McDonalds', 41.118337031499806, -85.18301550266874, '3010 W Coliseum Blvd, Fort Wayne, IN 46808'),
(19, 'CVS', 41.23892700843284, -85.85234720081716, '100 N Detroit St, Warsaw, IN 46580'),
(19, 'CVS', 41.17784048486054, -85.13196197383137, '770 E Dupont Rd, Fort Wayne, IN 46825'),
(24, 'Phillips Plumbing Service', 41.212069626848546, -85.8883977603363, '1492 S Wausau St, Warsaw, IN 46580'),
(25, 'Plumbing Services Inc', 41.034206950331125, -85.20790249057039,'2234 N Clinton St, Fort Wayne, IN 46805');

Insert into users (ID, USERID, PASSWORD) values (1,'user1','pass1'),(2,'user2','pass2'),(3,'user3','pass3'),(4,'user4','pass4'),
(5,'user5','pass5'),(6,'user6','pass6'),(7,'user7','pass7'),(8,'user8','pass8'),(9,'user9','pass9'),(10,'user10','pass10');
