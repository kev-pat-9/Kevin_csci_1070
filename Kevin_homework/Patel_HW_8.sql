-- 1
Alter table rental add column status varchar(225);
Select return_date, rental_date,
Case
    When return_date > rental_date + INTERVAL '7 days' then 'Late'
    When return_date < rental_date + INTERVAL '7 days' then 'Early'
    Else 'On Time'
End as status
From rental;

-- 2
Select sum(p.amount) as total_payment, c.first_name,
c.last_name
From payment p left join rental r on p.rental_id = r.rental_id
Left join customer c ON r.customer_id = c.customer_id
Left join address a ON c.address_id = a.address_id
Left join city ON a.city_id = city.city_id
Where city.city in ('Kansas City', 'Saint Louis')
Group by c.first_name, c.last_name;

-- 3
Select c.name as category_name, count(fc.film_id) as film_count
From category c Left join film_category fc 
On c.category_id = fc.category_id
Group by c.name;

-- 4
-- This allows a film to belong to multiple categories and a category
-- to include multiple films. It makes the database more flexible.

-- 5
Select f.film_id, f.title, f.length
From film f left join inventory i on f.film_id = i.film_id
Left join rental r on i.inventory_id = r.inventory_id
Where r.return_date between '2005-05-15' and '2005-05-31';
	
-- 6
Select f.film_id, f.title, p.amount
From film f left join inventory i on f.film_id = i.film_id
Left join rental r on i.inventory_id = r.inventory_id
Left join payment p on r.rental_id = p.rental_id
Where p.amount < (select avg(amount) from payment);

-- 7
Select count(case when return_date > rental_date + INTERVAL 
			 '7 days' then 1 end) as late,
			 count(case when return_date < rental_date + INTERVAL 
				   '7 days' then 1 end) as early,
				   count(case when return_date = rental_date + 
						 INTERVAL '7 days' then 1 end) as ontime
From rental;

-- 8
Select f.film_id,f.title,f.length,
Percent_rank() over (order by f.length) as rank
From film f;

-- 9
Explain Select c.name as category_name, count(fc.film_id) as film_count
From category c Left join film_category fc 
On c.category_id = fc.category_id
Group by c.name;
-- This plan is using a hashaggregate operation to group by c.name, it
-- is also joing 2 tables, there is no sorting in this plan.
Explain Select f.film_id,f.title,f.length,
Percent_rank() over (order by f.length) as rank
From film f;
-- The second plan is using windowagg operation to sort the results
-- by length, this one only uses one table.
