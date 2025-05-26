--Количество бронирований по каждому тарифу
SELECT 
    t.name AS tariff_name,
    COUNT(*) AS booking_count
FROM booking b
JOIN tariffs t ON b.tariff_id = t.tariff_id
GROUP BY t.name
ORDER BY booking_count DESC;
