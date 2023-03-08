                    

-- ДОМАШНЕЕ ЗАДАНИЕ №5

-- задание №1

SELECT id, created_at, update_at FROM users;

UPDATE users
SET created_at = NULL;

UPDATE users
SET update_at = NULL;

UPDATE users
SET created_at = now();

UPDATE users
SET update_at = current_timestamp;

-- задание №2

-- создадим столбцы с неудачной заданной датой 
ALTER TABLE users ADD COLUMN created_at_double VARCHAR(50);
ALTER TABLE users ADD COLUMN update_at_double VARCHAR(50);

SELECT * FROM users;

-- добавим некорректные даннные
UPDATE users SET  created_at_double = '21.10.2017 8:10', update_at_double = '20.11.2017 8:10' WHERE id = 1;
UPDATE users SET  created_at_double = '22.10.2017 4:10', update_at_double = '20.11.2017 8:10' WHERE id = 2;
UPDATE users SET  created_at_double = '23.10.2017 5:10', update_at_double = '20.11.2017 8:10' WHERE id = 18;
UPDATE users SET  created_at_double = '24.10.2017 6:10', update_at_double = '20.11.2017 8:10' WHERE id = 19;
UPDATE users SET  created_at_double = '25.10.2017 7:10', update_at_double = '20.11.2017 8:10' WHERE id = 21;
UPDATE users SET  created_at_double = '26.10.2017 9:10', update_at_double = '20.11.2017 8:10' WHERE id = 20;

-- создадим новый столбцы с типом данных datetime

ALTER TABLE users ADD COLUMN created_at_res datetime;
ALTER TABLE users ADD COLUMN updated_at_res datetime;

-- изменим строковый данные в корректные для даты и сохраним в новые столбцы

UPDATE users  SET created_at_res = STR_TO_DATE(created_at_double, '%d.%c.%Y %H:%i');

UPDATE users  SET updated_at_res = STR_TO_DATE(update_at_double, '%d.%c.%Y %H:%i');

-- удалим старые столбцы
ALTER TABLE users DROP COLUMN created_at_double;

ALTER TABLE users DROP COLUMN update_at_double;

-- переименуем новые столбцы в привычные названия

ALTER TABLE users RENAME COLUMN created_at_res TO created_at_double;

ALTER TABLE users RENAME COLUMN updated_at_res TO update_at_double;

-- задание №3

-- создам таблицу для выполнения задания

CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products VALUES (1, 1, 1, 10, DEFAULT, DEFAULT),
                                        (2, 2, 2, 1, DEFAULT, DEFAULT),
                                        (3, 3, 3, 0, DEFAULT, DEFAULT),
                                        (4, 4, 4, 5, DEFAULT, DEFAULT);
INSERT INTO storehouses_products VALUES (5, 5, 5, 0, DEFAULT, DEFAULT);
SELECT * FROM storehouses_products;



SELECT value, CASE WHEN value > 0 THEN 1
            WHEN value = 0 THEN 0
            END AS sort
FROM storehouses_products  ORDER BY sort DESC, value;
 
 -- задание №4
 
ALTER TABLE users ADD COLUMN month_birthday varchar(20);
UPDATE users SET  month_birthday = 'may' WHERE id = 1;
UPDATE users SET  month_birthday = 'august' WHERE id = 2;
UPDATE users SET  month_birthday = 'July' WHERE id = 18;
UPDATE users SET  month_birthday = 'march' WHERE id = 19;
UPDATE users SET  month_birthday = 'april' WHERE id = 20;
UPDATE users SET  month_birthday = 'june' WHERE id = 21;
UPDATE users SET  month_birthday = 'July' WHERE id = 22;
UPDATE users SET  month_birthday = 'august' WHERE id = 23;
 
SELECT * FROM users;
SELECT * FROM profiles;

SELECT firstname, month_birthday FROM users WHERE month_birthday = 'may' OR month_birthday = 'august';

-- Практическое задание теме “Агрегация данных”
-- задание №1
SELECT round(avg((TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25),2) FROM profiles;

-- задание №2

SELECT  dayofweek(DATE_FORMAT(birthday, '2021.%m.%d')) AS day_week, count(*) AS total FROM profiles GROUP BY day_week ORDER BY day_week;

-- задание №3
CREATE TABLE multiplication (
             id SERIAL PRIMARY KEY,
             x INT NOT NULL
);

INSERT INTO multiplication VALUES (1, 1),
                                  (2, 10),
                                  (3, 15);
                                 
SELECT exp(sum(log(x))) FROM multiplication;


