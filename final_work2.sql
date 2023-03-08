/* Курсовой проект по MySQL: База данных Факультета Физики
 
 Представленная далее база данных относится к высшему учебному заведению для корректной и быстрой работы факультета Физики. 
 Решаемы задачи:
 1. Учёт студетнов и компактное хранение информации о них
 2. Анализ успеваемости студетнов
 3. Учёт сотрудников факультета
 4. Персональный подход при анализе успеваемости и общей активности студентов

   */



DROP DATABASE IF EXISTS department_physics;

CREATE DATABASE department_physics;

USE department_physics;

-- информация о кафедрах

create table chair_info(
    id_chair INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key,
    name_chair varchar(255) not null,
    amount_members int unsigned not null, -- количество сотрудников кафедры 
    name_curriculum varchar(255) not null, -- название учебной программы
    head_chair varchar(255) not null -- заведующий кафедрой
);



-- общая информация о студентах

CREATE TABLE students(
    id serial,
    firstname varchar(255) NOT NULL,
    lastname varchar(255) NOT NULL,
    chair varchar (255) NOT NULL,
    phone char (20),
    created_at datetime DEFAULT current_timestamp,
    updated_at datetime DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
    index(lastname)
    );
-- 

-- Подробная информация о студентах 

CREATE TABLE profile_students(
    stud_id serial,
    gender ENUM('f', 'm', 'x') NOT NULL,
	birthday DATE NOT NULL,
	photo_id BIGINT UNSIGNED NOT NULL,
	city VARCHAR(130),
  	country VARCHAR(130),
  	adress varchar(130),
  	email varchar(255),
  	FOREIGN KEY (stud_id) REFERENCES students (id)
);

-- учебная информация



create table learning_info( 
    stud_id serial,
    course int unsigned not null,
    chair varchar (255) NOT NULL, -- название кафедры, потом удалила, т.к. дублирующаяся информация
    arrears bool default '0', -- задолжность
    form_education ENUM('бюджетное', 'коммерческое', 'целевое') NOT NULL,
    type_ed Enum ('очное', 'заочное', 'вечернее') not null,
    foreign key (stud_id) references students (id)
);

-- таблица с названиями спортивных секций

create table name_sport(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_sport varchar(255)
);


-- информаиця о спортивных секциях

create table sport_section(
    stud_id serial,
    name_sport_id int unsigned not null,
    foreign key (stud_id) references students (id),
    foreign key (name_sport_id) references name_sport (id)
);


 
-- информация о преподавателях спортивных секций

create table teacher_sport(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname varchar(255) NOT NULL,
    lastname varchar(255) NOT NULL,
    work_experience int unsigned not null, -- стаж работы
    name_sport_teach_id int unsigned not null,
    foreign key (name_sport_teach_id) references name_sport (id)
);


-- информация о профессорско-преподавательском составе

create table staff_info(
    id_staff INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key,
    firstname varchar(255) NOT NULL,
    lastname varchar(255) NOT NULL,
    post varchar(255) NOT NULL, -- должность
    subject varchar(255) not null, -- преподаваемая дисциплина
    admin_job varchar(255),  -- административная работа
    work_experience int unsigned not null,
    chair INT UNSIGNED NOT null,
    constraint fk_chair_name foreign key (chair) references chair_info (id_chair) ON UPDATE CASCADE ON DELETE cascade);


   
   --  подробная информация о сотрудниках 

CREATE TABLE profile_staff(
    staff_id INT UNSIGNED NOT NULL,
    gender ENUM('f', 'm', 'x') NOT NULL,
	birthday DATE NOT NULL,
	photo_id BIGINT UNSIGNED NOT NULL,
	city VARCHAR(130),
  	country VARCHAR(130),
  	adress varchar(130),
  	email varchar(255),
  	constraint fk_staff_name FOREIGN KEY (staff_id) REFERENCES staff_info (id_staff) ON UPDATE CASCADE ON DELETE cascade
);

-- информация о преподаваемых дисциплинах



create table subject_info(
    id_sb INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key,
    name varchar(255),
    count_hours int not null, -- количество часов
    chair INT UNSIGNED NOT null,
    name_curriculum varchar(255) not null, -- название учебной программы
    constraint fk_chair FOREIGN KEY (chair) REFERENCES chair_info (id_chair) ON UPDATE CASCADE ON DELETE cascade
);

-- таблица успеваемости студентов

create table academic_performance_1course(
    id_stud serial,
    id_course INT UNSIGNED NOT null,
    mechanics enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    history enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    mathematics enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    computer_sience enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    sociology enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    constraint fk_student foreign key (id_stud) references students (id) ON UPDATE CASCADE ON DELETE CASCADE
);

create table academic_performance_2course(
    id_stud serial,
    optics enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    hydraulics enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    programming enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    English enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    economy enum('3', '4', '5', 'зачёт', '2', 'незачёт'),
    constraint fk_student2 foreign key (id_course) references students (id) ON UPDATE CASCADE ON DELETE cascade
);



-- добавим в таблицу students внешний ключ по названию кафедры
alter table students modify column chair INT UNSIGNED NOT null;
alter table students add constraint fk_chair_name_stud foreign key (chair) references chair_info (id_chair) ON UPDATE CASCADE ON DELETE cascade;

-- добавим в таблицу learning_info внешний ключ по названию кафедры
alter table learning_info modify column chair INT UNSIGNED NOT null;
alter table learning_info add constraint fk_chair_name_learn foreign key (chair) references chair_info (id_chair) ON UPDATE CASCADE ON DELETE CASCADE;

-- в результате анализа выяснилось, что название кафедры - это дублирующая информация, удалим её

alter table learning_info DROP FOREIGN KEY fk_chair_name_learn;
ALTER TABLE learning_info DROP COLUMN chair;

alter table students modify column phone char(20);
alter table staff_info modify column subject varchar(255);


-- заполним данные по кафедрам

insert into chair_info(name_chair, amount_members, name_curriculum, head_chair)
values ('прикладная физика', 5, 'физика нефтегазового пласта', 'Ковалёва'),
       ('геофизика', 7, 'геофизика и геология', 'Валиулин'),
       ('радиофизика', 4, 'радиофизика', 'Бахтизин');


-- наполнение таблиц данными

INSERT INTO students VALUES(1,'Maggie','Payne', 1,'6-111-611-0304', default, DEFAULT);
INSERT INTO students VALUES(2,'Alba','Allington', 2,'4-561-186-4813', default, DEFAULT);
INSERT INTO students VALUES(3,'Liam','Yarwood', 3,'2-164-583-5718', default, DEFAULT);
INSERT INTO students VALUES(4,'Tara','Atkinson',1,'2-846-024-7250', default, DEFAULT);
INSERT INTO students VALUES(5,'Maxwell','Murray',1,'0-222-631-5471', default, DEFAULT);
INSERT INTO students VALUES(6,'Helen','Noach',2,'2-377-736-0676', default, DEFAULT);
INSERT INTO students VALUES(7,'Julianna','Tanner',3,'2-153-163-0761', default, DEFAULT);
INSERT INTO students VALUES(8,'Kieth','Morris',1,'2-570-267-2183', default, DEFAULT);
INSERT INTO students VALUES(9,'Peter','Knight',2,'8-668-483-4748', default, DEFAULT);
INSERT INTO students VALUES(10,'Kieth','Owens',1,'0-617-415-3474', default, DEFAULT);




-- заполним личную информацию по студентам
      
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (1, 'f', '2001-03-09', 1, 'Sukapura', 'Indonesia', '1 Armistice Parkway', 'jdumbar0@comsenz.com');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (2, 'f', '2000-08-13', 2, 'Abades', 'Portugal', '2 Oxford Terrace', 'wthornham1@purevolume.com');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (3, 'm', '2009-04-19', 3, 'Hitachi-Naka', 'Japan', '7 Loeprich Junction', 'epanchen2@newyorker.com');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (4, 'f', '2001-10-06', 4, null, 'France', '74969 Novick Point', 'gbrittin3@wired.com');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (5, 'f', '2005-08-10', 5, 'Saratamata', 'Vanuatu', '50044 Logan Drive', 'sgarling4@webs.com');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (6, 'm', '2008-07-08', 6, 'Pak Phanang', 'Thailand', '1734 Pawling Avenue', 'htomasello5@who.int');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (7, 'm', '2008-05-31', 7, 'Kavarna', 'Bulgaria', '66388 Kedzie Terrace', 'jmaccartair6@pagesperso-orange.fr');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (8, 'm', '2003-06-17', 8, 'Mantes-la-Jolie', 'France', '44519 Loeprich Street', 'lpriddle7@npr.org');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (9, 'f', '2003-04-12', 9, 'Lublin', 'Poland', '00 Nova Lane', 'ddavern8@toplist.cz');
insert into profile_students (stud_id, gender, birthday, photo_id, city, country, adress, email) values (10, 'm', '2003-06-08', 10, 'Victoriaville', 'Canada', '11 Farwell Parkway', 'lsheards9@chicagotribune.com');


-- заполним таблицу с учебной информацией

insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (1, 2, true, 'коммерческое', 'очное');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (2, 2, false, 'целевое', 'вечернее');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (3, 1, false, 'коммерческое', 'заочное');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (4, 1, false, 'коммерческое', 'вечернее');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (5, 2, true, 'бюджетное', 'очное');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (6, 1, false, 'коммерческое', 'вечернее');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (7, 1, false, 'коммерческое', 'заочное');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (8, 2, true, 'целевое', 'очное');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (9, 1, true, 'коммерческое', 'вечернее');
insert into learning_info (stud_id, course, arrears, form_education, type_ed) values (10, 2, true, 'коммерческое', 'вечернее');


-- заполним таблицу по разновидностям спортивных секций

INSERT INTO name_sport(id, name_sport) VALUES (1, 'футбол'),
                                              (2, 'хоккей'),
                                              (3, 'баскетбол'),
                                              (4, 'теннис'),
                                              (5, 'лёгкая атлетика'),
                                              (6, 'борьба'),
                                              (7, 'гимнастика'),
                                              (8, 'плавание'),
                                              (9, 'бег'),
                                              (10,'йога');
                                             
 -- добавим данные по преподавателям спортивных секций
 
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (1, 'Weider', 'Burbudge', 1, 4);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (2, 'Janeczka', 'Paike', 1, 3);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (3, 'Papagena', 'Josefson', 20, 4);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (4, 'Butch', 'Brookhouse', 23, 7);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (5, 'Hamel', 'Signe', 10, 3);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (6, 'Nadean', 'Dibner', 22, 10);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (7, 'Israel', 'Stading', 21, 10);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (8, 'Susette', 'Syers', 13, 9);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (9, 'Dari', 'Gietz', 19, 2);
insert into teacher_sport (id, firstname, lastname, work_experience, name_sport_teach_id) values (10, 'Arlette', 'Prayer', 14, 4);

-- добавим данные по спортивным секциям

INSERT INTO sport_section (stud_id, name_sport_id) VALUES (1, 1),
                                                          (2, 10),
                                                          (3, 1),
                                                          (4, 2),
                                                          (5, 2),
                                                          (6, 3),
                                                          (7, 4),
                                                          (8, 1),
                                                          (9, 1),
                                                          (10, 1);

-- добавим информацию по сотрудникам

insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (1, 'Huntley', 'Cinderey', 'доцент', '''', 'заведующий кафедрой', 42, 3);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (2, 'Hazel', 'Rheaume', 'профессор', 'history', 'декан', 25, 1);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (3, 'Chickie', 'Pile', 'ассистент', 'mathematics', 'заведующий кафедрой', 43, 2);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (4, 'Bettina', 'Hundell', 'доцент', 'computer_sience', 'заместитель декана', 44, 2);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (5, 'Tomasine', 'Dudderidge', 'доцент', 'sociology', 'куратор', 16, 1);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (6, 'Nanci', 'Kinig', 'ассистент', 'optics', 'заведующий кафедрой', 31, 3);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (7, 'Emmerich', 'Brodest', 'ассистент', 'hydraulics', 'куратор', 40, 2);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (8, 'Basilio', 'Kahn', 'профессор', 'programming', 'куратор', 15, 1);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (9, 'Hazel', 'Rheaume', 'профессор', 'English', 'куратор', 25, 1);
insert into staff_info (id_staff, firstname, lastname, post, subject, admin_job, work_experience, chair) values (10, 'Tomasine', 'Dudderidge', 'доцент', 'economy', 'куратор', 16, 1);
-- добавим подробную информацию о сотрудниках

insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (1, 'F', '1983-09-17', 1, 'Dapdap', 'Philippines', '03793 Bonner Parkway', 'sbyllam0@mayoclinic.com');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (2, 'F', '2067-06-20', 2, 'Yawata', 'Japan', '53275 Mayer Junction', 'dkirvin1@yale.edu');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (3, 'M', '1993-12-30', 3, 'Asprángeloi', 'Greece', '8 Arapahoe Road', 'cmiranda2@msu.edu');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (4, 'M', '2006-07-11', 4, 'Jämsänkoski', null, '11 Tennyson Road', 'fdelacote3@symantec.com');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (5, 'F', '1980-09-01', 5, 'Qianying', 'China', '424 Kingsford Center', 'hklouz4@seesaa.net');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (6, 'F', '2061-12-28', 6, 'Löddeköpinge', 'Sweden', '572 Rigney Road', 'phulse5@usnews.com');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (7, 'M', '2061-10-22', 7, 'Tsaratanana', 'Madagascar', '02 Laurel Parkway', 'jhanshaw6@photobucket.com');
insert into profile_staff (staff_id, gender, birthday, photo_id, city, country, adress, email) values (8, 'M', '2087-08-10', 8, 'Kobarid', null, '948 Eastwood Road', 'cwightman7@simplemachines.org');


-- добавим данный в таблицу с преподаваемыми дисциплинами

INSERT INTO subject_info (id_sb, name, count_hours, chair, name_curriculum) VALUES (1, 'mechanics', 42, 1, 'физика нефтегазового пласта'),
                                                                                   (2, 'history', 56, 2, 'геофизика'),
                                                                                   (3, 'mathematics', 72, 3, 'радиофизика'),
                                                                                   (4, 'computer_sience', 32, 2, 'геофизика'),
                                                                                   (5, 'sociology enum', 24, 1, 'физика нефтегазового пласта'),
                                                                                   (6, 'optics', 42, 2, 'геофизика'),
                                                                                   (7, 'hydraulics', 54, 3, 'радиофизика'),
                                                                                   (8, 'programming', 36, 2, 'геофизика'),
                                                                                   (9, 'English', 42, 1, 'физика нефтегазового пласта'),
                                                                                   (10, 'economy', 24, 1, 'физика нефтегазового пласта');
                                                                                   
                                                                                  
-- заполним таблицы табелей успеваемости

-- сначала вставим id студентов, относящихся к первому курсу

INSERT INTO academic_performance_1course(id_stud) 
SELECT stud_id FROM  learning_info  WHERE course = 1;

-- вручную проставила оценки

-- повторим тоже самое для второго курса

INSERT INTO academic_performance_2course(id_stud) 
SELECT stud_id FROM  learning_info  WHERE course = 2;

-- все таблицы заполнены, можно приступать к запросам

-- выведем студентов, у которых есть 2(незачёт) хотя бы по одному предмету 

SELECT concat(firstname, ' ', lastname) AS name FROM students
WHERE id = (SELECT id_stud FROM academic_performance_1course 
            WHERE (mechanics = '2' and history = 'незачёт' and mathematics = '2' and computer_sience = '2' and sociology = 'незачёт'));
           
-- Выведем средний балл по mathematics

SELECT avg(mathematics) FROM academic_performance_1course;

-- по какому предмету средний балл больше всего

SELECT avg(mathematics) AS avg_subj, (SELECT name FROM subject_info WHERE id_sb = 3) AS subject FROM academic_performance_1course
UNION 
SELECT avg(mechanics) AS avg_subj, (SELECT name FROM subject_info WHERE id_sb = 1) AS subject FROM academic_performance_1course
UNION 
SELECT avg(computer_sience) AS avg_subj, (SELECT name FROM subject_info WHERE id_sb = 4) AS subject FROM academic_performance_1course
ORDER BY avg_subj DESC LIMIT 1;

-- подсчитаем количество человек в каждой спортивной секции

SELECT count(*) AS cnt, (SELECT name_sport FROM name_sport WHERE id = name_sport_id) AS name_sport 
FROM sport_section GROUP BY name_sport;


-- выведем фамилию и имя студентов с табелем оценок

SELECT concat(st.firstname,' ', st.lastname) AS name, st.chair, c1.mechanics, c1.history, c1.mathematics, c1.computer_sience, c1.sociology 
FROM students st 
JOIN academic_performance_1course c1 ON st.id = c1.id_stud;

-- выведем все имена студентов, кто ходит в секцию футбола

SELECT concat(s.firstname,' ', s.lastname), s.chair, ns.name_sport FROM students s 
JOIN sport_section ss ON s.id = ss.stud_id 
JOIN name_sport ns ON ss.name_sport_id = ns.id
WHERE ns.name_sport = 'футбол';

-- выведем всех футболистов без долгов(у кого нет двоек и незачётов)

SELECT s.id, concat(s.firstname,' ', s.lastname) AS name, s.chair, ns.name_sport FROM students s 
JOIN sport_section ss ON s.id = ss.stud_id 
JOIN name_sport ns ON ss.name_sport_id = ns.id
JOIN academic_performance_1course c1 ON s.id = c1.id_stud
WHERE ns.name_sport = 'футбол' AND 
(mechanics != '2' and history != 'незачёт' and mathematics != '2' and computer_sience != '2' and sociology != 'незачёт') 
UNION 
SELECT s.id, concat(s.firstname,' ', s.lastname) AS name, s.chair, ns.name_sport FROM students s 
JOIN sport_section ss ON s.id = ss.stud_id 
JOIN name_sport ns ON ss.name_sport_id = ns.id
JOIN academic_performance_2course c2 ON s.id = c2.id_stud
WHERE ns.name_sport = 'футбол' AND 
(optics != '2' and programming != 'незачёт' and hydraulics != '2' and English != '2' and economy != 'незачёт');


-- средний балл каждого студента

SELECT c1.mechanics  FROM academic_performance_1course c1 WHERE id_stud = 3
UNION ALL 
SELECT c1.mathematics  FROM academic_performance_1course c1 WHERE id_stud = 3
UNION all
SELECT c1.computer_sience  FROM academic_performance_1course c1 WHERE id_stud = 3;




