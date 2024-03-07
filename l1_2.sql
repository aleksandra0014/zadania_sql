CREATE SCHEMA world
CREATE TABLE world.country2(
	id INT PRIMARY KEY, 
	name varchar(255),
	capital varchar(255), 
	population INT, 
	created_on timestamptz,
	hdi real);

ALTER TABLE world.country2
ADD COLUMN GDP INTEGER;

ALTER TABLE world.country2
DROP COLUMN created_on;

DROP TABLE world.country2;

INSERT INTO world.country2 VALUES
	('1', 'Country1', 'Capital1', 1000000, '2023-11-14 12:00:00', 0.85, 500000),
	('2', 'Country2', 'Capital2', 2000000, '2023-11-14 12:15:00', 0.92, 800000),
  	('20', 'Country20','Capital20', 5000000, '2023-11-14 15:30:00', 0.78, 1200000);

SELECT * FROM world.country2
ORDER BY population desc;

UPDATE world.country2 SET population = 20000000 WHERE population = (SELECT MIN(population) from world.country2);

SELECT * 
FROM world.country2
WHERE population < 20000000;

DELETE FROM world.country2 
WHERE population >= 20000000;