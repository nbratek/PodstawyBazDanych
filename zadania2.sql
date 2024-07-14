
select distinct p.ProductName, c.CategoryName, s.CompanyName, o.OrderDate
from Products p
inner join Suppliers s on p.SupplierID = s.SupplierID
inner join Categories c on p.CategoryID = c.CategoryID
left join [Order Details] od on p.ProductID = od.ProductID
left join Orders o on od.OrderID = o.OrderID and OrderDate not between '1997.02.20' and '1997.02.25'
where c.CategoryName = 'Beverages' and o.OrderID is not null

--

select distinct p.ProductName, c.CategoryName, od.UnitPrice
from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
join Categories c on p.CategoryID = c.CategoryID
join Customers on o.CustomerID = Customers.CustomerID
where o.OrderDate between '1997-03-01' and '1997-03-31'
and Country <> 'France'

--

select distinct o.OrderID
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Shippers s on o.ShipVia = s.ShipperID
join Products on od.ProductID = Products.ProductID
join Categories c on Products.CategoryID = c.CategoryID
where OrderDate between '1997-03-01' and '1997-05-31'
    and s.CompanyName = 'United Package'
    and o.OrderID not in (
        select distinct o.OrderID
        from Orders o
        join [Order Details] od on o.OrderID = od.OrderID
        join Shippers s on o.ShipVia = s.ShipperID
        join Products on od.ProductID = Products.ProductID
        join Categories c on Products.CategoryID = c.CategoryID
        where c.CategoryName = 'Confections'
    )