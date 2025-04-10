--Рейтинг клиентов по количеству бронирований (с оконной функцией)
SELECT 
    c.full_name,
    COUNT(b.booking_id) AS booking_count,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank
FROM clients c
JOIN booking b ON c.client_id = b.client_id
GROUP BY c.client_id;
