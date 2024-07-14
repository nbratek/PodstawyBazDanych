-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.


select firstname, lastname, birth_date
from member
inner join juvenile
on juvenile.member_no = member.member_no

-- Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek

select distinct title
from title
inner join loan
on title.title_no = loan.title_no

-- Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh
-- Kingʼ. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
-- zapłacono karę

select  fine_paid, DATEDIFF(day, in_date, loanhist.due_date) as d
from loanhist
inner join title
on loanhist.title_no = title.title_no
where title = 'Tao Teh King' and DATEDIFF(day, in_date, loanhist.due_date) > 0

-- Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez
-- osobę o nazwisku: Stephen A. Graff

select isbn
from reservation
inner join member
on reservation.member_no = member.member_no
where  lastname = 'Graff' and firstname = 'Stephen'

-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania
-- dziecka.

select  member.firstname, member.lastname, juvenile.birth_date, adult.city
from member
inner join juvenile
on juvenile.member_no = member.member_no
inner join adult
on juvenile.adult_member_no = adult.member_no

-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
--library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania
--dziecka oraz imię i nazwisko rodzica.

select  member.firstname, member.lastname, juvenile.birth_date, adult.city, m2.firstname, m2.lastname
from member
inner join juvenile
on juvenile.member_no = member.member_no
inner join adult
on juvenile.adult_member_no = adult.member_no
inner join member m2
on m2.member_no=adult_member_no


-- Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996 (baza library)

select a.city, a.street
from adult a
inner join juvenile j
on a.member_no = j.adult_member_no
where YEAR(birth_date) < 1996

-- Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków
-- biblioteki, którzy aktualnie nie przetrzymują książek. (baza library)

select distinct a.city, a.street
from adult a
inner join juvenile j
on a.member_no = j.adult_member_no
inner join loanhist l
on l.member_no=a.member_no
where YEAR(birth_date) < 1996 and l.in_date < GETDATE()

-- Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż dwoje
-- dzieci zapisanych do biblioteki

select a.member_no
from adult a
inner join member m
on a.member_no = m.member_no
inner join juvenile j
on a.member_no = j.adult_member_no
where a.state = 'AZ'
group by a.member_no
having (count(a.member_no) > 2)

-- Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej niż
-- dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni (CA) i
-- mają więcej niż troje dzieci zapisanych do biblioteki

select a.member_no
from adult a
inner join member m
on a.member_no = m.member_no
inner join juvenile j
on a.member_no = j.adult_member_no
where a.state = 'AZ' or a.state = 'CA'
group by a.member_no
having (count(a.member_no) > 3)


