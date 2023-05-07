-- Q1. Which countries have the most invoices??

-- SOLUTION : 
SELECT count(*) as C, billing_country
 FROM invoice
 group by billing_country
 order by C desc ;


-- Q2. what are the top 3 values of total invoice?

-- SOLUTION : 
SELECT total from invoice
order by total desc
limit 3 ;


-- Q3. Which city has the best customers? We would like to throw a promotional Music Festival in th ecity we made the most money
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

-- SOLUTION : 
Select sum(total) As invoice_total, billing_city from Invoice
group by billing_city 
order by invoice_total desc;


-- Q4. Who is the best customer? The customer who has spent the most money will be declared th ebest customer.
-- Write a query that returns th eperson who has spent the most money

-- SOLUTION : 
Select customer.customer_id,customer.first_name,customer.last_name, sum(invoice.total) as total 
From customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;

-- Q5. Who is the senior most employee based on the job title??

-- SOLUTION :
SELECT * FROM employee
order by Levels desc
limit 1;




