--1
select * from payment where amount >= 9.99;

-- 2
select amount ,title from payment p left join rental r on p.rental_id = r.rental_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id
where amount = 11.99

--3
select first_name,last_name,email,address,city,country 
from staff s left join address a on s.address_id = a.address_id
left join city c on a.city_id = c.city_id
left join country cc on c.country_id = cc.country_id

--4
-- I am looking for financial analyst postions in various sectors.