
with xDane as (
    select e.EmployeeID,e.FirstName, e.LastName,(UnitPrice * Quantity * (1- Discount)) cena , o.OrderID
        from Employees e
        left join Orders o on e.EmployeeID = o.EmployeeID
        left join [Order Details] od on o.OrderID = od.OrderID
        where year(OrderDate) = 1997 and month(OrderDate) = 2
),
xDane2 as (
    select x.EmployeeID, x.FirstName, x.LastName, count(x.OrderID)ilosc, sum(x.cena) as cena, max(x.OrderID) as orderid
        from xDane x
        group by x.EmployeeID, x.FirstName, x.LastName
)
select e.FirstName, e.LastName, isnull(x.ilosc, 0), isnull(round(x.cena + (select Freight from orders o where o.OrderID=x.orderid),2),0) wartosc_zam
    from Employees e
left join xDane2 x on x.EmployeeID = e.EmployeeID
order by ilosc desc

--

with xDane as
(
	select p.ProductID, p.ProductName, (od.Quantity*od.UnitPrice)-od.Discount wartosc
	  from Products p
	  join [Order Details] od on p.ProductID = od.ProductID
	  join orders o on od.OrderID = o.OrderID
	  join Categories c on c.CategoryID = p.CategoryID
	 where c.CategoryName = 'confections'
	   and year(o.orderdate) = 1997
	   and month(o.orderdate) = 3
)
select p.ProductName, ISNULL(ROUND(SUM(x.wartosc), 2), 0) as wartosc
  from Products p
  left join xDane x on x.ProductID = p.ProductID
  group by p.ProductName
  order by ISNULL(ROUND(SUM(x.wartosc), 2), 0) desc;

--


with xDane as (select p.ProductName, s.CompanyName, count(p.ProductID) ile_razy, p.ProductID
               from Products p
                        inner join Categories c on p.CategoryID = c.CategoryID
                        inner join [Order Details] od on p.ProductID = od.ProductID
                        inner join Orders o on od.OrderID = o.OrderID
                        left join Shippers s on o.ShipVia = s.ShipperID
               where c.CategoryName = 'Seafood'
                 and year(orderdate) = 1997
                 and month(o.OrderDate) = 4
               group by p.ProductName, s.CompanyName, p.ProductID)
select distinct x.CompanyName, x.ile_razy, x.ProductName
    from xDane x
where x.ProductName = (select top 1 xx.ProductName
						   from xdane xx
						  where xx.CompanyName = x.CompanyName
						    and xx.ile_razy = (select MAX(xxx.ile_razy)
												 from xDane xxx
												where xxx.CompanyName = xx.CompanyName));