DROP SCHEMA lista3
CASCADE;

CREATE SCHEMA lista3; 

CREATE TABLE lista3.country (
    code CHAR(3) NOT NULL DEFAULT 'UNK' PRIMARY KEY,
    name VARCHAR(255) NOT NULL DEFAULT ' ',
	code2 CHAR(2) NOT NULL DEFAULT ' ' UNIQUE);

ALTER TABLE lista3.country 
ADD CONSTRAINT check_code CHECK (LENGTH(code) >= 3);

CREATE TABLE lista3.city(
	ID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(255) NOT NULL DEFAULT '', 
	CountryCode char(3) NOT NULL DEFAULT '', 
	District VARCHAR(255) NOT NULL DEFAULT '',
	Info json DEFAULT NULL
);

ALTER TABLE lista3.country
ADD COLUMN Capital INT DEFAULT NULL,
ADD FOREIGN KEY (Capital) REFERENCES lista3.city(ID);

CREATE TYPE lista3.t_or_f AS ENUM ('T', 'F');

CREATE TABLE lista3.countrylanguage (
    CountryCode CHAR(3) NOT NULL DEFAULT '',
    Language CHAR(30) NOT NULL DEFAULT '',
    IsOfficial t_or_f NOT NULL DEFAULT 'F',
    Percentage DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    PRIMARY KEY (CountryCode, Language),
    FOREIGN KEY (CountryCode) REFERENCES lista3.country(Code)
);
   
CREATE INDEX idx_CountryCode ON lista3.countrylanguage (CountryCode);

CREATE SEQUENCE lista3.seq;

CREATE TABLE lista3.countryinfo (
    doc JSON,
    _id VARCHAR(32) DEFAULT nextval('lista3.seq') NOT NULL,
    PRIMARY KEY (_id)
);
