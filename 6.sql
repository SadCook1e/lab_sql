DROP TABLE IF EXISTS books;
CREATE TABLE books
(
    Id SERIAL PRIMARY KEY,
	Num INTEGER NOT NULL, 
	N_ew BOOLEAN NOT NULL, 
    Title CHARACTER VARYING(70) NOT NULL,
    Price REAL NOT NULL,
    Pages INTEGER NOT NULL,
	Format CHARACTER VARYING(30) NOT NULL,
	D_ate DATE NOT NULL,
	Edition INTEGER NOT NULL,
	Publishing_id INTEGER NOT NULL,
	Topic_id INTEGER NOT NULL,
	Category_id INTEGER  NOT NULL
);

DROP TABLE IF EXISTS Topic;
CREATE TABLE Topic (
  id SERIAL PRIMARY KEY,
  t_opic CHARACTER VARYING(70) NOT NULL
);
DROP TABLE IF EXISTS Category;
		
CREATE TABLE Category (
  id SERIAL PRIMARY KEY,
  c_ategory CHARACTER VARYING(70) NOT NULL
);


DROP TABLE IF EXISTS Publiching;	
CREATE TABLE Publiching (
  id SERIAL PRIMARY KEY,
  p_ubliching CHARACTER VARYING(70) NOT NULL
);

ALTER TABLE Books ADD FOREIGN KEY (Publishing_id) REFERENCES Publiching (id);
ALTER TABLE Books ADD FOREIGN KEY (Topic_id) REFERENCES Topic (id);
ALTER TABLE Books ADD FOREIGN KEY (Category_id) REFERENCES Category (id);

INSERT INTO Publiching(p_ubliching) VALUES
('pb'),
('pb2');
INSERT INTO Topic(t_opic) VALUES
('t'),
('t2');
INSERT INTO Category(c_ategory) VALUES
('ct'), 
('ct2');
INSERT INTO Books (Num, N_ew, Title, Price, Pages, Format, D_ate, Edition, Publishing_id, Topic_id, Category_id) VALUES 
(5896, '0', 'Title', 100, 200, 'fromat', '2000-07-03', 300, 1, 1, 1),
(5888, '0', 'Title2', 100, 200, 'fromat2', '2020-07-03', 300, 2, 2, 2);

Select * From Books;
--1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з`єднання, застосовуючи where.
Select Title,Price, Publiching.p_ubliching From books, Publiching where books.Publishing_id = Publiching.id; 
--2.Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з`єднання, застосовуючи inner join.
Select Title,Category.c_ategory From books Inner Join Category on books.category_id = category.id;
--3.Вивести значення наступних колонок: назва книги, ціна, назва видавництво, формат.
Select Title,Price,Publiching.p_ubliching,Format From books , Publiching where books.Publishing_id = Publiching.id; 
--4.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництво. Фільтр за темами і категоріями.
Select Topic.t_opic,Category.c_ategory,Title,Publiching.p_ubliching From books,Topic,Category,Publiching WHERE books.Topic_id = Topic.id and
books.Category_id = Category.id and books.Publishing_id = Publiching.id ORDER BY Topic.t_opic,Category.c_ategory;
--5.Вивести книги видавництва 'pb2', видані після 2000 р
Select * From books , Publiching where books.Publishing_id = Publiching.id and 
Publiching.p_ubliching like '%pb2%%' and Extract(Year from D_ate)>2000;
--6.Вивести загальну кількість сторінок по кожній назві категорії. Фільтр за спаданням кількості сторінок.
Select sum(Price),Category.c_ategory From books,Category WHERE books.Category_id = Category.id Group by Category.c_ategory;
--7.Вивести середню вартість книг по темі 't2' і категорії 'ct2'.
Select avg(Price) From books,Topic,Category WHERE books.Topic_id = topic.id and
books.category_id = category.id and topic.t_opic like '%%t2%%' and category.c_ategory like '%%ct2%%';
--8.Вивести всі дані універсального відношення. Використовувати внутрішнє з`єднання, застосовуючи where.
Select topic.t_opic,category.c_ategory,publiching.p_ubliching From books,topic,category,publiching WHERE books.topic_id = topic.id and
books.category_id = category.id and books.publishing_id = publiching.id;
--9.Вивести всі дані універсального відношення. Використовувати внутрішнє з`єднання, застосовуючи inner join.
Select topic.t_opic,category.c_ategory,publiching.p_ubliching From books Inner Join topic on books.topic_id = topic.id
Inner Join category on books.category_id = category.id Inner Join publiching on books.publishing_id = publiching.id;
--10.Вивести всі дані універсального відношення. Використовувати зовнішнє з`єднання, застосовуючи left join / rigth join.
Select topic.t_opic,category.c_ategory,publiching.p_ubliching From books LEFT OUTER JOIN topic on books.topic_id = topic.id
LEFT OUTER Join category on books.category_id = category.id LEFT OUTER Join publiching on books.publishing_id = publiching.id;
--11.Вивести пари книг, що мають однакову кількість сторінок. Використовувати самооб`єднання і аліаси (self join).
Select a.Title as Book_name_1 , a.Pages as Amount_of_pages_1, b.Title as Book_name_2,
b.Pages as Amount_of_pages_2 FROM books a ,books b  WHERE   a.Pages=b.Pages and a.id <> b.id;
--12.Вивести тріади книг, що мають однакову ціну. Використовувати самооб`єднання і аліаси (self join).
Select a.Title as Book_name_1 , a.Price as price_1, b.Title as Book_name_2,
b.Price as price_2,c.Title as Book_name_3, c.Price as price_3 FROM books a ,books b,books c  WHERE   a.Price=b.Price and b.Price =c.Price 
and a.Price=c.Price and a.id <> b.id and a.id <>c.id and b.id<>c.id;
--13.Вивести всі книги категорії 'ct2'. використовувати підзапити (Subquery) .
SELECT  * FROM books  WHERE category_id in (SELECT id FROM category WHERE c_ategory like '%%ct2%%');
--14.Вивести книги видавництва 'pb2', видані після 2000 р Використовувати підзапити (Subquery) .
SELECT  * FROM books  WHERE publishing_id in (SELECT id FROM publiching WHERE p_ubliching like '%pb2%%' and Extract(Year from D_ate)>2000);
--15.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов`язані підзапити (correlated subquery).
SELECT distinct(publiching.p_ubliching) FROM publiching  Inner Join books  on  publiching.id = books.publishing_id WHERE books.publishing_id in (SELECT publishing_id FROM books WHERE Pages >20);
--16.Вивести список категорій за якими більше 3-х книг. Використовувати пов`язані підзапити (correlated subquery).
SELECT c.c_ategory as Категорія,count(*) as Кількість_книг FROM category c Inner Join books b on c.id=b.category_id 
  WHERE (select count(*) FROM  books b WHERE b.category_id=c.id ) >= 3 GROUP BY c_ategory;
--17.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.
SELECT * FROM books WHERE  EXISTS(SELECT 1 FROM publiching WHERE p_ubliching like '%BHV%%' );
--18.Вивести список книг видавництва 'pb2', якщо в списку немає жодної книги цього видавництва. використовувати not  exists.
SELECT * FROM books WHERE  NOT EXISTS (SELECT 1 FROM publiching WHERE books.publishing_id=publiching.id and p_ubliching like '%pb2%%' );
--19.Вивести відсортоване загальний список назв тем і категорій. Використовувати union.
select 'book' as type,Title  from books union select 'topic' as type, t_opic from topic union select 'category' as type, 
c_ategory from category order by Title;
--20.Вивести відсортоване в зворотному порядку загальний список  перших слів назв книг (що не повторюються) і категорій. Використовувати union.
SELECT DISTINCT  'book' AS TYPE,substring(Title from 0 for position(' ' in Title))  FROM books UNION SELECT 'category' AS TYPE, 
c_ategory FROM category;
