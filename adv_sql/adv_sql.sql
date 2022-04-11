-- Summary Problems
-- Question 1
select count(*) as count_of_customers,
       min(STAY_CREDITS_EARNED) as min_credits,
       max(STAY_CREDITS_EARNED) as max_credits
from CUSTOMER;

-- Question 2
select CUSTOMER_ID, min(CHECK_IN_DATE) as earliest_check_in,
       count(*) as Number_of_Reservations
from RESERVATION
where CUSTOMER_ID in
    (select CUSTOMER_ID
    from CUSTOMER)
group by  CUSTOMER_ID
order by CUSTOMER_ID;

-- Question 3
select city, state, round(avg(STAY_CREDITS_EARNED)) as avg_credits_earned
from CUSTOMER
group by city, STATE
order by state, avg_credits_earned desc;

-- Question 4
-- Join 4 tables
select cus.CUSTOMER_ID, cus.last_name, ro.ROOM_NUMBER, count(res_de.RESERVATION_ID) as stay_count
from customer cus join reservation res on cus.CUSTOMER_ID = res.CUSTOMER_ID
join RESERVATION_DETAILS res_de on res.RESERVATION_ID = res_de.RESERVATION_ID
join room ro on res_de.ROOM_ID = ro.ROOM_ID
where ro.LOCATION_ID = 1
group by cus.CUSTOMER_ID, cus.last_name, ro.ROOM_NUMBER
order by CUSTOMER_ID, stay_count desc;


-- Question 5
select cus.CUSTOMER_ID, cus.last_name, ro.ROOM_NUMBER, count(res_de.RESERVATION_ID) as stay_count
from customer cus join reservation res on cus.CUSTOMER_ID = res.CUSTOMER_ID
join RESERVATION_DETAILS res_de on res.RESERVATION_ID = res_de.RESERVATION_ID
join room ro on res_de.ROOM_ID = ro.ROOM_ID
where ro.LOCATION_ID = 1 and STATUS = 'C'
group by cus.CUSTOMER_ID, cus.last_name, ro.ROOM_NUMBER
having count(res_de.RESERVATION_ID) > 2
order by CUSTOMER_ID, stay_count desc;

-- Question 6 - A
select LOCATION_NAME, CHECK_IN_DATE, count(NUMBER_OF_GUESTS)
from RESERVATION join LOCATION on reservation.LOCATION_ID = location.LOCATION_ID
where CHECK_IN_DATE > sysdate
group by rollup (LOCATION_NAME, CHECK_IN_DATE);

-- Question 6 - B
--CUBE generates a result set that represents aggregates for every possible combinations of values in the selected columns.
--Useful to generate information overall

-- Question 7
select FEATURE_NAME, count(*) as count_of_locations
from LOCATION L join LOCATION_FEATURES_LINKING LF on L.LOCATION_ID = lf.LOCATION_ID
join FEATURES F on LF.FEATURE_ID = F.FEATURE_ID
group by FEATURE_NAME
having count(*) > 2;

--Subquery Problems
-- Question 8
select distinct c.CUSTOMER_ID, c.FIRST_NAME, c.LAST_NAME, c.email
from CUSTOMER c
where CUSTOMER_ID not in
(   select CUSTOMER_ID
    from RESERVATION r);

-- Question 9
select FIRST_NAME, LAST_NAME, EMAIL, PHONE, STAY_CREDITS_EARNED
from CUSTOMER
where STAY_CREDITS_EARNED >
(select avg(STAY_CREDITS_EARNED)
from CUSTOMER)
order by  STAY_CREDITS_EARNED desc;

-- Question 10
select c.city, c.state, (total_earned - total_used) as credits_remaining
from CUSTOMER c join (
    select city, state, sum(STAY_CREDITS_EARNED) as total_earned, sum(STAY_CREDITS_USED) as total_used
    from CUSTOMER
    group by city, state
    order by city, state
) g on c.city = g.city
order by  credits_remaining desc;

-- Question 11
select confirmation_nbr, date_created, check_in_date, status, room_id
from RESERVATION r join RESERVATION_DETAILS rd on r.RESERVATION_ID = rd.RESERVATION_ID
where r.RESERVATION_ID in
(select room_id
from RESERVATION_DETAILS
group by room_id
having count(room_id) < 5)
and status != 'C';


-- Question 12
select CARDHOLDER_FIRST_NAME, CARDHOLDER_LAST_NAME, CARD_NUMBER, EXPIRATION_DATE, CC_ID
from CUSTOMER_PAYMENT
where CUSTOMER_ID in
(select c.CUSTOMER_ID
from customer c join RESERVATION r on c.CUSTOMER_ID = r.CUSTOMER_ID
where status = 'C'
group by c.CUSTOMER_ID
having count(RESERVATION_ID) = 1)
and CARD_TYPE = 'MSTR';



