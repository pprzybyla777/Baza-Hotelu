DROP VIEW IF EXISTS przyjezdni
GO
CREATE VIEW przyjezdni AS
SELECT nr_pokoju, Rezerwacja.nr_rezerwacji, data_przyjazdu, DATEDIFF(DAY,data_przyjazdu, data_odjazdu ) AS Ilość_dni, czy_parking 
FROM Rezerwacja
WHERE data_przyjazdu >= GETDATE()
GO
SELECT*FROM przyjezdni

