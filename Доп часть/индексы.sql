-- Индексы для таблицы Booking
CREATE INDEX if not EXISTS idx_booking_client ON Booking(client_id);
CREATE INDEX if not exists idx_booking_dates ON Booking(start_date, end_date);