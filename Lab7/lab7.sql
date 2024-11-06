--1 task
CREATE INDEX idx_actual_departure ON flights (actual_departure);

--2 task
CREATE UNIQUE INDEX idx_flight_no_scheduled_departure ON flights (flight_no, scheduled_departure);

--3 task
CREATE INDEX idx_departure_airport_id_arrival_airport_id ON flights (departure_airport_id, arrival_airport_id);

--4 task (with / without indexes)
EXPLAIN ANALYZE 
SELECT * 
FROM flights 
WHERE departure_airport_id = 17 AND arrival_airport_id = 6;

--5 task
EXPLAIN ANALYZE
SELECT
	*
FROM
	flights
WHERE
	departure_airport_id = 12 AND arrival_airport_id = 7;
	
--6 task
CREATE UNIQUE INDEX 
	idx_passport_number ON passengers (passport_number);
	
SELECT indexname AS index_name
FROM pg_indexes
WHERE tablename = 'passengers' AND indexname = 'idx_passport_number';

insert into passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, update_at) values (201, 'Curt', 'Whitewood', '6/26/2024', 'Male', 'Hungary', 'Thailand', '9429816551', '2024-06-02', '2024-08-23');
insert into passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, update_at) values (202, 'Sherwin', 'Coat', '5/3/2024', 'Male', 'Indonesia', 'Bulgaria', '0104288558', '2024-06-01', '2024-04-15');
	
--7 task
CREATE INDEX
	idx_first_name_last_name_date_of_birth_country_of_citizenship ON passengers (first_name, last_name, date_of_birth, country_of_citizenship);

EXPLAIN ANALYZE
SELECT
	first_name, last_name, date_of_birth, country_of_citizenship
FROM
	passengers
WHERE
	country_of_citizenship = 'Philippines' AND
	date_of_birth BETWEEN '1984-01-01' AND '1984-12-31';
	
--8 task
SELECT
	indexname AS index_name,
	indexdef AS index_definition
FROM
	pg_indexes
WHERE
	tablename = 'passengers';