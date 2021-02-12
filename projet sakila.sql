use sakila; 
#question 1
select * from sakila.actor limit 5;

#question 2 
select concat(first_name," ",last_name) as Actor_Name  from actor;

#question 3 
select concat(lower(first_name)," ",last_name) as Actor_Name  from actor;

#question 4 
select concat(upper(left(first_name,1)),".",last_name) as Actor_Name  from actor;

#question 5
select * from sakila.actor where first_name like "JENNIFER";

#question 6
select * from sakila.actor where length(first_name) = 3;

#question 7
select actor_id, first_name, last_name, char_length(first_name), char_length(last_name) from sakila.actor order by length(first_name) desc;

#question 8
select actor_id, first_name, last_name, char_length(first_name), char_length(last_name) from sakila.actor order by length(first_name) desc, length(last_name) asc ;

#question 9
select * from sakila.actor where last_name like "%SON%";

#question 10
select * from sakila.actor where last_name like "JOH%";

#question 11
select first_name, last_name from sakila.actor where last_name like "%LI%" order by (last_name) asc, (first_name) asc;

#question 12
select country from sakila.country where country in ("China", "Afghanistan" ,"Bangladesh");

#question 13
alter table sakila.actor add middle_name varchar(30) after first_name;

#question 14
alter table sakila.actor modify middle_name blob;

#question 15
alter table sakila.actor drop middle_name;
alter table sakila.actor drop Actor_Name;

#question16
SELECT *,count(last_name) FROM sakila.actor group by last_name having count(last_name)>1 order by count(last_name) desc;

#question17
SELECT last_name, count(last_name) FROM sakila.actor group by last_name having count(last_name)>= 3 order by (last_name) ASC;

#question18
select first_name, count(first_name) from sakila.actor group by first_name order by count(last_name) asc;
select * from sakila.actor;

#question19
insert into sakila.actor values (0,'ALAIN','NGABO', CURRENT_TIMESTAMP() );

#question20
update sakila.actor set first_name ='JEAN' where actor_id = 201;

#question21
delete from sakila.actor where actor_id = 201;

#question22
update sakila.actor set first_name ='HARPO'where actor_id = 172;

#question23 SET first_name = IF(first_name="ALAN","ALLAN","MUCHO ALLAN") WHERE actor_id = 173;
update sakila.actor set first_name  = 
	case
		when first_name = 'ALAN' then 'ALLAN'
        else 'MUCHO ALLAN'
	end 
where actor_id=173;

#question24
select * from sakila.actor;
select *, s.first_name, s.last_name, a.address from sakila.staff as s left outer join sakila.address as a using (address_id);

#question25 
#Afficher pour chaque membre du staff 
#,le total de ses salaires depuis Aout 2005. RQ: Utiliser les tables staff & payment

select s.first_name, s.last_name, sum(p.amount) from sakila.payment as p join sakila.staff as s using(staff_id) where p.payment_date like "2005-08-%" group by p.staff_id ;

#question26
#Afficher pour chaque film ,le nombre de ses acteurs Afficher pour chaque film ,le nombre de ses acteurs

#select f.title, count(a.actor_id) from sakila.film as f inner join sakila.film_actor as a using(film_id) group by a.actor_id;
SELECT * FROM film;
SELECT film.film_id, title, count(actor_id) AS nbr_actor 
FROM film INNER JOIN film_actor USING(film_id) GROUP BY film_id;

#question27

select* from sakila.film where title like "Hunchback Impossible";

#question 28 
#combien de copies exist t il dans le systme d'inventaire pour le film Hunchback Impossible

SELECT COUNT(i.inventory_id), f.title FROM sakila.inventory as i join sakila.film as f using(film_id) WHERE f.title='Hunchback Impossible' ;

#question 29
#Afficher les titres des films en anglais commençant par 'K' ou 'Q'
SELECT  f.title, l.language_id FROM sakila.language as l join sakila.film as f using(language_id) WHERE l.language_id=1 and f.title like "k%" or f.title like "Q%"; 
SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id = (SELECT language_id FROM language WHERE name = 'English'); 

SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id = 1;
#question 30
#Afficher les first et last names des acteurs qui ont participé au film intitulé 'ACADEMY DINOSAUR'
SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor USING (actor_id)
INNER JOIN film USING (film_id)
WHERE film.title = 'ACADEMY DINOSAUR';

#question 31
#Trouver la liste des film catégorisés comme family films.

SELECT film.title
FROM film
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE category.name = 'Family';

#Question 32 
#Afficher le top 5 des films les plus loués par ordre decroissant
SELECT film.title, COUNT(inventory.film_id) AS NbRental
FROM film
INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
GROUP BY inventory.film_id
ORDER BY NbRental DESC
LIMIT 5;

#autre manière 

SELECT title, count(rental_id) AS nbr_rental FROM film, inventory, rental 
    WHERE film.film_id = inventory.film_id AND inventory.inventory_id = rental.inventory_id
    GROUP BY title
    ORDER BY nbr_rental DESC
    LIMIT 5;
    
    #auttremanière


#question 33
SELECT store.store_id, city.city, country.country FROM store
    INNER JOIN address ON store.address_id=address.address_id
    INNER JOIN city ON address.city_id=city.city_id
    INNER JOIN country ON city.country_id=country.country_id;
    
#question 34
SELECT store_id,ci.city, co.country, sum(p.amount) as chiffre_daffaire
FROM sakila.payment p
left join sakila.staff sta
using(staff_id)
left join sakila.store sto
using(store_id)
left join sakila.address a 
on a.address_id=sto.address_id
left join sakila.city ci 
using(city_id)
left join sakila.country co 
using(country_id)
group by sta.store_id;
#question 37 
SELECT cat.name, sum(p.amount) as revenues FROM sakila.payment p
left join sakila.rental r
using(rental_id)
left join sakila.inventory i
using(inventory_id)
left join sakila.film_category c
using(film_id)
left join sakila.category cat
using(category_id)
group by cat.name
order by revenues desc
limit 5;

#question 36
use sakila; 
CREATE VIEW top_five_genres AS 
SELECT cat.name, sum(p.amount) as revenues FROM sakila.payment p
left join sakila.rental r
using(rental_id)
left join sakila.inventory i
using(inventory_id)
left join sakila.film_category c
using(film_id)
left join sakila.category cat
using(category_id)
group by cat.name
order by revenues desc
limit 5;

#Question 37
drop view sakila.top_five_genres;