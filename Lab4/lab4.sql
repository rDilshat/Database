--1 task
SELECT UPPER(airline_name)
FROM airline ORDER BY airline_name;

--2 task
UPDATE airline
SET
    airline_name = REPLACE(airline_name, 'Air', 'Aero');

--3 task
SELECT *
FROM flight
WHERE airline_id = 1

INTERSECT

SELECT *
FROM flight
WHERE airline_id = 2;

--4 task
SELECT airport_name
FROM airport
WHERE airport_name ILIKE '%Reginal%'
  AND airport_name ILIKE '%Air%';

--5 task
SELECT
    first_name,
    last_name,
    FORMAT('%s %s, %s',
           TO_CHAR(date_of_birth, 'FMMonth'),
           TO_CHAR(date_of_birth, 'DD'),
           TO_CHAR(date_of_birth, 'YYYY')) AS formatted_birth_date
FROM
    passengers;

--6 task
SELECT
    flight_id
FROM flight
WHERE act_arrival_time > sch_arrival_time;

--7 task
SELECT
    first_name,
    last_name,
    date_of_birth,
    CASE
        WHEN AGE(CURRENT_DATE, date_of_birth) BETWEEN INTERVAL '18 years' AND INTERVAL '35 years' THEN 'Young'
        WHEN AGE(CURRENT_DATE, date_of_birth) BETWEEN INTERVAL '36 years' AND INTERVAL '55 years' THEN 'Adult'
        ELSE 'Other'
    END AS age_group
FROM passengers;

--8 task
SELECT
    ticket_price,
    CASE
        WHEN ticket_price < 50 THEN 'Cheap'
        WHEN ticket_price BETWEEN 50 AND 150 THEN 'Medium'
        ELSE 'Expensive'
    END AS price_category
FROM booking;

--9 task
SELECT
    airline_country,
    COUNT(airline_name) AS number_of_airlines
FROM airline
GROUP BY airline_country;

--10 task
SELECT
    *
FROM flight
WHERE act_arrival_time > sch_arrival_time;