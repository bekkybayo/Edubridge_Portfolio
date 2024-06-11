--1. List all employees with their job titles and hire dates.

select 
e.BusinessEntityID, 
    p.FirstName, 
    p.LastName, 
    e.JobTitle, 
    e.HireDate
FROM 
    HumanResources.Employee e
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID;

	--2. Find the total number of products in each category
	select
	pc.Name AS CategoryName, 
    COUNT(p.ProductID) AS TotalProducts
FROM 
    Production.Product p
JOIN 
    Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN 
    Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    pc.Name;

	--3.Retrieve the top 5 most expensive products
	select 
	ProductID, 
    Name, 
    ListPrice
from 
    Production.Product
order by
    ListPrice desc;

	--4.List the orders that were made in the last month
 
select *
from Sales.SalesOrderHeader
where OrderDate >= DATEADD(MONTH, -1, GETDATE());

--5. Find the employee with the highest salary.

select top 1 p.FirstName, p.LastName, e.Rate
from Person.Person p
JOIN HumanResources.EmployeePayHistory e on p.BusinessEntityID = e.BusinessEntityID
order by e.Rate desc;
-- 6.List all employees who were hired in the year 2010.
select p.FirstName, p.LastName, e.HireDate
from Person.Person p
JOIN HumanResources.Employee e on p.BusinessEntityID = e.BusinessEntityID
where year(e.HireDate) = 2010;

--7. Retrieve all the distinct job titles from the Employee table.

select distinct JobTitle
from HumanResources.Employee;

--8. List the names of the products that have been sold at least 12 times.

select p.Name, sum(sod.OrderQty) as TotalOrderQty
from Production.Product p
JOIN Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
group by p.Name
having sum(sod.OrderQty) >= 50;

--9.  List the customers along with the total amount they have spent.

select
c.CustomerID, p.FirstName, p.LastName, sum(soh.TotalDue) as TotalSpent
from Sales.Customer c
join Person.Person p on c.PersonID = p.BusinessEntityID
join Sales.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
group by c.CustomerID, p.FirstName, p.LastName;


--10. list the names of products that belong to the subcategories with the highest number of products.

select Name
from Production.Product
where ProductSubcategoryID IN (
    select ProductSubcategoryID
    from Production.ProductSubcategory
    where ProductSubcategoryID = (
     select top 1 ProductSubcategoryID
      from Production.Product
      group by ProductSubcategoryID
      order by count(*) desc
    )
);

--11. Find the employees who have not received any bonuses.

select 
    p.FirstName, 
    p.LastName
from 
    HumanResources.Employee e
join 
    Person.Person p on e.BusinessEntityID = p.BusinessEntityID
left join 
    Sales.SalesPerson sp on e.BusinessEntityID = sp.BusinessEntityID
where 
    sp.Bonus IS NULL;

	--12.Get the details of the most recent order placed by each customer.

	select 
    soh.SalesOrderID, 
    soh.OrderDate, 
    soh.CustomerID, 
    soh.TotalDue
from
    Sales.SalesOrderHeader soh
where 
    soh.OrderDate = (select max(soh2.OrderDate) 
                     from Sales.SalesOrderHeader soh2 
                     where soh.CustomerID = soh2.CustomerID);

--13.Retrieve the names of employees who have more than one job title.

select p.FirstName, p.LastName
from Person.Person p
join HumanResources.Employee e on p.BusinessEntityID = e.BusinessEntityID
where e.BusinessEntityID IN (
    select BusinessEntityID
    from HumanResources.EmployeeDepartmentHistory
    group by BusinessEntityID
    having count(distinct DepartmentID) > 1
);

--14.List all employees who have the title 'Sales Representative'.

select p.FirstName, p.LastName
from Person.Person p
join HumanResources.Employee e on p.BusinessEntityID = e.BusinessEntityID
where e.JobTitle = 'Sales Representative';

--15. List the products along with their product categories.
select p.Name as ProductName, pc.Name as CategoryName
from Production.Product p
join Production.ProductSubcategory ps on p.ProductSubcategoryID = ps.ProductSubcategoryID
join Production.ProductCategory pc on ps.ProductCategoryID = pc.ProductCategoryID;

