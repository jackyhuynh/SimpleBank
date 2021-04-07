use credit_card_analysis2;

##INSERT STATEMENTS
insert into category(category_name) values ('Supermarket'), ('Merchendise'), ('Gasoline'), ('Utilities'), ('Services'), 
('Restaurants'), ('Pharmacy'), ('Travel'), ('Contracted Services'), ('Miscellaneous'), ('Veterinary'), ('Agricultural'), ('Entertainment'),
('Retail Outlets'), ('Transportation'), ('Clothing'), ('Bussiness Services'), ('Professional Services'), 
('Membership Services'), ('Government Services'), ('Lodging');

insert into user_details(name_on_card, address, user_ssn, date_of_birth, login_username, login_password) 
values('Miles Davis', '123 E Fort Wayne Street, Warsaw, IN', '1234567890', '1984-01-16','davis_miles', 'password123'),
('Stan Wright', '56 N Colosseum Blvd, Fort Wayne, IN', '8899776644', '1963-11-07', 'stanwright', 'password123'), 
('Hugh J', '451 Walter Way, New York, NY', '3344665500','1977-05-05', 'jhugh', 'password123'),
('Jane Doe', '78 Apartment D, Sunset Street, Detroit, MI', '5012369874', '1993-03-16', 'doe-jane', 'password123');

insert into card_details(user_id_fk, credit_card_number, expiration_date) values 
(1, '9988776655443322', '2021-07-07'),
(2, '3322114455669988', '2022-01-01'),
(2, '5566449977883322', '2023-05-30'),
(3, '9865321245784679', '2021-12-30'),
(4, '5957515358525456', '2022-06-16'),
(4, '3573693213438919', '2025-01-01');

insert into locations(location_name, location_latitude, location_longitude, location_address) values 
('Walmart', 41.271593744625605, -85.85662050266357, '2501 Walton Blvd, Warsaw, IN 46582'),
('Walmart', 41.128204039881574, -85.13785651616233, '5311 Coldwater Rd, Fort Wayne, IN 46825'),
('Kroger', 41.13341999837766, -85.06425317270948, '6002 St Joe Center Rd, Fort Wayne, IN 46835'),
('Kroger', 41.23966020298573, -85.82673778917074,'2211 E Center St, Warsaw, IN 46580'),
('Lassus Handy Dandy', 41.24635724998368, -85.82424384499369,'777 Parker St, Warsaw, IN 46580'),
('BP', 41.059638355675155, -85.21906204684748,'6044 W Jefferson Blvd, Fort Wayne, IN 46804'),
('NIPSCO', 41.24449936723772, -85.85569869388958, '004-043, #409, Warsaw, IN 46580'),
('NIPSCO', 41.110455850908906, -85.19726587568114, '3725 Hillegas Rd, Fort Wayne, IN 46808'),
('Indiana American Water Company-Warsaw Operations', 41.26727971390907, -85.86011635848693,'2420 Hidden Lake Dr Rd, Warsaw, IN 46580'),
('Fort Wayne Water Department', 41.079101877901756, -85.13710490267006,'200 E Berry St #130, Fort Wayne, IN 46802'),
('McDonalds', 41.24079039963746, -85.85321564684139,'315 N Detroit St, Warsaw, IN 46580'),
('McDonalds', 41.118337031499806, -85.18301550266874, '3010 W Coliseum Blvd, Fort Wayne, IN 46808'),
('CVS', 41.23892700843284, -85.85234720081716, '100 N Detroit St, Warsaw, IN 46580'),
('CVS', 41.17784048486054, -85.13196197383137, '770 E Dupont Rd, Fort Wayne, IN 46825'),
('Phillips Plumbing Service', 41.212069626848546, -85.8883977603363, '1492 S Wausau St, Warsaw, IN 46580'),
('Plumbing Services Inc', 41.034206950331125, -85.20790249057039,'2234 N Clinton St, Fort Wayne, IN 46805');

insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 18, MAKEDATE(2021,10), MAKETIME(14,26,20), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 676, MAKEDATE(2021,0), MAKETIME(10,3,47), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 595, MAKEDATE(2021,117), MAKETIME(15,1,43), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 512, MAKEDATE(2021,103), MAKETIME(19,55,21), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 261, MAKEDATE(2021,31), MAKETIME(21,50,57), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 70, MAKEDATE(2021,63), MAKETIME(10,5,40), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 976, MAKEDATE(2021,56), MAKETIME(8,0,47), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 407, MAKEDATE(2021,110), MAKETIME(20,58,27), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 806, MAKEDATE(2021,113), MAKETIME(6,1,36), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 799, MAKEDATE(2021,45), MAKETIME(22,43,31), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 931, MAKEDATE(2021,68), MAKETIME(11,53,2), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 596, MAKEDATE(2021,96), MAKETIME(4,24,38), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 419, MAKEDATE(2021,86), MAKETIME(6,24,20), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 584, MAKEDATE(2021,103), MAKETIME(7,57,26), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 758, MAKEDATE(2021,31), MAKETIME(17,19,40), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 695, MAKEDATE(2021,33), MAKETIME(14,34,10), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 816, MAKEDATE(2021,37), MAKETIME(6,37,28), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 587, MAKEDATE(2021,34), MAKETIME(16,24,38), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 949, MAKEDATE(2021,48), MAKETIME(12,55,10), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 470, MAKEDATE(2021,23), MAKETIME(2,16,12), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 952, MAKEDATE(2021,49), MAKETIME(13,11,30), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 58, MAKEDATE(2021,104), MAKETIME(1,11,16), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 494, MAKEDATE(2021,34), MAKETIME(7,7,57), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 561, MAKEDATE(2021,90), MAKETIME(12,16,3), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 698, MAKEDATE(2021,42), MAKETIME(13,9,52), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 569, MAKEDATE(2021,103), MAKETIME(8,2,40), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 976, MAKEDATE(2021,46), MAKETIME(23,13,44), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 728, MAKEDATE(2021,109), MAKETIME(15,4,56), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 699, MAKEDATE(2021,56), MAKETIME(4,44,43), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 678, MAKEDATE(2021,43), MAKETIME(15,17,19), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 453, MAKEDATE(2021,119), MAKETIME(7,8,47), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 319, MAKEDATE(2021,7), MAKETIME(10,11,43), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 638, MAKEDATE(2021,92), MAKETIME(8,54,38), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 454, MAKEDATE(2021,38), MAKETIME(12,13,52), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 816, MAKEDATE(2021,100), MAKETIME(13,44,14), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 153, MAKEDATE(2021,64), MAKETIME(22,27,48), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 484, MAKEDATE(2021,114), MAKETIME(19,24,34), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 10, MAKEDATE(2021,96), MAKETIME(4,37,14), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 546, MAKEDATE(2021,10), MAKETIME(5,30,34), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 211, MAKEDATE(2021,105), MAKETIME(13,42,53), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 535, MAKEDATE(2021,117), MAKETIME(7,56,10), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 85, MAKEDATE(2021,101), MAKETIME(2,16,44), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 328, MAKEDATE(2021,72), MAKETIME(2,28,46), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 360, MAKEDATE(2021,67), MAKETIME(5,30,22), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 250, MAKEDATE(2021,16), MAKETIME(19,43,43), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 745, MAKEDATE(2021,34), MAKETIME(17,10,7), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 999, MAKEDATE(2021,40), MAKETIME(17,55,4), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 811, MAKEDATE(2021,72), MAKETIME(11,42,29), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 899, MAKEDATE(2021,109), MAKETIME(17,48,44), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 474, MAKEDATE(2021,72), MAKETIME(18,21,0), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 666, MAKEDATE(2021,17), MAKETIME(2,29,43), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 204, MAKEDATE(2021,24), MAKETIME(23,9,14), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 64, MAKEDATE(2021,7), MAKETIME(1,26,2), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 283, MAKEDATE(2021,84), MAKETIME(17,14,57), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 653, MAKEDATE(2021,101), MAKETIME(4,17,7), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 956, MAKEDATE(2021,33), MAKETIME(10,34,26), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 852, MAKEDATE(2021,10), MAKETIME(14,21,27), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 963, MAKEDATE(2021,34), MAKETIME(16,25,47), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 141, MAKEDATE(2021,13), MAKETIME(17,19,23), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 44, MAKEDATE(2021,108), MAKETIME(19,8,48), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 525, MAKEDATE(2021,78), MAKETIME(2,1,39), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 294, MAKEDATE(2021,92), MAKETIME(14,42,27), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 940, MAKEDATE(2021,42), MAKETIME(9,52,35), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 438, MAKEDATE(2021,81), MAKETIME(18,34,0), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 878, MAKEDATE(2021,44), MAKETIME(16,48,4), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 806, MAKEDATE(2021,84), MAKETIME(13,42,49), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 909, MAKEDATE(2021,18), MAKETIME(22,15,3), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 239, MAKEDATE(2021,66), MAKETIME(13,12,11), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 337, MAKEDATE(2021,53), MAKETIME(18,2,3), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 716, MAKEDATE(2021,48), MAKETIME(16,12,18), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 893, MAKEDATE(2021,61), MAKETIME(20,19,23), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 958, MAKEDATE(2021,94), MAKETIME(7,10,41), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 224, MAKEDATE(2021,68), MAKETIME(19,6,18), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 743, MAKEDATE(2021,38), MAKETIME(3,5,1), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 942, MAKEDATE(2021,108), MAKETIME(21,2,8), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 492, MAKEDATE(2021,104), MAKETIME(7,50,42), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 64, MAKEDATE(2021,99), MAKETIME(19,32,55), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 845, MAKEDATE(2021,76), MAKETIME(4,51,0), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 758, MAKEDATE(2021,21), MAKETIME(22,42,48), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 74, MAKEDATE(2021,28), MAKETIME(5,45,21), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 89, MAKEDATE(2021,107), MAKETIME(8,57,20), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 336, MAKEDATE(2021,86), MAKETIME(1,28,37), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 991, MAKEDATE(2021,48), MAKETIME(9,35,53), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 892, MAKEDATE(2021,72), MAKETIME(21,47,35), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 355, MAKEDATE(2021,8), MAKETIME(16,0,48), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 444, MAKEDATE(2021,7), MAKETIME(8,54,11), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 46, MAKEDATE(2021,9), MAKETIME(16,19,50), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 118, MAKEDATE(2021,58), MAKETIME(12,21,40), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 994, MAKEDATE(2021,94), MAKETIME(5,45,28), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 153, MAKEDATE(2021,51), MAKETIME(15,10,58), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 6, 11, 495, MAKEDATE(2021,54), MAKETIME(3,26,24), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 784, MAKEDATE(2021,49), MAKETIME(9,19,15), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 133, MAKEDATE(2021,101), MAKETIME(11,3,26), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 60, MAKEDATE(2021,46), MAKETIME(5,9,49), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 4, 100, MAKEDATE(2021,62), MAKETIME(2,21,49), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 5, 353, MAKEDATE(2021,82), MAKETIME(19,18,19), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 1, 1, 997, MAKEDATE(2021,92), MAKETIME(3,48,20), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 69, MAKEDATE(2021,78), MAKETIME(8,52,15), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 4, 7, 645, MAKEDATE(2021,77), MAKETIME(12,50,15), 'Store');
insert into user_transaction_user_id_1(card_id_fk, category_id_fk, locationid_id_fk, amount, date_of_transaction, time_of_transaction, transaction_type) values (1, 9, 15, 812, MAKEDATE(2021,66), MAKETIME(7,3,21), 'Store');


select * from category;
select * from user_details;
select * from card_details;
select * from locations;
select * from user_transaction_user_id_1;

#select location_id, location_name from locations where location_id in (1, 4, 5, 7, 11, 15, 24);
##location-sub-cat
##(1-2-1, 4-1-2, 5-3-1, 7-11-4, 11-15-6, 15-24-9);


