SELECT * FROM pizza_db.pizza_sales LIMIT 5;

-- Total Revenue: The sum of the total price of all pizza orders.
SELECT 
    SUM(total_price) AS Total_Revenue
FROM
    pizza_db.pizza_sales;
    
--  Average Order Value: The average amount spent per order, calculated by dividing the total revenue by the total number of orders.   
SELECT 
    SUM(total_price) / COUNT(DISTINCT order_id)
FROM
    pizza_db.pizza_sales;
    
-- Total Pizzas Sold: The sum of the quantities of all pizzas sold.
SELECT 
    SUM(quantity) AS Total_Sold
FROM
    pizza_db.pizza_sales;

-- Total Orders: The total number of orders placed.
SELECT 
    COUNT(DISTINCT order_id) AS Total_Order
FROM
    pizza_db.pizza_sales;     
    
-- Average Pizzas Per Order: The average number of pizzas sold per order, calculated by dividing the total number of pizzas sold by the total number of orders. 
SELECT 
    CAST(CAST(SUM(quantity) AS DECIMAL (10 , 2 )) / CAST(COUNT(DISTINCT order_id) AS DECIMAL (10 , 2 ))
        AS DECIMAL (10 , 2 )) AS Avg_Pizzas_per_order
FROM
    pizza_db.pizza_sales; 
    

-- Hourly Trend Orders
SELECT 
    EXTRACT(HOUR FROM order_time) AS order_hours,
    SUM(quantity) AS total_pizzas_sold
FROM
    pizza_sales
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY EXTRACT(HOUR FROM order_time);

-- Standarize order_date format
ALTER TABLE pizza_sales
MODIFY order_date DATETIME;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;


UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

-- Weekly Trend Orders
SELECT 
    YEARWEEK(order_date, 3) AS YearWeek,
    YEAR(order_date) AS Year,
    COUNT(DISTINCT order_id) AS Total_orders
FROM 
    pizza_sales
GROUP BY 
    YearWeek,
    Year
ORDER BY 
    Year, YearWeek;

-- % of sales by Pizza Category
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL (10 , 2 )) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT 
                SUM(total_price)
            FROM
                pizza_sales)
        AS DECIMAL (10 , 2 )) AS Percentage
FROM
    pizza_sales
GROUP BY pizza_category;

-- % of sales by pizza size
SELECT 
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL (10 , 2 )) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT 
                SUM(total_price)
            FROM
                pizza_sales)
        AS DECIMAL (10 , 2 )) AS Percentage
FROM
    pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

-- Total pizza sold by pizza category
SELECT 
    pizza_category, SUM(quantity) AS total_pizza_sold
FROM
    pizza_sales
GROUP BY pizza_category
ORDER BY total_pizza_sold DESC;

-- Top 5 Pizza revenue 
SELECT 
    pizza_name, SUM(total_price) AS Total_Revenue
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Bottom 5 pizza revenue
SELECT 
    pizza_name, SUM(total_price) AS Total_Revenue
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

-- Top 5 piiza by quantity
SELECT 
    pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

-- Bottom 5 Pizza by quantity
SELECT 
    pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

-- Top 5 pizza by total order
SELECT 
    pizza_name, COUNT(DISTINCT order_id) AS Total_Order
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order DESC
LIMIT 5;

-- Bottom 5 pizza by total_order
SELECT 
    pizza_name, COUNT(DISTINCT order_id) AS Total_Order
FROM
    pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order ASC
LIMIT 5;