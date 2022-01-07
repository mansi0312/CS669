CREATE TABLE Movie(
Title VARCHAR(64),
Genre VARCHAR(32),
ReleaseDate DATE,
Price DECIMAL(6,2),
);

INSERT INTO Movie(Title, Genre, ReleaseDate, Price)
VALUES ('Furious 7', 'Action Film', '1-4-2015', $9.94);

SELECT *
FROM Movie;

UPDATE Movie
SET Price = $10.15;

DELETE FROM Movie;

DROP TABLE Movie;

CREATE TABLE Vacation (
VacationId DECIMAL(12) PRIMARY KEY,
Location VARCHAR(64) NOT NULL,
Description VARCHAR(1024) NULL,
StartedOn DATE NOT NULL,
EndedOn DATE NOT NULL
);

INSERT INTO Vacation(VacationId,
Location,
Description,
StartedOn,
EndedOn)
VALUES (2,
'Bora Bora',
'Exciting Snorkeling',
CAST('5-MAR-2019' AS DATE),
CAST('15-MAR-2019' AS DATE)
);

INSERT INTO Vacation(VacationId,
Location,
StartedOn,
EndedOn)
VALUES (3,
'Jamaica',
CAST('10-DEC-2018' AS DATE),
CAST('28-DEC-2018' AS DATE)
);

SELECT *
FROM Vacation;

INSERT INTO Vacation(VacationId,
Description,
StartedOn,
EndedOn)
VALUES (4,
'Experience the Netherlands No Other Way',
CAST('1-JAN-2020' AS DATE),
CAST('10-JAN-2020' AS DATE)
);

INSERT INTO Vacation(VacationId,
Location,
Description,
StartedOn,
EndedOn)
VALUES (4,
'Netherlands',
'Experience the Netherlands No Other Way',
CAST('1-JAN-2020' AS DATE),
CAST('10-JAN-2020' AS DATE)
);

SELECT Location, Description
FROM Vacation
WHERE VacationId = 2;

UPDATE Vacation
SET Description = NULL
WHERE VacationId = 3;

DELETE FROM Vacation
WHERE StartedOn > CAST('1-JUN-2019' AS DATE);