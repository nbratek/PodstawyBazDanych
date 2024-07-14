select OrderID
from Orders
where OrderDate = '1996-08-01'

--Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie

select CompanyName
from Customers
where City = 'London'

--Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii

select CompanyName
from Customers
where Country = 'France' OR Country = 'Spain'

--Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00

select ProductName, UnitPrice
from Products
where UnitPrice between 20.00 AND 30.00

-- Wybierz nazwy i ceny produktów z kategorii 'Meat/Poultry'

select ProductName, UnitPrice
from Products
where CategoryID=(select CategoryID from Categories where CategoryName = 'Meat/Poultry')

-- Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych
-- przez firmę ‘Tokyo Tradersʼ


select ProductName, UnitsInStock
from Products
where SupplierID = (select Suppliers.SupplierID from Suppliers where CompanyName = 'Tokyo Traders')

-- . Wybierz nazwy produktów których nie ma w magazynie

select ProductName
from Products
where UnitsInStock = 0

-- Szukamy informacji o produktach sprzedawanych w butelkach (‘bottleʼ)

select * from Products

select ProductName
from Products
where QuantityPerUnit LIKE '%bottle%'

-- Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na
-- literę z zakresu od B do L

select FirstName, LastName, Title
from Employees
where LastName like '[B-L]%'

-- Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na
-- literę B lub L

select FirstName, LastName, Title
from Employees
where LastName like '[B]%' or LastName like '[L]%'

-- Znajdź nazwy kategorii, które w opisie zawierają przecinek

select * from Categories

select CategoryName
from Categories
where Description like '%,%'

-- Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo 'Store'

select * from Customers

select CompanyName
from Customers
where CompanyName like '%Store%'

-- Szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20

select ProductName, UnitPrice
from Products
where UnitPrice < 10.00 or UnitPrice > 20.00

--Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00

select ProductName, UnitPrice
from Products
where UnitPrice BETWEEN 20.00 and 30.00

--Wybierz zamówienia złożone w 1997 roku

select OrderDate, CustomerID
from Orders
where YEAR(OrderDate) = '1997'

-- Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
-- klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem odbiorcy
-- jest Argentyna

select OrderDate, OrderID, CustomerID
from Orders
where ShippedDate is NULL and ShipCountry = 'Argentina'


-- Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w ramach
-- danego kraju nazwy firm posortuj alfabetycznie

select CompanyName, Country
from Customers
order by Country, CompanyName

-- Wybierz nazwy i kraje wszystkich klientów mających siedziby we Francji lub w
-- Hiszpanii, wyniki posortuj według kraju, w ramach danego kraju nazwy firm posortuj
-- alfabetycznie

select CompanyName, Country
from Customers
where Country = 'France' or Country = 'Spain'
order by Country, CompanyName

-- Wybierz zamówienia złożone w 1997 r. Wynik po sortuj malejąco wg numeru
-- miesiąca, a w ramach danego miesiąca rosnąco według ceny za przesyłkę

select OrderID, OrderDate
from Orders
where YEAR(OrderDate) = '1997'
order by MONTH(OrderDate), Freight

-- Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250

select UnitPrice, ProductName
from Products
where ProductID in (select ProductID from [Order Details] where OrderID=10250)

-- Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą kolumnę
-- zawierającą nr telefonu i nr faksu w formacie (numer telefonu i faksu mają być
-- oddzielone przecinkiem)

select * from Suppliers

select Phone + ', ' + Fax
from Suppliers