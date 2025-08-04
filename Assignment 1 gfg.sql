create database if not exists gfg;
use  gfg;
show databases;
show tables;
select * from restaurants;
-- Which restaurant of delhi is visited by least number of people
select * from restaurants where city='Delhi' and rating_count=(Select min(rating_count) from restaurants where city='Delhi');

-- Which restaurant has generated maximum revenue over india
select * from restaurants where cost*rating_count=(Select max(cost*rating_count) from restaurants);

-- How many restaurants are having rating more than average rating
select * from restaurants where rating>(select avg(rating) from restaurants);

-- Which restaurant in delhi has generated most revenue?
select * from restaurants where city='Delhi' and cost*rating_count=(select max(cost*rating_count) from restaurants where city='Delhi');

-- Which restaurant chain has maximum no of restaurants?
select name, count(name) as 'no_of_res' from restaurants
group by name
order by count(name) desc limit 10;
-- Subway, Domino's Pizza,Pizza Hut,KFC,McDonald's have most no of restaurant chains

-- Which restaurant chain has maximum  revenue ?
select name, sum(cost*rating_count) as 'revenue' from restaurants
group by name
order by sum(cost*rating_count) desc;


-- Which city has maximum no of restaurants
select city,count(*) as num_res from restaurants
group by city
order by count(*) desc;


-- Which city has generated maximum revenue all over India?
Select city, sum(cost*rating_count) as 'revenue' from restaurants group  by city
order by sum(cost*rating_count) desc;


-- List 10 least expensive cuisines
Select cuisine,avg(cost) from restaurants group by cuisine order by avg(cost) asc limit 10;

-- List 10 most expensive cuisines
Select cuisine,avg(cost) from restaurants group by cuisine order by avg(cost) desc limit 10;

-- Which city is having Biryani as the most famous cuisine?
Select city,count(*) as 'cnt' from restaurants 
where cuisine='Biryani' 
group by city order by count(*) desc limit 1;


-- WINDOW FUNCTIONS

-- 1. Rank every restaurant from most expensive to least expensive
SELECT *,RANK() OVER(ORDER BY COST DESC) AS 'rank', dense_rank() over(order by cost desc) as 'dense_rank' from restaurants;

-- 2. Rank every restaurant from most visited to least visited
SELECT *,RANK() OVER(ORDER BY rating_count DESC) AS 'rank', dense_rank() over(order by rating_count desc) as 'dense_rank' from restaurants;

-- 3. Rank every restaurant from most expensive to least expensive as per their city
select *, dense_rank() over(partition by city order by cost desc) as 'rank',row_number() over(partition by city order by cost desc) as 'row_num'from restaurants;

-- 4. Rank every restaurant from most expensive to least expensive as per their city along with its city [Adilabad - 1, Adilabad - 2]
select *, concat(city,'-',row_number() over(partition by city order by cost desc)) as 'rank_city' from restaurants;

-- 5. Find top 5 restaurants of every city as per their revenue
select * from 
        (select * ,row_number() over(partition by city order by rating_count*cost desc) as 'rank_city' from restaurants)t
where t.rank_city<6;