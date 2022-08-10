USE master
GO

--tworzenie bazy
USE [master]
GO
IF DB_ID(N'BD2_2022') IS NOT NULL
	DROP DATABASE BD2_2022;
GO

CREATE DATABASE BD2_2022
ON
(
NAME = BD2_2022,

--do folderu LAB3A
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LAB3A\BD2_2022.mdf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5)
LOG ON
(
NAME = BD2_2022_log,

--do folderu LAB3B
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LAB3B\BD2_2022_log.ldf',
SIZE = 5MB,
MAXSIZE = 25MB,
FILEGROWTH = 5MB
);
GO

--klienci

USE [BD2_2022]
GO

DROP TABLE IF EXISTS dbo.Klienci;
GO

CREATE TABLE Klienci
(
	[idKlienta] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Nazwa] nvarchar(100) NULL,
	[Nip] int NULL,
	[Branza] varchar(50)
);
GO

-- kontaktyklienta

USE [BD2_2022]
GO
IF OBJECT_ID(N'KontaktyKlienta', N'U') IS NOT NULL
	DROP TABLE KontaktyKlienta;
GO
DROP TABLE IF EXISTS dbo.KontaktyKlienta;
GO

CREATE TABLE KontaktyKlienta
(
	[idKontakty] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[idKlienta] int NOT NULL,
	[idRodzajuKontaktu] int NOT NULL,
	[Numer] int NULL,
	[Uwagi] nvarchar(250)
);
GO

--rodzajeadresow

USE [BD2_2022]
GO

DROP TABLE IF EXISTS dbo.RodzajeAdresow;
GO

CREATE TABLE RodzajeAdresow
(
	[idRodzajuAdresu] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Nazwa] nvarchar(100) NULL
);
GO

--rodzajekontaktow

USE [BD2_2022]
GO

DROP TABLE IF EXISTS dbo.RodzajeKontaktow;
GO

CREATE TABLE RodzajeKontaktow
(
	[idRodzajuKontaktu] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Nazwa] nvarchar(100) NULL
);
GO

-- adresyklienta

USE [BD2_2022]
GO
IF OBJECT_ID(N'AdresyKlienta',N'U')IS NOT NULL
DROP TABLE AdresyKlienta;
GO
DROP TABLE IF EXISTS dbo.AdresyKlienta;
GO
CREATE TABLE AdresyKlienta
([idadresu] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
 [idklienta] int NOT NULL,
 [idRodzajuAdresu] int NOT NULL,
 [Miasto] nvarchar(20) NULL,
 [KodPocztowy] nvarchar(6) NULL,
 [UlicaINumer] nvarchar(25) NULL
 );
 GO

 --sprawdzanie kolumn
 --adresyklienta
IF 'idklienta' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'AdresyKlienta')
BEGIN
	ALTER TABLE AdresyKlienta ADD idklienta int NOT NULL;
END

IF 'idRodzajuAdresu' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'AdresyKlienta')
BEGIN
	ALTER TABLE AdresyKlienta ADD idRodzajuAdresu int NOT NULL;
END
		
--rodzajeadresow
IF 'idRodzajuAdresu' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'rodzajeAdresow')
BEGIN
	ALTER TABLE rodzajeAdresow ADD idRodzajuAdresu int IDENTITY(1,1) NOT NULL PRIMARY KEY;
END

--rodzajekontaktow

IF 'idRodzajuKontaktu' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'rodzajeKontaktow')
BEGIN
	ALTER TABLE rodzajeKontaktow ADD idRodzajuKontaktu int IDENTITY(1,1) NOT NULL PRIMARY KEY;
END

--kontaktyklienta

IF 'idRodzajuKontaktu' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'KontaktyKlienta')
BEGIN
	ALTER TABLE KontaktyKlienta ADD idRodzajuKontaktu int NOT NULL;
END

IF 'idKlienta' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'KontaktyKlienta')
BEGIN
	ALTER TABLE KontaktyKlienta ADD idKlienta int NOT NULL;
END

--klienci

IF 'idKlienta' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Klienci')
BEGIN
	ALTER TABLE Klienci ADD idKlienta int IDENTITY(1,1) NOT NULL PRIMARY KEY;
END

--relacje kontaktyklienta

USE [BD2_2022]
GO
IF EXISTS ( SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(N'dbo.FK_KontaktyKlienta_Klienci')
				AND parent_object_id = OBJECT_ID(N'dbo.KontaktyKlienta'))
		ALTER TABLE KontaktyKlienta
			DROP CONSTRAINT FK_KontaktyKlienta_Klienci;
GO
IF EXISTS ( SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(N'dbo.FK_KontaktyKlienta_RodzajeKontaktow')
				AND parent_object_id = OBJECT_ID(N'dbo.KontaktyKlienta'))
		ALTER TABLE KontaktyKlienta
			DROP CONSTRAINT FK_KontaktyKlienta_RodzajeKontaktow;
GO
ALTER TABLE KontaktyKlienta
	ADD CONSTRAINT FK_KontaktyKlienta_Klienci
		FOREIGN KEY(idKlienta) REFERENCES Klienci(idKlienta);
GO
ALTER TABLE KontaktyKlienta
	ADD CONSTRAINT FK_KontaktyKlienta_RodzajeKontaktow
		FOREIGN KEY(idRodzajuKontaktu) REFERENCES RodzajeKontaktow(idRodzajuKontaktu);
GO

--relacje adresyklienta

USE [BD2_2022]
GO

GO
IF EXISTS ( SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(N'dbo.FK_AdresyKlienta_Klienci')
				AND parent_object_id = OBJECT_ID(N'dbo.AdresyKlienta'))
		ALTER TABLE AdresyKlienta
			DROP CONSTRAINT FK_AdresyKlienta_Klienci;
GO
IF EXISTS ( SELECT *
			FROM sys.foreign_keys
			WHERE object_id = OBJECT_ID(N'dbo.FK_AdresyKlienta_RodzajeAdresow')
				AND parent_object_id = OBJECT_ID(N'dbo.AdresyKlienta'))
		ALTER TABLE AdresyKlienta
			DROP CONSTRAINT FK_AdresyKlienta_RodzajeAdresow;
GO

--dodanie kluczy obcych
ALTER TABLE AdresyKlienta
	ADD CONSTRAINT FK_AdresyKlienta_Klienci
		FOREIGN KEY(idklienta) REFERENCES Klienci(idKlienta);
GO

ALTER TABLE AdresyKlienta
	ADD CONSTRAINT FK_AdresyKlienta_RodzajeAdresow
		FOREIGN KEY(idRodzajuAdresu) REFERENCES RodzajeAdresow(idRodzajuAdresu);
GO