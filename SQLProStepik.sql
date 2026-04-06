UPDATE channels
	SET title = 'Все про SQL'
	WHERE id = 35
  	AND owner_user_id = 15;


UPDATE users 
	SET password_hash = NULL 
	WHERE id  = 5;


UPDATE channel_subscribers 
	SET status = 'left'
	WHERE user_id = 11 AND channel_id = 2;


DELETE FROM users 
WHERE login = 'temporary_account';

INSERT INTO private_messages 
SET sender_id = 1, 
    receiver_id = 2, 
    body = 'Мой дядя самых честных правил';

INSERT INTO channels 
SET owner_user_id = 5,
	title = 'Все про SQL',
	is_private = 0;

--- 
INSERT INTO channel_subscribers (user_id, status, channel_id)
VALUES 
    (4, 'joined', 2),
    (8, 'joined', 2),
    (12, 'joined', 2);

SELECT *
FROM channel_subscribers
WHERE USER_id = 4 AND channel_id = 2;

INSERT INTO channel_messages (channel_id, sender_id, media_type, body)
VALUES (2, 5, 'text', 'Наш канал запустился. Ура!');

INSERT INTO channel_messages (channel_id, sender_id, media_type, body)
VALUES (2, 5, 'video', 'greetings.mp4');


INSERT INTO `groups` (title, owner_user_id, is_private)
SELECT title, owner_user_id, is_private
FROM channels
WHERE id = 2;


-- копирование 

INSERT group_messages (group_id, sender_id, media_type,body, filename,created_at)
SELECT  channel_id, sender_id, media_type, body, filename, created_at
FROM channel_messages
WHERE channel_id = 2 AND sender_id = 5;
     

-- копирование 

INSERT group_members (group_id, user_id, created_at)
SELECT channel_id, user_id, created_at 
FROM channel_subscribers 
WHERE  channel_id = 2;



-- удаление канала
-- сначала реакции

DELETE FROM channel_message_reactions
WHERE message_id IN (
    SELECT id FROM channel_messages WHERE channel_id = 2
);


-- потом сообщения

DELETE FROM channel_messages
WHERE channel_id = 2;


-- потом подписчики

DELETE FROM channel_subscribers
WHERE channel_id = 2;


-- и в конце сам канал

DELETE FROM channels
WHERE id = 2;

DELETE FROM channels WHERE id = 2;


ALTER TABLE private_messages
ADD COLUMN is_read BIT DEFAULT false NOT NULL;

-- диалог между user_id = 1 и user_id = 2

SELECT *
FROM private_messages 
WHERE sender_id = 1 AND receiver_id = 2 
    OR sender_id = 2 AND receiver_id = 1
ORDER BY created_at desc;



-- сколько у меня непрочитанных сообщений от пользователя Х

SELECT COUNT(*)
FROM private_messages 
WHERE sender_id = 2 and receiver_id = 1
	AND is_read = 0;


# сколько у меня всего непрочитанных сообщений 

SELECT COUNT(*)
FROM private_messages 
WHERE receiver_id = 1 
	AND is_read = 0;


-- отметим сообщения, как прочитанные
-- эмулируем ситуацию, что пользователь прочитал определенный диалог

UPDATE private_messages
SET is_read = 1
WHERE receiver_id = 1 AND sender_id = 2;

# сколько у меня всего непрочитанных сообщений 

SELECT COUNT(*)
FROM private_messages 
WHERE receiver_id = 1 
	AND is_read = 0;


-- вся таблица channels

SELECT *
FROM channels;


-- использование условий IF в SELECT запросе
-- выводит тип канала в зависимости от значения поля is_private

SELECT 
	is_private,
	IF (is_private = 1, 'private', 'public') AS publicity,
	title 
FROM channels;

-- то же самое, но компактнее

SELECT 
	is_private ,
	IF (is_private, 'закрытый', 'публичный') AS publicity,
	title 
FROM channels;

-- оператор ветвления CASE
-- выполняет то же, что и в предыдущих 2 запросах

SELECT 
	is_private,
	CASE(is_private)
		WHEN 0 THEN 'public'
		WHEN 1 THEN 'private'
		ELSE 'not set'
	END AS publicity,
	title 
FROM channels;

-- количество пользователей в каждом году

SELECT 
	COUNT(*),
	YEAR(birthday) AS birth_year
FROM users
GROUP BY birth_year;


-- подсчет количества пользователей в каждом поколении

SELECT 
	COUNT(*) AS cnt,
	CASE 
		WHEN year(birthday) > 1945 AND year(birthday) < 1965 THEN 'baby boomer'
		WHEN year(birthday) > 1964 AND year(birthday) < 1980 THEN 'generation X'
		WHEN year(birthday) > 1979 AND year(birthday) < 1996 THEN 'millenial'
		WHEN year(birthday) > 1995 AND year(birthday) < 2012 THEN 'generation Z'
		WHEN year(birthday) > 2011 THEN 'alpha'
	END	AS generation
FROM users
GROUP BY generation
ORDER BY min(YEAR(birthday))
# ORDER BY cnt DESC ;

-- то же, но с использованием функции BETWEEN

SELECT 
	count(*) AS cnt,
	CASE 
		WHEN year(birthday) BETWEEN 1945 AND 1965 THEN 'baby boomer'
		WHEN year(birthday) BETWEEN 1966 AND 1980 THEN 'generation X'
		WHEN year(birthday) BETWEEN 1981 AND 1995 THEN 'millenial'
		WHEN year(birthday) BETWEEN 1996 AND 2011 THEN 'generation Z'
		WHEN year(birthday) > 2011 THEN 'alpha'
	END	AS generation
FROM users
GROUP BY generation
ORDER BY min(YEAR(birthday))


SELECT count(*) AS cnt
FROM private_messages 
WHERE (sender_id = 1 AND receiver_id = 2)
   OR (sender_id = 2 AND receiver_id = 1);

SELECT *
FROM channels
ORDER BY created_at 
LIMIT 5;



SELECT id, title, owner_user_id, created_at
FROM channels
ORDER BY created_at 
LIMIT 5;


SELECT *
FROM channels 
WHERE LENGTH(title) < 3;

SELECT *
FROM stories
WHERE user_id IN (22, 33, 44, 55, 66);



-- выбрал юзеров по id у которых премиум акк и отсортировал по дате создания

SELECT created_at, user_id
FROM user_settings
WHERE is_premium_account = 1
ORDER BY created_at ASC
LIMIT 1;



SELECT user_id, created_at
FROM user_settings
WHERE created_at = (
    SELECT MIN(created_at)
    FROM user_settings
    WHERE is_premium_account = 1
)
AND is_premium_account = 1;



-- выбрал дату создания самую 'свежую'

SELECT max(created_at)
FROM stories;


-- сумма все просмотров сторисов

SELECT sum(views_count)
FROM stories;




-- выбрал среднюю длину приватных сообщений 

SELECT body
FROM private_messages
WHERE LENGTH(body) = (
    SELECT (AVG(LENGTH(body)))
    FROM private_messages
);



-- выбрал юзеров и посчитал у кого наибольшее кол-во каналов и отсортировал 

SELECT user_id, count(*) AS channels_count
FROM channel_subscribers
WHERE status = 'joined'
GROUP BY user_id
ORDER BY channels_count DESC 
LIMIT 1;



-- здесь вывел пулбличные групповые собщения отсортированые по алфавиту

SELECT id, SUBSTRING(title, 1, 30) AS title, is_private 
FROM `groups`
WHERE is_private = 0
group BY id
ORDER BY title ASC;


-- посчитал и вывел кол-во аккаунтво с премиум и без

SELECT is_premium_account, count(*) AS users_amount
FROM user_settings
GROUP BY is_premium_account;



-- посчитал кол-во реакций и отсортировал где больше 80

SELECT count(*) AS count, reaction_id
FROM private_message_reactions
GROUP BY reaction_id
HAVING count > 80
ORDER BY count desc;



-- выбрал и почитал каналы без иконки

SELECT count(*)
FROM channels
WHERE icon IS NULL;



-- выбрал и посчитал каналы с иконкой

SELECT count(*)
FROM channels
WHERE icon IS NOT NULL;



-- вывел 10 пользователей с сортировкой по фамилии 

SELECT id, firstname, lastname
FROM users
ORDER BY lastname ASC
LIMIT 10;



-- вывел все поля пользователей при этом пропустив первых 10

SELECT *
FROM users
ORDER BY lastname ASC
LIMIT 10
OFFSET 10;


-- вывел пропустил 60

SELECT *
FROM users
ORDER BY lastname ASC
LIMIT 10
OFFSET 60;

-- вывел кол-во просмотров и при помощи условия 
-- IF отсортировал больше 1000 популярные меньше 1000 нет

SELECT 
    id,
    views_count,
    IF(views_count > 1000, 'popular', 'not popular') AS is_popular
FROM stories;



select user_id, sum(views_count) as views_per_user
from stories
group by user_id
order by views_per_user desc
limit 5;


SELECT 
     COUNT(*) AS count,
	 IF(views_count >= 1000, 'popular', 'not popular') AS is_popular  
FROM stories
GROUP BY is_popular;



-- тоже самое что выше только через CASE

SELECT 
    COUNT(*) AS count,
    CASE 
        WHEN views_count >= 1000 THEN 'popular'
        ELSE 'not popular'
    END AS is_popular
FROM stories
GROUP BY is_popular;


-- вложенные запросы (с другой таблицы данные)

SELECT 	
	firstname,
	lastname,
	(SELECT app_language FROM user_settings WHERE user_id = 1) AS 'app_language',
	(SELECT is_premium_account FROM user_settings WHERE user_id = 1) AS 'is_premium_accaunt'
FROM users 
WHERE id = 1;



-- это запрос скалирированный и он меддленный его нужно избегать


SELECT 	
	firstname,
	lastname,
	(SELECT app_language FROM user_settings WHERE users.id) AS 'app_language',
	(SELECT is_premium_account FROM user_settings WHERE users.id) AS 'is_premium_accaunt'
FROM users 
WHERE id = 1;


SELECT app_language FROM user_settings WHERE user_id = 1;
SELECT is_premium_account FROM user_settings WHERE user_id = 1;


SELECT count(*)
FROM private_messages
WHERE receiver_id = 1
AND is_read = 0;



-- по эмейлу из другой таблицы с юзерс а не по айди 

SELECT count(*)
FROM private_messages
WHERE receiver_id = (SELECT id FROM users WHERE email = 'hardy42@example.com')
AND is_read = 0;



SELECT 
	count(*),
#	reaction_id,
	(SELECT code FROM reactions_list WHERE id = reaction_id) AS reaction_code
	FROM private_message_reactions 
GROUP BY reaction_id;




-- (CROSS, LEFT, RIHGHT, INNER)
# CROSS JOIN

SELECT *
FROM users, private_messages;


# также CROSS JOIN

SELECT *
FROM users
JOIN private_messages;


# количество строк в таблицах

SELECT count(*) FROM users;
SELECT count(*) FROM private_messages ;


# количество строк в CROSS JOIN

SELECT count(*)
FROM users, private_messages;


# можно объединять больше двух таблиц

SELECT *
FROM users, private_messages, channels, channel_messages;


# CROSS JOIN - работает медленно

SELECT *
FROM users
CROSS JOIN private_messages
WHERE users.id = private_messages.sender_id;


# INNER JOIN - работает эффективно

SELECT *
FROM users
INNER JOIN private_messages ON users.id = private_messages.sender_id;


-- это первый лефт джоин к таблице users (так как FROM users - значит главная таблица)
-- присоеденили и сравнили таблицу private_messages.

SELECT * 
FROM users 
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id 
WHERE private_messages.id IS NOT NULL 
ORDER BY private_messages.id; 


# INNER JOIN

SELECT *
FROM users
INNER JOIN private_messages ON users.id = private_messages.sender_id;


-- тот же иннер джоин только сортировка по имени

SELECT *
FROM users
INNER JOIN private_messages ON users.id = private_messages.sender_id
WHERE users.firstname = 'Fabiola'; 



# LEFT [OUTER] JOIN

SELECT *
FROM users
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id;



# INNER JOIN - количество строк

SELECT count(*)
FROM users
INNER JOIN private_messages ON users.id = private_messages.sender_id;


# LEFT [OUTER] JOIN - количество строк

SELECT count(*)
FROM users
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id;


# LEFT JOIN - отсортированная выборка

SELECT *
FROM users
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id
ORDER BY private_messages.id;


# LEFT JOIN - фильтрация (только пользователи без сообщений)

SELECT *
FROM users
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id
WHERE private_messages.id IS NULL 
ORDER BY private_messages.id;
# LIMIT 12;


# LEFT JOIN = INNER JOIN

SELECT *
FROM users
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id
WHERE private_messages.id IS NOT NULL 
ORDER BY private_messages.id;


# LEFT JOIN

SELECT users.*, private_messages.*
FROM users
LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id
ORDER BY private_messages.id;


 # RIGHT JOIN = LEFT JOIN

SELECT users.*, private_messages.*
FROM private_messages
RIGHT OUTER JOIN users ON users.id = private_messages.sender_id
ORDER BY private_messages.id;



# FULL OUTER JOIN

SELECT *
FROM users
LEFT JOIN private_messages ON users.id = private_messages.sender_id
	UNION
SELECT *
FROM users
RIGHT JOIN private_messages ON users.id = private_messages.sender_id;

-- FULL OUTER JOIN (PostgreSQL)

SELECT *
FROM users
FULL OUTER JOIN private_messages
  ON users.id = private_messages.sender_id;



# количество строк в INNER JOIN 

SELECT COUNT(*)
FROM users
INNER JOIN private_messages ON users.id = private_messages.sender_id;

# количество строк в LEFT JOIN 

SELECT COUNT(*)
FROM users
LEFT JOIN private_messages ON users.id = private_messages.sender_id

# количество строк в RIGHT JOIN 

SELECT COUNT(*)
FROM users
RIGHT JOIN private_messages ON users.id = private_messages.sender_id;

# арифметика JOIN

INNER JOIN = 5
LEFT JOIN = 9
RIGHT JOIN = 8 
FULL OUTER JOIN = 12 = 9 + 8 - 5 = 5 + 4 + 3

-- вложенные запросы 
-- сколлерированный вложенный запрос 

SELECT 
	firstname,
	lastname,
	(SELECT app_language FROM user_settings WHERE user_id = users.id) AS 'app_language',
	(SELECT is_premium_account FROM user_settings WHERE user_id = users.id) AS 'is_premium'
FROM users 
WHERE id = 1;


-- все тоже самое что и во вложенном запросе выше только это через JOIN 
-- желательно использовать JOIN так как коллеряция это медленный запрос

SELECT 
	firstname,
	lastname,
	user_settings.app_language,
	user_settings.is_premium_account, 
	user_settings.created_at
	FROM users 
JOIN user_settings ON user_settings.user_id = users.id 
WHERE id = 1;


# вывод данных о пользователе
-- скоррелированный вложенный вариант запроса

SELECT 
	firstname,
	lastname,
	(SELECT app_language FROM user_settings WHERE user_id = users.id) AS 'app_language',
	(SELECT is_premium_account FROM user_settings WHERE user_id = users.id) AS 'is_premium',
	(SELECT created_at FROM user_settings WHERE user_id = users.id) AS 'created_at'
FROM users
WHERE id = 5;

-- вариант с использованием INNER JOIN
-- и здесь переименованы колонки в запросе

SELECT 
	firstname,
	lastname,
	app_language,
	is_premium_account AS 'is_premium',
	created_at AS 'created_date'
FROM users AS u
JOIN user_settings AS us ON us.user_id = u.id
WHERE id = 1;	


SELECT sender_id 
FROM channel_messages
	UNION ALL
SELECT sender_id
FROM group_messages; 
		

SELECT count(*) AS cnt,
	   sender_id 
FROM (
		SELECT sender_id 
		FROM channel_messages
		UNION ALL
		SELECT sender_id
		FROM group_messages
) AS s
GROUP BY sender_id
ORDER BY cnt desc;
	

-- пример для оконных функций

SELECT count(*) AS cnt, 
		app_language
FROM user_settings 
GROUP BY app_language
ORDER BY cnt desc;



-- оконные функции

SELECT DISTINCT 
	count(*) OVER (PARTITION BY app_language) AS cnt,
	app_language,
	color_scheme 
FROM user_settings; 



SELECT DISTINCT 
		ROW_NUMBER() OVER() AS rn, 
		count(*) OVER (PARTITION BY app_language) AS cnt1, 
		count(*) OVER (PARTITION BY color_scheme) AS cnt2,
		app_language,	
		color_scheme 
		FROM user_settings
		ORDER BY rn;	 



# в рамках одного запроса можно использовать несколько оконных функций

# rn — просто номер строки
# language_rank — рейтинг языка с пропусками
# dense_rank — рейтинг языка без пропусков
# rn2 — порядковый номер строки внутри языка
# cnt1 — сколько строк с таким языком
# cnt2 — сколько строк с такой темой оформления

SELECT DISTINCT 
	ROW_NUMBER() OVER() AS rn, 
	RANK() OVER(ORDER BY app_language) AS language_rank, 
	DENSE_RANK() OVER(ORDER BY app_language) AS language_rank2,
	ROW_NUMBER() OVER(PARTITION BY app_language) AS rn2,
	COUNT(*) OVER (PARTITION BY app_language) AS cnt1,
	COUNT(*) OVER (PARTITION BY color_scheme) AS cnt2,
	app_language,
	color_scheme 
FROM user_settings
ORDER BY app_language, rn2;


# альтернативный синтаксис (именованные оконные функции)

SELECT DISTINCT 
	COUNT(*) OVER win1 AS cnt,
	app_language 
FROM user_settings
WINDOW win1 AS (PARTITION BY app_language);


# использование одного 'окна' вместе с разными фунциями

SELECT
  app_language,
  ROW_NUMBER() OVER w AS 'row_number',
  RANK()       OVER w AS 'rank',
  DENSE_RANK() OVER w AS 'dense_rank'
FROM user_settings
WINDOW w AS (ORDER BY app_language);


# пример из прошлых уроков (получение данных о пользователе из
--  разных таблиц с помощью вложенных запросоов)

SELECT 
	firstname,
	lastname,
	(SELECT app_language FROM user_settings WHERE user_id = users.id) AS 'app_language',
	(SELECT is_premium_account FROM user_settings WHERE user_id = users.id) AS 'is_premium_account'
FROM users
WHERE id = 2;


# тот же результат, но с помощью CTE (общего табличного выражения)

WITH cte1 AS (
	SELECT 
		user_id,
		app_language,
		is_premium_account
	FROM user_settings
)
SELECT 
	firstname,
	lastname, 
	app_language,
	is_premium_account	
FROM cte1
JOIN users AS u ON u.id = cte1.user_id
WHERE id = 2
;


--  в 1 запросе можно использовать несколько табличных выражений 
-- (у каждого из них должно быть свое уникальное имя)

WITH cte1 AS (
	SELECT * FROM channel_subscribers 
),
cte2 AS (
	SELECT * FROM group_members  
)
SELECT * FROM cte2
# ....;


# вывод иерархии сообщений (кто-кому отвечал)

WITH RECURSIVE message_replies(id, body, history) AS (
	SELECT id, body, cast(id AS CHAR(100))
	FROM group_messages 
	WHERE reply_to_id IS NULL 
		UNION ALL 
	SELECT gm.id, gm.body, CONCAT(mr.history, ' <-- ', gm.id)
	FROM message_replies AS mr
	JOIN group_messages AS gm ON mr.id = gm.reply_to_id
)
SELECT * FROM message_replies ORDER BY history;


-- решение заданий stepik 

SELECT lastname,
       firstname, 
       birthday,
      (SELECT app_language FROM user_settings WHERE user_id = users.id) 
      	AS 'app_language'
FROM users
WHERE email IN ('mgoyette@example.org');



SELECT lastname,
       firstname, 
       birthday,
      (SELECT app_language FROM user_settings WHERE user_id = users.id) AS 'app_language'
FROM users
WHERE id = 10;

SELECT firstname,
       lastname,
       birthday,
       (SELECT app_language FROM user_settings WHERE user_id = 10) AS 'app_language'
FROM users
WHERE id = 10;



-- выбрать пользователей имя и фамилия у которых стоит русский язык в настройках

SELECT firstname,
       lastname
FROM users
WHERE id IN (
    SELECT user_id 
    FROM user_settings 
    WHERE app_language = 'russian'
)
ORDER BY lastname;



SELECT id,
       views_count,
       created_at,
       (SELECT firstname 
        FROM users 
        WHERE users.id = stories.user_id) AS name,
       (SELECT lastname 
        FROM users 
        WHERE users.id = stories.user_id) AS lastname
FROM stories
WHERE user_id = 2
ORDER BY views_count DESC;



-- задача вывксти пользоветелей и посчитать лайки в историях 

SELECT id,
       views_count,
       created_at,
       (SELECT firstname 
        FROM users 
        WHERE users.id = stories.user_id) AS name,
       (SELECT lastname 
        FROM users 
        WHERE users.id = stories.user_id) AS lastname,
	   (SELECT count(*) 
		FROM stories_likes 
		WHERE story_id = stories.id) AS count
        FROM stories
WHERE user_id = 2
ORDER BY views_count DESC;


-- 
SELECT id, 
	   (SELECT firstname 
	   FROM users 
	   WHERE users.id = group_messages.sender_id) AS firstname,
	   (SELECT lastname 
	   FROM users 
	   WHERE users.id = group_messages.sender_id) AS lastname, 
	   SUBSTRING(body, 1, 30) AS body, # ограничение при помощи этой функции в сообщение тоолько от 1-30 символов
	   created_at
FROM group_messages 
WHERE media_type = 'text' AND group_id = 11
ORDER BY created_at ASC;




-- тот же запрос что и выше только через JOIN app_language 
-- из другой таблицы присоеденил

SELECT lastname,
       firstname, 
       birthday,
	   us.app_language
FROM users u
JOIN user_settings us
	ON u.id = us.user_id 
WHERE u.email = 'mgoyette@example.org';


-- здесь вызвал только фамилию и имя пользователей у 
-- которых установленный русский язык
-- и сгрупировал по фамилии как было в задании все так же через JOIN

SELECT lastname,
       firstname
FROM users u
JOIN user_settings us
	ON u.id = us.user_id 
WHERE us.app_language = 'russian'
ORDER BY lastname;

SELECT u.id AS user_id,
	   s.id AS strory_id,
	   views_count,
	   created_at,
       firstname,
       lastname
FROM stories s 
JOIN users u ON u.id = s.user_id 
WHERE u.id = 2
ORDER BY s.views_count desc;



-- вот здесь идет посчет лайков на истории созданые пользователем #2 
-- с применением JOIN stories + stories_likes

SELECT s.id AS id, 
       COUNT(sl.id) AS likes_count -- вот так нужно считать с другой таблицы
FROM stories s 
JOIN stories_likes sl ON s.id = sl.story_id
WHERE s.user_id = 2
GROUP BY s.id
ORDER BY likes_count DESC;


-- вывел сообщения группы 11 где медиа тип текст и сортировал по дате создания
-- присоеденил таблицу юзерс 

SELECT gm.id AS id,
	   u.firstname,
	   u.lastname,
	   SUBSTRING(gm.body, 1, 30),
	   gm.created_at
FROM group_messages gm 
JOIN users u ON gm.sender_id = u.id
WHERE gm.group_id = 11 AND gm.media_type = 'text'
ORDER BY gm.created_at ASC;



-- Выведите пользователя (таблица users) номер 11 вместе со 
-- списком идентификаторов каналов (таблица channel_subscribers), 
--  на которые он подписан. Учитывайте также статус подписки (поле status = 'joined').

SELECT u.firstname, 
       u.lastname, 
       cs.channel_id
FROM users u
JOIN channel_subscribers cs ON u.id = cs.user_id
WHERE u.id = 11 AND cs.status = 'joined'
ORDER BY cs.channel_id ASC;



-- все тоже самое что выше только с использованием cross join 

SELECT u.firstname, 
       u.lastname, 
       cs.channel_id
FROM users u 
CROSS JOIN channel_subscribers cs ON u.id = cs.user_id 
WHERE u.id = 11 AND  cs.status = 'joined'
ORDER BY cs.channel_id ASC;


-- здесь идет цепочка присоеденений таблиц users => channel_subscribers => channels
-- именно таблица к таблице 1 => 2 => 3 а не так что join двух таблиц к первой

SELECT
	u.firstname,
	u.lastname,
	c.title
FROM
	users u
JOIN channel_subscribers cs ON
	u.id = cs.user_id
JOIN channels c ON
	cs.channel_id = c.id
WHERE
	u.id = 11
	AND cs.status = 'joined'
ORDER BY
	cs.channel_id ASC;


-- при помощи join нашел пользователей которые не подписаны не на один канал

SELECT u.firstname,
	   u.lastname,
	   u.email 
FROM users u 
LEFT OUTER JOIN channel_subscribers cs ON u.id = cs.user_id
WHERE cs.channel_id IS NULL;


-- тоже самое что выше только через райт джоин


SELECT 
    u.firstname,
    u.lastname,
    u.email
FROM channel_subscribers cs
RIGHT OUTER JOIN users u ON u.id = cs.user_id
WHERE cs.user_id IS NULL;



-- найти по айди истории у которых нет ни одного лайка

SELECT s.id 
FROM stories s 
LEFT OUTER JOIN stories_likes sl ON sl.story_id = s.id 	
WHERE sl.story_id IS NULL;


SELECT sl.id
FROM stories_likes sl
LEFT JOIN stories s ON s.id = sl.story_id
WHERE s.id IS NULL;





--- какая реакция (эмодзи) самая популярная
--- вне зависимости от того, где она использовалась 
--- (сообщения в каналах, в группах, в личных сообщениях).
--- Подсчитайте суммарное количество реакций каждого типа,
--- которые использовались во всех сообщениях (во всех таблицах).
--- Отсортируйте результат по идентификатору реакции (поле reaction_id).
--- Порядок полей важен для проверки (ниже скрин ожидаемого результата): 
--- сначала идентификатор реакции, затем количество его использований.

SELECT 
reaction_id,
count(*) AS `count`
FROM (SELECT reaction_id FROM private_message_reactions
             UNION ALL 
	  SELECT reaction_id FROM channel_message_reactions
             UNION ALL 
      SELECT reaction_id FROM group_message_reactions) AS s      
GROUP BY reaction_id
ORDER BY reaction_id ASC;



--- выбрал пользователей и пересчитал у кого какое кол-во групп
SELECT owner_user_id, --- по айди пользователя 
count(*) AS cnt
FROM (SELECT owner_user_id FROM channels -- юнион соеденил 2 таблицы для полсчета
	        UNION ALL 
	  SELECT owner_user_id FROM `groups`) AS s
GROUP BY owner_user_id -- групировака по id 
ORDER BY cnt desc;  -- отсортировал кол-во груп по убыванию

--- Необходимо узнать: кто из пользователей добавился в максимальное количество 
--- каналов (если таковых несколько, то достаточно вывести одного из них).
--- Информация о членстве пользователей в каналах хранится в таблице channel_subscribers.

SELECT distinct user_id, 
	 COUNT(*) OVER (PARTITION BY user_id) AS channels_count
	 FROM channel_subscribers
WHERE `status` = 'joined'
ORDER BY channels_count DESC
LIMIT 1;



--- насколько популярен у пользователей премиум аккаунт.
--- Напишите запрос, выводящий оба значения в поле is_premium_account
---  таблицы user_settings и количество пользователей напротив него.
--- В решении
--- используйте оконные фунции
--- не используйте группировки

SELECT DISTINCT is_premium_account, 
	   count(*) OVER (PARTITION BY is_premium_account) AS users_amount
FROM user_settings;


SELECT
    COUNT(*) OVER (PARTITION BY reaction_id) AS `count`,
    DISTINCT reaction_id
FROM private_message_reactions;



--- Напишите запрос, выводящий количество использования каждой реакции 
--- в личных сообщениях. Сколько раз встречается каждый reaction_id в таблице private_message_reactions?
--- Выборку отсортировать по убыванию количества строк.

SELECT 
    count,
    reaction_id
FROM (
    SELECT DISTINCT 
        reaction_id,
        COUNT(*) OVER (PARTITION BY reaction_id) AS count
    FROM private_message_reactions
) AS sub
	ORDER BY `count` desc;

--- здесь нужно тоже самое но только оставить 5 реакций у которых по счету больше 80
--- при этом не использовать лимит

SELECT 
    `count`,
    reaction_id
FROM (
    SELECT DISTINCT 
        reaction_id,
        COUNT(*) OVER (PARTITION BY reaction_id) AS count
    FROM private_message_reactions
) AS sub
	WHERE `count` > 80
ORDER BY `count` DESC;



--- таже задача только с использованием функии cte 

WITH cte1 AS (
    SELECT 
        reaction_id,
        COUNT(*) OVER (PARTITION BY reaction_id) AS `count`
    FROM private_message_reactions
)
SELECT DISTINCT 
    `count`,
	reaction_id
   FROM cte1
WHERE `count` > 80
ORDER BY `count` DESC;


--- Необходимо узнать: какое количество просмотров историй (суммарно) 
--- набрал каждый пользователь.
--- Результат отсортируйте по номеру пользователя (поле user_id).

WITH cte1 AS (
    SELECT 
        user_id,
        SUM(views_count) OVER (PARTITION BY user_id) AS views_per_user
    FROM stories
) SELECT DISTINCT
	views_per_user,    
	user_id
    FROM cte1
ORDER BY user_id;

WITH cte1 AS (
    SELECT 
        user_id,
        SUM(views_count) OVER (PARTITION BY user_id) AS views_per_user
    FROM stories
) SELECT DISTINCT
	views_per_user,    
	user_id
    FROM cte1
ORDER BY user_id;


--- здесь все то же самое что в запросе выше только нужно оставить топ 5 кто больше всех
--- набрал просмотров
WITH cte1 AS (
    SELECT 
        user_id,
        SUM(views_count) OVER (PARTITION BY user_id) AS views_per_user
    FROM stories
) SELECT DISTINCT
	views_per_user,    
	user_id
    FROM cte1
ORDER BY cte1.views_per_user DESC
LIMIT 5;




SELECT DISTINCT s.id,
	count(*) OVER (PARTITION BY sl.id) AS 'likes_count'
FROM stories_likes sl
JOIN stories s ON sl.user_id = s.id
WHERE s.user_id = 2
order by sl.id desc;


SELECT 
    s.id,
    COUNT(sl.id) AS likes_count
FROM stories s
LEFT JOIN stories_likes sl ON s.id = sl.story_id
WHERE s.user_id = 2
GROUP BY s.id
ORDER BY likes_count DESC;


SELECT DISTINCT
    s.id,
    COUNT(sl.id) OVER (PARTITION BY s.id) AS likes_count
FROM stories s
LEFT JOIN stories_likes sl ON s.id = sl.story_id
WHERE s.user_id = 2
ORDER BY likes_count DESC;



--- это мое верное решение посчитал все раекции в сообщениях 
--- соеденил при помощи юнион алл 3 аблицы и пересчитал оконная функция
--- и DISTINCT убрал все повторы

SELECT DISTINCT reaction_id,
	count(reaction_id) OVER (PARTITION BY s.reaction_id) AS `count`	
FROM (SELECT reaction_id FROM private_message_reactions
	    UNION ALL  
	 SELECT reaction_id FROM channel_message_reactions
	    UNION ALL 
	 SELECT reaction_id FROM group_message_reactions) AS s;



--- правильное решение (ChatGPT)
--- это тоже самое решение что и было ранее считать только там было без оконной функции
--- и с групировкой

SELECT DISTINCT reaction_id, `count` # эта функция убирает повторы DISTINCT 
FROM (
  SELECT 
    reaction_id,
    COUNT(reaction_id) OVER (PARTITION BY reaction_id) AS `count`
  FROM (
    SELECT reaction_id FROM private_message_reactions
    UNION ALL
    SELECT reaction_id FROM channel_message_reactions
    UNION ALL
    SELECT reaction_id FROM group_message_reactions
  ) AS s
) AS t
ORDER BY reaction_id;

--- посчитал у кого больше пабликов и выделил 5
SELECT DISTINCT owner_user_id,
	   count(owner_user_id) OVER (PARTITION BY owner_user_id) AS cnt 
FROM (SELECT owner_user_id FROM channels
		UNION ALL 
	  SELECT owner_user_id FROM `groups`)
	  AS s
	ORDER BY cnt DESC 
	  LIMIT 5; 


SELECT DISTINCT
    owner_user_id,
    COUNT(owner_user_id) OVER (PARTITION BY owner_user_id) AS total_publics
FROM (
    SELECT owner_user_id FROM channels
    UNION ALL
    SELECT owner_user_id FROM `groups`
) AS all_publics
ORDER BY total_publics DESC
LIMIT 5;


--- новая тема поиск в тексте, это пример как через оператор LIKE 
--- как я уже делал ранее
SELECT * 
FROM saved_messages 
WHERE body LIKE '%ratone%' OR body LIKE '%est%';


--- наложение полнотекстового индекса с названием (full_body_idx)
--- и определение на которую таблицу этот индекс накладывается(saved_messages(body))

CREATE FULLTEXT INDEX full_body_idx ON saved_messages(body);


--- создание запроса при помощи уже ранее созданного индекса
--- при помощи данной функции можно через пробел перечеслять 
--- части текста строки которые есть в поиске 


SELECT *
FROM saved_messages 
WHERE MATCH(body) against('ratone est unde voluptatem' IN boolean mode);


--- прмер если поставить + перед словом поиска,
--- поиск будет искать каждое это слово вместе в одном сообщении
--- ~ - этот знак перед словом поиска означает что слово это может быть, может не быть
--- в итоговом выводе, оператор MATCH задает ему приоритет ниже
--- * это любая последовательность = +unde* далее любой текст в продолжении
--- эти возможности дает полнотекстовый индекс FULLTEXT INDEX


SELECT *
FROM saved_messages 
WHERE MATCH(body) against('~ratone +est +unde* +voluptatem' IN boolean mode);


# обычный фильтр с оператором WHERE-LIKE
SELECT *
FROM saved_messages 
WHERE body LIKE '%ratione%' OR body LIKE '%est%';

# создание полнотекстового индекса на поле body
CREATE FULLTEXT INDEX full_body_idx ON saved_messages(body);

# полнотекстовый поиск в режиме BOOLEAN
# + обязательное слово
# - исключаемое слово
SELECT *
FROM saved_messages 
WHERE match(body) AGAINST('+ratione +est -voluptatem' IN BOOLEAN MODE);

# полнотекстовый поиск в режиме BOOLEAN
# * заменитель любого окончания слова
SELECT *
FROM saved_messages 
WHERE MATCH(body) AGAINST('+ratione +est +vol*' IN BOOLEAN MODE);

--- тема представление - это заранее сохраненный SELECT запрос

# удалить представление с проверкой
DROP VIEW IF EXISTS v_users_messages;

--- в представлении всегда нужно явно расcписывать поля какие и откуда нужно вывести 
--- создание 
--- CREATE VIEW OR REPLACE - здесь сразу создать или изменить
--- хорошо создавать такие представления когда работаешь с одной и той же базой, 
--- чтобы те данные которые часто нужно можно было посмотреть не создавая новый запрос 


CREATE VIEW v_users_messages AS 
	SELECT 	users.id AS uid, firstname, lastname, login, email, password_hash, phone, birthday,
	 		private_messages.id AS pmid, sender_id, reply_to_id, media_type, body, filename, created_at
	FROM users 
	LEFT OUTER JOIN private_messages ON users.id = private_messages.sender_id 
	ORDER BY private_messages.id 
	LIMIT 12;	


--- вызов представления 
--- (в представлении так же можно исаользовать как и в любом запросе групировки
--- сортировки и т д)


SELECT * FROM v_users_messages vum
WHERE uid = 29; 



--- ПРОЦЕДУРЫ
--- создание процедуры 
--- delimiter // - разделение 

USE telegram;

DROP PROCEDURE IF EXISTS telegram.my_procedure;

delimiter //

CREATE PROCEDURE my_procedure()
BEGIN
	SELECT 1111;
	SELECT 2222;
END//

delimiter ; 

CALL my_procedure();


--- функция rand - генерирует постоянно случайный вывод

SELECT rand() 
ORDER BY rand()  
--- 
DROP IF EXISTS random_society;

SELECT id, title, invite_link, 'channel' -- channel это название поля откуда идет ответ от кандом запроса
FROM channels
	UNION 
SELECT id, title, invite_link, 'group'
FROM `groups`


ORDER BY rand()
LIMIT 1 

CALL random_society();


DROP PROCEDURE IF EXISTS telegram.random_society1;


CREATE PROCEDURE telegram.random_society1(cnt int)
BEGIN
	SELECT id, title , invite_link , 'channel' AS community_type
	FROM channels 
		UNION 
	SELECT id, title , invite_link , 'group' AS community_type
	FROM `groups`  
	ORDER BY rand()
	LIMIT cnt;
END//


# вызов процедуры
CALL random_society2(3);

--- функции 
--- создал функцию и сохранил при исполнении которой идет подсчет кол-ва пользователей
--- с премиум аккаунтом и без премиума и в качестве результата выдает приблизительное
--- float число, в нашем слуае примерно 0.53 (53%) половина пользователей имеет премиум
 
CREATE FUNCTION telegram.get_premium_precentage()
RETURNS float READS SQL DATA  
BEGIN
	DECLARE premium_users_count int; 	
	DECLARE total_users_count int;
	DECLARE _result float; 
	
	SET premium_users_count = (
		SELECT count(*)
		FROM user_settings 
		WHERE is_premium_account = TRUE 
	);
	
	SET total_users_count = (
		SELECT count(*)
		FROM user_settings 
		
	); 
	SET _result = premium_users_count / total_users_count;
	RETURN _result;
	END
	
SELECT get_premium_precentage();


# задаем локальную переменную
SET @users_count = 10;     
# читаем значение переменной
SELECT @users_count;

# выводим список глобальных переменных
SHOW VARIABLES;

# выводим только переменную foreign_key_checks (отвечает за проверку внешних ключей)
SHOW VARIABLES LIKE 'foreign_key_checks';

# выводим глобальное значение системной переменной
SHOW GLOBAL VARIABLES LIKE 'foreign_key_checks';

# выводим локальное значение системной переменной
SHOW SESSION VARIABLES LIKE 'foreign_key_checks';

# выключаем локально проверку внешних ключей
SET @@foreign_key_checks = 0;
SET foreign_key_checks = 0;

# выключаем глобально проверку внешних ключей
SET GLOBAL foreign_key_checks = 0;

# присвоение значений переменным в SELECT запросе
SELECT 
	@id := id,
	@firstname := firstname
FROM users
WHERE id = 1;

# чтение переменных
SELECT @id, @firstname;

# второй вариант присвоения значений переменным в SELECT запросе

SELECT id, firstname
INTO @id, @firstname
FROM users
WHERE id = 11;

--- примеры переменных 

SET @user_id = 5;
SET @channel_id = 5;

SELECT owner_user_id
FROM channels 
WHERE id = @channel_id;

SELECT @user_id = (
	   SELECT owner_user_id
	   FROM channels
	   WHERE id = @channel_id
) AS is_owner; 

SHOW FUNCTION STATUS WHERE Db = 'telegram';

SELECT get_user_for_channel_relation(1, 3);

SELECT *
FROM users 
WHERE id = 10;

# создание триггера на событие обновления (BEFORE UPDATE)

DROP TRIGGER IF EXISTS telegram.check_user_age_before_update;
USE telegram;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` TRIGGER `check_user_age_before_update` 
BEFORE UPDATE ON `users` 
FOR EACH ROW 
BEGIN 
	DECLARE message varchar(100);

	IF NEW.birthday > CURRENT_DATE() THEN 
		SET message = CONCAT('Update has been cancelled.',
			'New value: ', NEW.birthday, ' is incorrect.'
			'Old value: ', OLD.birthday, ' retained.'
		);

		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = message;
	END IF;	
END $$
DELIMITER ;


# создание триггера на событие вставки(BEFORE INSERT)

DROP TRIGGER IF EXISTS telegram.check_user_age_before_insert;
USE telegram;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` TRIGGER `check_user_age_before_insert` BEFORE INSERT ON `users` FOR EACH ROW BEGIN 
    IF NEW.birthday > CURRENT_DATE() THEN
        SET NEW.birthday = CURRENT_DATE();
    END IF;	
END $$
DELIMITER ;


# вставка некорректных данных (дата рождения)
INSERT INTO users 
SET 
	firstname = 'Nick',
	lastname = 'Durov',
	birthday = '2040.10.10'
;

# обновление на некорректные данные (дата рождения)
UPDATE users 
SET birthday = '2040.10.10'
WHERE id = 10;

--- решение задач на степик поиск при помощи создания full text idx

CREATE FULLTEXT INDEX full_title_idx ON channels(title);

SELECT id, title
FROM channels 
WHERE match(title) AGAINST('+sql -server' IN BOOLEAN MODE)
ORDER BY title;

DROP VIEW IF EXISTS v_users_without_phone;


CREATE VIEW v_users_without_phone AS 
SELECT *
FROM users u
INNER JOIN user_settings us ON users.id = user_settings.user_id
WHERE u.phone IS NULL OR u.phone = '';

SELECT * FROM telegram.v_users_without_phone;

CREATE OR REPLACE VIEW v_users_without_phone AS
SELECT *
FROM users AS u
INNER JOIN user_settings AS us ON u.id = us.user_id
WHERE u.birthday IS NOT NULL;


--- здесь уже при созданном view можно вызывать данные 
--- с дополнительными запросами

SELECT u.id, u.email FROM v_users_without_phone AS u
JOIN user_settings AS us ON u.id = us.user_id
WHERE us.app_language = 'Russian'
ORDER BY email;

--- создал процедуру при вызове которой удаляются все поля из 
--- сообщений если тело сообщения is NULL

DROP PROCEDURE IF exists remove_empty_messages;

CREATE PROCEDURE remove_empty_messages()

BEGIN
    DELETE FROM saved_messages
    WHERE body IS NULL;

    DELETE FROM private_messages
    WHERE body IS NULL;

    DELETE FROM channel_messages 
    WHERE body IS NULL;

    DELETE FROM group_messages 
    WHERE body IS NULL;
END;

CALL remove_empty_messages();


DROP PROCEDURE IF exists remove_empty_messages;

CREATE PROCEDURE remove_empty_messages(_user_number BIGINT UNSIGNED)
BEGIN
    DELETE FROM saved_messages
    WHERE user_id = _user_number AND body IS NULL;

    DELETE FROM private_messages
    WHERE sender_id = _user_number AND body IS NULL;

    DELETE FROM channel_messages
    WHERE sender_id = _user_number AND body IS NULL;

    DELETE FROM group_messages
    WHERE sender_id = _user_number AND body IS NULL;
END;

CALL remove_empty_messages();

SELECT 
FROM users;

ALTER TABLE users
ADD COLUMN is_active BIT;

--- проверка на совершеннолетие 
IF birthday > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN 
IF (YEAR(NOW()) - YEAR(birthday) < 18) THEN


SELECT deactivate_infants();
DROP PROCEDURE IF EXISTS deactivate_infants;
DROP function IF EXISTS deactivate_infants;

CREATE PROCEDURE telegram.deactivate_infants()
BEGIN
	UPDATE users u 
	INNER JOIN user_settings us ON u.id = us.user_id
	SET is_active = 0
    WHERE YEAR(NOW()) - YEAR(birthday) < 18 AND us.is_premium_account = 0;
END

CREATE FUNCTION telegram.deactivate_infants()
RETURNS INT
DETERMINISTIC
MODIFIES SQL DATA
BEGIN
    UPDATE users u
    INNER JOIN user_settings us ON u.id = us.user_id
    SET u.is_active = 0
    WHERE YEAR(NOW()) - YEAR(u.birthday) < 18
      AND us.is_premium_account = 0;
    RETURN ROW_COUNT();
END


SELECT deactivate_infants();


--- создание функции которая при введении параметр 1 или 0 проверяет есть ли 18 лет 
--- пользвоателям если нет то деактевирует их, так же второй параметр 1 или 0
--- проверяет если у пользователя не премиум аккаунт деактивирует их и сумирует
--- кол-во деактевированых аккаунтов 

CREATE FUNCTION deactivate_infants(deact_infants BIT, deact_free_accounts BIT)

RETURNS INT
DETERMINISTIC
MODIFIES SQL DATA
BEGIN
	DECLARE count_deactive INT DEFAULT 0;
	IF deact_infants = 1 THEN
	UPDATE users 
	SET is_active = 0
    WHERE YEAR(NOW()) - YEAR(birthday) < 18; 
	SET count_deactive = count_deactive + ROW_COUNT();
END IF;  
    
	 IF deact_free_accounts = 1 THEN   
        UPDATE users u
        INNER JOIN user_settings us ON u.id = us.user_id
        SET u.is_active = 0
        WHERE us.is_premium_account = 0;
        SET count_deactive = count_deactive + ROW_COUNT();
    END IF;

    RETURN count_deactive;
END;

--- создание переменной которая подсчитывает кол-во историй юзера = 1

SET @user_stories_count = (
    SELECT COUNT(*)
    FROM stories
    WHERE user_id = 1
);

--- создание триггера при удалении пользователья будет записываться в лог файл событие

CREATE TRIGGER before_user_delete
AFTER DELETE ON users FOR EACH ROW
BEGIN 
    INSERT INTO logs (value) VALUES ("Удалена строка users");
END


############################################################
--- тема транзакции 
# начать транзакцию
START TRANSACTION;	
	INSERT INTO `users` (firstname, lastname, email, birthday)
	VALUES ('Rahsan2','Runt2','crist.donny2@example.net','2018-01-07');
	
	#задаем переменную при добавлении нового пользователя чтобы user_id  
	#обновилось значение и не было ошибки 
	########################################
#	SET @user_id = (SELECT max(id) FROM users); - здесь вроде бы логично, но это не правильно
	
	SET @user_id = LAST_INSERT_ID(); # вот здесь правильно задана переменная перед добавлением данных
	
	INSERT INTO `user_settings` (user_id, is_premium_account, app_language, created_at)
 	VALUES (@user_id, FALSE, 'english', NOW());
	
COMMIT;  ---  коммит (фиксация) изменений 

# ROLLBACK;  --- ролбэк (откат) изменений

# проверка состояния таблиц после транзакции
SELECT * FROM users ORDER BY id DESC; 
SELECT * FROM user_settings ORDER BY user_id DESC;

CALL add_user(@trans_result); 
 
SELECT @trans_result; 


DROP PROCEDURE IF EXISTS add_user; 


# удаляем процедуру с проверкой
DROP PROCEDURE IF EXISTS telegram.add_user;

# устанавливаем разделитель команд
DELIMITER $$

# создаем процедуру
CREATE PROCEDURE telegram.add_user(
	_firstname VARCHAR(100), 
	_lastname VARCHAR(100), 
	_email VARCHAR(100), 
	_birthday DATE,
	_is_premium_account BIT, 
	_app_language ENUM('english','french','russian','german','belorussian','croatian','dutch'), 
	
	OUT trans_result VARCHAR(200)
)
BEGIN
# объявляем необходимые переменные
	DECLARE has_error BIT DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);

# объявляем обработчик исключений
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET has_error = 1;
	
		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		 
		SET trans_result = CONCAT('Error occured! Code: ', code, '. Text: ', error_string);
	END;

# начинаем транзакцию	
	START TRANSACTION;	
		INSERT INTO `users` (firstname, lastname, email, birthday)
		VALUES (_firstname, _lastname, _email, _birthday);

		INSERT INTO `user_settings` (user_id, is_premium_account, app_language, created_at)
		VALUES (LAST_INSERT_ID(), _is_premium_account, _app_language, NOW());
	
# проверяем ошибки
	IF has_error THEN
		# SET trans_result = 'Error!';
		ROLLBACK;
	ELSE 
		SET trans_result = 'Ok.';
		COMMIT;
	END IF;
END$$

# возвращаем разделитель в значение по умолчанию
DELIMITER ;


# вызываем процедуру с параметрами
CALL add_user('Leslie3', 'Reichel3',  'cronin.emmitt3@example.net', '1982-05-01', FALSE, 'english', @trans_result);

# читаем результат выполнения процедуры
SELECT @trans_result;

# проверяем данные в таблицах
SELECT * FROM users ORDER BY id DESC;
SELECT * FROM user_settings ORDER BY user_id DESC;


SHOW variables LIKE '%isolation%';

# вывести нужную переменную
SHOW VARIABLES LIKE '%isolation%';

# установить глобальный уровень изоляции транзакций в значение READ UNCOMMITTED
SET global TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

# установить глобальный уровень изоляции транзакций в значение READ COMMITTED
SET global TRANSACTION ISOLATION LEVEL READ COMMITTED;

# установить глобальный уровень изоляции транзакций в значение REPEATABLE READ
SET global TRANSACTION ISOLATION LEVEL REPEATABLE READ;

# установить глобальный уровень изоляции транзакций в значение SERIALIZABLE
SET global TRANSACTION ISOLATION LEVEL SERIALIZABLE;

# зайти на локальный сервер MySQL
mysql - u root -p

# выйти из сервера (закончить текущую сессию)
exit

# переключиться на БД telegram
use telegram;

# начать транзакцию
start transaction;
begin;

# зафиксировать изменения и закончить транзакцию
commit;

# отменить изменения и закончить транзакцию
rollback;

# вывести идентификатор текущего подключения
SELECT CONNECTION_ID();

# вывести список активных подключений к серверу
SHOW PROCESSLIST;

# заблокировать таблицу stories на чтение
LOCK TABLE stories READ;

# заблокировать таблицу stories на запись
LOCK TABLE stories WRITE;

# разблокировать все таблицы
UNLOCK TABLES;


--- задание на степик удалить канал с айди 1 для этого нужно удалить все зависимости
--- по очереди 
START TRANSACTION;

DELETE FROM channel_messages
WHERE channel_id = 1;

DELETE FROM channel_subscribers
WHERE channel_id = 1;

DELETE FROM channels
WHERE id = 1;

ROLLBACK;

SELECT * FROM channels WHERE id = 1;

CALL remove_channel;

--- выполнил задание, та же процедура только нужно было указать явно номер 
--- канала через переменную, моя субд не приняла указала на синтаксис а вот 
--- на степик во ОК 

DROP PROCEDURE IF EXISTS telegram.remove_channel;
CREATE PROCEDURE telegram.remove_channel(IN channel_number bigint unsigned)
BEGIN
	START TRANSACTION;
	DELETE FROM channel_messages
	WHERE channel_id = channel_number;

	DELETE FROM channel_subscribers
	WHERE channel_id = channel_number;

	DELETE FROM channels
	 	WHERE id = channel_number;
COMMIT;
END;


--- Заблокируйте таблицу пользователей на чтение, 
--- затем выведите количество строк в ней и после этого разблокируйте таблицу.

LOCK TABLE users READ;
SELECT count(*)
from users;
unlock tables;

# комманда позволяющая узнать на каких правах доступа подключение

SELECT user();

SELECT * FROM mysql.USER;

--- перечисляется что позволено для данного подключения какие комманды и т д 

SHOW grants;

--- создание учетной записи для нового администратора с определенными правами доступа

CREATE USER 'john_admin'@'localhost' identified BY '12345';

SHOW grants FOR 'john_admin'@'localhost';

--- показать все базы данных (при подключении с учетной записаи john_admin
--- с его акаунта не видно всех баз данных ему нужно раздать доступ, далее)

SHOW DATABASES;

--- раздача прав ниже (* - все базы .* - все таблицы)


GRANT ALL PRIVILEGES ON *.* TO 'john_admin'@'localhost';

CREATE USER 'alex_dev'@'localhost'; --- создал юзера без пароля, он может заходить
---                                     с этим лошином без пароля

--- задать пароль, способы
SET password;  --- таким образом можно задать пароль самому себе

SET password FOR 'alex_dev'@'localhost' = '12345'; --- так задал пароль юзеру

--- при помощи данной комнды в колонке authetication_string
--- можно увидить есть ли пароли 

SELECT * FROM mysql.USER; 
	
GRANT ALL PRIVILEGES ON telegram.* TO 'alex_dev'@'localhost'; 

CREATE USER 'max_tester'@'localhost' identified BY '12345';

--- создание юзера с определенными разрешениями

GRANT CREATE, ALTER, DROP, SELECT, INSERT, UPDATE, DELETE
ON telegram.* 
TO 'max_tester'@'localhost';

SHOW grants FOR 'max_tester'@'localhost';

--- создание юзера с дополнительными требованиями 
--- в данном случае смена пароля каждые 180 дней и 
--- блокировка на 2 дня в случае если данный пользователь
--- ввел пароль неверно 3 раза

CREATE USER 'paul_manager'@'localhost' identified BY '12345'
password expire INTERVAL 180 DAY 
failed_login_attempts 3
password_lock_time 2;

--- доступ к базе telegram ко всем колонкам, 
--- с разрешением одной только комманды SELECT

GRANT SELECT
ON telegram.* 
TO 'paul_manager'@'localhost';

# команда которая забрает права 

REVOKE ALL PRIVILEGES ON telegram.* FROM 'paul_manager'@'localhost'; 	 

# выдать права только на чтение и только на указанные поля
GRANT SELECT(firstname, lastname) ON telegram.users TO `paul_manager`@`localhost`;

--- удаление юзера 

DROP USER 'paul_manager'@'localhost';

# создание ролей 

CREATE ROLE '_admin';

CREATE ROLE '_developer', '_tester', '_manager';

SELECT * FROM mysql.user; 

# раздал ранее созданым пользователям 
# права и доступ как роль

GRANT ALL PRIVILEGES ON *.* TO '_admin';
GRANT ALL PRIVILEGES ON telegram.* TO '_developer';
GRANT CREATE, ALTER, DROP, SELECT, INSERT, UPDATE, DELETE
ON telegram.* 
TO '_tester';
GRANT SELECT ON telegram.* TO '_manager';

# далее уберу доступ у пользователей которые были созданы раннее
# и присоеденю их к этим созданым ролям вот таким образом
# откоючаю доступ

REVOKE ALL ON *.* FROM  'paul_manager'@'localhost', 
				'max_tester'@'localhost',
				'alex_dev'@'localhost',
				'john_admin'@'localhost';

SHOW grants FOR 'paul_manager'@'localhost';

# а здесь даю уже этим же пользователям доступ отталкиваясь
# от ранее созданной роли (по ролям)	

GRANT '_admin' TO 'john_admin'@'localhost';
GRANT '_developer' TO 'alex_dev'@'localhost';
GRANT '_tester' TO 'max_tester'@'localhost';
GRANT '_manager' TO 'paul_manager'@'localhost';

# при помощи этой команды идет присвоение роли при входе юзера

SET DEFAULT ROLE ALL TO 
		        'paul_manager'@'localhost', 
				'max_tester'@'localhost',
				'alex_dev'@'localhost',
				'john_admin'@'localhost';

# таким образом можно так же забирать права у пользователе по ролям

REVOKE '_manager' FROM  'paul_manager'@'localhost';

# создаем нового менеджера 

CREATE USER 'anna_manager'@'localhost' identified BY '12345'
password expire INTERVAL 180 DAY 
failed_login_attempts 3
password_lock_time 2;

# и дальше даем права-роль администратора новому менеджеру

GRANT '_manager' TO 'anna_manager'@'localhost';
SET DEFAULT ROLE ALL TO 'anna_manager'@'localhost';


# удалить роль
DROP ROLE '_manager';

--- пример запросы где применяется join так как колонка status_text 
--- желательно оптимизировать и колонку перенести в таблицу users 
--- далее будет пример как это сделать

SELECT 
	firstname,
	lastname,
	email,
	status_text
FROM users AS u 
# JOIN user_settings AS us ON u.id = us.user_id --- после того как перенесли колонку join не нужен
WHERE id = 1;

--- перенос колонки, для начала создается колонка в users 


--- далее указываем что одна колонка равна другой командой SET

UPDATE users AS u 
JOIN user_settings AS us ON u.id = us.user_id 
SET u.status_text = us.status_text; 


# удаление поля в таблице user_settings 
ALTER TABLE user_settings DROP COLUMN status_text;

--- далее оптимизация запросов из разных таблиц

# изначальный простой SELECT запрос
SELECT *
FROM stories 
WHERE user_id IN (1,2,3);

# запрос с учетом количества лайков
SELECT 
	s.id,
	COUNT(*)
FROM stories s
JOIN stories_likes sl ON s.id = sl.story_id 
WHERE s.user_id IN (1,2,3)
GROUP BY s.id;

USE telegram;

# добавление нового поля для подсчета лайков (собственно, денормализация)
ALTER TABLE stories ADD COLUMN likes_count bigint UNSIGNED DEFAULT 0;

# упрощение финального запроса (достаточно обратиться к 1 таблице)
SELECT 
	s.id,
	likes_count,
	s.*
FROM stories s
# JOIN stories_likes sl ON s.id = sl.story_id 
WHERE s.user_id IN (1,2,3)
# GROUP BY s.id;

--- создание переменной и лог файла 

SET GLOBAL slow_query_log = 'ON';
SET GLOBAL slow_query_log_file = 'c:\mysql-slow-query.log';
SET GLOBAL long_query_time = 1;


--- фиксирует те запросы которые не использовали индекс

SET GLOBAL log_queries_not_using_indexes = 'ON'; 

--- провека наличие созданых переменных

SHOW GLOBAL variables LIKE '%slow%';
SHOW GLOBAL variables LIKE '%long%';

 
--- простой тест записи в лог файл проверка

SELECT SLEEP(2);

SHOW VARIABLES LIKE 'slow_query_log_file';
SHOW VARIABLES LIKE 'log_output';
SHOW VARIABLES LIKE 'slow_query_log';

SHOW VARIABLES LIKE 'slow_query_log_file';

USE telegram;

SELECT *
FROM users;

SELECT count(*) FROM stories_likes;

--- EXPLAIN — это команда в SQL, которая показывает план выполнения запроса 
--- (execution plan), не запуская его.

# EXPLAIN показывает как исполняется запрос работает 
--- с такими запросами как
# (SELECT, DELETE, INSERT, REPLACE AND UPDATE) 

SELECT 
	s.id,
	COUNT(*) AS cnt,
	u.firstname,
	u.lastname,
	(SELECT app_language from user_settings us WHERE u.id = us.user_id) AS app_language
FROM users u
JOIN stories s ON u.id = s.user_id 
JOIN stories_likes sl ON s.id = sl.story_id 
GROUP BY s.id
ORDER BY cnt DESC 
LIMIT 20;

ALTER TABLE stories_likes ADD INDEX (story_id); --- добавил индекс

ALTER TABLE stories_likes ADD FOREIGN KEY (story_id) REFERENCES stories(id); 




SET @user_number = 11;

SELECT 
	users.id,
	users.birthday,
	user_settings.is_premium_account
FROM users
JOIN user_settings ON users.id = user_settings.user_id 
WHERE id = @user_number;


--- Требование о переносе поля реализуется в несколько шагов:

--- Создать дублирующее поле is_premium_account в таблице users
--- Скопировать UPDATE запросом данные этого поля из таблицы 
--- user_settings в таблицу users
--- Удалить поле is_premium_account из таблицы user_settings
 
--- создание колонки
ALTER TABLE users 
ADD COLUMN is_premium_account BIT;

--- добавление значений (копирование с другой колонки)

UPDATE users
JOIN user_settings AS us ON us.user_id = users.id
SET users.is_premium_account = us.is_premium_account;

--- удаление колонки с таблицы users 
ALTER TABLE users DROP COLUMN is_premium_account;




SELECT 
	users.id,
	users.birthday,
	user_settings.is_premium_account
FROM users
JOIN user_settings ON users.id = user_settings.user_id 
WHERE id = 1;


EXPLAIN SELECT *
FROM channels AS c
JOIN channel_messages AS cm ON c.id = cm.channel_id 
JOIN channel_message_reactions AS cmr ON cm.id = cmr.message_id 
JOIN reactions_list AS rl ON rl.id = cmr.reaction_id 
JOIN users AS u ON u.id = cm.sender_id;

ALTER TABLE channel_message_reactions  ADD FOREIGN KEY (message_id) REFERENCES channel_messages(id); 
