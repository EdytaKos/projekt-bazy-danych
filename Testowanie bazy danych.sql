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
delete from Paczka where id_paczki = 6
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1009, 1011, 1007, 'wysy³ka', '2022-05-06')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1010, 1012, 1008, 'wysy³ka', '2022-05-07')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (1011, 1013, 1009, 'przesy³ka', '2022-05-04')
insert into Paczka(id_kuriera, id_klienta, id_komory, typ, data_do_paczkomatu) values (7, 1014, 1011, 'wysy³ka', '2022-05-05')


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