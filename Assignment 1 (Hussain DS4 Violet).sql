#Disabling SQL Safe updates 
set sql_safe_updates = 0;

/*renaming date column because date is a SQL Keyword 
which is messing with the data*/

alter table wfp_food_prices_pakistan change date dates text;
select * from wfp_food_prices_pakistan;

/*Changing Data type of Dates column to date from text*/
update wfp_food_prices_pakistan
set dates = str_to_date(dates, "%m/%d/%Y");
alter table wfp_food_prices_pakistan
modify dates date;

/*●	Select dates and commodities for cities Quetta, Karachi, 
and Peshawar where price was less than or equal 50 PKR*/

select dates, cmname as commodity
from wfp_food_prices_pakistan
where mktname in ("Quetta", "Karachi", "Peshawar") 
and price <= 50;

/*●	Query to check number of observations against each market/city in PK*/

select mktname as city, count(*) as Observations 
from wfp_food_prices_pakistan
group by mktname;

/*●	Show number of distinct cities*/
select count(distinct mktname) as cities 
from wfp_food_prices_pakistan;

/*●	List down/show the names of cities in the table*/
select distinct mktname 
from wfp_food_prices_pakistan;

/*●	List down/show the names of commodities in the table*/
select distinct cmname 
from wfp_food_prices_pakistan;

/*●	List Average Prices for Wheat flour - Retail 
in EACH city separately over the entire period.*/

select mktname as city, round(avg(price),2) as avg_price
from wfp_food_prices_pakistan
where cmname = "Wheat flour - Retail"
group by mktname;

/*●	Calculate summary stats (avg price, max price) for 
each city separately for all cities except Karachi and 
sort alphabetically the city names, commodity names 
where commodity is Wheat (does not matter which one) 
with separate rows for each commodity*/

select mktname as city, cmname as commodity, round(avg(price),2) as avg_price, 
round(max(price),2) as max_price
from wfp_food_prices_pakistan
WHERE mktname <> 'Karachi'
and cmname like "%Wheat%"
group by mktname, cmname
order by mktname, cmname;


/*●	Calculate Avg_prices for each city for Wheat Retail and 
show only those avg_prices which are less than 30*/

select mktname as city, round(avg(price),2) as avg_price
from wfp_food_prices_pakistan
where cmname = "Wheat - Retail"
group by mktname
having avg_price < 30;

/*●	Prepare a table where you categorize prices based on a logic 
(price < 30 is LOW, price > 250 is HIGH, in between are FAIR)*/

-- Updating Price_Category based on logic
select *, 
    CASE
        WHEN price < 30 THEN 'Low'
        WHEN price > 250 THEN 'High'
        ELSE 'Fair'
    END as price_category
    from wfp_food_prices_pakistan;
    
/*●	Create a query showing date, cmname, category, 
city, price, city_category where Logic for city 
category is: Karachi and Lahore are 'Big City', Multan 
and Peshawar are 'Medium-sized city', Quetta is 'Small City'*/

select dates, cmname as commodity, category, mktname as city, price,
    CASE
        WHEN mktname in ("Karachi", "Lahore") THEN 'Big City'
        WHEN mktname in ("Multan", "Peshawar") THEN 'Medium-Sized City'
        ELSE 'Small CIty'
    END as city_category
	from wfp_food_prices_pakistan;

/*●	Create a query to show date, cmname, city, price. 
Create new column price_fairness through CASE showing
price is fair if less than 100, unfair if more than or equal to 100, 
if > 300 then 'Speculative'*/

select dates, cmname as commodity, mktname as city, price,
    CASE
        WHEN price <100 THEN 'Fair'
        WHEN price >= 100 and price <= 300 THEN 'Unfair'
        when price > 300 then 'Speculative'
    END as price_fairness
	from wfp_food_prices_pakistan;
    
    
/*●	Join the food prices and commodities table with a left join*/

select * from wfp_food_prices_pakistan
left join commodity on wfp_food_prices_pakistan.cmname = commodity.cmname;

/*●	Join the food prices and commodities table with an inner join*/

select * from wfp_food_prices_pakistan
inner join commodity on wfp_food_prices_pakistan.cmname = commodity.cmname;