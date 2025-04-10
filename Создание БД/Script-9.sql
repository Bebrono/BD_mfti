--Список бронирований с датой въезда и датой следующего бронирования в том же номере (LEAD функция)
SELECT 
    b.room_id,
    b.start_date,
    LEAD(b.start_date) OVER (PARTITION BY b.room_id ORDER BY b.start_date) AS next_booking_start
FROM booking b
ORDER BY b.room_id, b.start_date;
