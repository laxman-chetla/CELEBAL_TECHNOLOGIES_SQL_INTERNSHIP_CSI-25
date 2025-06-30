--Celebal Summer Internship SQL domain
--CSI ID: CT_CSI_SQ_1310
--Name:CHETLA LAXMAN
--WEEK 6 assignment (leetcode questions)








--1.Find Duplicate Emails

select Email from person group by email having count(*)>1;


--2.Customer Who never order

SELECT name AS Customers
FROM Customers
WHERE id NOT IN (SELECT customerId FROM Orders);


--3.Employees Earning More Than Their Managers (LeetCode 181)

select E.name as Employee from Employee E Join employee M on E.managerId =M.id where E.salary>M.salary;

--4.Classes More Than 5 Students
select class
 from courses 
 group by class
having count(student)>=5;

--5.Invalid Tweets (LeetCode 1683)

select tweet_id from tweets where length(content)>15;

--6.Combine Two Tables
  SELECT firstName, lastName, city, state
FROM Person
LEFT JOIN Address ON Person.personId = Address.personId;


--7.Article views

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id;



--8.Big Countries (LeetCode 595)
vSELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;


--9.Find Customer Referee (LeetCode 584)

SELECT name
FROM Customer
WHERE referee_id !=2 or referee_id is null;

--10. Recyclable and Low Fat Products (LeetCode 1757)
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';


--11.Customer Placing the Largest Number of Orders

select customer_number 
from orders 
group by customer_number 
order by count(*) desc
limit 1;

