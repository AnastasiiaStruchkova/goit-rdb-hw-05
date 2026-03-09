-- ТЕМА 5. ВКЛАДЕНІ ЗАПИТИ.
-- Студент: Анастасія Стручкова

-- Вказуємо активну схему для всього скрипта
USE `goit-rdb-hw-03`;

-- ---------------------------------------------------------
-- ЗАВДАННЯ 1: Вкладений запит у SELECT
-- Відображаємо order_details та поле customer_id з таблиці orders
-- ---------------------------------------------------------
SELECT 
    *,
    (SELECT customer_id 
     FROM `goit-rdb-hw-03`.`orders` 
     WHERE `orders`.id = `order_details`.order_id) AS customer_id
FROM `goit-rdb-hw-03`.`order_details`;



-- ---------------------------------------------------------
-- ЗАВДАННЯ 2: Вкладений запит у WHERE
-- Фільтрація за shipper_id = 3 через підзапит
-- ---------------------------------------------------------
SELECT *
FROM `goit-rdb-hw-03`.`order_details`
WHERE order_id IN (
    SELECT id
    FROM `goit-rdb-hw-03`.`orders`
    WHERE shipper_id = 3
);



-- ---------------------------------------------------------
-- ЗАВДАННЯ 3: Вкладений запит у FROM (Derived Table)
-- Середнє значення quantity для замовлень, де кількість > 10
-- ---------------------------------------------------------
SELECT 
    order_id, 
    AVG(quantity) AS avg_quantity
FROM (
    SELECT *
    FROM `goit-rdb-hw-03`.`order_details`
    WHERE quantity > 10
) AS temp_table
GROUP BY order_id;


-- ---------------------------------------------------------
-- ЗАВДАННЯ 4: Використання оператора WITH (CTE)
-- Переписане завдання №3 з використанням CTE
-- ---------------------------------------------------------
WITH temp_table AS (
    SELECT *
    FROM `goit-rdb-hw-03`.`order_details`
    WHERE quantity > 10
)
SELECT 
    order_id, 
    AVG(quantity) AS avg_quantity
FROM temp_table
GROUP BY order_id;



-- ---------------------------------------------------------
-- ЗАВДАННЯ 5: Створення та використання функції
-- Функція для ділення двох чисел з обробкою ділення на нуль
-- ---------------------------------------------------------

-- 1. Видаляємо стару версію, якщо вона існує
DROP FUNCTION IF EXISTS divide_func;

-- 2. Тимчасово змінюємо роздільник для створення тіла функції
DELIMITER //

-- 3. Створюємо функцію
CREATE FUNCTION divide_func(val1 FLOAT, val2 FLOAT) 
RETURNS FLOAT
DETERMINISTIC 
BEGIN
    IF val2 = 0 THEN
        RETURN 0;
    END IF;
    RETURN val1 / val2;
END //

-- 4. Повертаємо стандартний роздільник
DELIMITER ;

-- 5. Викликаємо функцію для атрибута quantity
SELECT 
    quantity, 
    divide_func(quantity, 2.0) AS divided_quantity 
FROM `goit-rdb-hw-03`.`order_details`;