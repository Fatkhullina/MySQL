-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs 
-- помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

-- SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs(
table_name varchar (255),
id_user bigint,
name varchar (255),
created_log DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=ARCHIVE;

DROP TRIGGER IF EXISTS log_user;

delimiter // 

CREATE TRIGGER log_user AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (table_name, id_user, name)
	VALUES           ('users', NEW.id, NEW.name);
END//

delimiter ;

DROP TRIGGER IF EXISTS log_products;

delimiter // 

CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (table_name, id_user, name)
	VALUES           ('products', NEW.id, NEW.name);
END//

delimiter ;


DROP TRIGGER IF EXISTS log_catalogs;

delimiter // 

CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (table_name, id_user, name)
	VALUES           ('catalogs', NEW.id, NEW.name);
END//

delimiter ;

INSERT INTO users (id, name, birthday_at)
	VALUES           (100, 'Vasya Vasin', '01.01.2000');

SELECT * FROM logs;

-- У меня вопрос: неужели нельзя автоматизировать вставку имени таблицы? 
-- Как достать имя таблицы я поняла, а как именно выбрать ту таблицу не знаюю..


/*Практическое задание по теме “NoSQL”
1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
127.0.0.1:6379> sadd ip1 1
(integer) 1
127.0.0.1:6379> sadd ip1 2
(integer) 1
127.0.0.1:6379> sadd ip1 3
(integer) 1
127.0.0.1:6379> sadd ip2 1
(integer) 1
127.0.0.1:6379> sadd ip2 2
(integer) 1
127.0.0.1:6379> scard ip1
(integer) 3
127.0.0.1:6379> scard ip2
(integer) 2

2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
127.0.0.1:6379> hmset name_user Ivan ivan@mail.com Anna anna@mail.com Vika vika@mail.com
OK
127.0.0.1:6379> hmset email_user ivan@mail.com Ivan anna@mail.com Anna vika@mail.com Vika
OK
127.0.0.1:6379> hget name_user Anna
"anna@mail.com"
127.0.0.1:6379> hget email_user anna@mail.com
"Anna"

3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.


db.shop.insert({name:'intel core i3-8100'}, {description:'Процессор для настольных персональных компьютеров'}, {price:'7890'}, {type:'Процессоры'})
WriteResult({ "nInserted" : 1 })
> db.shop.insert({name:'ASUS ROG MAXIMUS  HERO'}, {description: Материнская плата ASUS ROG MAXIMUS HERO, socket1151-v2, Z370,DDR4, ATX}, {price:'19310 рублей'}, {type: 'Материнские платы'})
uncaught exception: SyntaxError: missing } after property list :
@(shell):1:74
> db.shop.insert({name:'ASUS ROG MAXIMUS  HERO'}, {description:'Материнская плата ASUS ROG MAXIMUS HERO, socket1151-v2, Z370,DDR4, ATX'}, {price:'19310 рублей'}, {type: 'Материнские платы'})
WriteResult({ "nInserted" : 1 })
> db.shop.find()
{ "_id" : ObjectId("619b2ece0b3f209ace6e5a6d"), "name" : "intel core i3-8100" }
{ "_id" : ObjectId("619b301c0b3f209ace6e5a6e"), "name" : "ASUS ROG MAXIMUS  HERO" }
>
 /* 

