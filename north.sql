SELECT * 
FROM orders;

SELECT *
FROM employees;

SELECT 
    p.product_name,
    SUM(od.unit_price * od.quantity) AS revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

--- проверил совпадает ли мой дамп, кол-во заказов и деталей заказов с 
--- той базой которая должна быть. (все в порядке база та что нужно)

SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM order_details;


SELECT * FROM 
categories;


SELECT * FROM 
products;


--- Все строки заказов всех компаний кол-во и сумма
--- (All order lines of all companies, quantity and amount)

SELECT company_name, o.order_id, product_name, quantity, 
(quantity * od.unit_price * (1 - od.discount)) AS total_price
FROM customers AS c 
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id 
JOIN products AS p ON p.product_id = od.product_id;


--- выручка по клиентам (топ клиентов суммам)
--- (revenue by client (top client amounts)

SELECT 
    company_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(quantity * od.unit_price * (1 - od.discount)) AS revenue
FROM customers c
JOIN orders o 
    ON o.customer_id = c.customer_id
JOIN order_details od 
    ON o.order_id = od.order_id
GROUP BY company_name
ORDER BY revenue DESC;


--- какие товары приносят больше всего прибыли
--- (Which products generate the most profit)

SELECT 
    product_name,
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS revenue
FROM Products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name 
ORDER BY revenue DESC
LIMIT 5; 


--- топ 5 стран по выручке
--- (Top 5 countries by revenue)

SELECT 
    c.country,
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC
LIMIT 5;


--- топ 5 клиентов по выручке
--- (Top 5 clients by revenue)

SELECT c.company_name, 
	   SUM(od.quantity * od.unit_price * (1 - od.discount)) AS revenue
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
JOIN order_details od ON od.order_id = o.order_id  
GROUP BY c.company_name
ORDER BY revenue DESC
LIMIT 5;


SELECT 
    c.country,
    DATE_TRUNC('week', o.order_date) AS week,
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.country, week
ORDER BY week, revenue DESC;


--- 

SELECT 
    c.country,
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(WEEK FROM o.order_date) AS week,
    SUM(od.quantity * od.unit_price * (1 - od.discount)) AS revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.country, year, week
ORDER BY year, week;


