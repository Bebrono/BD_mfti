-- тест активных бронирований (текущие даты)
SELECT * FROM ActiveBookings 
ORDER BY end_date DESC;

-- Тест истории бронирований для клиента с несколькими бронями
SELECT * FROM ClientBookingHistory 
WHERE client_id = 1
ORDER BY start_date;

-- Проверка фильтрации по типу номера
SELECT * FROM ActiveBookings
WHERE room_type = 'люкс'
AND end_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days';

-- Тест подсчета общей стоимости бронирований клиента
SELECT 
    client_id,
    client_name,
    SUM(total_cost) AS total_spent,
    COUNT(*) AS bookings_count
FROM ClientBookingHistory
WHERE status = 'подтверждена'
GROUP BY client_id, client_name
ORDER BY total_spent DESC
LIMIT 5;

-- Проверка бронирований, заканчивающихся сегодня
SELECT * FROM ActiveBookings
WHERE end_date = CURRENT_DATE;

-- Тест поиска бронирований по периоду
SELECT * FROM ClientBookingHistory
WHERE start_date BETWEEN '2024-07-01' AND '2024-07-31'
ORDER BY start_date;

-- Проверка бронирований с определенной услугой
SELECT 
    booking_id,
    client_name,
    room_number,
    service_name,
    start_date,
    end_date
FROM ClientBookingHistory
WHERE service_name IS NOT NULL
AND status = 'подтверждена'
ORDER BY service_name;