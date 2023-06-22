#DATA SOURCE = https://mavenanalytics.io/data-playground?tags=10btmr8wmkqkEgJMfgtOv2


-- Analyze sales data for a retail company, including sales trends, customer segmentation, and product performance -- 


CREATE DATABASE toys_sales;

USE toys_sales;

CREATE TABLE sales (
    Sale_ID INT,
    Date DATE,
    Store_ID INT,
    Product_ID INT,
    Units INT
);

#to download a huge amount of data in few seconds
#secure-file-priv="C:/ProgramData/MySQL/MySQL Server 8.0/Uploads"

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv' INTO TABLE toys_sales.sales
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select COUNT(*) from sales;
select COUNT(*) from products;
select COUNT(*) from stores;
select COUNT(*) from inventory;

-- //////////////////////////////////////////////////////// DATA CLEANING ///////////////////////////////////////////////////-- 
#we are removing prefixes 
UPDATE products
SET product_price = REPLACE(product_price, '$', '')
WHERE product_price LIKE '$%';

UPDATE products
SET product_cost = REPLACE(product_cost, '$', '')
WHERE product_cost LIKE '$%';

                                                                   -- THE APPROACH FOLLOWED -- 
#1. Data Exploration and Understanding :
-- a. Sales = We have sales column which features the sale_id, date of transaction, the store_id, the product_id and the units sold of that product
-- b. Stores = This table has all the information about the stores as, id, name, city, location, and the date when the store was open
-- c. Products = We have product_id, name, the category, cost and the price of the products. 
-- d. Inventory = We have inventory table where store_id, product_id and stock on hand is given that is total units.alter

-- For our analysis we will be understanding how the sale trends through the different stores and products. 
-- We will also understand which products are performing well among the customers and which products are not performing so well. 
-- Also, we can analyse the customer segmentation based on thier purchase frequency, product preferences, understanding how mnany units are purchased and can segmment them into high -volume buyers

#2. Sales Trends Analysis 
                         -- We will be answering the following questions to understand the sales trends for the toys sales
                         
-- 1. What is the total sales revenue for each month?
-- 2. Which month had the highest sales revenue?
-- 3. What is the total sales revenue for each product category?
-- 4. Which product category generated the highest sales revenue?
-- 5. What is the total sales revenue for each store?
-- 6. Which store had the highest sales revenue?
-- 7. What is the average number of units sold per day for each product?
-- 8. Which product has the highest average number of units sold per day?
-- 9. What is the total sales revenue for each store-city?
-- 10. Which store-city had the highest sales revenue?
-- 11. What is the total sales revenue for each year?
-- 12. What is the average price of products in each category?
-- 13. How many units of each product have been sold?
-- 14. What is the average number of units sold per transaction?
-- 15. What is the distribution of sales revenue across different store locations?
-- 16. What is the total sales revenue for each store and product combination?
-- 17. Which products have the highest profit margins?
-- 18. What is the average transaction value for each store?
-- 19. How many unique customers made purchases in each store?
-- 20. What is the monthly sales trend for a specific product?
-- 21. How does the sales revenue vary across different days of the week?
-- 22. How does the sales revenue vary across different seasons or quarters?
-- 23. How does the sales revenue vary across different quarters for different stores?

#3. Customer Segmentation 
                         -- We will be answering the following questions to understand the customer segmentation for the toys sales

-- 1.Which store has the highest number of transactions?
-- 2.Can we identify the top-selling products for each store?
-- 3.How many unique products are sold in each store?
-- 4.Are there any differences in purchase patterns between weekdays and weekends for each store?
-- 5.Can we identify high-volume buyers who consistently purchase large quantities across different stores?
-- 6.What is the distribution of purchase frequencies among customers for each store?
-- 7.Can we identify any seasonal trends in purchasing behavior for different product categories?

#4. Product Performance Analysis :
                         -- We will be answering the following questions to understand the product performance for the toys sales
                         
-- 1. What are the top-selling products based on the quantity sold?
-- 2. Which products have generated the highest revenue?
-- 3. What is the average price of products sold?
-- 4. Are there any differences in sales performance among different product categories?
-- 5. What is the distribution of sales across different stores?
-- 6. Can we analyze the sales growth or decline of specific products over time?
-- 7. Which products have the highest profit margins?
-- 8. What is the total quantity sold for a specific product?
-- 9. Can we identify the best-selling product category?
-- 10. What is the average daily sales revenue?


#5.INVENTORY ANALYSIS :
                         -- We will be answering the following questions to understand the inventory for the toys sales
                         
-- 1. What is the current stock quantity for each product in each store?
-- 2. Which products are out of stock in each store?
-- 3. Which store has the highest and lowest stock levels?
-- 4. How does the stock quantity vary across different products?
-- 5. What is the average stock quantity per product across all stores?
-- 6. Which products have the highest stock quantity and are available in all stores?


-- ////////////////////////////////////////////////// DATA ANALYSIS ///////////////////////////////////////////////// -- 

# SALES ANALYSIS

-- 1.What is the total sales revenue for each month and year?

SELECT 
    DATE_FORMAT(s.Date, '%M') AS Months,
    DATE_FORMAT(s.Date, '%Y')AS Year,
    ROUND(SUM(s.units * p.product_price), 2) AS 'Total Revenue'
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY MONTH(s.Date) , YEAR(s.Date);

-- 2. Which month had the highest sales revenue in 2018? 

SELECT 
    DATE_FORMAT(s.Date, '%M') AS Months,
    DATE_FORMAT(s.Date, '%Y')AS Year,
    ROUND(SUM(s.units * p.product_price), 2) AS 'Total Revenue'
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
WHERE YEAR(s.Date) = 2018
GROUP BY MONTH(s.Date) , YEAR(s.Date)
ORDER BY ROUND(SUM(Product_price), 2) desc
LIMIT 1;

-- 3. What is the total sales revenue for each product category?

SELECT 
    product_category,
    ROUND(SUM(s.units * p.product_price), 2) AS 'Total Revenue'
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY Product_category;


-- 4.Which product category generated the highest sales revenue?

SELECT 
    product_category,
    ROUND(SUM(s.units * p.product_price), 2) AS 'Total Revenue'
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY Product_category
ORDER BY ROUND(SUM(Product_price), 2) DESC
LIMIT 1;

-- 5. What is the total sales revenue for each store?

SELECT 
    Store_name,
    ROUND(SUM(s.units * p.product_price), 2) AS TotalRevenue
FROM
    sales s
        JOIN
    stores st ON s.store_id = st.store_id
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY s.store_id
ORDER BY TotalRevenue;


-- 6. Which store had the highest sales revenue?

SELECT 
    Store_name,
    ROUND(SUM(s.units * p.product_price), 2) AS 'Total Revenue'
FROM
    sales s
        JOIN
    stores st ON s.store_id = st.store_id
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY s.store_id
ORDER BY ROUND(SUM(p.Product_price), 2) DESC
LIMIT 1;


-- 7. What is the average number of units sold per day for each product?

SELECT 
    p.product_name AS 'Product Name',
    s.Date,
    ROUND(AVG(Units)) AS avg_units
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY p.Product_id , s.Date;


-- 8. Which product has the highest average number of units sold per day?

SELECT 
    p.product_name AS 'Product Name',
    s.Date,
    ROUND(AVG(Units)) AS avg_units
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY p.Product_id , s.Date
ORDER BY avg_units DESC
LIMIT 1
;

-- 9. What is the total sales revenue for each store-city?

SELECT st.store_city as 'Store City Names', ROUND(SUM(s.units * p.product_price),2) as Total_sales_revenue
from sales s 
left join products p 
on p.product_id = s.product_id 
inner join stores st
on st.store_id = s.store_id
group by st.store_city;

-- 10. Which store-city had the highest sales revenue?

SELECT st.store_city as 'Store City Names', ROUND(SUM(s.units * p.product_price),2) as Total_sales_revenue
from sales s 
left join products p 
on p.product_id = s.product_id 
inner join stores st
on st.store_id = s.store_id
group by st.store_city
ORDER BY Total_sales_revenue DESC
LIMIT 1;


-- 11. What is the total sales revenue for each year?


SELECT 
    DATE_FORMAT(s.Date, '%Y') AS Year,
    ROUND(SUM(s.units * p.product_price), 2) AS 'Total Revenue'
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY YEAR(s.Date);


-- 12. What is the average price of products in each category?

SELECT 
    product_category,
    ROUND(AVG(Product_price), 2) AS avg_product_price
FROM
    products
GROUP BY product_category
ORDER BY avg_product_price;


-- 13. How many units of each product have been sold?

SELECT 
    p.Product_name AS product_name, SUM(s.units) AS Units_sold
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;


-- 14. What is the average number of units sold per transaction?

SELECT 
    AVG(units) AS avg_num_units_sold_per_transaction
FROM
    sales;


-- 15. What is the distribution of sales revenue across different store locations?

SELECT 
    st.store_location AS Store_Location,
    ROUND(SUM(s.units * p.product_price), 2) AS sales_revenue
FROM
    sales s
        LEFT JOIN
    products p ON p.product_id = s.product_id
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY st.Store_location
ORDER BY sales_revenue;


-- 16. What is the total sales revenue for each store and product combination?

SELECT 
    st.store_name,
    p.product_name,
    ROUND(SUM(s.units * p.product_price), 2) AS sales_revenue
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY st.store_name , p.product_name
ORDER BY st.store_name;


-- 17. Which products have the highest profit margins?

SELECT 
    product_name,
    ROUND((product_price - product_cost) / product_cost * 100,
            2) AS profit_margin
FROM
    products
ORDER BY profit_margin DESC;


-- 18. What is the average transaction value for each store?

SELECT 
    store_name,
    ROUND(AVG(Product_price * units), 2) AS avg_transaction_value
FROM
    sales s
        INNER JOIN
    products p ON p.product_id = s.product_id
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY st.store_name;


-- 19. How many unique customers made purchases in each store?
#Let's assume that each unique combination of "Store_ID" and "Product_ID" represents a unique customer.

SELECT 
    st.store_name,
    COUNT(CONCAT(s.Store_ID, '_', s.Product_ID)) AS unique_customers
FROM
    sales s
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY st.store_name
order by unique_customers desc;


-- 20. What is the monthly sales trend for a specific product?
#lets take `Colorbuds` product since it has the highest revenue 

SELECT 
    product_name,
    DATE_FORMAT(s.Date, '%Y') AS Year,
    DATE_FORMAT(s.Date, '%M') AS Months,
    ROUND(SUM(s.units * p.product_price), 2) AS sales
FROM
    sales s
        JOIN
    products p ON s.product_id = p.product_id
WHERE
    p.product_name = 'Colorbuds'
GROUP BY Months , Year
ORDER BY Year;

-- 21. How does the sales revenue vary across different days of the week?

SELECT 
    DATE_FORMAT(s.Date, '%W') AS Week,
    ROUND(SUM(s.units * p.product_price), 2) AS sales_revenue
FROM
    sales s
        JOIN
    products p ON s.product_id = p.product_id
group by Week
ORDER BY sales_revenue desc;


-- 22. How does the sales revenue vary across different seasons or quarters?

SELECT 
    CONCAT(YEAR(s.Date), '-', QUARTER(s.Date)) AS Quarter,
    ROUND(SUM(s.units * p.product_price), 2) AS Sales_Revenue
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY Quarter
ORDER BY Quarter;

-- 23. How does the sales revenue vary across different quarters for different stores?

SELECT 
    CONCAT(YEAR(s.Date), '-', QUARTER(s.Date)) AS Quarter,
    st.store_name AS Store_Name,
    SUM(s.units * p.product_price) AS Sales_Revenue
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY Quarter , Store_Name
ORDER BY Quarter , Store_Name;


-- In MySQL, the first month of each quarter starts as follows:
-- Quarter 1: January
-- Quarter 2: April
-- Quarter 3: July
-- Quarter 4: October
-- ---------------------------------------------------------------------------------------------------------------------------------------

# CUSTOMER SEGMENTATION

-- 1. Which store has the highest number of transactions?

SELECT 
    Store_name,
     COUNT(sale_id) AS Totaltransactions
FROM
    sales s
        JOIN
    stores st ON s.store_id = st.store_id
GROUP BY s.store_id
ORDER BY Totaltransactions desc; 


-- 2.Can we identify the top-selling products for each store?

SELECT 
    store_name, 
    product_name, 
    total_units_sold
FROM (
SELECT store_name, product_name, SUM(s.Units) AS total_units_sold,
    ROW_NUMBER() OVER (PARTITION BY st.Store_ID ORDER BY SUM(s.Units) DESC) AS rn
    from
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
        INNER JOIN
    stores st ON st.store_id = s.store_id
    GROUP BY s.product_id , s.store_id , product_name) sq
where rn = 1
ORDER BY total_units_sold desc;


-- 3. How many unique products are sold in each store?

SELECT 
    Store_Name, COUNT(DISTINCT s.product_id) AS unique_products
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
        INNER JOIN
    stores st ON st.store_id = s.store_id
GROUP BY st.store_name; 


-- 4. Are there any differences in purchase patterns between weekdays and weekends for each store?

#The WEEKDAY() function is used to determine the day of the week (0-6, where 0 represents Monday and 6 represents Sunday)

SELECT
    st.store_name,
    CASE WHEN WEEKDAY(s.date) < 5 THEN 'Weekday' ELSE 'Weekend' END AS purchase_day,
    COUNT(*) AS purchase_count
FROM
    sales s
    INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY
    st.store_name, purchase_day
ORDER BY store_name;


-- 5. Can we identify high-volume buyers who consistently purchase large quantities across different stores?

SELECT 
    st.store_name,
    s.store_id,
    SUM(s.units) AS total_units_purchased
FROM
    sales s
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY s.store_id
ORDER BY total_units_purchased DESC;


-- 6. What is the distribution of purchase frequencies among customers for each store?

SELECT
    st.store_name,
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT s.product_id) AS unique_product_count,
    COUNT(*) / COUNT(DISTINCT s.product_id) AS average_purchase_frequency  -- Divides the total number of transactions by the number of unique products to calculate the average purchase frequency per product.
FROM
    sales s
    INNER JOIN stores st ON s.store_id = st.store_id
GROUP BY
    st.store_name;


-- 7.Can we identify any quaterly trends in purchasing behavior for different product categories?

select CONCAT(YEAR(s.date), '-', QUARTER(s.Date)) as Quarters, product_category, SUM(s.units) 
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
        INNER JOIN
    stores st ON s.store_id = st.store_id
GROUP BY Quarters , product_category
ORDER BY Quarters , product_category;


-- -------------------------------------------------------------------------------------------------------------

# PRODUCT PERFORMANCE ANALYSIS 
     
select * from sales;
select * from products;
select * from stores;

-- 1. What are the top-selling products based on the quantity sold?

SELECT 
    SUM(s.units) AS units_sold, p.product_name AS product_name
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY units_sold DESC;


-- 2. Which products have generated the highest revenue?

SELECT 
    p.product_name AS product_name,
    ROUND(SUM(s.units * p.product_price), 2) AS total_revenue
FROM
    sales s
        INNER JOIN
    products p ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY total_revenue DESC;


-- 3. What is the average price of products sold?

SELECT 
    ROUND(AVG(product_price), 2) AS average_price
FROM
    products;


-- 4. Are there any differences in sales performance among different product categories?

SELECT 
    product_category,
    SUM(units) AS total_units_sold,
    ROUND(SUM(s.units * p.product_price), 2) AS total_sales_revenue
FROM
    sales s
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY product_category;


-- 5. What is the distribution of sales across different stores?

SELECT 
    Store_name,
    ROUND(SUM(s.units * p.product_price), 2) AS TotalRevenue
FROM
    sales s
        JOIN
    stores st ON s.store_id = st.store_id
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY s.store_id
ORDER BY TotalRevenue;


-- 6. Can we analyze the sales growth or decline of specific products over time?

SELECT
    product_name,
    DATE_FORMAT(date, '%Y-%m') AS sales_month,
    SUM(units) AS total_units_sold
FROM
    sales
    INNER JOIN products ON sales.product_id = products.product_id
WHERE product_name = 'Dino Egg'
GROUP BY
    product_name, sales_month
ORDER BY
    product_name, sales_month;


-- 7. Which products have the highest profit margins?

SELECT 
    product_name,
    ROUND((product_price - product_cost) / product_cost * 100,
            2) AS profit_margin
FROM
    products
ORDER BY profit_margin DESC;


-- 8. What is the total quantity sold for a specific product?

SELECT
    product_name,
    SUM(units) AS total_quantity_sold
FROM
    sales
    INNER JOIN products ON sales.product_id = products.product_id
WHERE
    product_name = 'Colorbuds';


-- 9. Can we identify the best-selling product category?

SELECT
    p.product_category AS best_selling_category,
    SUM(s.units) AS total_units_sold
FROM
    sales s
    INNER JOIN products p ON s.product_id = p.product_id
GROUP BY
    p.product_category
ORDER BY
    total_units_sold DESC
LIMIT 1;

-- 10. What is the average daily sales revenue?

SELECT 
    ROUND(AVG(sales_revenue), 2) AS average_daily_sales_revenue
FROM
    (SELECT 
        DATE(s.date) AS sale_date,
            SUM(s.units * p.product_price) AS sales_revenue
    FROM
        sales s
    INNER JOIN products p ON s.product_id = p.product_id
    GROUP BY sale_date) AS daily_sales_revenue;
    
    
-- ----------------------------------------------------------------------------------------------------------

# INVENTORY ANALYSIS 

select * from stores;
select * from inventory;
select * from products;

-- 1. What is the current stock quantity in each store?

SELECT 
    store_name, SUM(stock_on_hand) AS stock_quantity
FROM
    stores st
        INNER JOIN
    inventory i ON st.store_id = i.store_id
GROUP BY i.store_id;


-- 2. Which products are out of stock in each store?

SELECT 
    store_name, product_name
FROM
    stores st
        INNER JOIN
    inventory i ON st.store_id = i.store_id
        INNER JOIN
    products p ON p.product_id = i.product_id
WHERE
    stock_on_hand = 0;


-- 3. Which store has the highest and lowest stock levels?

SELECT 
    st.store_name,
    MAX(i.stock_on_hand) AS highest_stock_level,
    MIN(i.stock_on_hand) AS lowest_stock_level
FROM
    stores st
        INNER JOIN
    inventory i ON st.store_id = i.store_id
GROUP BY st.store_name
HAVING lowest_stock_level > 0
ORDER BY highest_stock_level DESC; 


-- 4. How does the stock quantity vary across different products?

SELECT 
    product_id, SUM(stock_on_hand) AS stock_quantity
FROM
    inventory
GROUP BY product_id; 


-- 5. What is the average stock quantity per product across all stores?

SELECT
    AVG(stock_on_hand) AS average_stock_quantity
FROM
    inventory;


-- 6. Which products have the highest stock quantity and are available in all stores?

SELECT
    p.product_name,
    MAX(i.stock_on_hand) AS highest_stock_quantity
FROM
    products p
INNER JOIN
    inventory i ON p.product_id = i.product_id
GROUP BY
    p.product_name
HAVING
    COUNT(DISTINCT i.store_id) = (SELECT COUNT(*) FROM stores);
    
-- /////////////////////////// RECOMMENDATIONS /////////////////////////////


-- 1. Implement personalized marketing campaigns: Leverage customer segmentation analysis to tailor marketing messages 
-- and promotions based on customer preferences and purchase history, increasing the relevance and effectiveness of marketing efforts.

-- 2. Optimize product mix : Analyzed sales data to identify top-performing products and align the product mix with customer demand. 
-- Discontinue low-performing products and introduce new products based on market trends and customer preferences.

-- 3. Enhance customer loyalty programs: Develop and refine customer loyalty programs to incentivize repeat purchases and foster long-term customer relationships. 
-- Offer exclusive rewards, personalized discounts, and special privileges to encourage customer loyalty.

-- 4. Improve inventory management: Utilize inventory data to optimize stock levels, ensuring sufficient availability of popular products while minimizing excess inventory. 
-- Implement inventory forecasting techniques to accurately predict demand and streamline inventory replenishment processes.

-- 5. Enhance online and mobile shopping experiences: Invest in user-friendly and intuitive e-commerce platforms and mobile apps to provide a seamless and 
-- convenient shopping experience for customers. Incorporate features such as personalized recommendations, easy checkout processes, and real-time inventory availability.

-- 6. Leverage customer feedback and reviews: Actively collect and analyze customer feedback and reviews to identify areas for improvement and 
-- address customer concerns. Use this information to enhance product quality, customer service, and overall customer satisfaction.

-- By implementing these recommendations, retail businesses can drive sales growth, optimize product offerings, and effectively target and engage their customer base.