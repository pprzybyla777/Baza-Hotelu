DROP VIEW IF EXISTS wandalizm
GO
CREATE VIEW wandalizm AS
SELECT imie, nazwisko, Rachunek.nr_rachunku, za_szkody, Pokoje.nr_pokoju,
CASE
	WHEN za_szkody>0 THEN 'Wandal'
		ELSE 'Nie wandal'
		END AS 'Status'
FROM Rachunek, Pokoje, Klient
WHERE Rachunek.nr_rachunku=Klient.nr_rachunku and Pokoje.nr_pokoju=Klient.nr_pokoju
GO
SELECT*FROM wandalizm