--1 task
CREATE OR REPLACE PROCEDURE insertflight
(
	p_flight_id INT,
    p_flight_no TEXT,
    p_scheduled_departure DATE,
    p_scheduled_arrival DATE,
    p_arrival_airport_id INT,
    p_departing_gate TEXT,
    p_arriving_gate TEXT,
    p_airline_id INT,
    p_status TEXT,
    p_actual_departure DATE,
    p_actual_arrival DATE,
    p_created_at DATE,
    p_update_at DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO flights
	(
		flight_id, 
        flight_no, 
        scheduled_departure, 
        scheduled_arrival, 
        arrival_airport_id, 
        departing_gate, 
        arriving_gate, 
        airline_id, 
        status, 
        actual_departure, 
        actual_arrival, 
        created_at, 
        update_at
	)
	VALUES
	(
		p_flight_id, 
        p_flight_no, 
        p_scheduled_departure, 
        p_scheduled_arrival, 
        p_arrival_airport_id, 
        p_departing_gate, 
        p_arriving_gate, 
        p_airline_id, 
        p_status, 
        p_actual_departure, 
        p_actual_arrival, 
        p_created_at, 
        p_update_at
	);
	
	RAISE NOTICE 'New flight has added successfully';
END
$$;

--2 task
CREATE OR REPLACE PROCEDURE updateStatusOfTheFlight
(
	p_booking_id INT,
	p_status TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF EXISTS(SELECT 1 FROM booking WHERE booking_id = p_booking_id) THEN
		UPDATE booking
		SET status = p_status WHERE booking_id = p_booking_id;
	
		RAISE NOTICE 'Status successfully updated for booking_id %', p_booking_id;
	ELSE
		RAISE NOTICE 'There is no booking with booking_id %', p_booking_id;
	END IF;
END
$$;

--3 task
CREATE OR REPLACE PROCEDURE flightsFrom
(
	p_airport_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE flight_record RECORD;
BEGIN
	FOR flight_record IN
		SELECT
			flight_no
		FROM
			flights
		JOIN
			airport ON departure_airport_id = airport_id
		WHERE
			airport.airport_name = p_airport_name
	LOOP
		RAISE NOTICE 'Flight_no: %', flight_record.flight_no;
	END LOOP;
END
$$;
CALL flightsFrom('Garbaharey Airport');

--4 task
CREATE OR REPLACE PROCEDURE averageDelay(
    p_airport_name TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    avg_delay INTERVAL;
BEGIN
    SELECT 
        AVG(flights.actual_departure - flights.scheduled_arrival)
    INTO avg_delay
    FROM 
        flights
    JOIN 
        airport ON flights.arrival_airport_id = airport.airport_id
    WHERE 
        airport.airport_name = p_airport_name;
		
    RAISE NOTICE 'The average delay for airport % is %', p_airport_name, avg_delay;
END;
$$;
CALL averageDelay('Akunaq Heliport');

--5 task
CREATE OR REPLACE PROCEDURE passengerInfo
(
	p_flight_no TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE passenger_record RECORD;
BEGIN
	FOR passenger_record IN
		SELECT
			(passengers.first_name || ' ' || passengers.last_name) AS full_name
		FROM
			passengers
		JOIN
			booking ON passengers.passenger_id = booking.passenger_id
		JOIN
			booking_flight ON booking.booking_id = booking_flight.booking_id
		JOIN
			flights ON booking_flight.flight_id = flights.flight_id
		WHERE
			flights.flight_no = p_flight_no
		LOOP
			RAISE NOTICE 'Passenger: %', passenger_record.full_name;
	END LOOP;
END;
$$;
CALL passengerInfo('CA-SK')

--6 task
CREATE OR REPLACE PROCEDURE richestPassenger()
LANGUAGE plpgsql
AS $$
DECLARE
    p_full_name TEXT;
    f_flight_count INT;
BEGIN
	WITH passenger_flight_count AS (
	SELECT
		(passengers.first_name || ' ' || passengers.last_name) AS full_name,
		COUNT(flights.flight_id) AS flight_count
	FROM
		passengers
	JOIN
		booking ON booking.passenger_id = passengers.passenger_id
	JOIN
		booking_flight ON booking_flight.booking_id = booking.booking_id
	JOIN
		flights ON flights.flight_id = booking_flight.flight_id
	GROUP BY
		passengers.first_name, passengers.last_name
	)
	SELECT
		full_name,
		flight_count
	INTO
		p_full_name, f_flight_count
	FROM
		passenger_flight_count
	WHERE
		flight_count = (SELECT MAX(flight_count) FROM passenger_flight_count);
		
	RAISE NOTICE 'Passenger: %, Flights: %', p_full_name, f_flight_count;
END;
$$;
CALL richestPassenger();

--7 task
CREATE OR REPLACE PROCEDURE delayedFlight()
LANGUAGE plpgsql
AS $$
DECLARE
    flight_records RECORD;
BEGIN
    FOR flight_records IN
        SELECT
            flights.flight_no
        FROM
            flights
        WHERE
            (flights.actual_departure::timestamp - flights.scheduled_departure::timestamp) > INTERVAL '1 day'
    LOOP
        RAISE NOTICE 'Flight_no: %', flight_records.flight_no;
    END LOOP;
END;
$$;
CALL delayedFlight();

--8 task
CREATE OR REPLACE PROCEDURE counter()
LANGUAGE plpgsql
AS $$
DECLARE
    airline_name_record RECORD;
BEGIN
    FOR airline_name_record IN
        SELECT
            airline.airline_name,
            COUNT(flights.flight_id) AS flight_count
        FROM
            flights
        JOIN
            airline ON flights.airline_id = airline.airline_id
        GROUP BY
            airline.airline_name
    LOOP
        RAISE NOTICE 'Airline name: %, Amount of flights: %', 
            airline_name_record.airline_name, airline_name_record.flight_count;
    END LOOP;
END;
$$;
CALL counter();

--9 task
CREATE OR REPLACE PROCEDURE avgPrice
(
	p_flight_no TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    average_price INT;
BEGIN
	SELECT
		AVG(booking.price)
	INTO
		average_price
	FROM
		booking
	JOIN
		booking_flight ON booking_flight.booking_id = booking.booking_id
	JOIN
		flights ON flights.flight_id = booking_flight.flight_id
	WHERE
		flights.flight_no = p_flight_no;
		
	RAISE NOTICE 'Flight_no: %, Average price: %', p_flight_no, average_price;
END;
$$;
CALL avgPrice('RU-KR');

--10 task
CREATE OR REPLACE PROCEDURE highestPrice()
LANGUAGE plpgsql
AS $$
DECLARE
    f_flight_no TEXT;
    d_departure_id INT;
    a_arrival_id INT;
    t_ticket_price NUMERIC;
BEGIN
    SELECT MAX(price) 
    INTO t_ticket_price
    FROM booking;

    SELECT 
        flights.flight_no,
        flights.departure_airport_id,
        flights.arrival_airport_id
    INTO 
        f_flight_no,
        d_departure_id,
        a_arrival_i
    FROM 
        booking
    JOIN 
        booking_flight ON booking.booking_id = booking_flight.booking_id
    JOIN 
        flights ON booking_flight.flight_id = flights.flight_id
    WHERE 
        booking.price = t_ticket_price;
    
    RAISE NOTICE 'Flight No: %, Departure Airport: %, Arrival Airport: %, Ticket Price: %', 
        f_flight_no, d_departure_id, a_arrival_id, t_ticket_price;
END;
$$;
CALL highestPrice();