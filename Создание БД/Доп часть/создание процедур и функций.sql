-- создание процедур и функций

DROP PROCEDURE IF EXISTS book_room;
DROP FUNCTION IF EXISTS calculate_cost;
DROP FUNCTION IF EXISTS check_availability;

-- Процедура бронирования номера
CREATE OR REPLACE PROCEDURE book_room(
    p_client_id INT,
    p_room_id INT,
    p_tariff_id INT,
    p_service_id INT,
    p_start_date DATE,
    p_end_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверяем доступность номера 
    IF EXISTS (
        SELECT 1 FROM Booking 
        WHERE room_id = p_room_id 
        AND status = 'подтверждена'
        AND NOT (p_end_date < start_date OR p_start_date > end_date)
    ) THEN
        RAISE EXCEPTION 'Номер % занят на эти даты', p_room_id;
    END IF;
    
    -- Создаем бронь 
    INSERT INTO Booking (
        client_id, 
        room_id, 
        tariff_id,
        service_id,
        start_date, 
        end_date, 
        status
    ) VALUES (
        p_client_id, 
        p_room_id,
        p_tariff_id,
        p_service_id,
        p_start_date, 
        p_end_date, 
        'подтверждена'
    );
    
    RAISE NOTICE 'Бронь создана. ID: %', currval('booking_booking_id_seq');
END;
$$;

-- функция расчета стоимости
CREATE OR REPLACE FUNCTION calculate_cost(
    p_tariff_id INT,
    p_nights INT
)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    tariff_price DECIMAL(10, 2);
BEGIN
    
    SELECT price INTO tariff_price 
    FROM Tariffs 
    WHERE tariff_id = p_tariff_id;
    
    RETURN tariff_price * p_nights;
END;
$$;

-- Функция проверки доступности номера
CREATE OR REPLACE FUNCTION check_availability(
    p_room_id INT,
    p_check_date DATE
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN NOT EXISTS (
        SELECT 1 FROM Booking
        WHERE room_id = p_room_id
        AND status = 'подтверждена'
        AND p_check_date BETWEEN start_date AND end_date
    );
END;
$$;

--Закрытие завершенных броней
CREATE OR REPLACE PROCEDURE close_expired_bookings()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Booking
    SET valid_to = CURRENT_TIMESTAMP
    WHERE status = 'подтверждена'
      AND valid_to = '9999-12-31 23:59:59'::timestamp
      AND end_date < CURRENT_DATE;
END;
$$;



-- ТЕСТЫ:
--Закрываем все просроченные брони
DO $$
BEGIN
	CALL close_expired_bookings();
END;
$$ LANGUAGE plpgsql;

-- Проверяем доступность номера (должно вернуть true/false)
SELECT check_availability(11, '2025-06-28') AS is_available;

-- Рассчитываем стоимость 3 ночей в номере 5
SELECT calculate_cost(5, 3) AS total_cost;

-- Пробное бронирование 
DO $$
BEGIN
    --CALL book_room(2, 13, 1, 3, '2025-12-25', '2025-12-28');
	CALL book_room(1, 6, 3, 3, '2025-05-24', '2025-05-26');
	--CALL book_room(2, 13, 1, 3, '2025-12-25', '2025-12-28');
	--CALL book_room(2, 13, 1, 3, '2025-12-25', '2025-12-28');
	--CALL book_room(2, 13, 1, 3, '2025-12-25', '2025-12-28');
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Ошибка бронирования: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
