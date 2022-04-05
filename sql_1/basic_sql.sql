-- Question 1
Select cardholder_first_name, cardholder_last_name, card_type, expiration_date
From CUSTOMER_PAYMENT
Order by expiration_date;

-- Question 2
Select first_name||' '|| last_name as customer_full_name
From customer
Where substr(FIRST_NAME, 1, 1) in ('A', 'B', 'C')
order by last_name desc;

-- Question 3 (sysdate = April/04/2022 Therefore, changed upperbound as sysdate and lowerbound as '2021-12-31')
Select CUSTOMER_ID, CONFIRMATION_NBR, DATE_CREATED, CHECK_IN_DATE, NUMBER_OF_GUESTS
from RESERVATION
Where (CHECK_IN_DATE <= sysdate) and (CHECK_IN_DATE >='2021-12-31')
ORDER BY CHECK_IN_DATE;

-- Question 4
--4-A
Select CUSTOMER_ID, CONFIRMATION_NBR, DATE_CREATED, CHECK_IN_DATE, NUMBER_OF_GUESTS
from RESERVATION
Where (CHECK_IN_DATE between '2021-12-31' AND sysdate )
ORDER BY CHECK_IN_DATE;
--4-B
Select CUSTOMER_ID, CONFIRMATION_NBR, DATE_CREATED, CHECK_IN_DATE, NUMBER_OF_GUESTS
from RESERVATION
Where (CHECK_IN_DATE <= sysdate) and (CHECK_IN_DATE >='2021-12-31')
MINUS
Select CUSTOMER_ID, CONFIRMATION_NBR, DATE_CREATED, CHECK_IN_DATE, NUMBER_OF_GUESTS
from RESERVATION
Where (CHECK_IN_DATE between '2021-12-31' AND sysdate )

-- Question 5
Select CUSTOMER_ID, LOCATION_ID,
       CHECK_OUT_DATE - CHECK_IN_DATE as length_of_stay
from RESERVATION
where status = 'C' and ROWNUM<=10
order by length_of_stay desc, customer_id;

-- Question 6
Select first_name, LAST_NAME, email,
       STAY_CREDITS_EARNED - STAY_CREDITS_USED as credits_available
from CUSTOMER
where (STAY_CREDITS_EARNED - STAY_CREDITS_USED) >= 10
order by credits_available desc;

-- Question 7
Select CARDHOLDER_FIRST_NAME, CARDHOLDER_MID_NAME, CARDHOLDER_LAST_NAME
from CUSTOMER_PAYMENT
where CARDHOLDER_MID_NAME is not Null
order by 2, 3;

-- Question 8
Select sysdate as today_unformatted,
       to_char(sysdate, 'MM/DD/YYYY') as today_formatted,
       25 as Credits_Earned,
       25/10 as Stays_Earned,
       Floor(25/10) as Redeemable_stays,
       Round(25/10) as Next_Stay_to_earn
From DUAL

-- Question 9
Select CUSTOMER_ID, LOCATION_ID,
       CHECK_OUT_DATE - CHECK_IN_DATE as length_of_stay
from RESERVATION
where status = 'C'
order by length_of_stay desc, CUSTOMER_ID
FETCH first 20 rows only;

-- Question 10
select FIRST_NAME, LAST_NAME, CONFIRMATION_NBR, DATE_CREATED, CHECK_IN_DATE, CHECK_OUT_DATE
from CUSTOMER cus inner join reservation res
    on cus.CUSTOMER_ID = res.CUSTOMER_ID
order by cus.CUSTOMER_ID, CHECK_OUT_DATE desc;
-- Question 11
Select first_name||' '|| last_name as Name, res.LOCATION_ID, CONFIRMATION_NBR, CHECK_IN_DATE, ROOM_NUMBER
from CUSTOMER cus join RESERVATION res on cus.CUSTOMER_ID = res.CUSTOMER_ID
                  join RESERVATION_DETAILS RD on res.RESERVATION_ID = RD.RESERVATION_ID
                  join ROOM R on RD.ROOM_ID = R.ROOM_ID
where STATUS = 'U' and STAY_CREDITS_EARNED > 40
order by last_name, CHECK_IN_DATE;

-- Question 12
Select FIRST_NAME, LAST_NAME, CONFIRMATION_NBR, DATE_CREATED, CHECK_IN_DATE, CHECK_OUT_DATE
from CUSTOMER cus left join reservation res on cus.CUSTOMER_ID = res.CUSTOMER_ID
where res.CUSTOMER_ID is null;

-- Question 13
Select '1-Gold Member' as Status_level, FIRST_NAME, LAST_NAME, EMAIL, STAY_CREDITS_EARNED
from CUSTOMER
where STAY_CREDITS_EARNED < 10
Union
Select '2-Platinum Member' as Status_level, FIRST_NAME, LAST_NAME, EMAIL, STAY_CREDITS_EARNED
from CUSTOMER
where 10 < STAY_CREDITS_EARNED  and  STAY_CREDITS_EARNED < 40
UNION
Select '3-Diamond Club' as Status_level, FIRST_NAME, LAST_NAME, EMAIL, STAY_CREDITS_EARNED
from CUSTOMER
where 40 <= STAY_CREDITS_EARNED
order by 1, 3;

select TO_CHAR(11234, '$999,999.99')
from dual;