use Obsluga_paczkomatow
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
IF((DATEDIFF(DD,@delivery, GETDATE()) > DATEDIFF(DD,@today, GETDATE())) ) 
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

