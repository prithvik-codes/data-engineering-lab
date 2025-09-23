CREATE DATABASE DMA;
USE DMA;

CREATE TABLE customers (
id VARCHAR(36) NOT NULL, -- string PK (UUID-friendly)
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(160) UNIQUE,
phone VARCHAR(32),
address VARCHAR(255),
city VARCHAR(120),
state VARCHAR(120),
postal_code VARCHAR(32),
country VARCHAR(120),
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
) ;

CREATE TABLE products (
id VARCHAR(36) NOT NULL, -- string PK
name VARCHAR(200) NOT NULL,
description TEXT,
category VARCHAR(120),
price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
sku VARCHAR(64) UNIQUE,
stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
) ;

CREATE TABLE sales (
id VARCHAR(36) NOT NULL, -- string PK
customer_id VARCHAR(36) NOT NULL,
product_id VARCHAR(36) NOT NULL,
sale_date DATETIME NOT NULL,
quantity INT NOT NULL CHECK (quantity > 0),
unit_price DECIMAL(12,2) NOT NULL CHECK (unit_price >= 0),
-- keep total_amount consistent via generated column
total_amount DECIMAL(12,2) AS (quantity * unit_price) STORED,
payment_method VARCHAR(32),
sales_channel VARCHAR(32),
PRIMARY KEY (id),
CONSTRAINT fk_sales_customer
FOREIGN KEY (customer_id) REFERENCES customers(id),
CONSTRAINT fk_sales_product
FOREIGN KEY (product_id) REFERENCES products(id),
INDEX idx_sales_date (sale_date),
INDEX idx_sales_customer (customer_id),
INDEX idx_sales_product (product_id)
) ;

INSERT INTO customers (id, first_name, last_name, email, phone, address, city, state,
postal_code, country, created_at)
VALUES
('CUST-0001','Alice','Shah','alice.shah@example.com','+91-900000001','MG Rd
12','Pune','MH','411001','India', NOW() - INTERVAL 60 DAY),
('CUST-0002','Bob','Fernandes','bob.fernandes@example.com','+91-900000002','Park St
8','Mumbai','MH','400001','India', NOW() - INTERVAL 45 DAY),
('CUST-0003','Carol','Mehta','carol.mehta@example.com','+91-900000003','Residency Rd
22','Bengaluru','KA','560001','India', NOW() - INTERVAL 40 DAY),
('CUST-0004','David','Khan','david.khan@example.com','+91-900000004','Link Rd
101','Delhi','DL','110001','India', NOW() - INTERVAL 30 DAY),
('CUST-0005','Eva','Iyer','eva.iyer@example.com','+91-900000005','FC Rd
5','Pune','MH','411004','India', NOW() - INTERVAL 25 DAY)
ON DUPLICATE KEY UPDATE
first_name=VALUES(first_name),
last_name =VALUES(last_name),
email =VALUES(email),
phone =VALUES(phone),
address =VALUES(address),
city =VALUES(city),
state =VALUES(state),
postal_code=VALUES(postal_code),
country =VALUES(country);

INSERT INTO products (id, name, description, category, price, sku, stock_quantity,
created_at)
VALUES

('PROD-COFFEE-101','Coffee Beans 1kg','Arabica medium roast','Grocery', 499.00,'SKU-
101',200, NOW() - INTERVAL 90 DAY),

('PROD-TEA-102','Assam Tea 500g','Strong CTC','Grocery', 199.00,'SKU-102',300, NOW()
- INTERVAL 90 DAY),
('PROD-CHOCO-103','Dark Chocolate 70%','100g bar','Snacks', 149.00,'SKU-103',500,
NOW() - INTERVAL 80 DAY),
('PROD-MILK-104','Milk 1L','Toned milk','Dairy', 69.00,'SKU-104',1000, NOW() -
INTERVAL 70 DAY),
('PROD-BREAD-105','Whole Wheat Bread','400g loaf','Bakery', 59.00,'SKU-105',800,
NOW() - INTERVAL 70 DAY),
('PROD-OIL-106','Olive Oil 1L','Extra virgin','Grocery', 899.00,'SKU-106',150, NOW() -
INTERVAL 60 DAY)
ON DUPLICATE KEY UPDATE
name =VALUES(name),
description =VALUES(description),
category =VALUES(category),
price =VALUES(price),
sku =VALUES(sku),
stock_quantity =VALUES(stock_quantity);

INSERT INTO sales (id, customer_id, product_id, sale_date, quantity, unit_price,
payment_method, sales_channel)
VALUES
-- 30–60 days ago
('SALE-0001','CUST-0001','PROD-COFFEE-101', NOW() - INTERVAL 55 DAY, 1, 499.00,
'Card','Store'),
('SALE-0002','CUST-0002','PROD-TEA-102', NOW() - INTERVAL 48 DAY, 2, 189.00,
'UPI','Store'), -- promo price
('SALE-0003','CUST-0003','PROD-CHOCO-103', NOW() - INTERVAL 42 DAY, 3, 149.00,
'Cash','Store'),
('SALE-0004','CUST-0001','PROD-MILK-104', NOW() - INTERVAL 40 DAY, 2, 69.00,
'UPI','Store'),
-- 20–35 days ago
('SALE-0005','CUST-0004','PROD-BREAD-105', NOW() - INTERVAL 35 DAY, 2, 59.00,
'Card','Online'),
('SALE-0006','CUST-0005','PROD-OIL-106', NOW() - INTERVAL 28 DAY, 1, 879.00,
'Card','Online'), -- discounted
('SALE-0007','CUST-0002','PROD-COFFEE-101', NOW() - INTERVAL 27 DAY, 1, 499.00,
'UPI','Store'),
('SALE-0008','CUST-0003','PROD-TEA-102', NOW() - INTERVAL 24 DAY, 1, 199.00,
'Cash','Store'),
-- last 2 weeks
('SALE-0009','CUST-0004','PROD-CHOCO-103', NOW() - INTERVAL 12 DAY, 5, 139.00,
'Card','Online'), -- festive offer
('SALE-0010','CUST-0001','PROD-MILK-104', NOW() - INTERVAL 10 DAY, 3, 69.00,
'UPI','Store'),
('SALE-0011','CUST-0005','PROD-BREAD-105', NOW() - INTERVAL 7 DAY, 1, 59.00,
'UPI','Store'),

('SALE-0012','CUST-0002','PROD-OIL-106', NOW() - INTERVAL 3 DAY, 1, 899.00,
'Card','Store')
ON DUPLICATE KEY UPDATE
customer_id =VALUES(customer_id),
product_id =VALUES(product_id),
sale_date =VALUES(sale_date),
quantity =VALUES(quantity),
unit_price =VALUES(unit_price),
payment_method=VALUES(payment_method),
sales_channel =VALUES(sales_channel);

SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS products FROM products;
SELECT COUNT(*) AS sales FROM sales;

SELECT s.id, c.first_name, p.name, s.quantity, s.unit_price, s.total_amount, s.sale_date
FROM sales s
JOIN customers c ON c.id = s.customer_id
JOIN products p ON p.id = s.product_id
ORDER BY s.sale_date DESC
LIMIT 10;