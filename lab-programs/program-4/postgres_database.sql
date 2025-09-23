CREATE TABLE sales (
sale_id SERIAL PRIMARY KEY,
sale_date DATE NOT NULL,
city VARCHAR(100) NOT NULL,
product VARCHAR(100),
amount INT,
price NUMERIC(10,2)
);

CREATE TABLE weather (
weather_id SERIAL PRIMARY KEY,
weather_date DATE NOT NULL,
city VARCHAR(100) NOT NULL,
temp_c NUMERIC(5,2),
humidity INT,
description VARCHAR(255)
);

INSERT INTO sales (sale_date, city, product, amount, price)
VALUES
('2025-06-27', 'London', 'Umbrella', 5, 12.99),
('2025-06-27', 'London', 'Raincoat', 2, 39.99),
('2025-06-28', 'Paris', 'Sunscreen', 10, 7.50),
('2025-06-28', 'Paris', 'Hat', 3, 15.00);

INSERT INTO weather (weather_date, city, temp_c, humidity, description)
VALUES
('2025-06-27', 'London', 18.3, 80, 'light rain'),
('2025-06-27', 'Paris', 26.1, 60, 'clear sky'),
('2025-06-28', 'London', 17.0, 85, 'heavy rain'),
('2025-06-28', 'Paris', 29.2, 55, 'sunny');

SELECT * FROM sales;
SELECT * FROM weather;