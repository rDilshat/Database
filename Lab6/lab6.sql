--1 task
SELECT
	p.*, b.airline_name
FROM
	flights p
JOIN
	airline b ON p.airline_id = b.airline_id
WHERE
	b.airline_name = 'YST';

--2 task
SELECT
	p.*, b.airport_name
FROM
	flights p
JOIN
	airport b ON p.departure_airport_id = b.airport_id;

--3 task
SELECT
	p.*
FROM
	airline p
WHERE NOT EXISTS (
    SELECT
		1
    FROM
		flights b
    WHERE
		p.airline_id = b.airline_id
    	AND EXTRACT(MONTH FROM b.scheduled_departure) = EXTRACT(MONTH FROM CURRENT_DATE) + 1
    	AND EXTRACT(YEAR FROM b.scheduled_departure) = EXTRACT(YEAR FROM CURRENT_DATE)
);

--4 task
SELECT
	p.*, b.flight_no
FROM
	passengers p
JOIN
	booking ON p.passenger_id = booking.passenger_id
JOIN
	booking_flight ON booking.booking_id = booking_flight.booking_id
JOIN
	flights b ON b.flight_id = booking_flight.flight_id
WHERE
	b.flight_no = 'NP-BA';

--5 task
SELECT
	ROUND(AVG(price), 2) AS average_price,
	SUM(price) AS total_price,
	MAX(price) AS max_price,
	MIN(price) AS min_price,
	flights.flight_no
FROM
	booking
JOIN
	booking_flight ON booking.booking_id = booking_flight.booking_id
JOIN
	flights ON flights.flight_id = booking_flight.flight_id
GROUP BY
	flights.flight_no;

--6 task
SELECT
	flights.flight_no, airport.airport_name, airline.airline_name, airport.country
FROM
	flights
JOIN
	airline ON airline.airline_id = flights.airline_id
JOIN
	airport ON airport.airport_id = flights.arrival_airport_id
WHERE
	airport.country = 'China';

--7 task
SELECT
	(passengers.first_name ||' '|| passengers.last_name) AS full_name,
	(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM passengers.date_of_birth)) AS Age ,
	flights.arriving_gate
FROM
	passengers
JOIN
	booking ON passengers.passenger_id = booking.passenger_id
JOIN
	booking_flight ON booking.booking_id = booking_flight.booking_id
JOIN
	flights ON flights.flight_id = booking_flight.flight_id
WHERE
	EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM passengers.date_of_birth) < 18;

--8 task
SELECT
	(passengers.first_name || ' ' || passengers.last_name) AS full_name,
	passengers.passport_number,
	flights.actual_arrival
FROM
	passengers
JOIN
	booking ON passengers.passenger_id = booking.passenger_id
JOIN
	booking_flight ON booking_flight.booking_id = booking.booking_id
JOIN
	flights ON flights.flight_id = booking_flight.flight_id;

--9 task
SELECT
	flights.flight_no, airline.airline_country, airport.country
FROM
	flights
JOIN
	airline ON airline.airline_id = flights.airline_id
JOIN
	airport ON airport.country = airline.airline_country
WHERE
    airline.airline_country = airport.country
GROUP BY
	airport.country, flights.flight_no, airline.airline_country;