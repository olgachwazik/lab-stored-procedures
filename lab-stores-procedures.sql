use sakila;

-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. 

DELIMITER //

create procedure action_movie_renters ()
begin
 select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end // 
DELIMITER ;

call action_movie_renters ();

-- 2. Now keep working on the previously stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

DELIMITER //

create procedure renters_per_category (in film_cat varchar(50))
begin
 select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = film_cat
  group by first_name, last_name, email;
end // 
DELIMITER ;

call renters_per_category ('Action');

call renters_per_category ('Animation');

-- 3. Write a query to check the number of movies released in each movie category. 

with cte_category_film_count as
(
	select category_id, count(film_id) as number_of_movies from film_category
	group by category_id
)
select c.name as category, number_of_movies from cte_category_film_count
join category c using (category_id);
-- having number_of_movies > 70;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 

DELIMITER //

create procedure filter_categories_count (in min_count int)
begin
	with cte_category_film_count as
	(
		select category_id, count(film_id) as number_of_movies from film_category
		group by category_id
	)
	select c.name as category, number_of_movies from cte_category_film_count
	join category c using (category_id)
    having number_of_movies > min_count;
end // 
DELIMITER ;

-- Pass that number as an argument in the stored procedure.

call filter_categories_count (70);