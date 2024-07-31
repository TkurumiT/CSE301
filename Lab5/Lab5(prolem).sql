use assignment3;
show tables;

-- 1. Display the clients (name) who lives in same city.
select *
from clients
where city in (
				select city
                from clients
                group by city
                having count(*)>=2)
order by city ;

-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
SELECT c.city, c.client_name, s.salesman_name
FROM clients c
JOIN salesman s 
WHERE c.city = 'Thu Dau Mot';

-- 3. Display client name, client number, order number, salesman number, and product number for each order.
SELECT c.client_name, so.client_number, so.order_number, so.salesman_number, sod.product_number from salesorder so
inner join salesorderdetails sod on so.order_number = sod.order_number 
inner join clients c on so.client_number = c.client_number;

-- 4. Find each order (client_number, client_name, order_number) placed by each client. 
select c.client_number, c.client_name, so.order_number 
from  salesorder so
inner join clients c ;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by them.
select c.client_number, c.client_name , Count(so.order_number)
from clients c 
inner join salesorder so on c.client_number = so.client_number
where so.order_number in ( select order_number from salesorder where order_status = 'Successful')
Group by c.client_number; 

-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders. 
select c.client_number, c.client_name , Count(so.order_number) 
from clients c 
inner join salesorder so on c.client_number = so.client_number
where so.order_number in ( select order_number from salesorder where order_status = 'Successful')
Group by c.client_number ;

-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select salesman_name
from salesman s inner join salesorder so on s.salesman_number = so.Salesman_Number
				inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
group by Salesman_Name
having sum(Order_Quantity) > 20;

-- 8. Find the salesman names who sells more than 20 products.
select salesman_name 
from salesman s 
inner join salesorder sod on sod.Salesman_Number = s.Salesman_Number 
inner join salesorderdetails sodd on sod.Order_Number = sodd.Order_Number 
group by salesman_name 
having sum(order_quantity) > 20 ;

-- 9. Display the client information (client_number, client_name) and order number of those clients who have order status is cancelled.
select c.client_number, c.client_name , Count(so.order_status) as order_status
from clients c 
inner join salesorder so on c.client_number = so.client_number
where so.order_number in ( select order_number from salesorder where order_status = 'cancelled')
Group by c.client_number ;

-- 10. Display client name, client number of clients C101 and count the number of orders which were received “successful”.
select c.client_number, c.client_name , Count(so.order_status) as order_status
from clients c 
inner join salesorder so on c.client_number = so.client_number
where so.order_number in ( select order_number from salesorder where order_status = 'Successful' and Client_Number = 'C101')
Group by c.client_number ;

-- 11. Count the number of clients orders placed for each product.

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product number.b) Using nested query with operator (IN, EXISTS, ANY and ALL).
select product_number , count(*)
from (
select distinct Client_number , product_number
from salesorder o inner join salesorderdetails od on o.order_number = od.order_number) as T
group by product_number
having count(*) > 2
order by count(*) desc;

-- 13. Find the salesman’s names who is getting the second highest salary.
select  salesman_name
from salesman
where salary = (
    SELECT MAX(salary)
    FROM Salesman
    WHERE salary < (
        SELECT MAX(salary)
        FROM Salesman
    )
);

-- 14. Find the salesman’s names who is getting second lowest salary.
select  salesman_name
from salesman
where salary = (
    SELECT min(salary)
    FROM Salesman
    WHERE salary > (
        SELECT min(salary)
        FROM Salesman
    )
);

-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the salesman whose salesman number is S001.
select  salesman_name, salary
from salesman
where salary > (
	select salary
    from salesman
    where salesman_number = 'S001'
);

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select s.Salesman_Name
from salesman s
inner join salesorder so on s.salesman_number = so.salesman_number
	join salesorderdetails sod on so.order_number = sod.order_number
where sod.product_number = 'P1002';
-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal to 5.
select p.product_name
from product p
where p.product_number in(select sod.product_number from salesorderdetails sod
	where sod.order_quantity = 5
);
-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select distinct s.Salesman_Name, s.Salesman_Number
from salesman s
	inner join salesorder so on s.Salesman_Number = so.Salesman_Number
    inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
    inner join product p on sod.Product_Number = p.Product_Number
where p.Product_Name in ('Pen', 'TV', 'Laptop');
-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand more than 50.
select s.salesman_name
from salesman s
inner join salesorder so on s.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
inner join product p on sod.Product_Number = p.Product_Number
where p.sell_price < 800 and quantity_on_hand > 50;
-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average salary.
select salesman_name, salary
from salesman
where salary > (
		select avg(salary)
		from salesman
);
-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the average amount paid.II. Additional excersice:
select client_name, amount_paid
from clients
where amount_paid > (select avg(amount_paid) from clients);
-- 23. Find the product price that was sold to Le Xuan.
select p.sell_price
from product p
inner join salesorderdetails sod on p.product_number = sod.product_number
inner join salesorder so on sod.order_number = so.order_number
inner join  clients c on so.client_number = c.client_number
where c.client_name = 'Le Xuan';
-- 24. Determine the product name, client name and amount due that was delivered.
select p.Product_Name, c.Client_Name, c.amount_due
from product p
inner join salesorderdetails sod on p.Product_Number = sod.Product_Number
inner join salesorder so on sod.Order_Number = so.Order_Number
inner join clients c on so.Client_Number = c.Client_Number
where so.delivery_status = 'Delivered';
-- 25. Find the salesman’s name and their product name which is cancelled.
select s.Salesman_Name, p.Product_Name
from salesman s
inner join salesorder so on s.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
inner join product p on sod.Product_Number = p.Product_Number
where so.order_status = 'Cancelled';
-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information for each customer.
-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been successful but the items have not yet been delivered to the client.
-- 29. Find each clients’ product which in on the way.
select c.client_name,p.product_name,so.delivery_status
from clients c
inner join  salesorder so on c.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number
inner join product p on sod.product_number = p.product_number
where so.delivery_status = 'On Way';
-- 30. Find salary and the salesman’s names who is getting the highest salary.
select salesman_name,salary
from salesman
where salary = (select max(salary) from salesman);
-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select salesman_name, salary
from salesman
where salary = (select min(salary) from salesman
	where salary > (select min(salary) from salesman
	)
);
-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more than 9.
select distinct p.product_name
from product p
inner join salesorderdetails sod on p.product_number = sod.product_number
where sod.order_quantity > 9;
-- 33. Find the name of the customer who ordered the same item multiple times.
select c.client_name,sod.product_number
from clients c
inner join salesorder so on c.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number
group by c.client_name, sod.product_number
having count(sod.order_number) > 1;
-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average salary and works in any of Thu Dau Mot city.
select salesman_name, salesman_number, salary
from salesman
where salary < (select avg(salary) from salesman)
	and city = 'Thu Dau Mot';
-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to highest.
select s.Salesman_Name, s.Salesman_Number, s.salary
from salesman s
where s.salary > ( select max(s2.salary) from salesman s2
	inner join salesorder so on s2.salesman_number = so.salesman_number
    where so.order_status = 'Cancelled'
)
order by s.salary asc;
-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
select max(salary) as fourth_max_salary
from salesman
where salary < ( select max(salary) from salesman
	where salary < ( select max(salary) from salesman
		where salary < ( select max(salary) from salesman)));
-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
select min(salary) as Third_min_salary
from salesman
where salary > ( select min(salary) from salesman
	where salary > ( select min(salary) from salesman));