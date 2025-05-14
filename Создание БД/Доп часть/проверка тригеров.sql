-- проверка тригеров

-- Проверка триггера дат (должна вызвать ошибку)
--UPDATE Booking SET start_date = '2024-12-31', end_date = '2024-12-01' WHERE booking_id = 1;

-- Проверка двойного бронирования
INSERT INTO Booking (booking_id, client_id, room_id, tariff_id, service_id, start_date, end_date, status)
VALUES (102, 1, 5, 1, 1, '2025-12-01', '2025-12-10', 'подтверждена');

INSERT INTO Booking (booking_id, client_id, room_id, tariff_id, service_id, start_date, end_date, status)
VALUES (103, 1, 7, 1, 1, '2025-12-05', '2025-12-15', 'подтверждена'); -- Ошибка