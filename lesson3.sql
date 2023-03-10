CREATE DATABASE IF NOT EXISTS vk;

USE vk;

DROP TABLE  IF EXISTS users;

CREATE TABLE users(
    id bigint UNSIGNED AUTO_INCREMENT primary KEY,
    firstname varchar(50) NOT NULL,
    lastname varchar(50) NOT NULL,
    phone char(11) NOT NULL,
    email varchar(120) UNIQUE,
    password_hash char(65),
    cteated_at datetime DEFAULT current_timestamp,
    update_at datetime DEFAULT current_timestamp ON UPDATE current_timestamp,
    INDEX (lastname),
    INDEX (phone)
);
CREATE TABLE profiles(
user_id  bigint UNSIGNED NOT NULL UNIQUE,
gender enum('f', 'm', 'x') NOT NULL,
birthday date NOT NULL,
photo_id bigint UNSIGNED NOT NULL,
city varchar(130),
country varchar(130),
FOREIGN KEY (user_id) REFERENCES users (id)
);


INSERT INTO users VALUES (1, 'Petya', 'Petukhov', '89279496966', 'petya@mail.com', '81dc9bdb52d04dc20036dbd8313ed055', DEFAULT, DEFAULT);

SELECT * FROM users;

INSERT INTO users (firstname, lastname, phone, email, password_hash) VALUES ('Vasya', 'Vasilkov', '99999999999', 'vasya@mail.com', '4a7d1ed414474e4033ac29ccb8653d9b');
SELECT * FROM users;

INSERT INTO profiles VALUES (1, 'm', '2000-01-01', 1, 'Moscow', 'Russia');	
INSERT INTO profiles VALUES (2, 'm', '2002-11-01', 2, 'Moscow', 'Russia');
SELECT * FROM profiles;

create TABLE messages (
    id serial,
    from_user_id bigint UNSIGNED NOT NULL,
    to_user_id bigint UNSIGNED NOT NULL,
    body text,
    created_at datetime DEFAULT now(),
    updated_at datetime DEFAULT current_timestamp ON UPDATE current_timestamp,
    is_delivered boolean DEFAULT FALSE,
    FOREIGN KEY (from_user_id) REFERENCES users (id),
    FOREIGN KEY (to_user_id) REFERENCES users (id)
);
INSERT into messages values(DEFAULT, 1, 2, 'Hi!', DEFAULT, DEFAULT, DEFAULT);
INSERT into messages values(DEFAULT, 1, 2, 'Vasya!', DEFAULT, DEFAULT, DEFAULT);
INSERT into messages values(DEFAULT, 2, 1, 'Hi, Petya!', DEFAULT, DEFAULT, DEFAULT);
 SELECT * FROM messages;

CREATE TABLE friend_requests(
   from_user_id bigint UNSIGNED NOT NULL,
   to_user_id bigint UNSIGNED NOT NULL,
   accepted bool DEFAULT FALSE,
   PRIMARY KEY (from_user_id, to_user_id)
   FOREIGN KEY (from_user_id) REFERENCES users (id),
   FOREIGN KEY (to_user_id) REFERENCES users (id)
);
CREATE TABLE communities (
   id serial,
   name varchar(145) NOT NULL,
   description varchar(255),
   admin_id bigint UNSIGNED NOT NULL,
   INDEX communities_name_idx (name),
   CONSTRAINT fk_communities_admin_id FOREIGN KEY (admin_id) REFERENCES users (id)
);

INSERT INTO communities VALUES (DEFAULT, 'Number1', 'I am number one', 1);

CREATE TABLE communities_users (
community_id bigint UNSIGNED NOT NULL,
user_id bigint UNSIGNED NOT NULL,
PRIMARY KEY (community_id, user_id),
FOREIGN KEY (community_id) REFERENCES communities (id),
FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO communities_users VALUES (1, 2);

CREATE TABLE media_types(
id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(45) NOT NULL unique
);

INSERT INTO media_types VALUES (DEFAULT, '??????????????????????');
INSERT INTO media_types VALUES (DEFAULT, '????????????');
INSERT INTO media_types VALUES (DEFAULT, '????????????????');


CREATE TABLE media (
id serial,
user_id bigint UNSIGNED NOT NULL,
media_types_id int UNSIGNED NOT NULL, 
file_name varchar(255),
file_size bigint UNSIGNED,
created_at datetime NOT NULL DEFAULT current_timestamp,
INDEX media_users_idx (user_id),
FOREIGN KEY (media_types_id) REFERENCES media_types (id),
FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.png', 78, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

-- ???????????????? ?????????????? ???3
-- ?????????????? ?????????????? ????????????

CREATE TABLE black_list (
   id serial,
   user_id bigint UNSIGNED NOT NULL,
   user_block_id bigint UNSIGNED NOT NULL,
   created_at datetime DEFAULT now() ON UPDATE current_timestamp,
   accepted bool DEFAULT FALSE,
   FOREIGN KEY (user_id) REFERENCES users (id),
   FOREIGN KEY (user_block_id) REFERENCES users (id)   
);
-- ?????????????? ?? ???????????? ???????????? ????????
INSERT INTO black_list VALUES (DEFAULT, 1, 2, DEFAULT, TRUE);

-- ?????????????? ????????????

CREATE TABLE likes (
   id serial,
   to_id_user bigint UNSIGNED NOT NULL,
   from_id_user bigint UNSIGNED NOT NULL,
   id_element_like bigint UNSIGNED NOT NULL, -- ???????????????????????????? ?????????????? ?????? ??????????
   accepted bool DEFAULT FALSE, 
   amount_like bigint UNSIGNED NOT NULL, -- ???????????????????? ????????????
   FOREIGN KEY (to_id_user) REFERENCES users (id),
   FOREIGN KEY (from_id_user) REFERENCES users (id)
);
CREATE TABLE repost (
    id serial,
    id_source_repost bigint UNSIGNED NOT NULL,
    id_receiver_repost bigint UNSIGNED NOT NULL,
    created_at datetime DEFAULT now(),
    FOREIGN KEY (id_source_repost) REFERENCES users (id),
    FOREIGN KEY (id_source_repost) REFERENCES communities (id),
    FOREIGN KEY (id_receiver_repost) REFERENCES users (id),
    FOREIGN KEY (id_receiver_repost) REFERENCES communities (id)    
);


-- ???????????????? ?????????????? ???4

INSERT users (id, firstname, lastname, phone, email, password_hash, cteated_at, update_at)
        VALUES (DEFAULT, 'Irina', 'Sovina', 12365478965, 'irina@mail.ru', 'jjj54444', DEFAULT, DEFAULT),
               (DEFAULT, 'Marina', 'mitina', 12355578965, 'marrina@mail.ru', 'jjj547744', DEFAULT, DEFAULT),
               (DEFAULT, 'Igor', 'Mosin', 12000478965, 'igor@mail.ru', 'jjffffff44', DEFAULT, DEFAULT),
               (DEFAULT, 'Alla', 'Alina', 77765478965, 'Alla@mail.ru', 'jj99999444', DEFAULT, DEFAULT),
               (DEFAULT, 'Anna', 'Suprun', 12365478977, 'Anna@mail.ru', 'jjj54444', DEFAULT, DEFAULT),
               (DEFAULT, 'Egor', 'Pashin', 12225478965, 'Pashin@mail.ru', 'jjssss444', DEFAULT, DEFAULT),
               (DEFAULT, 'Konstantin', 'Rivz', 77765478965, 'Rivz@mail.ru', 'rdfggb54444', DEFAULT, DEFAULT),
               (DEFAULT, 'Alla', 'Mot', 12377778965, 'Mot@mail.ru', 'sdwe454444', DEFAULT, DEFAULT),
               (DEFAULT, 'Igor', 'Mitin', 12987478965, 'Mitin@mail.ru', 'qqqq222444', DEFAULT, DEFAULT),
               (DEFAULT, 'Sonya', 'Sovina', 12365999965, 'Sonya@mail.ru', 'sssss333444', DEFAULT, DEFAULT),
               (DEFAULT, 'Irina', 'Suprun', 16985478965, 'suprun@mail.ru', '2658dhfgcjg44', DEFAULT, DEFAULT),
               (DEFAULT, 'Vlad', 'Popkin', 12361178965, 'Popkin@mail.ru', 'jeeddd443344', DEFAULT, DEFAULT),
               (DEFAULT, 'Sergey', 'Shpak', 12365478965, 'Shpak@mail.ru', 'sdsdsds54444', DEFAULT, DEFAULT),
               (DEFAULT, 'Lilya', 'Fonar', 12111178965, 'Fonar@mail.ru', 'ffffffsssss44', DEFAULT, DEFAULT),
               (DEFAULT, 'Irina', 'Sovina', 14445478965, 'irina99@mail.ru', 'uuuuuuuu444', DEFAULT, DEFAULT);
              
INSERT users (id, firstname, lastname, phone, email, password_hash, cteated_at, update_at)
        VALUES (DEFAULT, 'Inna', 'Sovina', 12775478965, 'inna@mail.ru', 'jjj51111114', DEFAULT, DEFAULT);
       
SELECT *FROM users;

INSERT users
SET firstname = 'Irena',
    lastname = 'Ponaroshku',
    phone = '79246587896',
    email = 'Irena@gmail.com';
   
SELECT * FROM users;

INSERT profiles VALUES (18, 'f', '1998-01-01', 18, 'Moscow', 'Russia'),
                       (19, 'f', '1978-11-01', 19, 'Tomsk', 'Russia'),
                       (20, 'm', '1991-01-12', 20, 'Moscow', 'Russia'),
                       (21, 'f', '1998-12-01', 21, 'Ufa', 'Russia'),
                       (22, 'f', '1987-05-01', 22, 'Muravlenko', 'Russia'),
                       (23, 'm', '1965-07-06', 23, 'Orsk', 'Russia'),
                       (24, 'm', '1998-10-01', 24, 'Moscow', 'Russia'),
                       (25, 'f', '2001-01-09', 25, 'Saratov', 'Russia'),
                       (26, 'm', '1990-11-11', 26, 'Omsk', 'Russia'),
                       (27, 'f', '2000-01-01', 27, 'Mink', 'Belarus'),
                       (28, 'f', '1993-03-01', 28, 'Moscow', 'Russia'),
                       (29, 'm', '1978-01-01', 29, 'Kursk', 'Russia'),
                       (30, 'm', '1994-05-27', 30, 'Vladivostok', 'Russia'),
                       (31, 'f', '1998-08-01', 31, 'Moscow', 'Russia'),
                       (32, 'f', '1989-01-01', 32, 'Kostroma', 'Russia'),
                       (33, 'f', '1979-09-23', 33, 'Moscow', 'Russia');
                      
INSERT profiles VALUES (34, 'f', '2010-01-01', 34, 'Moscow', 'Russia', DEFAULT);                      


INSERT INTO communities VALUES  (DEFAULT, 'Number10', 'I am number ten', 1),
                                (DEFAULT, 'Number2', 'I am number two', 1),
                                (DEFAULT, 'Number3', 'I am number three', 1),
                                (DEFAULT, 'Number4', 'I am number four', 1),
                                (DEFAULT, 'Number5', 'I am number five', 1),
                                (DEFAULT, 'Number6', 'I am number six', 1),
                                (DEFAULT, 'Number7', 'I am number seven', 1),
                                (DEFAULT, 'Number8', 'I am number eight', 1),
                                (DEFAULT, 'Number9', 'I am number nine', 1);
                               
INSERT INTO black_list VALUES (DEFAULT, 1, 2, DEFAULT, TRUE),
                              (DEFAULT, 18, 23, DEFAULT, TRUE),
                              (DEFAULT, 22, 29, DEFAULT, TRUE),
                              (DEFAULT, 19, 28, DEFAULT, TRUE),
                              (DEFAULT, 19, 2, DEFAULT, FALSE),
                              (DEFAULT, 25, 33, DEFAULT, TRUE),
                              (DEFAULT, 33, 25, DEFAULT, FALSE),
                              (DEFAULT, 31, 30, DEFAULT, TRUE),
                              (DEFAULT, 1, 27, DEFAULT, TRUE),
                              (DEFAULT, 27, 2, DEFAULT, FALSE);
                             
INSERT INTO communities_users VALUES (10, 19),
                                     (1, 25),
                                     (3, 31),
                                     (4, 27),
                                     (5, 18),
                                     (6, 22),
                                     (7, 24),
                                     (8, 33),
                                     (9, 30);
                                    
INSERT likes VALUES (DEFAULT, 19, 33, 11, TRUE, 1),
                    (DEFAULT, 18, 29, 2, TRUE, 1),
                    (DEFAULT, 25, 22, 3, TRUE, 1),
                    (DEFAULT, 1, 30, 4, TRUE, 1),
                    (DEFAULT, 30, 29, 5, TRUE, 1),
                    (DEFAULT, 27, 28, 6, TRUE, 1),
                    (DEFAULT, 33, 1, 7, FALSE, 1),
                    (DEFAULT, 1, 33, 8, TRUE, 1),
                    (DEFAULT, 19, 24, 9, TRUE, 1),
                    (DEFAULT, 24, 22, 10, TRUE, 1);


INSERT INTO media_types VALUES (DEFAULT, '??????????'),
                               (DEFAULT, '??????????'),
                               (DEFAULT, '????????????'),
                               (DEFAULT, '????????????'),
                               (DEFAULT, '????????'),
                               (DEFAULT, '??????????'),
                               (DEFAULT, '??????????????'),
                               (DEFAULT, '??????????');

INSERT INTO media VALUES (DEFAULT, 18, 9, 'book.djvu', 100, DEFAULT),
                         (DEFAULT, 19, 2, 'mus.mp3', 30, DEFAULT),
                         (DEFAULT, 20, 3, 'doc111.doc', 20, DEFAULT),
                         (DEFAULT, 21, 4, 'giv.giv', 10, DEFAULT),
                         (DEFAULT, 31, 5, 'video.MP4', 1000, DEFAULT),
                         (DEFAULT, 25, 6, 'stik.jpg', 5, DEFAULT),
                         (DEFAULT, 28, 7, 'emogi.jpg', 2, DEFAULT);

INSERT into messages VALUES (DEFAULT, 19, 2, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 19, 20, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 20, 28, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 28, 27, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 30, 33, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 33, 30, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 25, 26, 'Hi!', DEFAULT, DEFAULT, DEFAULT),
                             (DEFAULT, 26, 25, 'Hi!', DEFAULT, DEFAULT, DEFAULT);

INSERT repost VALUES (DEFAULT, 24, 20, DEFAULT); -- ????????????, ???? ?????????????????????? ????????????????????

SELECT * FROM users ORDER BY firstname; -- ???????????????????? ???? ???????????????? 

ALTER TABLE profiles ADD COLUMN at_active bool DEFAULT TRUE;

select * FROM profiles; 

UPDATE profiles SET at_active = 0 WHERE birthday < '2003-10-25';

INSERT into messages VALUES (DEFAULT, 19, 2, 'Hi!', '2033-10-10', DEFAULT, DEFAULT);

select * FROM messages;

DELETE FROM messages WHERE created_at < CURDATE();

                       

