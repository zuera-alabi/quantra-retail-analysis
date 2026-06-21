-- ================================================
-- QUANTRA RETAIL — SQL SALES PERFORMANCE ANALYSIS
-- Author: Zuera Alabi
-- Database: quantra_retail
-- ================================================

USE quantra_retail;

-- ================================================
-- SECTION 1: DATABASE EXPLORATION
-- ================================================

-- View all tables
SHOW TABLES;

-- Preview each table
SELECT * FROM products LIMIT 5;
SELECT * FROM customers LIMIT 5;
SELECT * FROM transactions LIMIT 5;

-- ================================================
-- SECTION 2: REVENUE ANALYSIS
-- ================================================

-- 1. Total Revenue, Total Cost and Total Profit
SELECT 
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(SUM(cost_price * quantity), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin_pct
FROM transactions;

-- 2. Revenue by Product Category
SELECT 
    p.product_category,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.total_amount), 2) AS total_revenue,
    ROUND(SUM(t.profit), 2) AS total_profit,
    ROUND(AVG(t.profit_margin), 2) AS avg_profit_margin
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;

-- ================================================
-- SECTION 3: CUSTOMER ANALYSIS
-- ================================================

-- 3. Revenue by City
SELECT 
    c.city,
    COUNT(DISTINCT t.customer_id) AS total_customers,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.total_amount), 2) AS total_revenue
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- 4. Top 10 Most Valuable Customers
SELECT 
    c.customer_name,
    c.city,
    c.gender,
    COUNT(t.transaction_id) AS total_purchases,
    ROUND(SUM(t.total_amount), 2) AS total_spent,
    ROUND(AVG(t.total_amount), 2) AS avg_order_value
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.city, c.gender
ORDER BY total_spent DESC
LIMIT 10;

-- ================================================
-- SECTION 4: SALES TRENDS
-- ================================================

-- 5. Monthly Sales Trend
SELECT 
    year,
    month_name,
    month,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS monthly_revenue,
    ROUND(SUM(profit), 2) AS monthly_profit
FROM transactions
GROUP BY year, month, month_name
ORDER BY year, month;

-- 6. Revenue by Store Type (Online vs In-Store)
SELECT 
    store_type,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin
FROM transactions
GROUP BY store_type
ORDER BY total_revenue DESC;

-- 7. Revenue by Payment Method
SELECT 
    payment_method,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction_value
FROM transactions
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 8. Top Performing Products
SELECT 
    p.product_name,
    p.product_category,
    COUNT(t.transaction_id) AS total_sales,
    ROUND(SUM(t.total_amount), 2) AS total_revenue,
    ROUND(SUM(t.profit), 2) AS total_profit,
    ROUND(AVG(t.profit_margin), 2) AS avg_margin
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.product_category
ORDER BY total_revenue DESC
LIMIT 10;


-- 9. Profit Margin by Category
SELECT 
    p.product_category,
    ROUND(AVG(t.profit_margin), 2) AS avg_profit_margin,
    ROUND(MAX(t.profit_margin), 2) AS max_margin,
    ROUND(MIN(t.profit_margin), 2) AS min_margin,
    ROUND(SUM(t.profit), 2) AS total_profit
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_category
ORDER BY avg_profit_margin DESC;

