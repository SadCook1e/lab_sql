DROP TABLE IF EXISTS books;
CREATE TABLE books
(
    Id SERIAL PRIMARY KEY,
	Num INTEGER NOT NULL, 
	N_ew BOOLEAN NOT NULL, 
    Title CHARACTER VARYING(70) NOT NULL,
    Price REAL NOT NULL,
    Publishing CHARACTER VARYING(30) NOT NULL,
    Pages INTEGER NOT NULL,
	Format CHARACTER VARYING(30) NOT NULL,
	D_ate DATE NOT NULL,
	Edition INTEGER NOT NULL,
	Topic CHARACTER VARYING(30) DEFAULT 'Використання ПК в цілому' ,
	Category CHARACTER VARYING(30) DEFAULT 'підручники'
);
CREATE UNIQUE INDEX Num_id ON books(Num);
DROP INDEX Num_id;

INSERT INTO books (Num, N_ew, Title, Price, Publishing, Pages, Format, D_ate, Edition, Topic, Category) VALUES 
(5041, '0', 'Апаратні засоби мультимедія. відеосистема РСе', 15.51, 'BHV С.-Петербург', 400, '70х100 / 16', '2000-06-01', 5000, 'Використання ПК в цілому', 'підручники' ),
(5048, '1', 'Освой самостійно модернізацію і ремонт ПК за 24 години, 2-е вид.', 18.90, 'Вільямс', 500, '70х100 / 16', '2000-07-07', 7000, 'Використання ПК в цілому', 'підручники'),
(5141,	'0',	'Структури даних і алгоритми.', 37.80, 'Вільямс', 384, '70х100 / 16', '2000-09-29', 5000, 'Використання ПК в цілому', 'підручники'),
(5127, 'Yes', 'Автоматизація інженерно графічних робіт', 11.58, 'Пітер', 256, '70х100 / 16', '2000-06-15', 5000, 'Використання ПК в цілому', 'підручники'),
(5110, 'No', 'Апаратні засоби мультимедія. відеосистема РСе', 15.51, 'BHV С.-Петербург', 400, '70х100 / 16',	'2000-07-24', 5000, 'Використання ПК в цілому',	'Апаратні засоби ПК'),
(5199, 'YES', 'Залізо IBM 2001.', 30.07, 'МікроАрт', 368, '70х100 / 16', '2000-02-12', 5000, 'Використання ПК в цілому',' Апаратні засоби ПК'),
(5199, 'YES', 'Залізо 2001.', 9.52, 'МікроАрт', 368, '70х100 / 16', '2000-02-12', 5000, 'Використання ПК в цілому',' Апаратні засоби ПК');


ALTER TABLE books ADD COLUMN Author CHARACTER VARYING(15);
ALTER TABLE books ALTER COLUMN Author TYPE CHARACTER VARYING(20);
ALTER TABLE books DROP COLUMN Author;


--Вивести значення наступних колонок: номер, код, новинка, назва, ціна, сторінки
SELECT Id, Num, N_ew, Title, Price, Pages FROM books;
--Вивести значення всіх колонок
SELECT * FROM books;
--3Вивести значення колонок в наступному порядку: код, назва, новинка, сторінки, ціна, номер
SELECT Num, Title, N_ew, Pages, Price, Id FROM books;
--Вивести значення всіх колонок 4 перших рядків
SELECT * FROM books LIMIT 4;
--Вивести значення всіх колонок 40% перших рядків
SELECT * FROM books TABLESAMPLE BERNOULLI(40);
--Вивести значення колонки код без повторення однакових кодів    
SELECT DISTINCT Num FROM books;
--Вивести всі книги новинки
SELECT * FROM books WHERE N_ew = '1';
--Вивести всі книги новинки з ціною від 10 до 20
SELECT * FROM books WHERE N_ew = '1' AND Price BETWEEN 10 AND 20;
--Вивести всі книги новинки з ціною менше 10 і більше 20
SELECT * FROM books WHERE N_ew = '1' AND (10 > Price OR Price > 20);
--Вивести всі книги з кількістю сторінок від 300 до 400 і з ціною більше 20 і менше 30
SELECT * FROM books WHERE Pages  BETWEEN 300 AND 400 AND Price BETWEEN 20 AND 35;
--1Вивести книги зі значеннями кодів 5199, 5141, 4985, 4241
SELECT * FROM books WHERE Num IN (5199, 5141);
--Вивести всі книги видані взимку 2000 року
SELECT * FROM books WHERE EXTRACT(MONTH FROM D_ate) IN (1,2,12) AND EXTRACT( YEAR FROM D_ate) = 2000;
--Вивести книги видані в 1999, 2001, 2003, 2005 р
SELECT * FROM books WHERE EXTRACT( YEAR FROM D_ate) IN (1999, 2001, 2003, 2005);
--Вивести книги назви яких починаються на літери А-К
SELECT * FROM books WHERE Title BETWEEN 'А' AND 'К';
--Вивести книги назви яких починаються на літери 'Ап', видані в 2000 році з ціною до 20
SELECT * FROM books WHERE Title LIKE 'Ап%' AND EXTRACT( YEAR FROM D_ate) = 2000 AND Price < 20;
--Вивести книги назви яких починаються на літери 'Ап', закінчуються на 'е', видані в першій половині 2000 року
SELECT * FROM books WHERE Title LIKE 'Ап%' AND Title LIKE '%е' AND EXTRACT(MONTH FROM D_ate) < 7 AND EXTRACT( YEAR FROM D_ate) = 2000;
--Вивести книги, в назвах яких є слово Залізо, але немає слова IBM
SELECT * FROM Books WHERE Title LIKE '%Залізо%' AND Title NOT LIKE '%IBM%';
--Вивести книги, в назвах яких присутній як мінімум одна цифра.
SELECT * FROM Books WHERE Title SIMILAR TO '%[0-9]%';