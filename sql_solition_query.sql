# Q1 Who is the senior most employee based on job title?

select title, first_name, last_name from employee
order by levels desc
limit 1;

# Which countries have the most Invoices?

select billing_country, count(invoice_id) as invoice_count from invoice
group by billing_country
order by invoice_count desc;

# Q3: What are top 3 values of total invoice?

select total from invoice
order by total desc
limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city, sum(total) as total_sum from invoice
group by billing_city
order by total_sum desc
limit 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

with cte as (
select customer_id, sum(total) as total_spend from invoice
group by customer_id
)

select cte.customer_id, customer.first_name, customer.last_name, cte.total_spend from cte
join customer on cte.customer_id = customer.customer_id
order by cte.total_spend desc
limit 1;

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct invoice.customer_id,customer.email, customer.first_name, customer.last_name from invoice_line
join track
on invoice_line.track_id = track.track_id and track.genre_id = 1
join invoice
on invoice.invoice_id = invoice_line.invoice_id
join customer
on customer.customer_id = invoice.customer_id
order by customer.email;

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.name,COUNT(artist.artist_id)as total_tracks from track
join album
on album.album_id = track.album_id
join artist
on album.artist_id = artist.artist_id
join genre ON genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by total_tracks desc
limit 10;

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name, milliseconds from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

select customer.customer_id, customer.first_name, customer.last_name, artist.name as artist_name, sum(total) as spend from invoice
join customer
on customer.customer_id = invoice.customer_id
join invoice_line
on invoice.invoice_id = invoice_line.invoice_id
join track
on track.track_id = invoice_line.track_id
join album
on album.album_id = track.album_id
join artist
on artist.artist_id = album.artist_id
group by 1,2,3,4
order by customer.first_name;

/* Q10: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with Customter_with_country as (
		select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
	    row_number() over(partition by billing_country order by sum(total) desc) as RowNo 
		from invoice
		join customer on customer.customer_id = invoice.customer_id
		group by 1,2,3,4
		order by 4 asc,5 desc)
select * from Customter_with_country
where RowNo <= 1;






