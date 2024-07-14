
select e.FirstName, e.LastName,
       isnull((select c.CompanyName from Customers c where c.CustomerID = xx.custid), 'brak') klient,
       isnull(xx.ilosc_zam, 0) as ilosc_zam
    from(
        select x.EmployeeID,
               max(x.ilosc_zam) ilosc_zam,
               max(x.CustomerID) custid
            from(
                select e.EmployeeID, count(OrderID) ilosc_zam, o.CustomerID
                    from Employees e
                    left join Orders o on e.EmployeeID = o.EmployeeID
                    where year(OrderDate) = 1997
                    group by e.EmployeeID, o.CustomerID
                ) x
            group by x.EmployeeID
        ) xx
right join Employees e on e.EmployeeID=xx.EmployeeID
order by xx.ilosc_zam desc

--

select c.CompanyName,
       isnull((select e.FirstName,e.LastName from Employees e where e.EmployeeID = x.empID), 'brak') pracownik,
       isnull(x.ilosc_zam, 0) as ilosc_zam
from (
    select x.CustomerID,
           max(x.ilosc_zam) ilosc_zam,
           max(x.EmployeeID) empID
        from(
            select c.CustomerID, count(OrderID) ilosc_zam, o.EmployeeID
                from Customers c
                left join Orders o on c.CustomerID = o.CustomerID
                where year(OrderDate) = 1997
                group by c.CustomerID, o.EmployeeID
            ) x
        group by x.CustomerID
     ) x
right join Customers c on c.CustomerID = x.CustomerID
order by x.ilosc_zam desc