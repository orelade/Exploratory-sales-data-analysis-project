select 
  * 
from 
  Sales$


select 
  COUNT(*) as recordcount 
from 
  Sales$


select 
  COUNT(*) as recordcount 
from 
  Customers$


select COUNT(*) as recordcount 
from 
  Products$
------------------------------------------------------------------------------------------------------------------------------------
--List of Products Sold

select 
  distinct ProductName as product 
from 
  Products$ 

select 
  * 
from 
  Products$
---------------------------------------------------------------------------------------------------------------------
--Cost of Producing Multi color Products
select 
  sum(ProductCost) as multitotalcost 
from 
  Products$ 
where 
  ProductColor = 'multi'
------------------------------------------------------------------------------------------------------------------------------------
--Cost of White Products
select 
  sum(ProductCost) as whitetotalcost 
from 
  Products$ 
where 
  ProductColor = 'white'
-----------------------------------------------------------------------------------------------------------------------------------
--Customer Name
select 
  distinct(Prefix + FirstName + ' ' + LastName) as customername 
from 
  Customers$
-----------------------------------------------------------------------------------------------------------------------------------
--Count of Customers that have children
select 
  count(
    distinct(Prefix + FirstName + ' ' + LastName)
  ) as parentcustomercount 
from 
  Customers$ 
where 
  TotalChildren > 0

-----------------------------------------------------------------------------------------------------------------------------------
--Count of Customers that do not have children
select 
  count(
    distinct(Prefix + FirstName + ' ' + LastName)
  ) as nonparentcustomercount 
from 
  Customers$ 
where 
  TotalChildren = 0

------------------------------------------------------------------------------------------------------------------------------------
/*Getting the KPI's*/
--Sales Amount
with new as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  [OrderQuantity] * [ProductPrice] as Salesamount 
from 
  new
-----------------------------------------------------------------------------------------------------------------------------------
--Total Sales Amount
with new as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  sum([OrderQuantity] * [ProductPrice]) as Totalsalesamount 
from 
  new
------------------------------------------------------------------------------------------------------------------------------------
--Total Product Cost
select 
  sum(ProductCost) as Totalproductcost 
from 
  Products$

------------------------------------------------------------------------------------------------------------------------------------
--Total Product Cost by Product

select 
  ModelName as ProductName, 
  sum(ProductCost) as Totalproductcost 
from 
  Products$ 
group by 
  ModelName 
order by 
  Totalproductcost desc

------------------------------------------------------------------------------------------------------------------------------------
--Total Order Quantity
select 
  sum(OrderQuantity) as TotalOrderQuantity 
from 
  Sales$
----------------------------------------------------------------------------------------------------------------------
--Return Amount
with N as (
  select 
    Returns$.ReturnQuantity, 
    Products$.ProductPrice 
  from 
    Returns$ 
    inner join Products$ on Returns$.ProductKey = Products$.ProductKey
) 
select 
  [ReturnQuantity] * [ProductPrice] as ReturnAmount 
from 
  N
-----------------------------------------------=----------------------------------------------------------------------------------
--Total Return Amount
with N as (
  select 
    Returns$.ReturnQuantity, 
    Products$.ProductPrice 
  from 
    Returns$ 
    inner join Products$ on Returns$.ProductKey = Products$.ProductKey
) 
select 
  sum(
    [ReturnQuantity] * [ProductPrice]
  ) as TotalReturnAmount 
from 
  N
-----------------------------------------------=----------------------------------------------------------------------------------
--Total Return Quantity
select 
  sum(ReturnQuantity) as TotalReturnQuantity 
from 
  Returns$ 
--------------------------------------------------------------------------------------------------------------------------------------  
  --Total Order Quantity by Country
  with O as (
    select 
      Sales$.OrderQuantity, 
      Territories$.Country 
    from 
      Sales$ 
      inner join Territories$ on Sales$.TerritoryKey = Territories$.SalesTerritoryKey
  ) 
select 
  Country, 
  sum(OrderQuantity) as TotalOrderQuantity 
from 
  O 
group by 
  Country

------------------=------------------------------------------------------------------------------------------------------------------
--Total Sales Amount by Country

with D as (
  select 
    Sales$.OrderQuantity, 
    Territories$.Country, 
    Products$.ProductPrice 
  from 
    (
      (
        Sales$ 
        inner join Territories$ on Sales$.TerritoryKey = Territories$.SalesTerritoryKey
      ) 
      inner join Products$ on Sales$.ProductKey = Products$.ProductKey
    )
) 
select 
  Country, 
  sum([OrderQuantity] * [ProductPrice]) as TotalSalesAmount 
from 
  D 
group by 
  Country

------------------------------------------------=----------------------------------------------------------------------------------
--Total Sales Amount by Product
with B as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice, 
    Products$.ModelName 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  ModelName as ProductName, 
  sum([OrderQuantity] * [ProductPrice]) as TotalSalesAmount 
from 
  B 
group by 
  ModelName
------------------------------------------------=----------------------------------------------------------------------------------
--Total Return Amount by Product

with C as (
  select 
    Returns$.ReturnQuantity, 
    Products$.ProductPrice, 
    Products$.ModelName 
  from 
    Returns$ 
    inner join Products$ on Returns$.ProductKey = Products$.ProductKey
) 
select 
  ModelName as ProductName, 
  sum(
    [ReturnQuantity] * [ProductPrice]
  ) as TotalReturnAmount 
from 
  C 
group by 
  ModelName 
order by ModelName
------------------------------------------------=----------------------------------------------------------------------------------
--Total Profit
with E as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice, 
    Products$.ProductCost 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  E
------------------------------------------------=----------------------------------------------------------------------------------
--Total Profit trend

with F as (
  select 
    Sales$.OrderQuantity, 
    Sales$.OrderDate, 
    Products$.ProductPrice, 
    Products$.ProductCost 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  OrderDate, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  F 
group by 
  OrderDate 
order by 
  OrderDate desc

------------------------------------------------=----------------------------------------------------------------------------------
--profit in 2016
with F as (
  select 
    Sales$.OrderQuantity, 
    Sales$.OrderDate, 
    Products$.ProductPrice, 
    Products$.ProductCost 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  OrderDate, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  F 
where 
  OrderDate like '%2016' 
group by 
  OrderDate 
order by OrderDate desc

------------------------------------------------=----------------------------------------------------------------------------------
--profit in 2015
with F as (
  select 
    Sales$.OrderQuantity, 
    Sales$.OrderDate, 
    Products$.ProductPrice, 
    Products$.ProductCost 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  OrderDate, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  F 
where 
  OrderDate like '%2015' 
group by 
  OrderDate 
order by 
  OrderDate desc

------------------------------------------------=----------------------------------------------------------------------------------
--Total Profit by Product
with G as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice, 
    Products$.ProductCost, 
    Products$.ModelName 
  from 
    Sales$ 
    inner join Products$ on Sales$.ProductKey = Products$.ProductKey
) 
select 
  ModelName as ProductName, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  G 
group by 
  ModelName 
order by 
  TotalProfit desc

------------------------------------------------=----------------------------------------------------------------------------------

--Total Profit by Country
with H as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice, 
    Products$.ProductCost, 
    Territories$.Country 
  from 
    (
      (
        Sales$ 
        inner join Products$ on Sales$.ProductKey = Products$.ProductKey
      ) 
      inner join Territories$ on Sales$.TerritoryKey = Territories$.SalesTerritoryKey
    )
) 
select 
  Country, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  H 
group by 
  Country 
order by 
  TotalProfit desc

-------------------------------------------------=----------------------------------------------------------------------------------
--Total Profit in Australia
with H as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice, 
    Products$.ProductCost, 
    Territories$.Country 
  from 
    (
      (
        Sales$ 
        inner join Products$ on Sales$.ProductKey = Products$.ProductKey
      ) 
      inner join Territories$ on Sales$.TerritoryKey = Territories$.SalesTerritoryKey
    )
) 
select 
  Country, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  H 
  where Country = 'Australia'
group by 
  Country
order by 
  TotalProfit
-------------------------------------------------=----------------------------------------------------------------------------------

--checks if there is any missing value in country  to totalprofit field
with H as (
  select 
    Sales$.OrderQuantity, 
    Products$.ProductPrice, 
    Products$.ProductCost, 
    Territories$.Country 
  from 
    (
      (
        Sales$ 
        inner join Products$ on Sales$.ProductKey = Products$.ProductKey
      ) 
      inner join Territories$ on Sales$.TerritoryKey = Territories$.SalesTerritoryKey
    )
) 
select 
  Country, 
  (
    sum([OrderQuantity] * [ProductPrice])
  ) - (
    sum(ProductCost)
  ) as TotalProfit 
from 
  H 
where 
  Country is null 
group by 
  Country 
order by 
  TotalProfit desc

