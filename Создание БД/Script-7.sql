--Найти клиентов, которые бронировали номер хотя бы один раз в июле 2024
SELECT DISTINCT c.full_name
FROM clients c
JOIN booking b ON c.client_id = b.client_id
WHERE b.start_date BETWEEN '2024-07-01' AND '2024-07-31';
