--1. ActiveBookings — активные бронирования
--Это представление показывает только подтвержденные брони, которые еще не завершились (актуальные на текущую дату).

DROP VIEW IF EXISTS ActiveBookings;

CREATE VIEW ActiveBookings AS
SELECT 
    b.booking_id,
    b.client_id,
    c.full_name AS client_name,
    r.number AS room_number,
    r.room_type,
    t.name AS tariff_name,
    b.start_date,
    b.end_date,
    b.status
FROM 
    Booking b
JOIN 
    Clients c ON b.client_id = c.client_id
JOIN 
    Rooms r ON b.room_id = r.room_id
JOIN 
    Tariffs t ON b.tariff_id = t.tariff_id
WHERE 
    b.status = 'подтверждена' 
    AND b.end_date >= CURRENT_DATE
    AND b.valid_to IS NULL;