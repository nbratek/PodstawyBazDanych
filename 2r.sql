select top 5 orderid, productid, quantity
from [order details]
order by quantity desc

select top 5 with ties orderid, productid, quantity
from [order details]
order by quantity desc

select count (*)
from employees

select count (reportsto)
from employees

select avg(unitprice)
from products

--  Podaj liczbę produktów o cenach mniejszych niż 10 lub większych niż 20

select count(ProductID)
from Products
where UnitPrice < 10.00 or UnitPrice > 20.00

-- Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20

select MAX(UnitPrice)
from Products
where UnitPrice < 20.00

--  Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o produktach
-- sprzedawanych w butelkach (‘bottleʼ)

select MAX(UnitPrice) as mx, min(UnitPrice) as mn, AVG(UnitPrice) as sr
from Products
where QuantityPerUnit like '%bottle%'

-- Wypisz informację o wszystkich produktach o cenie powyżej średniej

select ProductName, QuantityPerUnit
from Products
where UnitPrice > (select AVG(UnitPrice)
                   from Products)

-- Podaj sumę/wartość zamówienia o numerze 10250

select SUM(UnitPrice * Quantity * (1-Discount))
from [Order Details]
where OrderID = 10250

select *
from [Order Details]

-- Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia

select OrderID, MAX(UnitPrice)
from [Order Details]
group by OrderID

-- Posortuj zamówienia wg maksymalnej ceny produktu

select OrderID, MAX(UnitPrice) as mx
from [Order Details]
group by OrderID
order by mx desc

-- Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia

select OrderID, MAX(UnitPrice) as mx, MIN(UnitPrice) as mn
from [Order Details]
group by OrderID


-- Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów
-- (przewoźników)

select SupplierID, COUNT(ProductID)
from Products
group by SupplierID

--Który ze spedytorów był najaktywniejszy w 1997 roku

select TOP 1 ShipVia
from Orders
where YEAR(OrderDate) = 1997
group by ShipVia
order by count(OrderDate) desc

--. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5

select OrderID, count(*)
from [Order Details]
group by OrderID
having count(*) > 5

-- Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
-- (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z
-- klientów

select CustomerID, COUNT(*)
from Orders
where YEAR(OrderDate) = 1998
group by CustomerID
having COUNT(*) >8
order by sum(Freight) desc


--  Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia w tablicy
-- order details i zwraca wynik posortowany w malejącej kolejności (wg wartości
-- sprzedaży).

select OrderID, SUM(UnitPrice*Quantity*(1- Discount)) as wartosc
from [Order Details]
group by OrderID
order by wartosc desc

-- Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10
-- wierszy

select Top 10 OrderID, SUM(UnitPrice*Quantity*(1- Discount)) as wartosc
from [Order Details]
group by OrderID
order by wartosc desc

-- Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
-- productid jest mniejszy niż 3

select ProductID, sum(Quantity)
from [Order Details]
where ProductID < 3
group by ProductID

-- Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę zamówionych
-- jednostek produktu dla wszystkich produktów

select ProductID, sum(Quantity)
from [Order Details]
group by ProductID
order by ProductID

-- Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których łączna
-- liczba zamawianych jednostek produktów jest większa niż 250

select OrderID, sum(UnitPrice*Quantity*(1-Discount)) as wartosc, sum(Quantity) as ilosc
from [Order Details]
group by OrderID
having SUM(Quantity) >250


-- Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień

select EmployeeID, count(OrderID)
from Orders
group by EmployeeID
order by EmployeeID


-- Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę" dla
-- przewożonych przez niego zamówień

select ShipVia, OrderID, SUM(Freight) as oplata
from Orders
group by ShipVia, OrderID
with rollup

-- Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę"
-- przewożonych przez niego zamówień w latach o 1996 do 1997

select ShipVia, OrderID, SUM(Freight) as oplata
from Orders
where YEAR(ShippedDate) = 1996 or YEAR(ShippedDate) = 1997
group by ShipVia, OrderID
with rollup

-- Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata i miesiące

select EmployeeID, MONTH(OrderDate) as m, YEAR(OrderDate) as r, COUNT(OrderID)
from Orders
group by EmployeeID, MONTH(OrderDate), YEAR(OrderDate)
with rollup

-- Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej kategori

select CategoryID, max(UnitPrice) as max, min(UnitPrice) as min
from Products
group by CategoryID