use [Obsluga_paczkomatow]
go
select * from Klient
-- dodawanie klient�w
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Anna', 'Kowalskac', 'kowalska@o2.pl', '0', '479822178')
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Aleksandra', 'B�k', 'bak@gmail.pl', '0', '323654876')
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Alicja', 'B�k', 'alicja@wp.pl', '1', '879654892')
insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Aleksandra', 'Kwarc', 'kwarc@gmail.pl', '0', '761098050')
--insert into Klient (imie, nazwisko, email, aplikacja, nr_telefonu) values ('Olaf', 'Kwarc', 'kwarc@gmail.pl', '0', '761098050')



-- dodawanie paczkomat�w o zadanej lokalizacji
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

--b��d
--dbo.spDodajPaczkomat @idlokalizacji='x'
go

-- dodawanie kurier�w
select * from Kurier
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Artur', 'Wi�niewski', 'artur@wp.pl', '879879879', 'Pocztex', '2020-01-01', null )
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Artur', 'Kowal', 'arturkowal@o2.pl', '973602012', 'Pocztex', '2020-07-01', 'Sp�znienie dnia 12.05.2022r.' )
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Krystian', 'Wr�bel', 'krystian.w@wp.pl', '999653021', 'Pocztex', '2021-07-03', null )
insert into Kurier(imie, nazwisko, email,nr_kontaktowy, firma, praca_od, uwagi) values ('Zbigniew', 'Wi�nia', 'wisnia@wp.pl', '746982013', 'Pocztex', '2022-05-01', 'St�uczenie paczki dnia 02.05.2022r.' )


-- dodawanie kom�r
select * from Komora
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (1, 'wielka', '1')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (5, 'du�a', '1')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (2, 'ma�a', '0')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (4, '�rednia', '1')
insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (3, 'mini', '0')
--insert into Komora(id_paczkomatu, rozmiar, czy_wolna) values (7, 'mini', '0')

-- dodawanie paczek
select * from Paczka
delete from Paczka where id_paczki = 6
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1009, 1011, 1007, 'wysy�ka', '2022-05-06')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1010, 1012, 1008, 'wysy�ka', '2022-05-07')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1011, 1013, 1009, 'przesy�ka', '2022-05-04')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (7, 1014, 1011, 'wysy�ka', '2022-05-05')


-- wy�wietlanie liczby paczkomat�w
select * from liczbaPaczkomat�w

-- wy�wietlanie liczby klient�w
select * from liczbaKlient�w

-- wy�wietlanie liczby kurier�w
select * from liczbaKurier�w

-- wy�wietlanie wszystkich paczkomat�w
exec naszePunkty

-- zmiana pola aplikacja w tabeli Klient
exec zmianaWAplikacji @ap='1', @klient=1011


-- paczki danego klienta
exec pklienta @id=1012


-- paczki kt�re dostarczy� dany kurier
exec pkuriera @id=7