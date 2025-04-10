--Список всех комнат и сколько раз каждая бронировалась (даже если не бронировалась)
SELECT 
    r.number AS room_number,
    COUNT(b.booking_id) AS times_booked
FROM rooms r
LEFT JOIN booking b ON r.room_id = b.room_id
GROUP BY r.room_id
ORDER BY times_booked DESC;
