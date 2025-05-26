--Клиенты, сделавшие более 2-х бронирований
SELECT 
    c.full_name,
    COUNT(b.booking_id) AS total_bookings
FROM clients c
JOIN booking b ON c.client_id = b.client_id
GROUP BY c.client_id
HAVING COUNT(b.booking_id) >= 1
ORDER BY total_bookings DESC;
