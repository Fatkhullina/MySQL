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

SELECT count(*) FROM users AS u
JOIN profiles AS p ON p.user_id = u.id 
JOIN posts_likes pl ON pl.user_id = u.id
WHERE  TIMESTAMPDIFF(YEAR, p.birthday, now()) <=10 AND pl.like_type = 1;

-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT count(*) AS cnt, 
CASE p.gender WHEN 'f' THEN 'female'
              WHEN 'm' THEN 'male'
END AS gender
FROM profiles p 
JOIN posts_likes pl ON p.user_id = pl.user_id
WHERE p.gender != 'x'
GROUP BY p.gender
ORDER BY cnt DESC LIMIT 1;



