-- Stwórz zapytanie zwracające nazwę kraju, jego stolicę, wartość „GNP” (countryinfo) dla kraju z
--największą wartością „GNP”

SELECT lista3.country.name AS country_name, 
	   lista3.city.name AS city_name, 
	   lista3.countryinfo.doc ->> 'GNP' AS gnp
FROM ((lista3.country 
INNER JOIN lista3.city 
ON lista3.country.Capital = lista3.city.id)
	  INNER JOIN lista3.countryinfo 
	  ON lista3.country.name = lista3.countryinfo.doc ->> 'Name')
WHERE CAST(lista3.countryinfo.doc ->> 'GNP' AS float) = (SELECT MAX(CAST(lista3.countryinfo.doc ->> 'GNP' AS float))
			FROM lista3.countryinfo);

--Stwórz zapytanie zwracające minimalne, maksymalne oraz średnie „GNP” dla każdego z kontynentów
SELECT 
	(doc -> 'geography' ->> 'Continent') continent,
	MIN(CAST(lista3.countryinfo.doc ->> 'GNP' AS float)) min_gpt, 
	MAX(CAST(lista3.countryinfo.doc ->> 'GNP' AS float)) max_gpt, 
	AVG(CAST(lista3.countryinfo.doc ->> 'GNP' AS float)) avg_gpt
FROM 
	lista3.countryinfo 
GROUP BY 
	continent;

--Stwórz zapytanie zwracające wszystkie miasta znajdujące się w regionie: North America(countryinfo)
SELECT 
	lista3.city.name city
FROM 
	lista3.city 
INNER JOIN lista3.countryinfo 
	ON lista3.city.countrycode = lista3.countryinfo.doc ->> '_id'
WHERE 
	doc -> 'geography' ->> 'Region' = 'North America';

--Stwórz zapytanie zwracające listę nazw państw dla których wartość pola „HeadOfState” zawiera w sobie „Elisabeth”
SELECT 
	(lista3.countryinfo.doc ->> 'Name') country
FROM 
	lista3.countryinfo
WHERE 
	(lista3.countryinfo.doc -> 'government' ->> 'HeadOfState') LIKE '%Elisabeth%';

--Stwórz zapytanie zwracające ilość państw znajdujących się na każdym z kontynentów
SELECT 
	(doc -> 'geography' ->> 'Continent') continent,
	COUNT(doc ->> 'Name') num_countries
FROM 
	lista3.countryinfo
GROUP BY 
	continent;

--Stwórz zapytanie zwracające nazwy 10 państw z największą oraz 10 państw z najmniejszą
--wartością pola LifeExpectancy (countryinfo)

(SELECT 
    (doc ->> 'Name') AS name,
    (doc -> 'demographics' ->> 'LifeExpectancy') AS life_exp
  FROM 
    lista3.countryinfo
  WHERE 
    (doc -> 'demographics' ->> 'LifeExpectancy') IS NOT NULL
  ORDER BY 
    CAST((doc -> 'demographics' ->> 'LifeExpectancy') AS FLOAT) DESC
  LIMIT 10)
UNION 
(SELECT 
    (doc ->> 'Name') AS name,
    (doc -> 'demographics' ->> 'LifeExpectancy') AS life_exp
  FROM 
    lista3.countryinfo
  WHERE 
    (doc -> 'demographics' ->> 'LifeExpectancy') IS NOT NULL
  ORDER BY 
    CAST((doc -> 'demographics' ->> 'LifeExpectancy') AS FLOAT) ASC
  LIMIT 10)
ORDER BY life_exp;





