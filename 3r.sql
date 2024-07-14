-- Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy
-- 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy

select ProductName, UnitPrice, Address, City, Country
from Products as P
inner join Suppliers as S
on P.SupplierID = S.SupplierID
where UnitPrice BETWEEN 20.00 and 30.00

-- Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych
-- przez firmę ‘Tokyo Tradersʼ

select ProductName, UnitsInStock
from Products as P
inner join Suppliers as S
on P.SupplierID = S.SupplierID
where S.CompanyName = 'Tokyo Traders'

-- Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to
-- pokaż ich dane adresowe

select C.CustomerID
from Customers as C
left outer join Orders as O
on C.CustomerID = O.CustomerID and YEAR(O.OrderDate) = 1997
where O.OrderID is null

-- Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których
-- aktualnie nie ma w magazynie

select CompanyName, Phone
from Suppliers as S
inner join Products P on S.SupplierID = P.SupplierID
where UnitsInStock = 0


-- Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy
-- 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas
-- tylko produkty z kategorii ‘Meat/Poultryʼ

select ProductName, UnitPrice, Address
from Products
inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
inner join Categories
on Products.CategoryID = Categories.CategoryID
where (UnitPrice between 20.00 and 30.00)  and CategoryName = 'Meat/Poultry'

-- Wybierz nazwy i ceny produktów z kategorii ‘Confectionsʼ dla każdego produktu podaj
-- nazwę dostawcy

select ProductName, UnitPrice, CompanyName
from Products
inner join Categories
on Products.CategoryID = Categories.CategoryID
inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
where CategoryName = 'Confections'

-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma ‘United Packageʼ


select distinct Customers.CompanyName, Customers.Phone
from Customers
inner join Orders
on Customers.CustomerID = Orders.CustomerID
inner join Shippers
on Orders.ShipVia = Shippers.ShipperID
where YEAR(OrderDate) = 1997 and Shippers.CompanyName = 'United Package'


-- Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- ‘Confectionsʼ

select distinct Customers.CompanyName, Customers.Phone
from Customers
inner join Orders
on Customers.CustomerID = Orders.CustomerID
inner join [Order Details]
on Orders.OrderID = [Order Details].OrderID
inner join Products
on [Order Details].ProductID = Products.ProductID
inner join Categories
on Products.CategoryID = Categories.CategoryID
where CategoryName = 'Confections'


--Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza
--northwind)

select e2.FirstName, e2.LastName, e1.FirstName, e1.LastName
from Employees e1
inner join Employees e2
on e1.EmployeeID=e2.ReportsTo


-- . Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza
-- northwind)

select distinct e1.FirstName, e1.LastName
from Employees e1
inner join Employees e2
on e1.EmployeeID=e2.ReportsTo
where e1.ReportsTo is null

-- Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
-- nazwę klienta.

select O.OrderID, sum(Quantity), C.CompanyName
from Orders O
inner join [Order Details] OD
on  O.OrderID = OD.OrderID
inner join Customers C
on O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName


-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250

select O.OrderID, sum(Quantity), C.CompanyName
from Orders O
inner join [Order Details] OD
on  O.OrderID = OD.OrderID
inner join Customers C
on O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
having sum(Quantity) > 250

-- Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta.

select O.OrderID, sum(Quantity*UnitPrice* (1-Discount)), C.CompanyName
from Orders O
inner join [Order Details] OD
on O.OrderID = OD.OrderID
inner join Customers C
on O.CustomerID = C.CustomerID
group by O.OrderID, C.CompanyName


-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250

select O.OrderID, sum(Quantity*UnitPrice* (1-Discount)), C.CompanyName
from Orders O
inner join [Order Details] OD
on O.OrderID = OD.OrderID
inner join Customers C
on O.CustomerID = C.CustomerID
group by O.OrderID, C.CompanyName
having sum(Quantity) > 250

-- Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko pracownika
-- obsługującego zamówień

select O.OrderID, sum(Quantity*UnitPrice* (1-Discount)), C.CompanyName, E.FirstName, E.LastName
from Orders O
inner join [Order Details] OD
on O.OrderID = OD.OrderID
inner join Customers C
on O.CustomerID = C.CustomerID
inner join Employees E
on O.EmployeeID = E.EmployeeID
group by O.OrderID, C.CompanyName, E.FirstName, E.LastName
having sum(Quantity) > 250


-- Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.

select C.CategoryName, SUM(Quantity)
from Categories C
inner join Products P
on C.CategoryID = P.CategoryID
inner join [Order Details] OD
on P.ProductID = OD.ProductID
group by C.CategoryName

-- . Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
-- klientów jednostek towarów z tek kategorii.

select C.CategoryName, SUM(Quantity* P.UnitPrice*(1-Discount))
from Categories C
inner join Products P
on C.CategoryID = P.CategoryID
inner join [Order Details] OD
on P.ProductID = OD.ProductID
group by C.CategoryName


-- Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
-- b) łącznej liczby zamówionych przez klientów jednostek towarów.

select C.CategoryName, SUM(Quantity* P.UnitPrice*(1-Discount)) as suma
from Categories C
inner join Products P
on C.CategoryID = P.CategoryID
inner join [Order Details] OD
on P.ProductID = OD.ProductID
group by C.CategoryName
order by suma, sum(Quantity)

-- Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę

select O.OrderID, (sum(UnitPrice*(1-Discount)*Quantity) + O.Freight)
from Orders O
inner join [Order Details] OD
on O.OrderID = OD.OrderID
GROUP BY O.OrderID, O.Freight


-- Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r

select S.CompanyName, count(*)
from Shippers S
inner join Orders O
on S.ShipperID = O.ShipVia
where year(OrderDate) = 1997
group by CompanyName

-- Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w
-- 1997r, podaj nazwę tego przewoźnika

select Top 1 CompanyName, count(*)
from Shippers
inner join Orders O
on Shippers.ShipperID = O.ShipVia
where YEAR(OrderDate) = 1997
group by CompanyName

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika

select E.FirstName, E.LastName, sum(Quantity*UnitPrice*(1-Discount))
from Employees E
inner join Orders O
on E.EmployeeID = O.EmployeeID
inner join [Order Details] OD
on O.OrderID = OD.OrderID
group by E.FirstName, E.LastName

-- Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika

select TOP 1 E.FirstName, E.LastName, count(*)
from Employees E
inner join Orders O
on E.EmployeeID = O.EmployeeID
where YEAR(OrderDate) = 1997
group by E.FirstName, E.LastName
order by count(*) desc

-- Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o największej
-- wartości) w 1997r, podaj imię i nazwisko takiego pracownika

select top 1 E.FirstName, E.LastName, sum(Quantity*UnitPrice*(1-Discount)) as v
from Employees E
inner join Orders O
on E.EmployeeID = O.EmployeeID
inner join [Order Details]
on O.OrderID = [Order Details].OrderID
where year(OrderDate) = 1997
group by e.FirstName, E.LastName
order by v desc

--  Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych

select E.FirstName, E.LastName, sum(Quantity*UnitPrice*(1-Discount))
from Employees E
inner join Employees E2
on E.EmployeeID = E2.ReportsTo
inner join Orders O
on E.EmployeeID = O.EmployeeID
inner join [Order Details] OD
on O.OrderID = OD.OrderID
group by E.EmployeeID, E.FirstName, E.LastName





