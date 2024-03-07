-- Stwórz zapytanie zwracające wszystkie wartości pola „GovernmentForm” (countryinfo) bez
-- powtórzeń

SELECT DISTINCT doc -> 'government' ->> 'GovernmentForm' government_form
FROM lista3.countryinfo;

-- 2. Stwórz zapytanie wypisujące najczęściej występującą wartość w bazie dla pola „Continent”
-- (countryinfo)

SELECT doc -> 'geography' ->> 'Continent' continent
FROM lista3.countryinfo 
GROUP BY continent 
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 3. Stwórz zapytanie wypisujące nazwy państw wraz z wartością IndepYear w kolejności malejącej
-- po polu „IndepYear” (countryinfo)

SELECT doc ->> 'Name' country, CAST(doc ->> 'IndepYear' AS float) indep_year
FROM lista3.countryinfo 
WHERE CAST(doc ->> 'IndepYear' AS float) IS NOT NULL
ORDER BY indep_year DESC;

-- 4. Stwórz zapytanie wypisujące języki oraz ilokrotnie są językami urzędowymi w kolejności
-- malejącej

SELECT language, COUNT(*) ile
FROM lista3.countrylanguage
WHERE IsOfficial = 'T'
GROUP BY language 
ORDER BY ile DESC;

-- opcja z 0 
SELECT l.language, COUNT(countrycode) AS ile
FROM (SELECT DISTINCT language
    FROM lista3.countrylanguage) AS l
LEFT JOIN lista3.countrylanguage AS c ON l.language = c.language AND c.IsOfficial = 'T'
GROUP BY l.language
ORDER BY ile DESC;

SELECT language, COUNT(*) filter (where IsOfficial='T') ile
FROM lista3.countrylanguage
GROUP BY language 
ORDER BY ile DESC;

-- 5. Stwórz zapytanie wypisujące języki oraz ilość ludzi posługujących się nimi na całym świecie w
-- kolejności malejącej

SELECT language, 
	round(SUM(percentage*0.01*(CAST(doc -> 'demographics' ->> 'Population' AS float)))) ile_ludzi
FROM lista3.countrylanguage 
JOIN lista3.countryinfo 
ON lista3.countrylanguage.countrycode = lista3.countryinfo.doc ->> '_id'
GROUP BY language
ORDER BY ile_ludzi DESC

-- 6. Stwórz zapytanie wypisujące kraje które znajdują się w pierwszej dwudziestce pod względem
-- długości życia oraz jednocześnie znajdują się w pierwszej dwudziestce krajów z największą
-- wartością GNP

SELECT doc ->> 'Name' as country, CAST(doc -> 'demographics' ->> 'LifeExpectancy' AS FLOAT) life_expe, CAST(doc ->> 'GNP' AS FLOAT) gnp
FROM lista3.countryinfo 
WHERE (CAST(doc -> 'demographics' ->> 'LifeExpectancy' AS FLOAT) IN (
	SELECT CAST(doc -> 'demographics' ->> 'LifeExpectancy' AS FLOAT) AS l_exp
	FROM lista3.countryinfo
	WHERE CAST(doc -> 'demographics' ->> 'LifeExpectancy' AS FLOAT) IS NOT NULL
	ORDER BY l_exp DESC
	LIMIT 20)) 
	AND 
	( CAST(doc ->> 'GNP' AS FLOAT) IN (
	SELECT CAST(doc ->> 'GNP' AS FLOAT) gnp
	FROM lista3.countryinfo
	WHERE CAST(doc ->> 'GNP' AS FLOAT) IS NOT NULL
	ORDER BY gnp DESC
	LIMIT 20))
ORDER BY life_expe DESC, gnp DESC;

-- druga wersja 
SELECT tab1.country, tab1.l_exp, tab2.gnp
FROM 
(SELECT doc ->> 'Name' AS country,
	CAST(doc -> 'demographics' ->> 'LifeExpectancy' AS FLOAT) AS l_exp
FROM lista3.countryinfo
WHERE CAST(doc -> 'demographics' ->> 'LifeExpectancy' AS FLOAT) IS NOT NULL
ORDER BY l_exp DESC
LIMIT 20) tab1
JOIN
(SELECT doc ->> 'Name' AS country,
    CAST(doc ->> 'GNP' AS FLOAT) AS gnp
FROM lista3.countryinfo
WHERE CAST(doc ->> 'GNP' AS FLOAT) IS NOT NULL
ORDER BY gnp DESC
LIMIT 20) tab2
ON (tab1.country) = (tab2.country)
ORDER BY l_exp DESC, gnp DESC;






