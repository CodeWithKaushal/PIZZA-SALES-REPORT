CREATE TABLE Pizza_sales (
    pizza_id int,
    order_id int,
    pizza_name_id varchar(100),
    quantity int,
    order_date date,
    order_time time,
    unit_price float,
    total_price float,
    pizza_size varchar(100),
    pizza_category varchar(100),
    pizza_ingredients varchar(200),
    pizza_name varchar(100)
);


COPY public.pizza_sales (pizza_id, order_id, pizza_name_id, quantity, order_date, order_time, unit_price, total_price, pizza_size, pizza_category, pizza_ingredients, pizza_name) 
FROM 'C:/Program Files/PostgreSQL/16/data/Data_Copy/pizza_sales.csv' 
DELIMITER ',' 
CSV 
HEADER;


select * from Pizza_sales;



--  1] Total Revenue

select sum(total_price) As Total_Revenue from pizza_sales;

-- 2] Average Order Value

select (sum(total_price) / (count(DISTINCT order_id))) As Average_Order_Value from pizza_sales;

-- 3] Total Pizza sold
select sum(quantity) as Total_Pizza_sold from pizza_sales;

-- 4] Total Orders  

select count(distinct order_id) as Total_orders from pizza_sales

-- 5] Average Pizza Per Order

select cast(cast(sum(quantity) As decimal(10,2))/
cast(count(distinct order_id) as decimal (10,2)) as decimal (10,2))
As Avg_Pizzas_per_order
from pizza_sales;


-- 6] Daily Trend for total orders

SELECT TO_CHAR(order_date, 'Day') AS order_day, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TO_CHAR(order_date, 'Day');

-- 7] Monthly Trend for Orders

SELECT TO_CHAR(order_date, 'Month') AS month_name, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TO_CHAR(order_date, 'Month');


-- 8] D. % of Sales by Pizza Category

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

--  9] % of Sales by Pizza Size

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size


-- 10] Total Pizzas Sold by Pizza Category

SELECT pizza_category, SUM(quantity) AS total_quantity_sold
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 2
GROUP BY pizza_category
ORDER BY total_quantity_sold DESC;

-- 11] Top 5 Pizzas by Revenue

SELECT Top_5_pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC




