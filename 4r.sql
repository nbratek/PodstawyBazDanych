;with t as (
select productname, categoryid, unitprice
,( select avg(unitprice)
from products as p_in
where p_in.categoryid = p_out.categoryid ) as average
from products as p_out
)
select *, UnitPrice - average as diff from t


-- Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)

select O.Freight + (select sum(OD.UnitPrice*Quantity*(1-Discount))
                        from [Order Details] as OD
                    )
from Orders as O
where OrderID = 10250

-- . Podaj łączną wartość każdego zamówienia (uwzględnij cenę za przesyłkę)

select OrderID, (O.Freight + (select sum(OD.UnitPrice*Quantity*(1-Discount))
                        from [Order Details] as OD
                    ))
from Orders as O
group by OrderID, O.Freight

-- Dla każdego produktu podaj maksymalną wartość zakupu tego produktu

select ProductName, (select max(Quantity*OD.UnitPrice*(1-Discount))
                         from [Order Details] OD
                         where P.ProductID = OD.ProductID)
from Products P

-- Dla każdego klienta podaj łączną wartość jego zamówień (bez opłaty za przesyłkę) z
-- 1996r

select O.CustomerID, (select sum(Quantity*UnitPrice*(1-Discount))
                          from [Order Details] OD
                          where O.OrderID = OD.OrderID
                )
from Orders O
where YEAR(OrderDate) =1996

--Dla każdego klienta podaj łączną wartość jego zamówień (uwzględnij opłatę za
--przesyłkę) z 1996r

select O.CustomerID, O.Freight + (select sum(Quantity*UnitPrice*(1-Discount))
                          from [Order Details] OD
                          where O.OrderID = OD.OrderID
                )
from Orders O
where YEAR(OrderDate) =1996

--  Dla każdego klienta podaj maksymalną wartość zamówień złożonych przez tego
-- klienta w 1997r

select O.CustomerID,  (select max(Quantity*UnitPrice*(1-Discount))
                          from [Order Details] OD
                          where O.OrderID = OD.OrderID
                )
from Orders O
where YEAR(OrderDate) =1997

-- Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to
-- pokaż ich dane adresowe

select C.CompanyName, C.Address, C.City
from Customers C
where C.CustomerID not in (select O.CustomerID
                               from Orders O
                               where  YEAR(OrderDate) = 1997
                               )

-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma United Package.

select C.CompanyName, C.Phone
from Customers C
where C.CustomerID in (select O.CustomerID
                           from Orders O
                           where YEAR(OrderDate) = 1997 and (select S.CompanyName
                                                             from Shippers S
                                                             where O.ShipVia = S.ShipperID)
                                                             =  'United Package')


-- Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- Confections.

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu

select ProductName
from Products P
where (select avg(P.UnitPrice) from Products P) > P.UnitPrice

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej
-- kategorii

select ProductName
from Products P
where (select avg(P1.UnitPrice) from Products P1 where P.CategoryID = P1.CategoryID) > P.UnitPrice


-- Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów
-- oraz różnicę między ceną produktu a średnią ceną wszystkich produktów

select P.ProductName, P.UnitPrice, (select avg(P1.UnitPrice)  from Products P1) as srednia, P.UnitPrice - (select avg(P2.UnitPrice) from Products P2)
from Products P

-- Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią cenę
-- wszystkich produktów danej kategorii oraz różnicę między ceną produktu a średnią
-- ceną wszystkich produktów danej kategorii

select P.ProductName, P.UnitPrice, (select avg(P1.UnitPrice)  from Products P1 where P.CategoryID = P1.CategoryID) as srednia,
       P.UnitPrice - (select avg(P2.UnitPrice) from Products P2 where P.CategoryID = P2.CategoryID)
from Products P


-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień uwzględnij
-- cenę za przesyłkę

select E.FirstName, E.LastName, (select SUM(Quantity*UnitPrice*(1-Discount))
                                     from Orders O
                                     inner join [Order Details] OD
                                     on O.OrderID = OD.OrderID
                                     where E.EmployeeID = O.EmployeeID) + (select sum(O.Freight)
                                                                           from Orders O
                                                                           where O.EmployeeID = E.EmployeeID)
from Employees E

-- Ogranicz wynik z pkt 1 tylko do pracowników
-- a) którzy mają podwładnych

select E.FirstName, E.LastName, (select SUM(Quantity*UnitPrice*(1-Discount))
                                     from Orders O
                                     inner join [Order Details] OD
                                     on O.OrderID = OD.OrderID
                                     where E.EmployeeID = O.EmployeeID) + (select sum(O.Freight)
                                                                           from Orders O
                                                                           where O.EmployeeID = E.EmployeeID)
from Employees E
where E.EmployeeID in (select E1.EmployeeID
                           from Employees E1
                           inner join Employees E2
                           on E1.EmployeeID = E2.ReportsTo)

