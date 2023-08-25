DROP VIEW IF EXISTS jakie_dostępne
GO
CREATE VIEW jakie_dostępne AS
SELECT nr_pokoju, nazwa_kategorii FROM Pokoje, Kategoria_pokoju
WHERE Pokoje.id_kategorii=Kategoria_pokoju.id_kategorii
AND dostepnosc='TAK'
GO
SELECT*FROM jakie_dostępne