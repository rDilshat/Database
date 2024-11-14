--1 task
CREATE VIEW flights_info AS
SELECT
	*
FROM
	flights
WHERE
	scheduled_departure = '2023-08-08';
	
SELECT * FROM flights_info;

--2 task
CREATE VIEW booking_flight_info AS
SELECT
	booking_flight.booking_id,
	booking_flight.flight_id,
	flights.scheduled_departure,
	flights.arrival_airport_id
FROM
	booking_flight
JOIN
	flights ON flights.flight_id = booking_flight.flight_id
WHERE
	scheduled_departure BETWEEN '2023-08-08' AND CURRENT_DATE + interval '1 week';
	
SELECT * FROM booking_flight_info;

--3 task
CREATE VIEW popular_flights_info AS
SELECT
	flights.flight_no,
	flights.scheduled_departure,
	flights.scheduled_arrival,
	COUNT(booking_flight.booking_id) AS booking_count
FROM
	flights
JOIN
	booking_flight ON booking_flight.flight_id = flights.flight_id
GROUP BY
	flights.flight_no, flights.scheduled_departure, flights.scheduled_arrival
ORDER BY
	booking_count DESC
	LIMIT 5;
	
SELECT * FROM popular_flights_info;

--4 task
CREATE VIEW airline_flights_info AS
SELECT
	flights.flight_no,
	airline.airline_name
FROM
	flights
JOIN
	airline ON flights.airline_id = airline.airline_id;
	
SELECT * FROM airline_flights_info
WHERE airline_name = 'IPC';

--5 task
CREATE OR REPLACE VIEW airline_flights_info AS
SELECT
    flights.flight_no,
    airline.airline_name,
    flights.scheduled_departure
FROM
    flights
JOIN
    airline ON flights.airline_id = airline.airline_id
WHERE
    flights.scheduled_departure BETWEEN '2023-08-08' AND '2023-08-15';

SELECT * FROM airline_flights_info
WHERE airline_name = 'IPC';

--6 task
CREATE VIEW delayed_flights_info AS
SELECT
	flight_no,
	scheduled_departure,
	actual_departure
FROM
	flights
WHERE
	actual_departure > scheduled_departure + interval '24 hours';

SELECT * FROM delayed_flights_info;

--7 task
CREATE VIEW leffler_thompson_platform_info AS
SELECT
	(passengers.first_name || '' || passengers.last_name) AS full_name,
	passengers.country_of_citizenship,
	booking.booking_platform
FROM
	passengers
JOIN
	booking ON passengers.passenger_id = booking.passenger_id
WHERE
	booking.booking_platform = 'Leffler-Thompson';
	
SELECT * FROM leffler_thompson_platform_info;

--8 task
CREATE VIEW most_visited_country AS
SELECT
	airport.country,
	COUNT(flights.flight_id) AS flight_count
FROM
	airport
JOIN
	flights ON airport.airport_id = flights.arrival_airport_id
GROUP BY
	airport.country
ORDER BY
	flight_count DESC
	LIMIT 10;
	
SELECT * FROM most_visited_country

--9 task
CREATE OR REPLACE VIEW most_visited_country AS
SELECT
	airport.country,
	COUNT(flights.flight_id) AS flight_count,
	airport.state
FROM
	airport
JOIN
	flights ON airport.airport_id = flights.arrival_airport_id
GROUP BY
	airport.country, airport.state -- added state
ORDER BY
	flight_count DESC
	LIMIT 10;
	
SELECT * FROM most_visited_country

--10 task
DROP VIEW popular_flights_info;
DROP VIEW flights_info;
DROP VIEW delayed_flights_info;
DROP VIEW booking_flight_info;
DROP VIEW leffler_thompson_platform_info;
DROP VIEW airline_flights_info;
DROP VIEW most_visited_country;