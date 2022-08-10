use master
go
/*
________________________________________
Tworzenie bazy
________________________________________*/

-- Przed utworzeniem sprawdzam czy taka baza ju¿ nie istnieje
IF DB_ID(N'Obsluga_paczkomatow') IS NOT NULL
DROP DATABASE Obsluga_paczkomatow;
GO


-- Tworzenie bazy danych

CREATE DATABASE Obsluga_paczkomatow
ON
(
NAME = Obsluga_paczkomatow,

--do folderu projekt_a
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\projekt_a\Obsluga_paczkomatow.mdf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5)
LOG ON
(
NAME =Obsluga_paczkomatow_log,

--do folderu projekt_b
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\projekt_b\Obsluga_paczkomatow_log.ldf',
SIZE = 5MB,
MAXSIZE = 25MB,
FILEGROWTH = 5MB
);
GO

use [Obsluga_paczkomatow]
go

--TABELE

--Klient

DROP TABLE IF EXISTS dbo.Klient;
GO

CREATE TABLE Klient 
(
  [id_klienta] int IDENTITY(1,1) NOT NULL primary key,
  [imie] nvarchar(15) not null,
  [nazwisko] nvarchar(35) not null,
  [email] nvarchar(50) null,
  [aplikacja] char(1) not null,
  [nr_telefonu] nvarchar(10) not null ,
);
GO



-- Kurier 

use [Obsluga_paczkomatow]
go

DROP TABLE IF EXISTS dbo.Kurier;
GO

CREATE TABLE Kurier 
(
  [id_kuriera] int IDENTITY(1,1) NOT NULL primary key,
  [imie] nvarchar(15) not null,
  [nazwisko] nvarchar(35) not null,
  [email] nvarchar(50) null,
  [nr_kontaktowy] nvarchar(10) not null,
  [firma] nvarchar(15) not null,
  [praca_od] date not null,
  [uwagi] nvarchar(MAX) null,
);
GO


--Paczka

use [Obsluga_paczkomatow]
go

DROP TABLE IF EXISTS dbo.Paczka;
GO

CREATE TABLE Paczka
(
  [id_paczki] int IDENTITY(1,1) NOT NULL primary key,
  [id_kuriera] int not null,
  [id_klienta] int not null,
  [id_komory] int not null,
  [typ] nvarchar(15) not null,
  [data_do_paczkomatu] datetime not null,

);
GO

--Paczkomat
use [Obsluga_paczkomatow]
go

DROP TABLE IF EXISTS dbo.Paczkomat;
GO

CREATE TABLE Paczkomat
(
  [id_paczkomatu] int IDENTITY(1,1) NOT NULL primary key,
  [id_lokalizacji] int not null,

);
GO


--Komora

use [Obsluga_paczkomatow]
go

DROP TABLE IF EXISTS dbo.Komora;
GO

CREATE TABLE Komora
(
  [id_komory] int IDENTITY(1,1) NOT NULL primary key,
  [id_paczkomatu] int not null,
  [rozmiar] nvarchar(10) not null,
  [czy_wolna] char(1) not null,

);
GO



--Opinia

use [Obsluga_paczkomatow]
go

DROP TABLE IF EXISTS dbo.Opinia

CREATE TABLE Opinia(
  [id_klienta] int not null,
  [id_paczki] int not null,
  [ocena] int not null,
  [data_oceny] date not null,
  [data_odbioru] date not null,
 CONSTRAINT [PK_Opinia] PRIMARY KEY CLUSTERED 
(
	[id_klienta] ASC,
	[id_paczki] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


--SPRAWDZANIE TABEL

--komora

IF 'id_paczkomatu' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Komora')
BEGIN
	ALTER TABLE Komora ADD id_paczkomatu int NOT NULL;
END




-- paczka

-- a)
IF 'id_kuriera' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Paczka')
BEGIN
	ALTER TABLE Paczka ADD id_kuriera int NOT NULL;
END

-- b)
IF 'id_klienta' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Paczka')
BEGIN
	ALTER TABLE Paczka ADD id_klienta int NOT NULL;
END

-- c)
IF 'id_komory' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Paczka')
BEGIN
	ALTER TABLE Paczka ADD id_komory int NOT NULL;
END


--opinia

-- a)

IF 'id_paczki' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Paczka')
BEGIN
	ALTER TABLE Opinia ADD id_paczki int NOT NULL;
END


-- b)

IF 'id_klienta' NOT IN (SELECT c.name 
					   FROM sys.tables t JOIN sys.columns c ON t.object_id = c.object_id 
					   WHERE t.name = 'Paczka')
BEGIN
	ALTER TABLE Opinia ADD id_klienta int NOT NULL;
END


-- relacje

ALTER TABLE [Paczka] ADD FOREIGN KEY ([id_kuriera]) REFERENCES [Kurier] ([id_kuriera])
GO

ALTER TABLE [Paczka] ADD FOREIGN KEY ([id_klienta]) REFERENCES [Klient] ([id_klienta])
GO

ALTER TABLE [Komora] ADD FOREIGN KEY ([id_paczkomatu]) REFERENCES [Paczkomat] ([id_paczkomatu])
GO

ALTER TABLE [Paczka] ADD FOREIGN KEY ([id_komory]) REFERENCES [Komora] ([id_komory])
GO

ALTER TABLE [Opinia] ADD FOREIGN KEY ([id_klienta]) REFERENCES [Klient] ([id_klienta])
GO

ALTER TABLE [Opinia] ADD FOREIGN KEY ([id_paczki]) REFERENCES [Paczka] ([id_paczki])
GO

-- ograniczenia
--paczkomat
if OBJECT_ID('dbo.[UNQ_lok_paczkomatu]', 'UQ') is not null 
alter table [Paczkomat]
drop constraint UNQ_lok_paczkomatu
go

alter table [Paczkomat] add constraint UNQ_lok_paczkomatu
unique (id_lokalizacji)

--kurier a

if OBJECT_ID('dbo.[UNQ_mailKuriera]', 'UQ') is not null 
alter table [Kurier]
drop constraint UNQ_mailKuriera
go

alter table [Kurier] add constraint UNQ_mailKuriera
unique (email)

--kurier b
if OBJECT_ID('dbo.[UNQ_nrKuriera]', 'UQ') is not null 
alter table [Kurier]
drop constraint UNQ_nrKuriera
go

alter table [Kurier] add constraint UNQ_nrKuriera
unique (nr_kontaktowy)



--klient 
if OBJECT_ID('dbo.[UNQ_mailKlienta]', 'UQ') is not null 
alter table [Klient]
drop constraint UNQ_mailKlienta
go

alter table [Klient] add constraint UNQ_mailKlienta
unique (email)

--klient 
if OBJECT_ID('dbo.[UNQ_nrKlienta]', 'UQ') is not null 
alter table [Klient]
drop constraint UNQ_nrKlienta
go

alter table [Klient] add constraint UNQ_nrKlienta
unique (nr_telefonu)



/*
________________________________________
Kod wspomagaj¹cy aplikacjê
________________________________________*/
use [Obsluga_paczkomatow]
go

create or alter proc pkuriera
@id int
as
select * from Kurier 
inner join Paczka on Kurier.id_kuriera = Paczka.id_kuriera where Kurier.id_kuriera = @id
-------------------------------------------------
create or alter proc pklienta
@id int
as
select * from Klient
inner join Paczka on Klient.id_klienta = Paczka.id_kuriera where Klient.id_klienta = @id
-------------------------------------------------
create or alter view liczbaKlientów as
select count(id_klienta) as liczbaKlientów from Klient
-------------------------------------------------
create or alter proc naszePunkty
as
begin
	select * from Paczkomat
end
-- -------------------------------------------------
create or alter view liczbaKurierów as
select count(id_kuriera) as liczbaKurierów from Kurier
-------------------------------------------------
create or alter view liczbaPaczkomatów as
select count(id_paczkomatu) as liczbaPaczkomatów from Paczkomat
-------------------------------------------------
create or alter proc zmianaWAplikacji 
@ap char(1), 
@klient int
as
begin
	update Klient
	set aplikacja = @ap
	where id_klienta = @klient
end
-------------------------------------------------
create or alter proc [dbo].[spDodajPaczkomat]
@idlokalizacji int
as
begin
	insert into Paczkomat (id_lokalizacji) values(@idlokalizacji)
end


/*
________________________________________
Niedeklaratywne metody sprawdzania 
poprawnoœci danych
________________________________________*/

use [Obsluga_paczkomatow]
go
--Kurier
--  walidacja adresu email kuriera
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[emailKuriera] ON [dbo].[Kurier] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT email FROM inserted) NOT LIKE '%_@%_.__%'))
BEGIN
RAISERROR('Niepoprawny adres mailowy',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END

--  komunikat pojawiaj¹cy siê je¿eli do pola not null nie wpiszemy wartoœci
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notNullKurier] ON [dbo].[Kurier] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT imie FROM inserted) is null ) OR ((SELECT nazwisko FROM inserted) is null) OR ((SELECT nr_kontaktowy FROM inserted) is null)  
OR ((SELECT firma FROM inserted) is null) OR ((SELECT praca_od FROM inserted) is null))
BEGIN
RAISERROR('Brak obowi¹zkowej wartoœci',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END



--Klient
--- walidacja adresu email klienta
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[emailKlienta] ON [dbo].[Klient] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT email FROM inserted) NOT LIKE '%_@%_.__%'))
BEGIN
RAISERROR('Niepoprawny adres mailowy',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END
-- komunikat pojawiaj¹cy siê je¿eli do pola not null nie wpiszemy wartoœci
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notNullKlient] ON [dbo].[Klient] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT imie FROM inserted) is null ) OR ((SELECT nazwisko FROM inserted) is null) 
OR ((SELECT nr_telefonu FROM inserted) is null)  OR ((SELECT aplikacja FROM inserted) is null))
BEGIN
RAISERROR('Brak obowi¹zkowej wartoœci',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END


--Komora
--komunikat pojawiaj¹cy siê je¿eli do pola not null nie wpiszemy wartoœci
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notNullKomora] ON [dbo].[Komora] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT rozmiar FROM inserted) is null ) OR ((SELECT rozmiar FROM inserted) is null) )
BEGIN
RAISERROR('Brak obowi¹zkowej wartoœci',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END


--Paczka
--  walidacja terminu dostarczenia paczki do paczkomatu
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER [dbo].[dostarczeniePaczki] ON [dbo].[Paczka] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
DECLARE @today date
DECLARE @delivery date
SET @today = GETDATE()
SET @delivery = (SELECT data_do_paczkomatu FROM inserted)
IF((DATEDIFF(DD,@delivery, GETDATE()) < DATEDIFF(DD,@today, GETDATE())) ) 
BEGIN
RAISERROR('B³¹d w dacie dostarczenia paczki',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END
-- komunikat pojawiaj¹cy siê je¿eli do pola not null nie wpiszemy wartoœci
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notNullPaczka] ON [dbo].[Paczka] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT typ FROM inserted) is null ) OR ((SELECT data_do_paczkomatu FROM inserted) is null) )
BEGIN
RAISERROR('Brak obowi¹zkowej wartoœci',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END


--Opinia
--  walidacja daty odbioru 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[dataOdbioru] ON [dbo].[Opinia] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
DECLARE @received date
DECLARE @wPaczkomacie date
SET @wPaczkomacie = (select data_do_paczkomatu from dbo.Paczka)
SET @received= (SELECT data_odbioru FROM inserted)
IF((DATEDIFF(DD,@received, GETDATE()) > DATEDIFF(DD, @wPaczkomacie, GETDATE())+7) OR (DATEDIFF(DD,@received, GETDATE()) > GETDATE())) 
BEGIN
RAISERROR('B³¹d w dacie odbioru paczki',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END

--  walidacja daty wystawienia opinii
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[dataOpinii] ON [dbo].[Opinia] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
DECLARE @opinion date
DECLARE @wPaczkomacie date
SET @wPaczkomacie = (select data_do_paczkomatu from dbo.Paczka)
SET @opinion= (SELECT data_odbioru FROM inserted)
IF((DATEDIFF(DD,@opinion, GETDATE()) > DATEDIFF(DD, @wPaczkomacie, GETDATE())+14)) 
BEGIN
RAISERROR('B³¹d w dacie opinii',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END



-- komunikat pojawiaj¹cy siê je¿eli do pola not null nie wpiszemy wartoœci
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notNullOpinia] ON [dbo].[Opinia] AFTER INSERT AS
BEGIN
SET NOCOUNT ON;
IF(((SELECT data_oceny FROM inserted) is null ) OR ((SELECT data_odbioru FROM inserted) is null) )
BEGIN
RAISERROR('Brak obowi¹zkowej wartoœci',14,1);
ROLLBACK TRANSACTION;
RETURN;
END
END

/*
________________________________________
Testowanie bazy danych
________________________________________*/

use [Obsluga_paczkomatow]
go
select * from Klient
-- dodawanie klientów
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Anna', 'Kowalskac', 'kowalska@o2.pl', '0', '479822178')
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Aleksandra', 'B¹k', 'bak@gmail.pl', '0', '323654876')
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Alicja', 'B¹k', 'alicja@wp.pl', '1', '879654892')
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Aleksandra', 'Kwarc', 'kwarc@gmail.pl', '0', '761098050')
--insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Olaf', 'Kwarc', 'kwarc@gmail.pl', '0', '761098050')



-- dodawanie paczkomatów o zadanej lokalizacji
exec dbo.spDodajPaczkomat @idlokalizacji=5
go

exec dbo.spDodajPaczkomat @idlokalizacji=4
go

exec dbo.spDodajPaczkomat @idlokalizacji=3
go

dbo.spDodajPaczkomat @idlokalizacji=2
go

dbo.spDodajPaczkomat @idlokalizacji=1
go

--b³¹d
--dbo.spDodajPaczkomat @idlokalizacji='x'
go

-- dodawanie kurierów
select * from Kurier
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Artur', 'Wiœniewski', 'artur@wp.pl', '879879879', 'Pocztex', '2020-01-01', null )
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Artur', 'Kowal', 'arturkowal@o2.pl', '973602012', 'Pocztex', '2020-07-01', 'Spóznienie dnia 12.05.2022r.' )
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Krystian', 'Wróbel', 'krystian.w@wp.pl', '999653021', 'Pocztex', '2021-07-03', null )
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Zbigniew', 'Wiœnia', 'wisnia@wp.pl', '746982013', 'Pocztex', '2022-05-01', 'St³uczenie paczki dnia 02.05.2022r.' )


-- dodawanie komór
select * from Komora
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (1, 'wielka', '1')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (5, 'du¿a', '1')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (2, 'ma³a', '0')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (4, 'œrednia', '1')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (3, 'mini', '0')
--insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (7, 'mini', '0')

-- dodawanie paczek
select * from Paczka

insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1, 3, 5, 'wysy³ka', '2022-05-06')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (2, 2, 2, 'wysy³ka', '2022-05-07')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1, 2, 3, 'przesy³ka', '2022-05-04')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (3, 1, 1, 'wysy³ka', '2022-05-05')


-- wyœwietlanie liczby paczkomatów
select * from liczbaPaczkomatów

-- wyœwietlanie liczby klientów
select * from liczbaKlientów

-- wyœwietlanie liczby kurierów
select * from liczbaKurierów

-- wyœwietlanie wszystkich paczkomatów
exec naszePunkty

-- zmiana pola aplikacja w tabeli Klient
exec zmianaWAplikacji @ap='1', @klient=1011


-- paczki danego klienta
exec pklienta @id=1012


-- paczki które dostarczy³ dany kurier
exec pkuriera @id=7
