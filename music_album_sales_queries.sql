
create database musicdata;
use musicdata;
 #Q.1. who is name the senior most employee based on job title?
 
select*from employee
order by levels
desc
limit  1;
 
 #Q.2. which countries have the most invoices?
 
 select count(billing_country) , billing_country from invoice
 group by billing_country
 order by count(billing_country) desc;
 
 #what are top 3 values of total invoice
 
 
select total  from invoice

order by total desc

;

# which city has the best customers? we would like to throw a promotional music festival in the city
# we made the most money.write a query that returnsone city that has the highest sum of invoice totals.
 #Return both the city name &sum of all invoice totals.
 select*from invoice;
 select billing_city, sum(total) from invoice 
 group by billing_city
 order by sum(total) desc
 limit 1;
 
 
 #who is the best customer? the customer who has spent the most money
 #will be declared the best customer. Write a query that returns the person who has spent the most money.
 
 select customer_id,sum(total) as "money_spent" from invoice
 group by "money_spent" desc
 limit 1
 ;
 -- best customer on basis of spent money, name
 select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as Total from customer join invoice
 on customer.customer_id= invoice.customer_id
 group by customer.customer_id
 order by total desc
 limit 1;
 
 /** write qury to return the email, first name, last name, & Genre of all 
 rock music listners. Return your list ordered alphabetically by email starting with A.
 **/
 select distinct email, first_name, last_name
 from customer
 join invoice on customer.customer_id= invoice.customer_id
 join invoice_line on invoice.invoice_id=invoice_line.invoice_id 
where tracK_id in(
 select track_id from track_2
 
 join genre on track_2.genre_id=genre.genre_id
where genre.name like 'rock')
order by email;



/** lets invite the artist who have written the most rock music in our dataset. 
write a query that returns the artist name and total track count of the top 10 rock bands.**/

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track_2 
join album on album.album_id= track_2.album_id
join artist on artist.artist_id= album.artist_id
join genre on genre.genre_id=track_2.genre_id
where genre.name like 'rock'
group by artist.artist_id
order by number_of_songs desc

limit 10;

/** return all the track names that have a song length longer than the average song length.
return the name and milliseconds for each track.order by the song length with the longest songs.alter

**/


select name,milliseconds from track_2
where milliseconds>(select avg(milliseconds) as average_length 
from track_2)
order by milliseconds desc;



/** find how much amount spent by each customer on artists?write a 
Query to return customer name, artist name and total spent.
**/

 -- with best_selling_artist as (
select artist.artist_id as artist_id, artist.name as artist_name, 
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track_2 on track_2.track_id = invoice_line.track_id
join album on album.album_id = track_2.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by  3 desc
limit 1;

-- we want to find most popular music genre for each country by highest amount.
with popular_genre as
(
select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as rowno
from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track_2 on track_2.track_id=invoice_line.track_id
join genre on genre.genre_id= track_2.genre_id
group by 2,3,4
order by 2 asc, 1 desc
)
select*from popular_genre where rowno<=1
;

--   customer spending most on music for each country
-- and money spent, and customer name --
with customer_with_country as (
select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
row_number() over (partition by billing_country order by sum(total) desc) as rowno
from invoice
join customer on customer.customer_id=  invoice.customer_id
group by 1,2,3,4
order by 4 asc, 5 desc)
select*from customer_with_country where rowno<=1
;
