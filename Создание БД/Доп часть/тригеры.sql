-- тригеры

DROP TRIGGER IF EXISTS trg_validate_dates ON Booking;
DROP TRIGGER IF EXISTS trg_update_room_status ON Booking;
DROP TRIGGER IF EXISTS trg_prevent_double_booking ON Booking;
DROP TRIGGER IF EXISTS trg_booking_validity ON Booking;
DROP TRIGGER IF EXISTS trg_update_booking ON Booking;
-- Триггер для проверки дат бронирования
CREATE OR REPLACE FUNCTION validate_booking_dates()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.start_date > NEW.end_date THEN
        RAISE EXCEPTION 'Дата начала бронирования (%) не может быть позже даты окончания (%)', 
                        NEW.start_date, NEW.end_date;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_dates
BEFORE INSERT OR UPDATE ON Booking
FOR EACH ROW EXECUTE FUNCTION validate_booking_dates();

-- Триггер для обновления статуса номера
CREATE OR REPLACE FUNCTION update_room_status()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.status = 'подтверждена' THEN
        UPDATE Rooms SET status = 'занят' WHERE room_id = NEW.room_id;
    ELSIF OLD.status = 'подтверждена' AND NEW.status = 'отменена' THEN
        UPDATE Rooms SET status = 'свободен' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_update_room_status
AFTER INSERT OR UPDATE OF status ON Booking
FOR EACH ROW EXECUTE FUNCTION update_room_status();

-- Триггер для проверки "клиент не может бронировать два номера на одни даты"
CREATE OR REPLACE FUNCTION prevent_double_booking()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Booking
        WHERE client_id = NEW.client_id
        AND booking_id != NEW.booking_id
        AND status = 'подтверждена'
        AND NOT (NEW.end_date < start_date OR NEW.start_date > end_date)
    ) THEN
        RAISE EXCEPTION 'Клиент % уже имеет подтверждённую бронь на эти даты', NEW.client_id;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_prevent_double_booking
BEFORE INSERT OR UPDATE ON Booking
FOR EACH ROW EXECUTE FUNCTION prevent_double_booking();

--Триггер для автоматической установки valid_to
CREATE OR REPLACE FUNCTION set_booking_validity()
RETURNS TRIGGER AS $$
BEGIN
    NEW.valid_from := CURRENT_TIMESTAMP;
    
    IF NEW.status = 'отменена' THEN
        NEW.valid_to := CURRENT_TIMESTAMP;
    ELSE
        NEW.valid_to := '9999-12-31 23:59:59'::timestamp;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_booking_validity
BEFORE INSERT ON Booking
FOR EACH ROW
EXECUTE FUNCTION set_booking_validity();

--Триггер для обработки изменений статуса
CREATE OR REPLACE FUNCTION update_booking_validity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status <> OLD.status THEN
        IF NEW.status = 'отменена' THEN
            NEW.valid_to := CURRENT_TIMESTAMP;
        ELSIF NEW.status = 'подтверждена' AND OLD.status = 'отменена' THEN
            NEW.valid_to := '9999-12-31 23:59:59'::timestamp;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_booking
BEFORE UPDATE ON Booking
FOR EACH ROW
EXECUTE FUNCTION update_booking_validity();