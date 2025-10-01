-- CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    product_id INT,
    customer_id INT,
    quantity INT,
    price NUMERIC(10,2),
    timestamp TIMESTAMP
);
select * from transactions;

-- Total sales per product
SELECT product_id, SUM(quantity*price) AS total_sales
FROM transactions
GROUP BY product_id
ORDER BY total_sales DESC;

-- -- Top 5 customers by spending
SELECT customer_id, SUM(quantity*price) AS customer_spend
FROM transactions
GROUP BY customer_id
ORDER BY customer_spend DESC
LIMIT 5;
