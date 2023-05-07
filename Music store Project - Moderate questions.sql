-- Q1. Write query to return the email,first name,last name & Genre of all rock Music listeners. return your list
-- orderd alphabetically by email starting with A

-- SOLUTION : 
   Select distinct email, first_name, last_name
   from customer
   join invoice On customer.customer_id = invoice.customer_id
   join invoice_line on invoice.invoice_id = invoice.invoice_id
   where track_id IN 
   (Select track_id from track
   join genre On track.genre_id = genre.genre_id
   where genre.name like "Rock" )
   order by email asc;

-- Q2. Let`s invite the artists who have written the most rock music in our dataset. 
-- Write a query that retuns the Artist name and total track count of the top 10 rock bands

-- SOLUTION : 
   Select artist.artist_id, artist.name ,count(artist.artist_id) As number_of_songs
   from track
   Join album on track.album_id = album.album_id
   join artist on album.artist_id = artist.artist_id
   join genre on track.genre_id = genre.genre_id
   group by artist.artist_id
   order by number_of_songs desc
   limit 10;

-- Q3. Return all the track names that have a song length longer than then average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs 
-- listed first. 

-- SOLUTION : 
   Select name, milliseconds
   From Track
   Where milliseconds > (Select avg(milliseconds) As avg_track_length
   from Track)
   order by milliseconds desc;
   


