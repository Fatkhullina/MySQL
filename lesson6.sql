SELECT * FROM users;
SELECT * FROM communities_users;
SELECT  * FROM communities;
SELECT * FROM messages;

-- Домашнее задание №6
-- задание №1
-- выберем для запроса пользлвателя с id = 3;                                                      

SELECT count(*) AS cnt, from_user_id FROM messages WHERE to_user_id = 3
GROUP BY from_user_id ORDER BY from_user_id  LIMIT 1 ;


SELECT count(*) AS cnt, from_user_id FROM messages WHERE to_user_id = 3
GROUP BY from_user_id ORDER BY cnt DESC LIMIT 1 ;

-- У меня возник вопрос, ответьет пожалуйста, вот в такого рода запросе, что является приоритетным при выполнения?? 
-- Получается сначало выполняется запрос на данные, потом сортировка по id, потом сортировка по группам, а потом подсчет внутри групп?

-- задание №2

SELECT * FROM profiles;