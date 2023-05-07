-- Q1. Find how much amount spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent.

-- SOLUTION :
with best_selling_artist AS ( 
 Select artist.artist_id as artist_id, artist.name as artist_name, 
 Sum(invoice_line.unit_price*invoice_line.quantity) AS total_sales
 from invoice_line
 JOIN track ON track.track_id = invoice_line.track_id
 JOIN album ON album.album_id = track.album_id
 JOIN artist ON artist.artist_id = album.artist_id
 Group By 1
 ORDER BY 3 DESC
 LIMIT 1)

Select customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name,
   sum(invoice_line.unit_price*invoice_line.quantity) As amount_spent
   FROM invoice
  JOIN customer On customer.customer_id = invoice.customer_id
  JOIN invoice_line On invoice_line.invoice_id = invoice.invoice_id
  JOIN track ON track.track_id = invoice_line.track_id
  JOIN album ON album.album_id = track.album_id
  JOIN best_selling_artist On best_selling_artist.artist_id = album.artist_id
  GROUP BY 1,2,3,4
  ORDER BY 5 DESC;

-- Q2. We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amout of purchases. Write a query that returns each 
-- country along with the top Genre. For countries where the maximum number of purchases is shared 
-- return all Genres.

-- SOLUTION :
  WITH popular_genre AS
    (SELECT COUNT(invoice_line.quantity) AS purchases, customer.country,genre.name, genre.genre_id, 
     ROW_NUMBER()OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNO
      FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON customer.customer_id = invoice.customer_id
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre ON genre.genre_id = track.genre_id
   GROUP BY 2,3,4
   ORDER BY 2 ASC, 1 DESC )
    SELECT * FROM  popular_genre ORDER BY RowNo <= 1 desc ;


-- Q3. Write a query that determines the customer that has spent the most on music for each country 
-- Write a query that returns the country along with the top customer and how much they spent. For 
-- countries where the top amount spent is shared, provide all customers  who spent this  amount 

-- SOLUTION : 
    USE music_store;
    WITH RECURSIVE
    customer_with_country AS (
       SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
       FROM invoice
       JOIN customer ON customer.customer_id = invoice.customer_id
       GROUP BY 1,2,3,4
       ORDER BY 2,3  DESC),
     
  country_max_spending AS (
      SELECT billing_country,MAX(total_spending) AS max_spending
      FROM customer_with_country
      GROUP BY billing_country)
  Select customer_with_country.billing_country, customer_with_country.total_spending, customer_with_country.first_name,
      customer_with_country.last_name, customer_with_country.customer_id
  FROM customer_with_country
  JOIN country_max_spending
ON customer_with_country.billing_country = country_max_spending.billing_country;

-- METHOD 2
WITH customer_with_country AS(
      SELECT customer.customer_id, first_name,last_name,billing_country,SUM(total) AS total_spending,
      ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY sum(total) DESC)  AS RowNo
      FROM Invoice
      JOIN customer ON customer.customer_id = invoice.customer_id
      GROUP BY 1,2,3,4
      ORDER BY 4 ASC,5 DESC)
      
SELECT * FROM customer_with_country WHERE RowNo  <= 1  order by RowNo  <= 1 desc;
  