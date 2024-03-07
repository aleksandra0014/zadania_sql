DROP SCHEMA lista6
CASCADE;

CREATE SCHEMA lista6;

-- tutaj data zależy od tytułu ale tytuł nie jest kluczem więc nie jest w bnf 
CREATE TABLE lista6.Książki
( 
	książka_id integer,
    tytuł varchar(255),
    data_publikacji date,
    PRIMARY KEY (książka_id)
);

INSERT INTO lista6.Książki VALUES(
	101, 'W ciemnym lesie', '2012-02-01');
	

-- 1PN w tej tabeli zamiast informacje ogólne i dawania jsona w takiej kolumnie, zrobiłam dwie kolumnny o dacie urodzenia i kraju pochodzenia 
-- tak aby tabela była w pierwszej postaci, czyli komórki były w postaci atomowej 

-- 2PN w tabeli potenjclanym kluczem oprócz autor_id może być również imię i nazwisko, a w tym przyadku płeć jest wyznacza również przez samo imię, 
-- a więc przez część klucza, aby to zmienić i sprowadzić do 2PN wprowadziłam takie zmiany (od razu 3PN)

CREATE TABLE lista6.Autorzy_przed_poprawką
(
    autor_id integer,
    imie varchar(255),
    nazwisko varchar(255),
	płeć varchar(255),
	dodatkowe_info json,
    PRIMARY KEY (autor_id)
);

CREATE TABLE lista6.Autorzy
(
    autor_id integer,
    imie varchar(255),
    nazwisko varchar(255),
    data_urodzenia date,
    kraj varchar(255),
    PRIMARY KEY (autor_id)
);

INSERT INTO lista6.Autorzy VALUES(
		1, 'Ruth', 'Ware', '1978-11-09', 'Anglia');
	
CREATE TABLE lista6.Autorzy_płeć
(
    imie varchar(255),
	płeć varchar(255)
);

INSERT INTO lista6.Autorzy_płeć VALUES(
		'Ruth', 'K');
	

CREATE TABLE lista6.Autorzy_książki
(
	autor_id integer,
	książka_id integer,
	FOREIGN KEY (książka_id) REFERENCES lista6.Książki (książka_id),
	FOREIGN KEY (autor_id) REFERENCES lista6.Autorzy (autor_id)

);

INSERT INTO lista6.Autorzy_książki VALUES
(1, 101);
	

CREATE TABLE lista6.Gatunki
(
    gatunek_id integer,
    nazwa varchar(255),
    PRIMARY KEY (gatunek_id)
);

INSERT INTO lista6.Gatunki VALUES(
		5, 'kryminał');
	

CREATE TABLE lista6.Gatunki_książki
(
	gatunek_id integer,
	książka_id integer,
	FOREIGN KEY (książka_id) REFERENCES lista6.Książki (książka_id),
	FOREIGN KEY (gatunek_id) REFERENCES lista6.Gatunki (gatunek_id)
	
);

INSERT INTO lista6.Gatunki_książki VALUES(
		5, 101);
	

-- 3PN liczba mieszkańców jest wyznaczana przez miejscowość, a więc zależność klient - liczba mieszkańców jest przechodnia, aby sprowadzić do 3PN wyodrębniłam te zależności 
CREATE TABLE lista6.Klienci_przedpoprawką
(
    klient_id integer PRIMARY KEY,
    imie varchar(255),
    nazwisko varchar(255),
    email varchar(255),
	miejscowość varchar(255),
	liczba_mieszkańców varchar(255)
);

CREATE TABLE lista6.Klienci
(
    klient_id integer,
    imie varchar(255),
    nazwisko varchar(255),
    email varchar(255),
	miejscowość varchar(255),
    PRIMARY KEY (klient_id)
);

INSERT INTO lista6.Klienci VALUES(
		1, 'Anna', 'Nowak', 'nowak@gmail.com', 'Wieluń');
	
CREATE TABLE lista6.miejscowość
(
	miejscowość varchar(255),
	liczba_mieszkańców varchar(255)
);

INSERT INTO lista6.miejscowość VALUES(
		'Wieluń', 27000);
	
CREATE type lista6.dostepnosc as ENUM('Dostępna', 'Wypożyczona', 'Zarezerwowana');


CREATE TABLE lista6.Egzemplarze
(
    egz_id integer,
	książka_id integer,
    status lista6.dostepnosc,
    PRIMARY KEY (egz_id),
	FOREIGN KEY (książka_id) REFERENCES lista6.Książki (książka_id)
);

INSERT INTO lista6.Egzemplarze VALUES(
		111, 101, 'Dostępna');
	
CREATE TABLE lista6.Wypozyczenia_przedpoprawką
(
    Egzemplarze_id integer,
    Klienci_id integer,
    data_wypożyczenia date,
    data_zwrotu date,
	długość_wypożyczenia integer,
    PRIMARY KEY (Egzemplarze_id, Klienci_id),
	FOREIGN KEY (Egzemplarze_id) REFERENCES lista6.Egzemplarze (egz_id),
	FOREIGN KEY (Klienci_id) REFERENCES lista6.Klienci (klient_id)
);

-- 3PN- data wypożyczenia, zwrotu i długość sa od siebie zależne, a więc jedną można wyrzucić
CREATE TABLE lista6.Wypożyczenia
(
    Egzemplarze_id integer,
    Klienci_id integer,
    data_wypożyczenia date,
	długość_wypożyczenia integer,
    PRIMARY KEY (Egzemplarze_id, Klienci_id),
	FOREIGN KEY (Egzemplarze_id) REFERENCES lista6.Egzemplarze (egz_id),
	FOREIGN KEY (Klienci_id) REFERENCES lista6.Klienci (klient_id)
);


INSERT INTO lista6.Wypożyczenia VALUES(
	111, 1, '2023-12-04', 14)


-- załóżmy, że mamy biblioteki powiatową, które mają różne książki i odpowiednie gminy, które pod nie należą 
CREATE TABLE lista6.Biblioteki_pow
(
	nazwa varchar(255), 
	tytuł_ksiazki varchar(255),
	gmina varchar(255)
);

-- tutaj mamy zależności wielowartościowe od biblioteki zależą tytuly jakie są i oddziały (zależność wielowartościowa), ale tytul i gmina są niezależne,
-- aby przejść do 4 postaci należy usunąć zależności wielowartościowe, czyli:

CREATE TABLE lista6.Biblioteki_pow_ksiazki(
	nazwa varchar(255), 
	tytuł_ksiazki varchar(255)
);

CREATE TABLE lista6.Biblioteki_pow_gminy(
	nazwa varchar(255), 
	gmina varchar(255)
)

