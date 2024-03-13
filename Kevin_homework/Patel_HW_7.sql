-- #1
Select * from customer where last_name like 'T%'
Order by first_name ASC;

-- #2
Select * from rental where return_date 
Between '2005-05-28' and '2005-06-01';

-- #3
Select f.title, count(r.rental_id) as rentalcount
From rental r left join inventory i on r.inventory_id = i.inventory_id
Left join film f on i.film_id = f.film_id
Group by f.title order by rentalcount DESC
Limit 10;

-- #4
Select c.customer_id , c.first_name, c.last_name, 
Sum(p.amount) as totalspent
From customer c left join payment p On c.customer_id = p.customer_id
Group by c.customer_id, c.first_name, c.last_name
Order by totalspent ASC;

-- #5
Select a.first_name, a.last_name, 
Count(fa.film_id) as MovieCount
From actor a left join film_actor fa on a.actor_id = fa.actor_id
Left join film f on fa.film_id = f.film_id 
Where year(f.release_year) = 2006
Group by a.first_name, a.last_name
Order by MovieCount DESC Limit 1;

-- #6
-- 4:
--"Sort  (cost=423.12..424.62 rows=599 width=49)"
--"  Sort Key: (sum(p.amount))"
--"  ->  HashAggregate  (cost=388.00..395.49 rows=599 width=49)"
--"        Group Key: c.customer_id"
--"        ->  Hash Right Join  (cost=22.48..315.02 rows=14596 width=23)"
--"              Hash Cond: (p.customer_id = c.customer_id)"
--"              ->  Seq Scan on payment p  (cost=0.00..253.96 rows=14596 width=8)"
--"              ->  Hash  (cost=14.99..14.99 rows=599 width=17)"
--"                    ->  Seq Scan on customer c  (cost=0.00..14.99 rows=599 width=17)"

-- 5:
--"Limit  (cost=276.04..276.04 rows=1 width=21)"
--"  ->  Sort  (cost=276.04..276.36 rows=128 width=21)"
--"        Sort Key: (count(fa.film_id)) DESC"
--"        ->  HashAggregate  (cost=274.12..275.40 rows=128 width=21)"
--"              Group Key: a.first_name, a.last_name"
--"              ->  Hash Join  (cost=119.50..233.15 rows=5462 width=15)"
--"                    Hash Cond: (fa.film_id = f.film_id)"
--"                    ->  Hash Join  (cost=6.50..105.76 rows=5462 width=15)"
--"                          Hash Cond: (fa.actor_id = a.actor_id)"
--"                          ->  Seq Scan on film_actor fa  (cost=0.00..84.62 rows=5462 width=4)"
--"                          ->  Hash  (cost=4.00..4.00 rows=200 width=17)"
--"                                ->  Seq Scan on actor a  (cost=0.00..4.00 rows=200 width=17)"
--"                    ->  Hash  (cost=100.50..100.50 rows=1000 width=4)"
--"                          ->  Seq Scan on film f  (cost=0.00..100.50 rows=1000 width=4)"
--"                                Filter: ((release_year)::integer = 2006)"

-- #7
Select c.name as genre, AVG(f.rental_rate) as AverageRate
From category c left join film_category fc
on c.category_id = fc.category_id
Left join film f on fc.film_id = f.film_id
Group by c.name Order by AverageRate DESC;

-- #8
Select c.name as genre, count(r.rental_id) 
As rentalcount, sum(p.amount) as totalsales
From category c left join film_category fc
On c.category_id = fc.category_id
Left join film f on fc.film_id = f.film_id
Left join inventory i on f.film_id = i.film_id
Left join rental r on i.inventory_id = r.inventory_id
Left join payment p on r.rental_id = p.rental_id
Group by c.name order by rentalcount DESC Limit 5;

-- #Extra Credit
Select c.name as genre, extract(month from r.rental_date)
As rentalmonth, count(f.film_id) as totalrented
From category c left join film_category fc
On c.category_id = fc.category_id
Left join film f on fc.film_id = f.film_id
Left join inventory i on f.film_id = i.film_id
Left join rental r on i.inventory_id = r.inventory_id
Group by extract(month from r.rental_date), c.name
Order by c.name DESC;