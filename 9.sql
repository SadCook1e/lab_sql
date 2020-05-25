
--1.Розробити і перевірити скалярну (scalar) функцію, що повертає загальну вартість книг, виданих в певному році.
DROP FUNCTION IF EXISTS funk1;
CREATE FUNCTION funk1(f_date int) RETURNS real AS $$
    SELECT  sum(Price) from books where Extract(Year from D_ate) = f_date ;
$$ LANGUAGE SQL;

SELECT  funk1(2000);
	
-- 2.Розробити і перевірити табличну (inline) функцію, яка повертає список книг, виданих в певному році.
DROP FUNCTION IF EXISTS funk2;
   CREATE FUNCTION funk2 (find_date date)
      RETURNS TABLE (name varchar) as
	  $BODY$ 
      select Title from books where (Extract(Year from D_ate) = Extract(Year from find_date) )
   	  $BODY$
		LANGUAGE SQL;
		
		SELECT * from funk2('2000.02.23'); 
		
