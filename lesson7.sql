SELECT * FROM users;
SELECT * FROM communities_users;
SELECT  * FROM communities;
SELECT * FROM messages;

-- Домашнее задание №6
-- задание №1
-- выберем для запроса пользлвателя с id = 3;                                                      

SELECT count(*) AS cnt, from_user_id FROM messages WHERE to_user_id = 3
GROUP BY from_user_id ORDER BY from_user_id  LIMIT 1 ;


SELECT count(*) AS cnt, from_user_id FROM messages WHERE to_user_id = 5
GROUP BY from_user_id ORDER BY cnt DESC LIMIT 1 ;



-- задание №2

SELECT * FROM profiles;
-- Домашнее задание №8
-- 1. Пусть задан некоторый пользователь.
 -- Из всех пользователей соц. сети найдите человека,
 -- который больше всех общался с выбранным пользователем (написал ему сообщений).

SELECT count(*) AS cnt, u.lastname FROM messages AS m
JOIN users  AS u ON m.from_user_id = u.id
WHERE m.to_user_id = 5 AND m.is_delivered = 1
GROUP BY m.from_user_id
ORDER BY cnt DESC LIMIT 1;

-- или
SELECT count(*) AS cnt, u.lastname, m.from_user_id  FROM messages AS m
JOIN users  AS u ON m.from_user_id = u.id
WHERE m.to_user_id = 5 AND m.is_delivered = 1
GROUP BY m.from_user_id
ORDER BY m.from_user_id DESC LIMIT 1;



-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет

SELECT * FROM users AS u
JOIN profiles AS p ON p.user_id = u.id 
JOIN posts_likes pl ON pl.user_id = u.id;
