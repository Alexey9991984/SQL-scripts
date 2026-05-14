
CREATE SCHEMA eurobulk;

 
CREATE TABLE drivers (
	 driver_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	 full_name VARCHAR (45) NULL 
);

CREATE TABLE trucks (
	 truck_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	 truck_number VARCHAR (20) NOT NULL UNIQUE
);



CREATE TABLE trailers (
	trailer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trailer_number VARCHAR (20) NOT NULL UNIQUE
);


CREATE TABLE trips (
    trip_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    driver_id INT NOT NULL,
    truck_id  INT NOT NULL,
    trailer_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date   DATE,

    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (truck_id)   REFERENCES trucks(truck_id),
    FOREIGN KEY (trailer_id) REFERENCES trailers(trailer_id)
);

DROP  TABLE trip_events;


CREATE TABLE trip_events (
    event_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    trip_id INT NOT NULL,
    arrival_timestamp TIMESTAMP NOT NULL,
    departure_timestamp TIMESTAMP,
    location VARCHAR(100) NOT NULL,
    odometer INT NOT NULL,
    action_type VARCHAR(30) NOT NULL,
    notes TEXT,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

CREATE TABLE truck_driver_assignments (
    assignment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    truck_id INT NOT NULL,
    driver_id INT NOT NULL,
    start_timestamp TIMESTAMP NOT NULL,
    end_timestamp TIMESTAMP,
    FOREIGN KEY (truck_id) REFERENCES trucks(truck_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

CREATE TABLE truck_trailer_assignments (
    assignment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	truck_id INT NOT NULL,
    trailer_id INT NOT NULL,
	start_timestamp TIMESTAMP NOT NULL,
    end_timestamp TIMESTAMP,
FOREIGN KEY (truck_id) REFERENCES trucks(truck_id),
FOREIGN KEY (trailer_id) REFERENCES trailers(trailer_id)
);


INSERT INTO drivers (full_name)
VALUES ('Oleksii Fandieiev');

SELECT *
FROM drivers;


INSERT INTO trucks (truck_number)
VALUES ('EOP GR85');

INSERT INTO trucks (truck_number)
VALUES ('EOP 9GN8');

SELECT *
FROM trucks;


DELETE 
FROM trips 
WHERE trip_id = 1;


INSERT INTO trailers (trailer_number)
VALUES ('FY8666');

INSERT INTO trailers (trailer_number)
VALUES ('EC9018')

INSERT INTO trailers (trailer_number)
VALUES ('JB9957')


SELECT *
FROM trailers;


INSERT INTO trips (
	driver_id,
	truck_id,
	trailer_id,
	start_date,
	end_date
	)
VALUES (
	1,
	1,
	1,
	'2025-04-12',
	'2025-04-24'
);

INSERT INTO truck_driver_assignments (
    truck_id,
    driver_id,
    start_timestamp,
    end_timestamp
)
VALUES (
    1,
    1,
    '2025-04-12 18:10',
    '2025-04-24 20:00'
);



INSERT INTO truck_trailer_assignments (
    truck_id,
    trailer_id,
    start_timestamp,
    end_timestamp
)
VALUES (
    1,
    1,
    '2025-04-12 18:10',
    '2025-04-24 20:00'
);

SELECT *
FROM trips;

UPDATE 

SELECT *
FROM trailers t ;

TRUNCATE TABLE trip_events, trips
RESTART IDENTITY CASCADE;

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-12 18:10:00',
	'2025-04-13 06:10:00',
	'Padborg',
	 744783,
	'start'
);

SELECT *
FROM trip_events;

DELETE FROM trip_events
WHERE event_id = 12;



INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-13 10:10:00',
	'2025-04-13 11:20:00',
	'Thisted Dragsbaek',
	 745075,
	'unload'
);
 
INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-14 07:40:00',
	'2025-04-14 08:50:00',
	'Hamburg TWS',
	 745560,
	'wash'
);
 
INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-14 09:00:00',
	'2025-04-14 16:40:00',
	'Hamburg Cargill',
	 745564,
	'load'
);
 
INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-15 11:40:00',
	'2025-04-15 16:20:00',
	'Lummen Puratos',
	 746118,
	'unload'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-15 11:40:00',
	'2025-04-15 16:20:00',
	'Lummen Puratos',
	 746118,
	'unload'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-15 17:00:00',
	'2025-04-15 18:30:00',
	'Moerbroek HTC',
	 746162,
	'wash'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-16 07:50:00',
	'2025-04-16 13:00:00',
	'Olenex Edibie Oils, Vondelingenweg',
	 746285,
	'load'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-19 20:10:00',
	'2025-04-19 23:10:00',
	'Thisted Dragsbaek',
	 747278,
	'unload'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-20 10:10:00',
	'2025-04-20 11:50:00',
	'Hjollund Dantra',
	 747406,
	'wash'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-20 12:40:00',
	'2025-04-20 14:40:00',
	'Grinsted IFF',
	 747464,
	'load'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-21 19:30:00',
	'2025-04-21 22:00:00',
	'Kutno Pringles',
	 748566,
	'unload'
);



INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-22 14:40:00',
	'2025-04-22 17:00:00',
	'Wroclaw Alterna',
	 748980,
	'wash'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-22 17:40:00',
	'2025-04-23 11:40:00',
	'Wroclaw Cargill',
	 748991,
	'load'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-24 12:40:00',
	'2025-04-24 14:00:00',
	'Faxe Haribo',
	 749696,
	'unload'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	1,
	'2025-04-24 20:00:00',
	'2025-04-25 07:00:00',
	'Padborg',
	 749696,
	'finish'
);

SELECT *
FROM trip_events;


INSERT INTO trips (
	driver_id,
	truck_id,
	trailer_id,
	start_date,
	end_date
	)
VALUES (
	1,
	2,
	2,
	'2025-03-22',
	'2025-04-03'
);


SELECT *
FROM trips;

SELECT *
FROM trip_events;


DELETE FROM trip_events 
WHERE event_id = 26;

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-22 17:40:00',
	'2025-03-23 05:00:00',
	'Padborg',
	 345026,
	'start'
);

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-23 07:50:00',
	'2025-03-23 09:20:00',
	'Hamburg Cargill',
	 345218,
	'load'
);	


INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-23 14:10:00',
	'2025-03-23 17:00:00',
	'Tangermunde',
	 345437,
	'unload'
);	


INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-23 18:30:00',
	'2025-03-24 07:30:00',
	'Bernburg BTR',
	 345550,
	'wash'
);	

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-24 08:20:00',
	'2025-03-24 11:40:00',
	'Barby Cargill',
	 345602,
	'load'
);	

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-25 09:30:00',
	'2025-03-24 10:20:00',
	'Faxe Bryggeri',
	 346045,
	'unload'
);	

INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-25 11:30:00',
	'2025-03-25 13:40:00',
	'Koge Dantra Hoyer',
	 346083,
	'wash'
);	



INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-25 15:30:00',
	'2025-03-25 17:20:00',
	'Eslov Nordic Sugar',
	 346192,
	'load'
);	


INSERT INTO trip_events (
	trip_id,
	arrival_timestamp,
    departure_timestamp,
    LOCATION,
	odometer,
	action_type
)
VALUES (
	2,
	'2025-03-26 08:20:00',
	'2025-03-26 10:10:00',
	'Kohberg Bakery Group',
	 346568,
	'unload'
);	

SELECT *
FROM trip_events
WHERE location = 'Lummen Puratos';

SELECT *
FROM trip_events
WHERE location = 'Faxe Bryggeri';

UPDATE trip_events
SET departure_timestamp = '2025-03-25 10:20:00'
WHERE location = 'Faxe Bryggeri';

SELECT *
FROM trip_events
WHERE location = 'Faxe Bryggeri';

SELECT *
FROM trip_events te
WHERE te.trip_id =1;

UPDATE truck_trailer_assignments
SET end_timestamp = '2026-03-26 07:00'
WHERE assignment_id = 1;

SELECT * 
FROM truck_trailer_assignments;


UPDATE trip_events
SET
    arrival_timestamp = arrival_timestamp + INTERVAL '1 year',
    departure_timestamp = departure_timestamp + INTERVAL '1 year';

UPDATE trips 
SET 
	start_date = start_date + INTERVAL '1 year',
	end_date = end_date + INTERVAL '1 year';

SELECT *
FROM trips;

SELECT *
FROM truck_driver_assignments tda 
WHERE truck_id = 1;

UPDATE truck_driver_assignments tda  
SET 
	start_timestamp = tda.start_timestamp  + INTERVAL '1 year',
	end_timestamp = tda.end_timestamp + INTERVAL '1 year';

SELECT * 
FROM trips;  

INSERT INTO truck_driver_assignments (
    truck_id,
    driver_id,
    start_timestamp,
    end_timestamp
)
VALUES (
    2,
    1,
    '2026-03-22 05:00',
    '2026-04-03 13:00'
);



SELECT *
FROM truck_driver_assignments tda ;

SELECT *
FROM truck_trailer_assignments tta ;


INSERT INTO truck_trailer_assignments (
    truck_id,
    trailer_id,
    start_timestamp,
    end_timestamp
)
VALUES (
    1,
    1,
    '2026-04-12 06:10',
    '2026-04-24 20:00'
);

SELECT * 
FROM trips;

SELECT * 
FROM trips;
