select*from walmart;

select count(*) from walmart;

--Business Problems 
--Question: What are the different payment methods, and how many transactions and
--items were sold with each method?
select payment_method,
                count(*) as No_of_payments,
				sum(quantity) as Transactions
				from walmart
				group by payment_method;

--Which category received the highest average rating in each branch?
select * from (

select branch, category,
              Avg(rating) as Avg_Rating,
			  RANK() over(partition by branch order by avg(rating)desc)as rank
			from walmart
			  group by branch,category
			  ) where rank =1;
			  
--What is the busiest day of the week for each branch based on transaction volume?
select *
from
    (select branch,to_char(to_date(date,'DD/MM/YY'),'Day') as Day_name,
	count(*) as no_of_transactions,
	rank() over(partition by branch order by count(*) desc) as rank
	from walmart
	group by 1,2
	)where rank=1;

--: How many items were sold through each payment method?
select payment_method,sum(quantity) as Items_sold
                                     from walmart
									 group by payment_method;

--What are the average, minimum, and maximum ratings for each category in each city?
select city,category,
           avg(rating) as Avg_rating,
		   min(rating) as Min_rating,
		   max(rating) as Max_rating
		   from walmart
		   group by city,category;

--: What is the total profit for each category, ranked from highest to lowest?
select category,
               sum(total * profit_margin) as Total_profit,
			   sum(total) as total_revenue
		       from walmart
			   group by category;
--What is the most frequently used payment method in each branch?
with cte as
(select branch,payment_method ,
              count(*) as Total_Trans,
			  rank() over (partition by branch order by count(*)desc) as rank
              from walmart
			  group by branch,payment_method)
			  select*from cte where rank=1;

--How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
SELECT
	branch,
CASE 
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC



