-- Data types and views
-- Question 1
select sysdate, to_char(sysdate, 'YEAR') as YEAR,
       to_char(sysdate,'DAY') ||' '||to_char(sysdate, 'Mon') as DAY_MONTH,
       TRUNC(sysdate, 'HH') as DATE_WITH_HOURS,
       ROUND(TO_DATE('22-12-31') - sysdate) as DAYS_TIL_END_OF_YEAR,
       lower(to_char(sysdate,'MON')||' '||to_char(sysdate,'DAY')||' '||TO_CHAR(sysdate, 'YYYY')) as LOWERCASE
from dual;

-- Question 2
SELECT RESERVATION_ID, CUSTOMER_ID,
       'Checking in on '|| to_char(CHECK_IN_DATE, 'DAY')||' - '|| to_char(CHECK_IN_DATE,'MON DD, YYYY') as ARRIVAL_DATE,
       'at '||
        case LOCATION_ID
            when 1 then 'South Congress'
            when 2 then 'East 7th'
            when 3 then 'Balcones Cabins'
        end as LOCATION_NAME,
        NVL(NOTES, ' ') as NOTES
from RESERVATION;

-- Question 3 ( no rows returned as last check_out date is in 2021)
SELECT substr(FIRST_NAME,1,1)||'. '||upper(LAST_NAME) as customer_name,
       check_in_date, CHECK_OUT_DATE, EMAIL
from CUSTOMER, RESERVATION
where ( sysdate - CHECK_OUT_DATE) <= 30
order by CHECK_OUT_DATE;

-- Question 4
SELECT RESERVATION_ID, CUSTOMER_ID, to_char(weekend_rate * 1.1 * 2,'$99,999.99') as ANTICIPATED_TOTAL
from RESERVATION res left join ROOM r
on res.LOCATION_ID = r.LOCATION_ID
where CHECK_IN_DATE = '2021-11-05'
group by  RESERVATION_ID, CUSTOMER_ID, WEEKEND_RATE;

-- Question 5
select CARDHOLDER_LAST_NAME, length(BILLING_ADDRESS) as billing_adress_length,
       round((sysdate - EXPIRATION_DATE)) as days_until_card_expiration
from CUSTOMER_PAYMENT
where round((sysdate - EXPIRATION_DATE)) > 0
order by days_until_card_expiration;

-- Question 6
select LAST_NAME, substr(ADDRESS_LINE_1,1,1) as Street_Nbr,
       substr(ADDRESS_LINE_1, (INSTR(ADDRESS_LINE_1, ' ')+1)) as STREET_NAME, -- after space occurence
       NVL(ADDRESS_LINE_2, 'n/a'), CITY, STATE, ZIP
from CUSTOMER;

-- Question 7 
select FIRST_NAME||' '||LAST_NAME as Customer_Name, card_type,
       '****-****-****-'||substr(CARD_NUMBER,13) as redacted_card_number
from CUSTOMER, CUSTOMER_PAYMENT
where CARD_TYPE = 'VISA' or CARD_TYPE = 'MSTR'
order by LAST_NAME;

-- Question 8 Replacing Union Statements
Select
case
    when STAY_CREDITS_EARNED<10 then '1-Gold Member'
    when 10<=STAY_CREDITS_EARNED and STAY_CREDITS_EARNED<40 then '2-Platinum Member'
    when 40<=STAY_CREDITS_EARNED then '3-Diamond Club'
end as status_level,
FIRST_NAME, LAST_NAME, EMAIL, STAY_CREDITS_EARNED
from CUSTOMER
order by 1, 3;

-- Question 9 Rank (need desc to make the more credits earned, the higher the rank is)
select FIRST_NAME, LAST_NAME, CUSTOMER_ID, EMAIL, STAY_CREDITS_EARNED,
       Rank() over (order by STAY_CREDITS_EARNED desc) as Customer_Rank
from CUSTOMER;
