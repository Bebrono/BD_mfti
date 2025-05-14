-- Индексы для таблицы Booking
CREATE INDEX idx_booking_client ON Booking(client_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);