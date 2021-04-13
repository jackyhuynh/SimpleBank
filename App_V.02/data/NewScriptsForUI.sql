use credit_card_analysis;

##GET ALL TRANSACTION DATA getTransactionDataWithStoreName

select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',  
t.time_of_transaction as 'Time', t.transaction_type as 'Type', l.location_name as 'Store Name' 
from user_transaction_user_id_1 as t
left join locations as l 
on l.location_id = t.locationid_id_fk
where l.deleted=1 and t.deleted=1
order by t.transaction_id;

##GET TRANSACTION DATA FOR EXISTING MONTH getCurrentMonthTransaction
select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',  
t.time_of_transaction as 'Time', t.transaction_type as 'Type', l.location_name as 'Store Name' 
from user_transaction_user_id_1 as t
left join locations as l 
on l.location_id = t.locationid_id_fk
where month(t.date_of_transaction) = month(sysdate()) and t.deleted=1 and l.deleted=1
order by t.transaction_id;

##GET TRANSACTION DETAILS BETWEEN TIME PERIOD getTransactionBetweenTimePeriod

select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',  
t.time_of_transaction as 'Time', t.transaction_type as 'Type', l.location_name as 'Store Name' 
from user_transaction_user_id_1 as t
left join locations as l 
on l.location_id = t.locationid_id_fk
where t.date_of_transaction between '2021-02-01' and '2021-03-31'and t.deleted=1 and l.deleted=1
order by t.transaction_id;

##GET TRANSACTIONS COORDINATES BETWEEN DATES TO PLOT ON MAP getTransactionCoordinatesForTimePeriod

select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', t.time_of_transaction as 'Time', 
l.location_name as 'LocationName', l.location_latitude as Latitude, l.location_longitude as Longitude, l.location_address as Address 
from user_transaction_user_id_1 as t 
left join locations as l 
on t.locationid_id_fk = l.location_id 
where t.date_of_transaction between '2021-02-01' and '2021-03-31' and t.deleted=1 and l.deleted=1
order by t.transaction_id;

##GET TRANSACTIONS BY CATEGORY getTransactionsByCategoryForCurrentMonth
select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', c.category_name as 'Category' 
from user_transaction_user_id_1 as t 
left join category as c
on t.category_id_fk = c.category_id 
where month(t.date_of_transaction) = month(sysdate()) and t.deleted=1 and c.deleted=1
order by t.transaction_id;


##GET AGGRGATED EXPENDITURE IN CATEGORY FOR CURRENT MONTH getAggregatedExpenditureByCategory

select sum(t.amount) as 'Sum', c.category_name as Category 
from user_transaction_user_id_1 as t 
left join category as c
on t.category_id_fk = c.category_id
where month(t.date_of_transaction) = month(sysdate()) and t.deleted=1 and c.deleted=1
group by c.category_name;
insert into user_details(name_on_card, address, user_ssn, date_of_birth, login_username, login_password) values('Issac Newton', 'Londn, England', '5655656', STR_TO_DATE ('01/21/1975','%m/%d/%Y'), 'inewton', 'pwd123');