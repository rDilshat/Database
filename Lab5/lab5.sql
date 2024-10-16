--1 task
ALTER TABLE passengers
ADD CONSTRAINT check_passenger_age CHECK(date_of_birth <= CURRENT_DATE - INTERVAL '10 years');

--2 task
ALTER TABLE booking
ADD CONSTRAINT check_price CHECK(ticket_price >= 0 AND ticket_price <= 50000);

--3 task
ALTER TABLE baggage
ADD CONSTRAINT check_weight CHECK(weight_in_king BETWEEN 1 AND 23);

--4 task
ALTER TABLE airport
ADD CONSTRAINT check_length CHECK(LENGTH(airport_name) >=10);

--5 task
ALTER TABLE airport
ADD CONSTRAINT uq_airport_id UNIQUE (airport_id);

ALTER TABLE airline
ADD CONSTRAINT uq_airline_code UNIQUE (airline_code);

ALTER TABLE baggage
ADD CONSTRAINT uq_booking_id UNIQUE (booking_id);

ALTER TABLE baggage_check
ADD CONSTRAINT uq_check_result UNIQUE (check_result);

ALTER TABLE boarding_pass
ADD CONSTRAINT uq_seat UNIQUE (seat);

ALTER TABLE booking
ADD CONSTRAINT uq_booking_platform UNIQUE (booking_platform);

ALTER TABLE booking_flight
ADD CONSTRAINT uq_updated_at UNIQUE (updated_at);

ALTER TABLE flight
ADD CONSTRAINT uq_act_arrival_time UNIQUE (act_arrival_time);

ALTER TABLE passengers
ADD CONSTRAINT uq_passport_number UNIQUE (passport_number);

ALTER TABLE security_check
ADD CONSTRAINT uq_check_result UNIQUE (check_result);

--6 task
ALTER TABLE passengers
ADD CONSTRAINT checker CHECK(
    (gender = 'male' AND
    date_of_birth <= CURRENT_DATE - INTERVAL '18 years') OR
    (gender = 'female' AND
    date_of_birth = CURRENT_DATE - INTERVAL '19 years')
    );

--7 task
ALTER TABLE passengers
ADD CONSTRAINT check_citizenship_and_date_of_birth CHECK(
    (country_of_citizenship = 'Kazakhstan' AND
    date_of_birth <= CURRENT_DATE - INTERVAL '18 years') OR
    (country_of_citizenship = 'France' AND
     date_of_birth <= CURRENT_DATE - INTERVAL '17 years') OR
    (country_of_citizenship NOT IN ('Kazakhstan', 'France') AND
     date_of_birth <= CURRENT_DATE - INTERVAL '19 years')
    );

--8 task
ALTER TABLE booking
ADD COLUMN ticket_discount NUMERIC (5,2),
    ADD CONSTRAINT check_discount CHECK(
        (created_at >= '2024-01-01' AND ticket_discount = ticket_price * 0.05) OR
        (created_at <= '2024-01-01' AND ticket_discount = ticket_price * 0.10)
        );