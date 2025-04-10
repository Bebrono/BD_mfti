--Бронирования, в которых стоимость услуги выше средней стоимости всех услуг
SELECT 
    b.booking_id,
    s.name AS service_name,
    s.price
FROM booking b
JOIN services s ON b.service_id = s.service_id
WHERE s.price > (
    SELECT AVG(price) FROM services
);
