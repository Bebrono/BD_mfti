--Номера, которые ни разу не бронировались (подзапрос с NOT EXISTS)
SELECT r.number
FROM rooms r
WHERE NOT EXISTS (
    SELECT 1 FROM booking b WHERE b.room_id = r.room_id
);
