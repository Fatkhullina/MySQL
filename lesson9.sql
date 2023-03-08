-- Домашнее задание №9
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзак

 START TRANSACTION;

 INSERT INTO sample.accounts (user_id)
 SELECT id FROM vk.users WHERE id = 1;

 USE vk;

 COMMIT;

-- 2.  Создайте представление, которое выводит название name товарной позиции из таблицы products и
--      соответствующее название каталога name из таблицы catalogs.
                      
 CREATE VIEW  catpro1  AS SELECT p.name,c.name AS catname FROM products AS p 
                       JOIN catalogs AS c ON c.id = p.catalog_id;                      
                      
SELECT * FROM catpro1;

      
-- “Хранимые процедуры и функции, триггеры"
      
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу 
-- "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
      
delimiter $
CREATE FUNCTION hello() RETURNS text DETERMINISTIC 
BEGIN
    IF (current_time() > '06:00:00' AND current_time() < '12:00:00') THEN RETURN 'Good morning!';
    ELSEIF (current_time() > '12:00:00' AND current_time() < '18:00:00') THEN RETURN 'Good afternoon!';
    ELSEIF (current_time() > '18:00:00' AND current_time() < '00:00:00') THEN RETURN 'Good evening!';
    ELSEIF (current_time() > '00:00:00' AND current_time() < '06:00:00') THEN RETURN 'Good night!';
    END IF; 
END $
 
delimiter ;
SELECT hello();

-- 3. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS no_null_name;

delimiter //

CREATE TRIGGER no_null_name BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
	SIGNAL SQLSTATE '45000' SET message_text = 'Insert Canceled. Name and description should not be undefined at the same time!';
	END IF;
END//

delimiter ;

INSERT INTO products (id, name, description, price, catalog_id)
       VALUES (50, 'ASUS RVX-2', 'Материнская плата', 10000, 3);
      
INSERT INTO products (id, name, price, catalog_id)
       VALUES (51, 'ASUS RVX-13', 10000, 2);      

INSERT INTO products (id, price, catalog_id)
       VALUES (52, 13000, 2);      

--  Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 50

DROP FUNCTION IF EXISTS fibonacci;       

delimiter //

CREATE FUNCTION fibonacci(n int UNSIGNED)
RETURNS bigint DETERMINISTIC
BEGIN
    RETURN (pow((sqrt(5)+1)/2, n) - pow(1-(sqrt(5)+1)/2, n))/sqrt(5);   
END//

delimiter ;

SELECT fibonacci(2);

      
      
-- “Администрирование MySQL”
-- Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.


CREATE USER shop_read;
CREATE USER shop;

GRANT USAGE, SELECT ON shop.* TO shop_read;
GRANT ALL ON shpo.* TO shop;


