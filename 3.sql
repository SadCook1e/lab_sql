DROP TABLE IF EXISTS books;
CREATE TABLE books
(
    Id SERIAL PRIMARY KEY,
	Num INTEGER NOT NULL, 
	N_ew BOOLEAN, 
    Title CHARACTER VARYING(70) NOT NULL,
    Price REAL,
    Publishing CHARACTER VARYING(30) NOT NULL,
    Pages INTEGER,
	Format CHARACTER VARYING(30) NOT NULL,
	D_ate DATE,
	Edition INTEGER,
	Topic CHARACTER VARYING(30) DEFAULT 'Використання ПК в цілому' ,
	Category CHARACTER VARYING(30) DEFAULT 'підручники'
);


INSERT INTO books (Num, N_ew, Title, Price, Publishing, Pages, Format, D_ate, Edition, Topic, Category) VALUES 
(5041, '0', 'Апаратні засоби мультимедія. відеосистема РСе', 0, 'BHV С.-Петербург', 300, '70х100 / 16', NULL, 5000, 'Використання ПК в цілому', 'підручники' ),
(5048, '1', 'Освой самостійно модернізацію і ремонт ПК за 24 години, 2-е вид.', NULL, 'Вільямс', 500, '70х100 / 16', '2000-07-07', 7000, 'Використання ПК в цілому', 'підручники'),
(5141,	'0',	'Структури даних і алгоритми.', 37.80, 'Вільямс', 384, '70х100 / 16', '2000-09-29', 5000, 'Використання ПК в цілому', 'підручники'),
(5127, 'Yes', 'Автоматизація інженерно графічних робіт', 11.58, 'Пітер', 256, '70х100 / 16', '2000-06-15', 5000, 'Використання ПК в цілому', 'підручники'),
(5110, 'No', 'Апаратні засоби мультимедія. відеосистема РСе', 15.51, 'BHV С.-Петербург', 400, '70х100 / 16',	'2000-07-24', NULL, 'Використання ПК в цілому',	'Апаратні засоби ПК'),
(5199, 'YES', 'Залізо IBM 2001.', 30.07, 'МікроАрт', 368, '70х100 / 16', '2000-02-12', 5000, 'Використання ПК в цілому',' Апаратні засоби ПК'),
(5199, 'YES', 'Залізо 2001.', 9.52, 'МікроАрт', 368, '70х100 / 16', '2000-02-12', 5000, 'Використання ПК в цілому',' Апаратні засоби ПК');

Select * From Books;

--1.Вивести книги у яких не введена ціна або ціна дорівнює 0
Select * From Books WHERE Price is NULL OR Price = 0;
--2.Вивести книги у яких введена ціна, але не введений тираж
Select * FROM Books Where Price is not NULL and Edition is Null;
--3.Вивести книги, про дату видання яких нічого не відомо.
Select * From Books Where D_ate is NULL;
--4.Вивести книги, з дня видання яких пройшло не більше року.

--5.Вивести список книг-новинок, відсортоване за зростанням ціни
Select * From Books Where N_ew = TRUE Order by Price;
--6.Вивести список книг з числом сторінок від 300 до 400, відсортоване в зворотному алфавітному порядку назв
Select * From Books Where Pages Between 300 and 400 order by Title desc;
--7.Вивести список книг з ціною від 20 до 40, відсортоване в спаданням дати
Select * From Books Where Price Between 20 and 40 order by D_ate desc;
--8.Вивести список книг, відсортованих в алфавітному порядку назв і ціною по спадаючій
Select * From Books Order by Title desc, Price desc;
--9.Вивести книги, у яких ціна однієї сторінки <10 копійок.
Select * From Books Where Price/Pages < 0.1;
--10.Вивести значення наступних колонок: число символів в назві, перші 20 символів назви великими літерами
Select char_length(Title), upper(left(Title, 20)) From Books;
--11.Вивести значення наступних колонок: перші 10 і останні 10 символів назви прописними буквами, розділені '...'
Select lower(left(Title, 10)), '. . .', lower(right(Title, 10)) From Books;
--12.Вивести значення наступних колонок: назва, дата, день, місяць, рік
Select Title, D_ate, Extract(Day from D_ate), Extract(Month from D_ate), Extract(Year from D_ate) FROM Books;
--13.Вивести значення наступних колонок: назва, дата, дата в форматі 'dd / mm / yyyy'
Select to_char(D_ate, 'DD/MM/YYYY') From Books;
--14.Вивести значення наступних колонок: код, ціна, ціна в грн., Ціна в євро, ціна в руб.
--Select Num, Price, CAST(CAST(Price as Numeric)AS MONEY) from Books;
--15.Вивести значення наступних колонок: код, ціна, ціна в грн. без копійок, ціна без копійок огругленная
--16.Додати інформацію про нову книгу (всі колонки)
INSERT INTO books (Num, N_ew, Title, Price, Publishing, Pages, Format, D_ate, Edition, Topic, Category) VALUES 
(5133, '0', 'New Title', 200, 'New Publishing', 2000, '200x100', '1900-09-29', 500, 'New Topic', 'New Category');
Select * From Books;
--17.Додати інформацію про нову книгу (колонки обов'язкові для введення)
INSERT INTO books (Num, Title, Publishing, Format) VALUES 
(5133,'Title', 'New Publishing','200x100');
--18.Видалити книги, видані до 2000 року
Delete From Books Where Extract(Year from D_ate) < 2000;
--19.Проставити поточну дату для тих книг, у яких дата видання відсутній
Update Books Set D_ate = CURRENT_DATE Where D_ate is Null;
--20.Встановити ознака новинка для книг виданих після 2005 року
Update Books Set N_ew = '1' Where Extract(Year from D_ate) > 2005;