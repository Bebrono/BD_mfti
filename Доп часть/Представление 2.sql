--ClientBookingHistory — история бронирований клиента
--Это представление показывает все брони клиента с дополнительной информацией (комнаты, тарифы, услуги).

DROP VIEW IF EXISTS ClientBookingHistory;

CREATE OR REPLACE VIEW ClientBookingHistory AS
SELECT 
    b.booking_id,
    b.client_id,
    c.full_name AS client_name,
    c.phone,
    r.number AS room_number,
    r.room_type,
    s.name AS service_name,
    t.name AS tariff_name,
    b.start_date,
    b.end_date,
    b.status,
    (b.end_date - b.start_date) AS nights_count,
    (t.price + COALESCE(s.price, 0)) * (b.end_date - b.start_date) AS total_cost,
    CASE
        WHEN b.valid_to = '9999-12-31 23:59:59'::timestamp THEN 'Активна'
        WHEN b.status = 'отменена' THEN 'Отменена'
        ELSE 'Завершена'
    END AS booking_state
FROM 
    Booking b
JOIN 
    Clients c ON b.client_id = c.client_id
JOIN 
    Rooms r ON b.room_id = r.room_id
LEFT JOIN 
    Services s ON b.service_id = s.service_id
JOIN 
    Tariffs t ON b.tariff_id = t.tariff_id
WHERE 
    CURRENT_TIMESTAMP BETWEEN b.valid_from AND b.valid_to;
    
    