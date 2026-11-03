select *
from employee;
..........1. Who is the senior most employee based on job title?
select *
from employee
#order by hire_date
order by levels desc
limit 1;
...........2. Which countries have the most Invoices?
select count(*) as totalcount,billing_country
from invoice
group by billing_country
order by totalcount desc
............3. What are top 3 values of total invoice?
select total
from invoice
order by total desc
limit 3;
................4. Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals
SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;
......................5. Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money
select sum(v.total) as totalinvoice,c.customer_id,c.first_name,c.last_name
from customer c
inner join invoice v
on c.customer_id=v.customer_id
group by c.customer_id
order by totalinvoice desc 
limit 1;
...........1. Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A
SELECT DISTINCT c.first_name, c.last_name, c.email
FROM customer c
INNER JOIN invoice i
    ON c.customer_id = i.customer_id
INNER JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
WHERE track_id IN (
    SELECT track_id
    FROM track t
    INNER JOIN genre g
        ON t.genre_id = g.genre_id
    WHERE g.name = 'Rock'
)
order by c.email


SELECT DISTINCT
    email AS Email,
    first_name AS FirstName,
    last_name AS LastName,
    genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoiceline ON invoiceline.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoiceline.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

................2. Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands

SELECT
    COUNT(t.track_id) AS totalTrackCount,
    ar.name,
    ar.artist_id
FROM artist ar
INNER JOIN album al
    ON ar.artist_id = al.artist_id
INNER JOIN track t
    ON al.album_id = t.album_id
INNER JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id
ORDER BY totalTrackCount DESC
LIMIT 10;
..............3. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first

SELECT name,miliseconds
FROM track
WHERE miliseconds > (
	SELECT AVG(miliseconds) AS avg_track_length
	FROM track )
ORDER BY miliseconds DESC;

...............1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent
select ar.name as artistName,sum(il.unit_price*il.quantity) as totalSpent ,
concat(c.first_name,'',c.last_name) as customerName
from customer c
inner join invoice i
on c.customer_id=i.customer_id
inner join invoice_line il
on il.invoice_id=i.invoice_id
inner join track t
on t.track_id=il.track_id
inner join  album al
on al.album_id= t.album_id
inner join artist ar
on ar.artist_id=al.artist_id
group by ar.artist_id,ar.name,c.customer_id,c.first_name,c.last_name
order by totalSpent desc;


select ar.name as artistName,sum(il.unit_price*il.quantity) as totalSpent ,
CONCAT(TRIM(c.first_name), ' ', TRIM(c.last_name)) AS customer_name 
from customer c
inner join invoice i
on c.customer_id=i.customer_id
inner join invoice_line il
on il.invoice_id=i.invoice_id
inner join track t
on t.track_id=il.track_id
inner join  album al
on al.album_id= t.album_id
inner join artist ar
on ar.artist_id=al.artist_id
GROUP BY c.customer_id, ar.artist_id
order by totalSpent desc;
.............................2. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres

SELECT
    iv.billing_country,
    g.name AS genre,
    SUM(il.quantity) AS total_purchases

FROM invoice iv

INNER JOIN invoice_line il
    ON iv.invoice_id = il.invoice_id

INNER JOIN track t
    ON t.track_id = il.track_id

INNER JOIN genre g
    ON g.genre_id = t.genre_id

GROUP BY
    iv.billing_country,
    g.genre_id,
    g.name

HAVING SUM(il.quantity) = (

    SELECT MAX(genre_total.total_quantity)

    FROM (
        SELECT
            SUM(il2.quantity) AS total_quantity

        FROM invoice iv2

        INNER JOIN invoice_line il2
            ON iv2.invoice_id = il2.invoice_id

        INNER JOIN track t2
            ON t2.track_id = il2.track_id

        INNER JOIN genre g2
            ON g2.genre_id = t2.genre_id

        WHERE iv2.billing_country = iv.billing_country

        GROUP BY g2.genre_id, g2.name

    ) AS genre_total

)

ORDER BY iv.billing_country;
..............................3. Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount
select iv.billing_country,sum(total) as toalMoneySpent,concat(trim(c.first_name),' ',trim(c.last_name)) as CustomerName
from invoice iv
inner join customer c
on iv.customer_id=c.customer_id
group by iv.billing_country,c.customer_id,c.first_name,c.last_name
having sum(total)=(
select max(customerSpending.total2)
from LATERAL(
select sum(iv2.total) as total2
 from invoice iv2
inner join customer c2
on iv2.customer_id=c2.customer_id
where iv2.billing_country=iv.billing_country
group by c2.customer_id,c2.first_name,c2.last_name) as customerSpending

)




