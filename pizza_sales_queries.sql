use test;

select * from pizza_sales;

-- Daily Trend for Total Orders
SELECT DATENAME(DW, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);

-- Top selling pizza on each day
WITH RankedPizzaSales AS (SELECT DATENAME(DW, order_date) as order_day, pizza_name_id,
	ROW_NUMBER() OVER (PARTITION BY DATENAME(DW, order_date) ORDER BY COUNT(*) DESC) AS ranking 
	FROM pizza_sales GROUP BY
    DATENAME(DW, order_date), pizza_name_id
)
SELECT order_day, pizza_name_id
FROM RankedPizzaSales
WHERE ranking = 1;

-- Monthly Trend for Orders
select DATENAME(MONTH, order_date) as Month_Name, COUNT(DISTINCT order_id) as Total_Orders
from pizza_sales
GROUP BY DATENAME(MONTH, order_date);

-- % of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS Sales_pct
FROM pizza_sales
GROUP BY pizza_category;

-- % of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS Sales_pct
FROM pizza_sales GROUP BY pizza_size ORDER BY pizza_size;

-- Top 5 Pizzas by Revenue
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales GROUP BY pizza_name
ORDER BY Total_Revenue DESC;

-- Bottom 5 Pizzas by Revenue
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales GROUP BY pizza_name
ORDER BY Total_Revenue ASC;

-- Top 5 Pizzas by Quantity
SELECT Top 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC;

-- Bottom 5 Pizzas by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC;