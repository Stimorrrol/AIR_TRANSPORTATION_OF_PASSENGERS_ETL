SELECT DISTINCT fare_conditions
FROM bookings.ticket_flights;


SELECT f.flight_id
	  , passenger_id
	  , actual_departure
	  , actual_arrival
	  , ABS(EXTRACT(epoch FROM actual_departure) - EXTRACT(epoch FROM scheduled_departure)) AS delay_departure
	  , ABS(EXTRACT(epoch FROM actual_arrival) - EXTRACT(epoch FROM scheduled_arrival)) AS delay_arrival
	  , aircraft_code
	  , seat_no
	  , departure_airport
	  , arrival_airport
	  , flight_no
	  , fare_conditions
FROM bookings.flights AS f JOIN bookings.ticket_flights AS tf USING (flight_id)
			               JOIN bookings.boarding_passes AS bp ON tf.flight_id = bp.flight_id AND tf.ticket_no = bp.ticket_no 
			               JOIN bookings.tickets AS t ON tf.ticket_no = t.ticket_no 
WHERE f.status = 'Arrived'
ORDER BY f.flight_id;
