USE Hotel2

DROP TABLE IF EXISTS Kategoria_pokoju
CREATE TABLE Kategoria_pokoju
(
id_kategorii int PRIMARY KEY IDENTITY,
nazwa_kategorii varchar(16),
cena_za_dobe float
)
INSERT INTO Kategoria_pokoju VALUES
('jednoosobowy', '145.00'),
('dwuosobowy', '190.00'),
('trzyosobowy', '220.00'),
('apartament', '270.00')
SELECT*FROM Kategoria_pokoju


-- 1:1 Pokoje - Kategoria_pokoju

DROP TABLE IF EXISTS Pokoje
CREATE TABLE Pokoje
(
nr_pokoju int PRIMARY KEY IDENTITY,
id_kategorii int FOREIGN KEY REFERENCES Kategoria_pokoju(id_kategorii),
dostepnosc varchar(3)
)
INSERT INTO Pokoje VALUES
('3', 'NIE'),
('2', 'NIE'),
('1', 'TAK'),
('1', 'NIE'),
('4', 'NIE')
SELECT*FROM Pokoje
SELECT*FROM Kategoria_pokoju


DROP TABLE IF EXISTS Rachunek
CREATE TABLE Rachunek
(
nr_rachunku int PRIMARY KEY IDENTITY,
za_noclegi float,
za_uslugi float,
za_szkody float,
rabat_noclegowy float,
kwota_do_zaplaty float
)
INSERT INTO Rachunek VALUES
('1100.00', '200.00', '250.00', '0.05', '1495.00'),
('1330.00', '550.50', '0', '0.05', '1814.00'),
('1620.00', '1500.00', '0', '0', '3120.00'),
('145', '200', '0', '0.05', '337.75')
SELECT*FROM Rachunek

DROP TABLE IF EXISTS Rezerwacja
CREATE TABLE Rezerwacja
(
nr_rezerwacji int PRIMARY KEY IDENTITY,
nr_rachunku int UNIQUE FOREIGN KEY REFERENCES Rachunek(nr_rachunku),
nr_pokoju int UNIQUE FOREIGN KEY REFERENCES Pokoje(nr_pokoju),
id_kategorii int FOREIGN KEY REFERENCES Kategoria_pokoju(id_kategorii),
data_rezerwacji date,
data_przyjazdu date,
data_odjazdu date,
ilosc_dni int,
czy_parking varchar(3)
)
INSERT INTO Rezerwacja VALUES
('1', '1', '3', '2022-01-03', '2022-01-10', '2022-01-15', '5', 'TAK'),
('2', '2', '2', '2022-01-12', '2022-01-21', '2022-01-28', '7', 'TAK'),
('3', '5', '4', '2022-01-16', '2022-01-24', '2022-01-30', '6', 'TAK'),
('4', '3', '1', '2022-01-23', '2022-01-31', '2022-02-01', '1', 'NIE')
SELECT*FROM Rezerwacja

DROP TABLE IF EXISTS Klient
CREATE TABLE Klient
(
id_klienta int PRIMARY KEY IDENTITY,
nr_rezerwacji int FOREIGN KEY REFERENCES Rezerwacja(nr_rezerwacji),
nr_rachunku int FOREIGN KEY REFERENCES Rachunek(nr_rachunku),
nr_pokoju int FOREIGN KEY REFERENCES Pokoje(nr_pokoju),
imie varchar(35),
nazwisko varchar(35),
telefon varchar(17),
email varchar(255)
)
INSERT INTO Klient VALUES
('1', '1', '1', 'Grzegorz', 'Dudek', '(+48)-222-333-444', 'gdudek@gmail.com'),
('1', '1', '1', 'Iwona', 'Dudek', '(+48)-264-573-422', 'iwonkaa@wp.pl'),
('1', '1', '1', 'Dawid', 'Dudek', '(+48)-262-323-434', NULL),
('2', '2', '2', 'Krzysztof', 'Walczak', '(+48)-112-112-112', 'kwalczak@o2.pl'),
('2', '2', '2', 'Iwona', 'Olszewski', '(+48)-663-320-439', 'olszewski90@o2.pl'),
('3', '3', '5', 'Natalia', 'Borkowski', '(+48)-962-399-934', 'nborkowski97@wp.pl'),
('4', '4', '3', 'Aleksandra', 'Wilk', '(+48)-165-363-334', 'wilk@o2.pl')
SELECT*FROM Klient



SELECT nr_pokoju, Rezerwacja.nr_rezerwacji, data_przyjazdu, DATEDIFF(DAY,data_rezerwacji, data_przyjazdu) AS Ilość_dni FROM Rezerwacja
ORDER BY Ilość_dni DESC


DROP FUNCTION IF EXISTS dbo.cały_rachunek
GO
CREATE FUNCTION cały_rachunek(@nr_rachunku int)
RETURNS table AS
RETURN (SELECT*FROM Rachunek WHERE nr_rachunku=@nr_rachunku)
GO
SELECT*FROM dbo.cały_rachunek('3') 


DROP FUNCTION IF EXISTS dbo.ilosc_rabatow
GO
CREATE FUNCTION dbo.ilosc_rabatow()
RETURNS int
BEGIN
DECLARE @ile_rabatow int
SET @ile_rabatow=(SELECT COUNT(*) FROM Rachunek
		WHERE rabat_noclegowy>0)
RETURN @ile_rabatow
END
GO
SELECT dbo.ilosc_rabatow() as 'Ilosc rabatow'

DROP FUNCTION IF EXISTS dbo.kalkulator_noclegow
GO
CREATE FUNCTION dbo.kalkulator_noclegow(@data_przyjazdu date,@data_odjazdu date, @id_kategorii_pokoju int)
RETURNS float
BEGIN
declare @cena float
set @cena=((SELECT cena_za_dobe from Kategoria_pokoju WHERE id_kategorii=@id_kategorii_pokoju) * CAST(DATEDIFF(DAY,@data_przyjazdu, @data_odjazdu) AS float))
return @cena
end
go
select dbo.kalkulator_noclegow('2022-02-01','2022-02-03', '1') as 'Cena'













CREATE TABLE Parking
(
nr_miejsca int PRIMARY KEY IDENTITY
)




-- 

Alter table Pokoje
add CONSTRAINT FK_kat_pok_id_kategorii foreign key (id_kategorii)
references Kategoria_pokoju(id_kategorii)



-- 1:n Rezerwacja - Kategoria_pokoju










-- 1:n Rachunek - platnosci

DROP TABLE IF EXISTS platnosci
CREATE TABLE platnosci
(
id_platnosci int PRIMARY KEY IDENTITY,
nr_rachunku int FOREIGN KEY REFERENCES Rachunek(nr_rachunku),
kwota float,
data_platnosci date,
typ_platnosci varchar(30)
)


-- 1:1 Rachunek - Rezerwacja

ALTER TABLE Rezerwacja
ADD nr_rachunku int UNIQUE;

ALTER TABLE Rezerwacja
ADD CONSTRAINT FK_rach_nr_rachunku FOREIGN KEY (nr_rachunku)
REFERENCES Rachunek(nr_rachunku)

-- 1:n Rezerwacja - Klient


-- 1:1 Mieszkancy - Parking

DROP TABLE IF EXISTS Mieszkancy
CREATE TABLE Mieszkancy
(
id_mieszkanca int PRIMARY KEY IDENTITY,
nr_rezerwacji int FOREIGN KEY REFERENCES Rezerwacja(nr_rezerwacji),
id_klienta int FOREIGN KEY REFERENCES Klient(id_klienta),
id_kategorii int FOREIGN KEY REFERENCES Kategoria_pokoju(id_kategorii),
nr_miejsca int UNIQUE FOREIGN KEY REFERENCES Parking(nr_miejsca),
zameldowanie datetime,
wymeldowanie datetime,
)
INSERT INTO Mieszkancy VALUES
('10.01.2022 10:21:22', '15.01.2022 08:10:32'),
( '10.01.2022 10:22:00', '15.01.2022 08:10:55'),
( '10.01.2022 10:21:35', '15.01.2022 08:11:12')
SELECT*FROM Mieszkancy

