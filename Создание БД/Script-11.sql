--Топ-5 самых дорогих услуг
SELECT 
    name,
    price
FROM services
ORDER BY price DESC
LIMIT 5;
