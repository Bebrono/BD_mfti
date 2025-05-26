--Список всех клиентов, которые забронировали номер, с деталями номера и периода
SELECT 
    c.full_name,
    r.number AS room_number,
    b.start_date,
    b.end_date
FROM booking b
JOIN clients c ON b.client_id = c.client_id
JOIN rooms r ON b.room_id = r.room_id
ORDER BY b.start_date;
