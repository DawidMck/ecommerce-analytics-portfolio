USE retail_sales;

-- 1. Ogólne podsumowanie kluczowych wskaźników (KPI) firmy
SELECT 
    SUM(sales_amount) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_items_sold
FROM orders;

-- 2. Analiza wskaźnika zwrotów (Return Rate)
SELECT 
    COUNT(CASE WHEN order_status = 'Returned' THEN 1 END) AS total_returned,
    COUNT(*) AS total_orders,
    ROUND(COUNT(CASE WHEN order_status = 'Returned' THEN 1 END) * 100.0 / COUNT(*), 2) AS return_rate_pct
FROM orders;

-- 3. Zwroty w podziale na konkretne produkty
SELECT 
    p.product_name, 
    COUNT(o.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_count
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY returned_count DESC;

-- 4. Średni czas dostawy (w dniach) ogółem oraz wg regionów i produktów
SELECT AVG(days_to_ship) AS avg_days_to_ship_overall FROM orders;

SELECT 
    c.region, 
    ROUND(AVG(o.days_to_ship), 2) AS avg_days_to_ship
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
group by c.region
ORDER BY avg_days_to_ship DESC;

-- 5. Średni koszt wysyłki z podziałem na regiony
SELECT 
    c.region, 
    ROUND(AVG(o.shipping_cost), 2) AS avg_shipping_cost
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY avg_shipping_cost DESC;

-- 6. Analiza satysfakcji klientów a czas dostawy i status zamówienia
SELECT 
    o.customer_satisfaction, 
    ROUND(AVG(o.days_to_ship), 2) AS avg_days_to_ship
FROM orders o 
GROUP BY o.customer_satisfaction
ORDER BY o.customer_satisfaction;

SELECT 
    o.order_status, 
    ROUND(AVG(o.days_to_ship), 2) AS avg_days_to_ship
FROM orders o 
GROUP BY o.order_status
ORDER BY avg_days_to_ship DESC;

-- 7. Dominujące metody płatności
SELECT 
    payment_method, 
    COUNT(*) AS total_transactions
FROM orders 
GROUP BY payment_method
ORDER BY total_transactions DESC;