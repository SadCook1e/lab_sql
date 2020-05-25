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
(5199, Null, 'Залізо IBM 2001.', 3000.80, 'МікроАрт', 368, '70х100 / 16', '2000-02-12', 5000, 'Використання ПК в цілому',' Апаратні засоби ПК'),
(5199, 'YES', 'Залізо 2001.', 9.52, 'МікроАрт', 368, '70х100 / 16', '2020-02-12', 5000, 'Використання ПК в цілому',' Апаратні засоби ПК');

Select * From Books;
--1.Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну
Select count(*), sum(Price), avg(Price), min(Price), max(Price) from Books;
--2.Вивести загальна кількість всіх книг без урахування книг з непроставленою ціною
Select count(*) from Books where Price is not Null; 
--3.Вивести статистику (див. 1) для книг новинка / не новинка
Select N_ew, count(*), sum(Price), avg(Price), min(Price), max(Price) from Books Where N_ew is not null group by N_ew ;
--4.Вивести статистику (див. 1) для книг за кожним роком видання
Select Extract(Year from D_ate), count(*), sum(Price), avg(Price), min(Price), max(Price) from Books group by Extract(Year from D_ate);
--5.Змінити п.4, виключивши з статистики книги з ціною від 10 до 20
Select Extract(Year from D_ate), count(*), sum(Price), avg(Price), min(Price), max(Price) from Books Where Price not between 10 and 20 group by Extract(Year from D_ate);
--6.Змінити п.4. Відсортувати статистику за спаданням кількості.
Select Extract(Year from D_ate), count(*), sum(Price), avg(Price), min(Price), max(Price) from Books group by Extract(Year from D_ate) order by count(*) desc;
--7.Вивести загальну кількість кодів книг і  кодів книг, що не повторюються
Select count(Num), count(DISTINCT Num) from Books;
--8.Вивести статистику: загальна кількість і вартість книг по першій букві її назви
Select left(Title, 1), count(*), sum(Price) from Books group by left(Title, 1);
--9.Змінити п. 8, виключивши з статистики назви починаються з англ. букви і з цифри.
Select left(Title, 1), count(*), sum(Price) from Books where Title LIKE '[А-Я]%' group by left(Title, 1);
--10.Змінити п. 9 так щоб до складу статистики потрапили дані з роками великими 2000.
Select left(Title, 1), count(*), sum(Price) from Books where Title LIKE '[А-Я]%' and Extract(Year from D_ate) > 2000 group by left(Title, 1) order by left(Title, 1) desc;
--11.Змінити п. 10. Відсортувати статистику за спаданням перших букв назви.
Select left(Title, 1), count(*), sum(Price) from Books where Title LIKE '[А-Я]%' and Extract(Year from D_ate) > 2000 group by left(Title, 1) order by left(Title, 1) desc;
--12.Вивести статистику (див. 1) по кожному місяцю кожного року.
Select Extract(Year from D_ate), Extract(Month from D_ate), count(*), sum(Price), avg(Price), min(Price), max(Price) from Books group by Extract(Year from D_ate), Extract(Month from D_ate);
--13.Змінити п. 12 так щоб до складу статистики не були дані з незаповненими датами.
Select Extract(Year from D_ate), Extract(Month from D_ate), count(*), sum(Price), avg(Price), min(Price), max(Price) from Books where D_ate is not null group by Extract(Year from D_ate), Extract(Month from D_ate);
--14.Змінити п. 12. Фільтр за спаданням року і зростанням місяця.
Select Extract(Year from D_ate), Extract(Month from D_ate), count(*), sum(Price), avg(Price), min(Price), max(Price) from Books group by Extract(Year from D_ate), Extract(Month from D_ate) order by Extract(Year from D_ate) asc, Extract(Month from D_ate) desc;
--15.Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро / руб. Колонкам запиту дати назви за змістом.
--16.Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / руб.) Ціна.
--17.Вивести статистику (див. 1) по видавництвах.
Select Edition, count(*), sum(Price), avg(Price), min(Price), max(Price) from Books group by Edition;
--18.Вивести статистику (див. 1) за темами і видавництвам. Фільтр по видавництвам.
--Select Edition, Topic, count(*), sum(Price), avg(Price), min(Price), max(Price) from Books group by Edition;
--19.Вивести статистику (див. 1) за категоріями, тем і видавництвам. Фільтр по видавництвам, тем, категорій.
--20.Вивести список видавництв, у яких огруглено до цілого ціна однієї сторінки більше 10 копійок.
Select Publishing from Books where round(Price)/Pages > 0.1;