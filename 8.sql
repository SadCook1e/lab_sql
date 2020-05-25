CREATE FUNCTION topic_range() RETURNS trigger AS  $topic_range$
	DECLARE 
    num integer; 
	BEGIN
		
		Select count(Topic) INTO num FROM topic;
		New.count= num;
		IF (num<5 or num>10 ) THEN
			RAISE EXCEPTION 'Кількість тем може бути в діапазоні від 5 до 10.';
		END IF;
		RETURN NEW;
	END;
$topic_range$ LANGUAGE plpgsql;

CREATE TRIGGER topic_range BEFORE INSERT OR UPDATE or DELETE ON topic
    FOR EACH ROW EXECUTE PROCEDURE topic_range();

--2.Новинкою може бути тільки книга видана в поточному році.

CREATE FUNCTION new_book() RETURNS trigger AS  $new_book$
	BEGIN
			IF (EXTRACT (YEAR FROM New.D_ate)!=EXTRACT(YEAR FROM current_date)) and (New.book_new=true) THEN
				RAISE EXCEPTION 'Новинкою може бути тільки книга видана в поточному році.';
				END IF;	
		RETURN NEW;
	END;
$new_book$ LANGUAGE plpgsql;

CREATE TRIGGER new_book BEFORE INSERT OR UPDATE or DELETE ON books
    FOR EACH ROW EXECUTE PROCEDURE new_book();

--3.Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 3 00 - 3 0 $.
CREATE FUNCTION pages_price() RETURNS trigger AS  $pages_price$
	BEGIN
			IF (New.Pages<100)and(New.Price >10) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 100 не може коштувати більше 10 $';
				END IF;	
			IF (New.Pages<200)and(New.Price >20) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 200 не може коштувати більше 20 $';
				END IF;	
			IF (New.Pages<300)and(New.Price >30) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 300 не може коштувати більше 30 $';
				END IF;	
				
		RETURN NEW;
	END;
$pages_price$ LANGUAGE plpgsql;

CREATE TRIGGER pages_price BEFORE INSERT OR UPDATE or DELETE ON books
    FOR EACH ROW EXECUTE PROCEDURE pages_price();
--4.Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.
CREATE FUNCTION publiching_edition() RETURNS trigger AS  $publiching_edition$
	BEGIN
			IF (New.publishing like '%%BHV С.-Петербург%%' )and(New.edition<5000) THEN
				RAISE EXCEPTION 'Видавництво "BHV" не випускає книги накладом меншим 5000';
				END IF;	
			IF (New.like '%%DiaSoft%%' )and(New.edition<10000) THEN
				RAISE EXCEPTION 'Видавництво Diasoft не випускає книги накладом меншим 10000';
				END IF;	
			
				
		RETURN NEW;
	END;
$publiching_edition$ LANGUAGE plpgsql;

CREATE TRIGGER publiching_edition BEFORE INSERT OR UPDATE or DELETE ON books
    FOR EACH ROW EXECUTE PROCEDURE publiching_edition();

--7.Користувач "dbo" не має права змінювати ціну книги.
CREATE FUNCTION dbo() RETURNS trigger AS  $dbo$
  BEGIN
    IF(select current_user='dbo') THEN
      RAISE EXCEPTION 'Користувач "dbo" не має права змінювати ціну книги';
      END IF;
    RETURN NEW;
  END;
$dbo$ LANGUAGE plpgsql;

CREATE TRIGGER dbo
  BEFORE UPDATE of Price
  ON books
  FOR EACH ROW
  EXECUTE PROCEDURE dbo();

--8.Видавництва ДМК і Еком підручники не видають.
CREATE FUNCTION publiching() RETURNS trigger AS  $publiching$
	BEGIN
			IF (New.Publishing like '%%ДМК%%' )and(New.Category like'%%підручники%%') THEN
				RAISE EXCEPTION 'Видавництва ДМК і Еком підручники не видають.';
				END IF;	
			IF (New.Publishing like '%%Еком%%' )and(New.Category like'%%підручники%%') THEN
				RAISE EXCEPTION 'Видавництва ДМК і Еком підручники не видають.';
				END IF;	
			
				
		RETURN NEW;
	END;
$publiching$ LANGUAGE plpgsql;

CREATE TRIGGER publiching BEFORE INSERT OR UPDATE or DELETE ON books
    FOR EACH ROW EXECUTE PROCEDURE publiching();

--9.Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
CREATE FUNCTION foo() RETURNS trigger AS  $foo$
  BEGIN
    IF ((select count(*) from books where N_ew='Yes'and EXTRACT(MONTH from D_ate)=EXTRACT(MONTH from current_data))>1 and New.n_ew = 'Yes' 
      and EXTRACT(MONTH from New.D_ate)=EXTRACT(MONTH from current_date) ) THEN
      RAISE EXCEPTION 'Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року';
      END IF;
    RETURN NEW;
  END;
$foo$ LANGUAGE plpgsql;

CREATE TRIGGER foo
  BEFORE INSERT or UPDATE 
  ON books
  FOR EACH ROW
  EXECUTE PROCEDURE foo()