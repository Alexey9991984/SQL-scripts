# создать новую БД telegram:
CREATE SCHEMA `telegram` ;
CREATE DATABASE `telegram` ;

# создать таблицу users в БД telegram:
CREATE TABLE `telegram`.`users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `firstname` VARCHAR(45) NULL,
    `lastname` VARCHAR(45) NULL,
    `email` VARCHAR(100) NULL,
    PRIMARY KEY (`id`)
);

# вставить новые строки в таблицу users:
INSERT INTO `telegram`.`users` (`id`, `firstname`, `lastname`, `email`) 
VALUES ('1', 'Pavel', 'Durov', 'pavel@mail.ru');

INSERT INTO `telegram`.`users` (`id`, `firstname`, `lastname`, `email`) 
VALUES ('2', 'Mark', 'Zuckerberg', 'mark@gmail.com');

INSERT INTO `telegram`.`users` (`id`, `firstname`, `lastname`, `email`) 
VALUES ('3', 'Ilon', 'Musk', 'ilon@mail.ru');

# вывести пользователя c идентификатором 3:
SELECT *
FROM users
WHERE id = 3;

# вывести пользователя с указаным email:
SELECT *
FROM users
WHERE email = 'pavel@mail.ru';

# вывести всех пользователей, почта которых находится вне домена mail.ru:
SELECT *
FROM users
WHERE email NOT LIKE '%mail.ru';

# обновить email пользователя с идентификатором 2:
UPDATE users
SET email = 'newmail@mail.ru'
WHERE id = 2;

# удалить строку с пользователем номер 3:
DELETE FROM users
WHERE id = 3;


DROP DATABASE IF EXISTS telegram; 
CREATE SCHEMA telegram;
USE telegram;


DROP TABLE IF EXISTS users;

CREATE TABLE `users` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `firstname` VARCHAR(100),
    `lastname` VARCHAR(100), 
    `login` VARCHAR(100) UNIQUE,
    `email` VARCHAR(100) UNIQUE,
    `password_hash` VARCHAR(256),
    `phone` VARCHAR(20) UNIQUE,
    INDEX `idx_users_username` (`firstname`, `lastname`)
);


DROP TABLE IF EXISTS user_settings;
CREATE TABLE user_settings(
    user_id BIGINT UNSIGNED NOT NULL,
    is_premium_account BIT,
    is_night_mode_enabled BIT,
    color_scheme ENUM('classic', 'day', 'tinted', 'night'),
    app_language ENUM('english', 'french', 'russian', 'german', 'belorussian', 'croatian', 'dutch'),
    status_text VARCHAR(70),
    notifications_and_sounds JSON,
    created_at DATETIME DEFAULT NOW()
);
	 	
ALTER TABLE user_settings ADD CONSTRAINT fk_user_settings_user_id
FOREIGN KEY (user_id) REFERENCES users(id);  
	 	
	 	
ALTER TABLE users ADD COLUMN birthday datetime;  

ALTER TABLE users MODIFY COLUMN birthday date;

ALTER TABLE users RENAME COLUMN birthday TO date_of_birth; 


DROP TABLE IF EXISTS `private_messages`;


DROP TABLE IF EXISTS `private_messages`;

CREATE TABLE `private_messages` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `sender_id` BIGINT UNSIGNED NOT NULL,
    `receiver_id` BIGINT UNSIGNED NOT NULL,
    `media_type` ENUM('text', 'image', 'audio', 'video'),
    `body` TEXT,
    `filename` VARCHAR(200),
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`sender_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`receiver_id`) REFERENCES `users`(`id`)
);


DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	titile varchar(45),
	icon varchar(45),
	invite_link varchar(100),
	settings JSON,
	owner_user_id bigint UNSIGNED NOT NULL,
	is_private bit,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (owner_user_id) REFERENCES users (id) 
  );



DROP TABLE IF EXISTS `group_members`;

CREATE TABLE `group_members`(
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	group_id bigint UNSIGNED NOT NULL,
	user_id bigint UNSIGNED NOT NULL,
	created_at datetime DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (group_id) REFERENCES `groups` (id)
);


DROP TABLE IF EXISTS `group_messages`;

CREATE TABLE `group_messages` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	group_id bigint UNSIGNED NOT NULL,
	sender_id bigint UNSIGNED NOT NULL,
	reply_to_id bigint UNSIGNED NULL,
	media_type enum('text', 'image', 'audio', 'video'),
	body text,
	filename varchar(100) NULL,
	created_at datetime DEFAULT CURRENT_TIMESTAMP(),
	FOREIGN KEY (sender_id) REFERENCES users (id),
	FOREIGN KEY (group_id) REFERENCES `groups` (id),
	FOREIGN KEY (reply_to_id) REFERENCES `group_messages` (id)
);
	

DROP TABLE IF EXISTS channels;

CREATE TABLE channels (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	title varchar(45),
	icon varchar(45),
	invite_link varchar(45),
	settings JSON,
	owner_user_id bigint UNSIGNED NOT NULL,
	channel_type bit, 
	created_at datetime DEFAULT CURRENT_TIMESTAMP(),
	FOREIGN KEY (owner_user_id) REFERENCES users (id)
	);

DROP TABLE IF EXISTS channel_subscribers;
CREATE TABLE channel_subscribers (
	channel_id bigint UNSIGNED NOT NULL,
	user_id bigint UNSIGNED NOT NULL,
	status enum('requested', 'joined', 'left'),
    created_at datetime DEFAULT CURRENT_TIMESTAMP(),
	updated_at datetime ON UPDATE CURRENT_TIMESTAMP(), 
    PRIMARY KEY (user_id, channel_id),
	FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (channel_id) REFERENCES channels (id)
);


DROP TABLE IF EXISTS channel_messages;
CREATE TABLE channel_messages (
	id bigint UNSIGNED NOT NULL,
	channel_id bigint UNSIGNED NOT NULL,
	sender_id bigint UNSIGNED NOT NULL,
	media_type enum('text', 'image', 'audio', 'video'),
	body text,
	filename varchar(100) NULL,
	created_at datetime DEFAULT CURRENT_TIMESTAMP(),
	FOREIGN KEY (sender_id) REFERENCES users (id),
	FOREIGN KEY (channel_id) REFERENCES `channels` (id)
);


DROP TABLE IF EXISTS saved_messages;
CREATE TABLE saved_messages (
	id bigint UNSIGNED NOT NULL,
	user_id bigint UNSIGNED NOT NULL,
	body text,
	created_at datetime DEFAULT CURRENT_TIMESTAMP(),
	FOREIGN KEY (user_id) REFERENCES users (id)  
);



DROP TABLE IF EXISTS reactions_list;
CREATE TABLE reactions_list (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(1)
)DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TABLE IF EXISTS private_message_reactions;
CREATE TABLE private_message_reactions (
    reaction_id BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
    FOREIGN KEY (message_id) REFERENCES private_messages (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS channel_message_reactions;
CREATE TABLE channel_message_reactions (
    reaction_id BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
    FOREIGN KEY (message_id) REFERENCES channel_messages (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS group_message_reactions;
CREATE TABLE group_message_reactions (
    reaction_id BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
    FOREIGN KEY (message_id) REFERENCES group_messages (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS stories;
CREATE TABLE stories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    caption VARCHAR(140),
    filename VARCHAR(100),
    views_count INT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP(),
	FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS stories_likes;
CREATE TABLE stories_likes (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    story_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP(),
	FOREIGN KEY (user_id) REFERENCES users (id)
);

ALTER TABLE users
ADD COLUMN userpic LONGBLOB;


ALTER TABLE users
ADD COLUMN is_active BIT NOT NULL DEFAULT 1;


ALTER TABLE private_messages 
RENAME COLUMN body TO message_text;


ALTER TABLE channels
MODIFY COLUMN title VARCHAR(45) NOT NULL;

ALTER TABLE users 
MODIFY COLUMN email varchar(100) UNIQUE;

alter table user_settings 
modify column app_language enum('english', 'french', 'russian', 'german', 'belarusian', 'croatian', 'dutch', 'klingon');

alter table group_members
add column status ENUM('requested', 'joined', 'left');

rename table `groups` to communities;

DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
	id bigint UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL
);

ALTER TABLE user_settings 
ADD COLUMN language_id bigint UNSIGNED NOT NULL;

ALTER TABLE user_settings 
ADD FOREIGN KEY (language_id) REFERENCES languages (id);

alter table user_settings
drop column app_language;

INSERT INTO users (id, firstname, lastname, email, phone)
VALUES ('1', 'Kelsie', 'Olson', 'xheindenreich@example.net', '9548492646');


# DML: INSERT, SELECT, UPDATE, DELETE
# CRUD


# базовый вариант команды INSERT
INSERT INTO users (id, firstname, lastname, email, phone)
VALUES ('1', 'Kelsie', 'Olson', 'xheidenreich@example.net', '9548492646');

INSERT INTO users (id, firstname, lastname, email, phone)
VALUES ('2', 'Kelsie', 'Olson', 'xheidenreich2@example.net', '9548492642');

# опция IGNORE - позволяет игнорировать ошибки в данных
INSERT IGNORE INTO users (id, firstname, lastname, email, phone)
VALUES ('3', 'Celestino', 'Cruickshank', 'flavio.hammes@example.com', '9686686728');

# можно не указывать автоинкрементное (AUTO_INCREMENT) поле
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Celestino', 'Cruickshank', 'flavio.hammes2@example.com', '9686686722');

# идентификаторы можно добавлять не по порядку
INSERT INTO users (id, firstname, lastname, email, phone)
VALUES ('93', 'Gregory', 'Jenkins', 'weimann.richard@example.com', '9860971258');

# можно указывать NULL или DEFAULT вместо значений для поля
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Celestino', 'Cruickshank', DEFAULT, NULL);

# добавим колонку is_deleted
ALTER TABLE users ADD COLUMN is_deleted BIT DEFAULT 0;

# значение по умолчанию для поля is_deleted
INSERT INTO users (firstname, lastname, is_deleted)
VALUES ('Celestino', 'Cruickshank', DEFAULT);

# NULL для поля is_deleted
INSERT INTO users (firstname, lastname, is_deleted)
VALUES ('Celestino', 'Cruickshank', NULL);

# вставим абсолютно пустую строку
INSERT INTO users ()
VALUES ();

# не указываем имена полей - ошибка
INSERT INTO users
VALUES ('Celestino', 'Cruickshank', DEFAULT);

# не указываем имена полей - рабочий вариант
INSERT INTO users
VALUES (101, 'Eleonore', 'Ward', NULL, 'antonietta333@example.com',DEFAULT, 9397815333, '2000.01.01', 0);

# перепутали фамилию и почту - сработало
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Pearl', 'xeichmann@example.net', 'Prohaska', '9136605713');

# перепутали телефон и почту - ошибка
INSERT INTO users (firstname, lastname, phone, email)
VALUES ('Pearl', 'Prohaska', 'xeichmann@example.net', '9136605713');

# пакетная вставка данных - работает быстро
INSERT INTO users (firstname, lastname, email, phone) VALUES
('Ozella', 'Hauck', 'idickens@example.com', '9773438197'),
('Emmet', 'Hammes', 'qcremin@example.org', '9694110645'),
('Lori', 'Koch', 'damaris34@example.net', '9192291407'),
('Sam', 'Kuphal', 'telly.miller@example.net', '9917826315');

# одиночная вставка данных - работает медленно
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Ozella', 'Hauck', 'idickens2@example.com', '9773438192');
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Emmet', 'Hammes', 'qcremin2@example.org', '9694110642');
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Lori', 'Koch', 'damaris342@example.net', '9192291402');
INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Sam', 'Kuphal', 'telly.miller2@example.net', '9917826312');

# второй вариант команды INSERT (можно вставить только 1 строку)
INSERT INTO users
SET
    firstname = 'Miguel',
    lastname = 'Watsica',
    email = 'hassan.kuphal@example.org',
    login = 'hassan_kuphal',
    phone = '9824696112'
;

# INSERT-SELECT
INSERT INTO users
    (firstname, lastname, email, phone)
SELECT
    'Sam2', 'Kuphal2', 'telly.miller222@example.net', '9917826222';

# INSERT-SELECT
INSERT INTO users (firstname, lastname, email)
SELECT first_name , last_name , email
FROM sakila.staff;

# опция ON DUPLICATE KEY UPDATE позволяет выполнить обновление
INSERT INTO users (id, firstname, lastname, email, phone)
VALUES (2, 'Lucile', 'Rolfson', 'dbartell@example.net', 9258387168)
ON DUPLICATE KEY UPDATE
    firstname = 'Lucile',
    lastname = 'Rolfson',
    email = 'dbartell@example.net',
    phone = 9258387168
;

ALTER TABLE channel_subscribers 
MODIFY COLUMN status enum('requested', 'joined', 'left', 'removed');

ALTER TABLE channels 
ADD COLUMN is_private TINYINT(1) NOT NULL DEFAULT 0;



INSERT INTO channels (title, invite_link, owner_user_id, is_private) 
VALUES ('MySQL news', 'https://t.me/mysql_news', 1, true);


INSERT INTO channel_subscribers (channel_id, user_id, status)
VALUES (1, 2, 'requested'); 


INSERT INTO channel_subscribers (channel_id, user_id, status)
VALUES (1, 3, 'requested'); 


INSERT INTO channel_subscribers (channel_id, user_id, status)
VALUES (1, 4, 'requested'); 

UPDATE channel_subscribers 
SET 
	status = 'joined'
WHERE channel_id = 1 and user_id = 2; 

UPDATE channel_subscribers 
SET 
	status = 'joined'
WHERE channel_id = 1 AND user_id = 3;


UPDATE channel_subscribers 
SET 
	status = 'left'
WHERE channel_id = 1 AND user_id = 2;

UPDATE channel_subscribers 
SET 
	status = 'removed'
WHERE channel_id = 1 AND user_id = 2;



