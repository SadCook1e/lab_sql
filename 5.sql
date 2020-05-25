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
('pb');
INSERT INTO Topic(t_opic) VALUES
('t');
INSERT INTO Category(c_ategory) VALUES
('ct');
INSERT INTO Books (Num, N_ew, Title, Price, Pages, Format, D_ate, Edition, Publishing_id, Topic_id, Category_id) VALUES 
(5896, '0', 'Title', 100, 200, 'fromat', '2000-07-03', 300, 1, 1, 1);

Select * From Books;