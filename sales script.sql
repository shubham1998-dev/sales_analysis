use amazon.sales;
select * from amazon.sales;

ALTER TABLE amazon.sales
ADD COLUMN timeofday VARCHAR(10),
ADD COLUMN dayname VARCHAR(10),
ADD COLUMN monthname VARCHAR(10);

UPDATE amazon.sales
SET timeofday = CASE 
  WHEN HOUR(date) BETWEEN 0 AND 11 THEN 'Morning'
  WHEN HOUR(date) BETWEEN 12 AND 16 THEN 'Afternoon'
  ELSE 'Evening'
END,
dayname = DAYNAME(date),
monthname = MONTHNAME(date);

select * from amazon.sales;

-- Business Questions
-- 1. What is the count of distinct cities in the dataset?
select count(distinct(city)) from amazon.sales;

-- 2. For each branch, what is corresponding city?
select distinct Branch,City from amazon.sales;

-- 3. What is the count of distinct product lines in the dataset?
select count(distinct 'Product line') from amazon.sales;

-- 4. Which payment method occurs most frequently?
select Payment, count(*) as frequency
from amazon.sales
group by Payment
order by frequency DESC
LIMIT 1;

-- 5. Which product line has the highest sales?
select 'Product line', count(*) as total_sales
from amazon.sales
group by 'Product line'
order by 'total_sales'
DESC;

-- 6. How much revenue is generated each month?
select monthname, sum(total) as revenue
from amazon.sales
group by monthname
order by revenue DESC;

-- 7. In which month did the cost of goods sold reach it's peak?
select monthname, sum(cogs) as total_cogs
from amazon.sales
group by monthname
order by total_cogs DESC;

-- 8. Which product line generates the highest revenue?
select 'Product line', sum(total) as highest_revenue
from amazon.sales
group by 'Product line'
order by highest_revenue desc;

-- 9. In which city was the highest revenue recorded?
select City, sum(total) as highest_revenue
from amazon.sales
group by City
order by highest_revenue desc;

-- 10. Which product line incurred the highest value added tax?
select 'Product line', sum('Tax 5%') as Total_vat
from amazon.sales
group by 'Product line'
order by 'Total_vat' desc;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad". 
select 'Product line', sum(total) as total_sales,
  case
    when sum(total) > (
       select avg(total_sales)
       from(
        select 'Product line', SUM(Total) as total_sales
        from amazon.sales
        group by 'Product line'
       ) as subquery
      ) then 'Good'
      else 'Bad'
     end as sales_status
     from amazon.sales
     group by 'Product line'
     order by total_sales desc
     limit 0,1000;
     
-- 12. Identify the branch that exceeded avg. no. of product sold?
select Branch, sum(Quantity) as total_quantity
from amazon.sales
group by Branch
having sum(Quantity) > (select avg(Quantity) from amazon.sales);

-- 13. Which product line is most frequently associated with each gender?
select 'Product line', Gender, count(*) as frequency
from amazon.sales
group by Gender, 'Product line'
order by frequency desc; 

-- 14.  Calculate the average rating for each product line.
select 'Product line', avg(Rating) as avg_rating
from amazon.sales
group by 'Product line'
order by avg_rating desc;

-- 15. Count the sales occurrences for each time of day on every weekday.
select timeofday, dayname, count(*) as sales_occurrence
from amazon.sales
where dayname in ('Mon', 'Tue', 'Wed', 'Thu', 'Fri')
group by timeofday, dayname
order by sales_occurrence desc;   

select timeofday, dayname, count(*) as sales_occurrence
from amazon.sales
group by timeofday, dayname
order by sales_occurrence desc;

-- 16. Identify the customer type contributing the highest revenue.
select 'Customer type', sum(Total) as highest_revenue
from amazon.sales
group by 'Customer type'
order by highest_revenue desc limit 1;

-- 17. Determine the city with highest VAT percentage.
select City,
sum('Tax 5%') as highest_vat,
sum(Total) as total_sales,
(sum('Tax 5%')/sum(Total))*100 as vat_percentage
from amazon.sales
group by City
order by vat_percentage desc limit 1;

-- 18. Identify the customer with highest VAT payments.
select 'Customer type', sum('Tax 5%') as highest_vat_payments
from amazon.sales
group by 'Customer type'
order by highest_vat_payments desc limit 1;

-- 19. what is the count of distinct customer types in dataset?
select count(distinct('Customer types')) as distinct_customers
from amazon.sales;

-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct(Payment)) as distinct_payment
from amazon.sales;

-- 21. Which customer type occurs most frequently?
select 'Customer type', count('Customer type') as frequency
from amazon.sales
group by 'Customer type'
order by frequency desc limit 1;

-- 22.Identify the customer type with the highest purchase frequency.
select 'Customer type', count(*) as highest_purchase
from amazon.sales
group by 'Customer type'
order by highest_purchase desc limit 1;

-- 23.determine the predominant gender among customer.
select Gender, count(*) as predominant_gender
from amazon.sales
group by Gender
order by predominant_gender desc limit 1;

-- 24. Examine the distribution of gender with each branch.
select Branch, Gender, count(*) as gender_count
from amazon.sales
group by Gender, Branch
order by gender_count desc;

-- 25. Identify the time of day when customer provide the most ratings.
select timeofday, count(Rating) as rating_count
from amazon.sales
group by timeofday
order by rating_count desc limit 1;

-- 26. Determine the time of day with highest customer rating for each branch.
select Branch, timeofday, avg(Rating) as average_rating
from amazon.sales
group by Branch,timeofday
order by average_rating desc;

-- 27. Identify the day of the week with highest average ratings.
select dayname, avg(Rating) as highest_rating
from amazon.sales
group by dayname
order by highest_rating desc limit 1;

-- 28. determine the day of week with the highest average rating for each brnch.
select Branch,dayname, avg(Rating) as avg_rating
from amazon.sales
group by Branch, dayname
order by avg_rating desc;
