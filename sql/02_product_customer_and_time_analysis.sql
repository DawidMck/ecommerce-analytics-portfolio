USE retail_sales;

-- 1. Ranking produktów pod kątem przychodu, ilości i zysku
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS total_amount,
    SUM(o.quantity) AS total_quantity,
    SUM(o.profit) AS total_profit,
    ROUND(SUM(o.profit) / SUM(o.sales_amount) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;

-- 2. Ranking najlepszych klientów
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.sales_amount) AS total_amount,
    SUM(o.quantity) AS total_quantity,
    SUM(o.profit) AS total_profit,
    ROUND(SUM(o.profit) / SUM(o.sales_amount) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_profit DESC;

-- 3. Rentowność i wolumen zamówień w ujęciu miesięcznym
SELECT
    MONTH(order_date) AS order_month, 
    SUM(profit) AS profit_by_month
FROM orders
GROUP BY MONTH(order_date)
ORDER BY profit_by_month DESC;

SELECT
    MONTH(order_date) AS order_month, 
    COUNT(order_id) AS total_orders_by_month
FROM orders
GROUP BY MONTH(order_date)
ORDER BY total_orders_by_month DESC;

-- 4. Analiza kategorii produktów a płeć klientów
SELECT 
    c.gender,
    pc.category_name, 
    COUNT(pc.category_name) AS total_purchases
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
GROUP BY c.gender, pc.category_name
ORDER BY total_purchases DESC;

-- 5. Wpływ poziomu rabatu na zysk i liczbę zamówień
SELECT
    discount_pct, 
    SUM(profit) AS total_profit
FROM orders
GROUP BY discount_pct
ORDER BY total_profit DESC;

SELECT
    discount_pct, 
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY discount_pct
ORDER BY total_orders DESC;