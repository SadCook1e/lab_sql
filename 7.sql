--1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
drop function if exists foo1;
create function foo1()
	returns table (Title text,Price real, publishing text,format text )
as
$$
Select cast(Title as text),cast(Price as real),cast(Publishing.Publishing as text),cast(format as text) 
From books , Publishing
where books.publishing_id = publishing.id
$$
language sql;

select *
from foo1();

--2.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
drop function if exists foo2;
create function foo2()
	returns table (topic text,category text,publiching text,format text )
as
$$
Select cast(topic.topic as text),cast(category.category as text),cast(Title as text),cast(publishing.publishing as text) 
From books,topic,category,publishing 
WHERE books.topic_id = topic.id 
and
books.category_id = category.id 
and books.publishing_id = publishing.id 
ORDER BY topic.topic,category.category
$$
language sql;

Select * from foo2();

--3.Вивести книги видавництва 'BHV', видані після 2000 р
drop function if exists foo3;
create function foo3()
	returns table (name text,price real,publiching text)
as
$$
Select cast(Title as text),cast(Price as real),cast(publishing.publishing as text) 
From books , publishing 
where books.publishing_id = publishing.id 
and 
publishing.publishing like '%BHV%%' and Extract(Year from D_ate)>2000
$$
language sql;

Select * from foo3();

--4.Вивести загальну кількість сторінок по кожній назві категорії. 
drop function if exists foo4;
create function foo4()
	returns table (page_count integer,category text)
as
$$
Select cast(sum(Pages) as integer),cast(category.category as text) 
From books,category 
WHERE books.category_id = category.id 
Group by category.category 
$$
language sql;

Select * from foo4();

--5.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
drop function if exists foo5;
create function foo5()
	returns table (avg_price real)
as
$$
Select cast(avg(Price) as real)
From books,topic,category 
WHERE books.topic_id = topic.id 
and books.category_id = category.id 
and topic.topic like '%%Використання ПК%%' and category.category like '%%Linux%%'
$$
language sql;

Select * from foo5();

--6.Вивести всі дані універсального відносини.
drop function if exists foo6;
create function foo6()
	returns table (topic text, category text, publiching text)
as
$$
Select cast(topic.topic as text),cast (category.category as text),cast(publishing.publishing as text) 
From books,topic,category,publishing 
WHERE books.topic_id = topic.id 
and books.category_id = category.id 
and books.publishing_id = publishing.id 
$$
language sql;


Select * from foo6();

--7.Вивести пари книг, що мають однакову кількість сторінок.
drop function if exists foo7;
create function foo7()
	returns table (n1 text, p1 text, n2 text, p2 text)
as
$$
Select cast(a.Title as text)  , cast( a.Pages as text),
cast(b.Title as text) , cast( b.Pages as text)
FROM books a ,books b  
WHERE   a.Pages=b.Pages and a.id <> b.id
$$
language sql;


Select * from foo7();

--8.Вивести тріади книг, що мають однакову ціну.
drop function if exists foo8;
create function foo8()
	returns table (n1 text, p1 real, n2 text,p2 real, n3 text, p3 real)
as
$$
Select cast(a.Title as text)  ,cast(a.Price as real) , cast(b.Title as text) ,
cast(b.Price as real) ,cast(c.Title as text) , cast(c.Price as real) 
FROM books a ,books b,books c  
WHERE   a.Price=b.Price and b.Price =c.Price 
and a.Price=c.Price and a.id <> b.id and a.id <>c.id and b.id<>c.id
$$
language sql;

Select * from  foo8();

--9.Вивести всі книги категорії 'C ++'.
drop function if exists foo9;
create function foo9()
	returns setof books
as
$$
SELECT  * FROM books  WHERE category_id in (SELECT id FROM category WHERE category like '%%C ++%%')
$$
language sql;

Select * from foo9();

--10.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
drop function if exists foo10;
create function foo10()
	returns table (publishing text)
as
$$

SELECT distinct(cast(publishing.publishing as text))  
FROM publishing  Inner Join books  on  publishing.id = books.publishing_id
WHERE books.publishing_id in (SELECT publishing_id FROM books WHERE Pages >400);
$$
language sql;

Select * from foo10();

--11.Вивести список категорій за якими більше 3-х книг.
drop function if exists foo11;
create function foo11()
	returns table (category text,book_count int)
as
$$
SELECT cast(c.category as text) ,cast(count(*) as int)  
FROM category c Inner Join books b on c.id=b.category_id 
WHERE (select count(*) FROM  books b WHERE b.category_id=c.id ) >= 3 GROUP BY category;
$$
language sql;

Select * from foo11();

--12.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.
drop function if exists foo12;
create function foo12()
	returns setof books
as
$$
SELECT * FROM books WHERE  EXISTS(SELECT 1 FROM publishing WHERE publishing like '%BHV%%' )
$$
language sql;

Select * from foo12();

--13.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.
drop function if exists foo13;
create function foo13()
	returns setof books
as
$$
SELECT * FROM books WHERE  NOT EXISTS (SELECT 1 FROM publishing WHERE books.publishing_id= publishing.id 
									  and publishing like '%BHV%%' )
$$
language sql;

Select * from foo13();

--14.Вивести відсортоване загальний список назв тем і категорій.
drop function if exists foo14;
create function foo14()
	returns table (type text,name text)
as
$$
select cast('book' as text) ,cast(Title as text) 
from books union select cast('topic' as text), cast(topic as text)
from topic union select cast('category' as text), cast(category as text)
from category order by Title
$$
language sql;

Select * from foo14();

--15.Вивести в зворотному порядку загальний список неповторяющихся перших слів назв книг і категорій.
drop function if exists foo15;
create function foo15()
	returns table (type text,name text)
as
$$
SELECT DISTINCT  cast('book' AS text),cast(substring(Title from 0 for position(' ' in Title)) as text) 
FROM books UNION SELECT 'category' AS TYPE, 
cast(substring(category from 0 for position(' ' in category)) as text)  FROM category 
$$
language sql;

Select * from  foo15();