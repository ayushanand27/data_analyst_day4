-- Create database (if needed)
CREATE DATABASE IF NOT EXISTS olist_ecommerce;
USE olist_ecommerce;

-- 1. Geolocation table
CREATE TABLE IF NOT EXISTS olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10),
    PRIMARY KEY (geolocation_zip_code_prefix, geolocation_city, geolocation_state)
);

-- 2. Customers table
CREATE TABLE IF NOT EXISTS olist_customers_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 3. Sellers table
CREATE TABLE IF NOT EXISTS olist_sellers_dataset (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- 4. Products table
CREATE TABLE IF NOT EXISTS olist_products_dataset (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 5. Category translation table
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- 6. Orders table (main table)
CREATE TABLE IF NOT EXISTS olist_orders_dataset (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id)
);

-- 7. Order items table
CREATE TABLE IF NOT EXISTS olist_order_items_dataset (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id),
    FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id)
);

-- 8. Order payments table
CREATE TABLE IF NOT EXISTS olist_order_payments_dataset (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);

-- 9. Order reviews table
CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);

-- Clear all existing data safely
SET SQL_SAFE_UPDATES = 0;
DELETE FROM olist_order_reviews_dataset;
DELETE FROM olist_order_payments_dataset;
DELETE FROM olist_order_items_dataset;
DELETE FROM olist_orders_dataset;
DELETE FROM product_category_name_translation;
DELETE FROM olist_products_dataset;
DELETE FROM olist_sellers_dataset;
DELETE FROM olist_customers_dataset;
DELETE FROM olist_geolocation_dataset;
SET SQL_SAFE_UPDATES = 1;

-- 1. Insert into olist_geolocation_dataset
INSERT INTO olist_geolocation_dataset VALUES
("01037", -23.54562128, -46.63929205, "sao paulo", "SP"),
("01046", -23.54608113, -46.64482030, "sao paulo", "SP"),
("01041", -23.54439216, -46.63949931, "sao paulo", "SP"),
("01035", -23.54157796, -46.64160722, "sao paulo", "SP"),
("01012", -23.54776230, -46.63536054, "são paulo", "SP"),
("01047", -23.54627311, -46.64122517, "sao paulo", "SP"),
("01013", -23.54692321, -46.63426370, "sao paulo", "SP"),
("01029", -23.54376906, -46.63427784, "sao paulo", "SP");

-- 2. Insert into olist_customers_dataset (USING IDs THAT WILL BE REFERENCED IN ORDERS)
INSERT INTO olist_customers_dataset VALUES
("b0830fb4747a6c6d20dea0b8c802d7ef", "cust_unique_1", "14409", "franca", "SP"),
("41ce2a54c0b03bf3443c3d931a367089", "cust_unique_2", "09790", "sao bernardo do campo", "SP"),
("f88197465ea7920adcdbec7375364d82", "cust_unique_3", "01151", "sao paulo", "SP"),
("8ab97904e6daea8866dbdbc4fb7aad2c", "cust_unique_4", "08775", "mogi das cruzes", "SP"),
("503740e9ca751ccdda7ba28e9ab8f608", "cust_unique_5", "13056", "campinas", "SP"),
("ed0271e0b7da060a393796590e7b737a", "cust_unique_6", "89254", "jaragua do sul", "SC"),
("9bdf08b4b3b52b5526ff42d37d47f222", "cust_unique_7", "04534", "sao paulo", "SP"),
("f54a9f0e6b351c431402b8461ea51999", "cust_unique_8", "35182", "timoteo", "MG"),
("310ae3c140ff94b03219ad0adc3c778f", "cust_unique_9", "81560", "curitiba", "PR");

-- 3. Insert into olist_sellers_dataset (USING IDs THAT WILL BE REFERENCED IN ORDER ITEMS)
INSERT INTO olist_sellers_dataset VALUES
("48436dade18ac8b2bce089ec2a041202", "13023", "campinas", "SP"),
("dd7ddc04e1b6c2c614352b383efe2d36", "13844", "mogi guacu", "SP"),
("5b51032eddd242adc84c38acab88f23d", "20031", "rio de janeiro", "RJ"),
("9d7a1d34a5052409006425275ba1c2b4", "04195", "sao paulo", "SP"),
("df560393f3a51e74553ab94004ba5c87", "12914", "braganca paulista", "SP"),
("6426d21aca402a131fc0a5d0960a3c90", "20920", "rio de janeiro", "RJ"),
("7040e82f899a04d1b434b795a43b4617", "55325", "brejao", "PE"),
("5996cddab893a4652a15592fb58ab8db", "16304", "penapolis", "SP"),
("a416b6a846a11724393025641d4edd5e", "01529", "sao paulo", "SP");

-- 4. Insert into olist_products_dataset (USING IDs THAT WILL BE REFERENCED IN ORDER ITEMS)
INSERT INTO olist_products_dataset VALUES
("4244733e06e7ecb4970a6e2683c13e61", "perfumaria", 40, 287, 1, 225, 16, 10, 14),
("e5f2d52b802189ee658865ca93d83a8f", "artes", 44, 276, 1, 1000, 30, 18, 20),
("c777355d18b72b67abbeef9df44fd0fd", "esporte_lazer", 46, 250, 1, 154, 18, 9, 15),
("7634da152a4610f1595efa32f14722fc", "bebes", 27, 261, 1, 371, 26, 4, 26),
("ac6c3623068f30de03045865e4e10089", "utilidades_domesticas", 37, 402, 4, 625, 20, 17, 13),
("ef92defde845ab8450f9d70c526ef70f", "instrumentos_musicais", 60, 745, 1, 200, 38, 5, 11),
("8d4f2bb7e93e6710a28f34fa83ee7d28", "cool_stuff", 56, 1272, 4, 18350, 70, 24, 44),
("557d850972a7d6f792fd18ae1400d9b6", "moveis_decoracao", 56, 184, 2, 900, 40, 8, 40),
("310ae3c140ff94b03219ad0adc3c778f", "eletrodomesticos", 57, 163, 1, 400, 27, 13, 17);

-- 5. Insert into product_category_name_translation
INSERT INTO product_category_name_translation VALUES
("beleza_saude", "health_beauty"),
("informatica_acessorios", "computers_accessories"),
("automotivo", "auto"),
("cama_mesa_banho", "bed_bath_table"),
("moveis_decoracao", "furniture_decor"),
("esporte_lazer", "sports_leisure"),
("perfumaria", "perfumery"),
("utilidades_domesticas", "housewares"),
("telefonia", "telephony");

-- 6. Insert into olist_orders_dataset (USING IDs THAT WILL BE REFERENCED IN ORDER ITEMS, PAYMENTS, REVIEWS)
INSERT INTO olist_orders_dataset VALUES
("00010242fe8c5a6d1ba2dd792cb16214", "b0830fb4747a6c6d20dea0b8c802d7ef", "delivered", "2017-09-18 20:41:37", "2017-09-18 21:24:27", "2017-09-19 14:31:00", "2017-09-25 15:27:45", "2017-10-01 00:00:00"),
("00018f77f2f0320c557190d7a144bdd3", "41ce2a54c0b03bf3443c3d931a367089", "delivered", "2017-05-02 18:38:49", "2017-05-02 18:55:23", "2017-05-03 13:50:00", "2017-05-10 18:06:29", "2017-05-20 00:00:00"),
("000229ec398224ef6ca0657da4fc703e", "f88197465ea7920adcdbec7375364d82", "delivered", "2018-01-17 19:28:06", "2018-01-17 19:45:59", "2018-01-18 13:39:59", "2018-01-25 00:28:42", "2018-02-05 00:00:00"),
("00024acbcdf0a6daa1e931b038114c75", "8ab97904e6daea8866dbdbc4fb7aad2c", "delivered", "2018-08-14 21:18:39", "2018-08-14 22:20:29", "2018-08-15 19:46:34", "2018-08-22 18:17:02", "2018-09-01 00:00:00"),
("00042b26cf59d7ce69dfabb4e55b4fd9", "503740e9ca751ccdda7ba28e9ab8f608", "delivered", "2017-02-12 21:57:05", "2017-02-12 22:10:13", "2017-02-13 14:58:04", "2017-02-20 10:57:55", "2017-03-01 00:00:00"),
("00048cc3ae777c65dbb7d2a0634bc1ea", "ed0271e0b7da060a393796590e7b737a", "delivered", "2017-05-22 12:22:08", "2017-05-22 13:25:17", "2017-05-23 10:07:46", "2017-05-30 12:55:51", "2017-06-10 00:00:00"),
("00054e8431b9d7675808bcb819fb4a32", "9bdf08b4b3b52b5526ff42d37d47f222", "delivered", "2017-12-13 13:10:30", "2017-12-13 13:22:11", "2017-12-14 10:07:46", "2017-12-21 12:55:51", "2018-01-05 00:00:00"),
("000576fe39319847cbb9d288c5617fa6", "f54a9f0e6b351c431402b8461ea51999", "delivered", "2018-07-09 18:29:09", "2018-07-09 19:50:47", "2018-07-10 14:16:31", "2018-07-17 14:08:10", "2018-07-30 00:00:00"),
("0005a1a1728c9d785b8e2b08b904576c", "310ae3c140ff94b03219ad0adc3c778f", "delivered", "2018-03-25 20:41:37", "2018-03-25 21:24:27", "2018-03-26 14:31:00", "2018-04-02 15:27:45", "2018-04-15 00:00:00");

-- 7. Insert into olist_order_items_dataset (ALL REFERENCES NOW EXIST)
INSERT INTO olist_order_items_dataset VALUES
("00010242fe8c5a6d1ba2dd792cb16214", 1, "4244733e06e7ecb4970a6e2683c13e61", "48436dade18ac8b2bce089ec2a041202", "2017-09-19 09:45:35", 58.90, 13.29),
("00018f77f2f0320c557190d7a144bdd3", 1, "e5f2d52b802189ee658865ca93d83a8f", "dd7ddc04e1b6c2c614352b383efe2d36", "2017-05-03 11:05:13", 239.90, 19.93),
("000229ec398224ef6ca0657da4fc703e", 1, "c777355d18b72b67abbeef9df44fd0fd", "5b51032eddd242adc84c38acab88f23d", "2018-01-18 14:48:30", 199.00, 17.87),
("00024acbcdf0a6daa1e931b038114c75", 1, "7634da152a4610f1595efa32f14722fc", "9d7a1d34a5052409006425275ba1c2b4", "2018-08-15 10:10:18", 12.99, 12.79),
("00042b26cf59d7ce69dfabb4e55b4fd9", 1, "ac6c3623068f30de03045865e4e10089", "df560393f3a51e74553ab94004ba5c87", "2017-02-13 13:57:51", 199.90, 18.14),
("00048cc3ae777c65dbb7d2a0634bc1ea", 1, "ef92defde845ab8450f9d70c526ef70f", "6426d21aca402a131fc0a5d0960a3c90", "2017-05-23 03:55:27", 21.90, 12.69),
("00054e8431b9d7675808bcb819fb4a32", 1, "8d4f2bb7e93e6710a28f34fa83ee7d28", "7040e82f899a04d1b434b795a43b4617", "2017-12-14 12:10:31", 19.90, 11.85),
("000576fe39319847cbb9d288c5617fa6", 1, "557d850972a7d6f792fd18ae1400d9b6", "5996cddab893a4652a15592fb58ab8db", "2018-07-10 12:30:45", 810.00, 70.75),
("0005a1a1728c9d785b8e2b08b904576c", 1, "310ae3c140ff94b03219ad0adc3c778f", "a416b6a846a11724393025641d4edd5e", "2018-03-26 18:31:29", 145.95, 11.65);

-- 8. Insert into olist_order_payments_dataset (USING THE SAME ORDER IDs)
INSERT INTO olist_order_payments_dataset VALUES
("00010242fe8c5a6d1ba2dd792cb16214", 1, "credit_card", 8, 99.33),
("00018f77f2f0320c557190d7a144bdd3", 1, "credit_card", 1, 24.39),
("000229ec398224ef6ca0657da4fc703e", 1, "credit_card", 1, 65.71),
("00024acbcdf0a6daa1e931b038114c75", 1, "credit_card", 8, 107.78),
("00042b26cf59d7ce69dfabb4e55b4fd9", 1, "credit_card", 2, 128.45),
("00048cc3ae777c65dbb7d2a0634bc1ea", 1, "credit_card", 2, 96.12),
("00054e8431b9d7675808bcb819fb4a32", 1, "credit_card", 1, 81.16),
("000576fe39319847cbb9d288c5617fa6", 1, "credit_card", 3, 51.84),
("0005a1a1728c9d785b8e2b08b904576c", 1, "credit_card", 6, 341.09);

-- 9. Insert into olist_order_reviews_dataset (USING THE SAME ORDER IDs)
INSERT INTO olist_order_reviews_dataset VALUES
("rev001", "00010242fe8c5a6d1ba2dd792cb16214", 4, NULL, NULL, "2018-01-18 00:00:00", "2018-01-18 21:46:59"),
("rev002", "00018f77f2f0320c557190d7a144bdd3", 5, NULL, NULL, "2018-03-10 00:00:00", "2018-03-11 03:05:13"),
("rev003", "000229ec398224ef6ca0657da4fc703e", 5, NULL, NULL, "2018-02-17 00:00:00", "2018-02-18 14:36:24"),
("rev004", "00024acbcdf0a6daa1e931b038114c75", 5, NULL, "Recebi bem antes do prazo estipulado.", "2017-04-21 00:00:00", "2017-04-21 22:02:06"),
("rev005", "00042b26cf59d7ce69dfabb4e55b4fd9", 5, NULL, "Parabéns lojas lannister adorei comprar pela Internet seguro e prático Parabéns a todos feliz Páscoa", "2018-03-01 00:00:00", "2018-03-02 10:26:53"),
("rev006", "00048cc3ae777c65dbb7d2a0634bc1ea", 1, NULL, NULL, "2018-04-13 00:00:00", "2018-04-16 00:39:37"),
("rev007", "00054e8431b9d7675808bcb819fb4a32", 5, NULL, NULL, "2017-07-16 00:00:00", "2017-07-18 19:30:34"),
("rev008", "000576fe39319847cbb9d288c5617fa6", 5, NULL, NULL, "2018-08-14 00:00:00", "2018-08-14 21:36:06"),
("rev009", "0005a1a1728c9d785b8e2b08b904576c", 5, NULL, NULL, "2017-05-17 00:00:00", "2017-05-18 12:05:37");

-- 10. Verify all data was inserted correctly
SELECT 
    (SELECT COUNT(*) FROM olist_geolocation_dataset) as geolocation_count,
    (SELECT COUNT(*) FROM olist_customers_dataset) as customers_count,
    (SELECT COUNT(*) FROM olist_sellers_dataset) as sellers_count,
    (SELECT COUNT(*) FROM olist_products_dataset) as products_count,
    (SELECT COUNT(*) FROM product_category_name_translation) as categories_count,
    (SELECT COUNT(*) FROM olist_orders_dataset) as orders_count,
    (SELECT COUNT(*) FROM olist_order_items_dataset) as order_items_count,
    (SELECT COUNT(*) FROM olist_order_payments_dataset) as payments_count,
    (SELECT COUNT(*) FROM olist_order_reviews_dataset) as reviews_count;
    
    
    
 
SELECT order_id, order_status, order_purchase_timestamp
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_purchase_timestamp BETWEEN '2018-01-01' AND '2018-12-31'
ORDER BY order_purchase_timestamp DESC;

SELECT 
    customer_state,
    COUNT(*) as total_customers,
    AVG(LENGTH(customer_zip_code_prefix)) as avg_zip_length
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC;






SELECT 
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm * product_height_cm * product_width_cm as product_volume
FROM olist_products_dataset
WHERE product_weight_g BETWEEN 100 AND 1000
  AND product_photos_qty > 1
  AND product_category_name IS NOT NULL
ORDER BY product_volume DESC;


SELECT 
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    c.customer_city,
    c.customer_state
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';


SELECT 
    p.product_id,
    p.product_category_name,
    COUNT(oi.order_id) as times_ordered,
    COALESCE(SUM(oi.price), 0) as total_revenue
FROM olist_products_dataset p
LEFT JOIN olist_order_items_dataset oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_category_name
ORDER BY total_revenue DESC;


SELECT 
    o.order_id,
    o.order_status,
    c.customer_city,
    c.customer_state,
    s.seller_city,
    s.seller_state,
    p.product_category_name,
    oi.price,
    oi.freight_value
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
INNER JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
INNER JOIN olist_products_dataset p ON oi.product_id = p.product_id
INNER JOIN olist_sellers_dataset s ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered';


SELECT 
    order_id,
    customer_id,
    order_purchase_timestamp
FROM olist_orders_dataset
WHERE order_id IN (
    SELECT order_id 
    FROM olist_order_payments_dataset 
    WHERE payment_value > 500
);


SELECT 
    product_id,
    product_category_name
FROM olist_products_dataset p
WHERE NOT EXISTS (
    SELECT 1 
    FROM olist_order_items_dataset oi 
    WHERE oi.product_id = p.product_id
);




SELECT 
    seller_id,
    AVG(price) as avg_seller_price,
    (SELECT AVG(price) FROM olist_order_items_dataset) as overall_avg_price
FROM olist_order_items_dataset
GROUP BY seller_id
HAVING avg_seller_price > (SELECT AVG(price) FROM olist_order_items_dataset);


SELECT 
    product_category_name,
    COUNT(*) as product_count,
    AVG(product_weight_g) as avg_weight,
    MAX(product_weight_g) as max_weight,
    MIN(product_weight_g) as min_weight,
    SUM(product_weight_g) as total_weight
FROM olist_products_dataset
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
HAVING COUNT(*) > 5
ORDER BY product_count DESC;


SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.price) as total_revenue,
    SUM(oi.freight_value) as total_freight,
    AVG(oi.price) as avg_order_value
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
INNER JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


SELECT 
    payment_type,
    COUNT(*) as payment_count,
    SUM(payment_value) as total_payment_value,
    AVG(payment_value) as avg_payment_value,
    MAX(payment_value) as max_payment_value,
    MIN(payment_value) as min_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payment_value DESC;


CREATE INDEX idx_orders_customer_id ON olist_orders_dataset(customer_id);
CREATE INDEX idx_orders_status_date ON olist_orders_dataset(order_status, order_purchase_timestamp);
CREATE INDEX idx_order_items_product_id ON olist_order_items_dataset(product_id);
CREATE INDEX idx_order_items_seller_id ON olist_order_items_dataset(seller_id);
CREATE INDEX idx_payments_order_id ON olist_order_payments_dataset(order_id);
CREATE INDEX idx_customers_state ON olist_customers_dataset(customer_state);
CREATE INDEX idx_products_category ON olist_products_dataset(product_category_name);

CREATE INDEX idx_orders_composite ON olist_orders_dataset(customer_id, order_status, order_purchase_timestamp);
CREATE INDEX idx_order_items_composite ON olist_order_items_dataset(order_id, product_id, seller_id);

SHOW INDEX FROM olist_orders_dataset;
SHOW INDEX FROM olist_order_items_dataset;


EXPLAIN SELECT 
    o.order_id,
    o.order_status,
    c.customer_state,
    SUM(oi.price) as order_total
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
INNER JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp BETWEEN '2018-01-01' AND '2018-12-31'
  AND c.customer_state = 'SP'
GROUP BY o.order_id, o.order_status, c.customer_state
ORDER BY order_total DESC;
 
 -- 1. Customer Order Summary View
CREATE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.customer_state,
    c.customer_city,
    COUNT(o.order_id) as total_orders,
    SUM(COALESCE(oi.price, 0)) as total_spent,
    AVG(COALESCE(oi.price, 0)) as avg_order_value,
    MAX(o.order_purchase_timestamp) as last_order_date
FROM olist_customers_dataset c
LEFT JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_state, c.customer_city;

-- 2. Product Performance View
CREATE VIEW product_performance AS
SELECT 
    p.product_id,
    p.product_category_name,
    pt.product_category_name_english,
    COUNT(oi.order_id) as times_ordered,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_price,
    SUM(oi.freight_value) as total_freight
FROM olist_products_dataset p
LEFT JOIN olist_order_items_dataset oi ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY p.product_id, p.product_category_name, pt.product_category_name_english;

-- 3. Seller Performance View
CREATE VIEW seller_performance AS
SELECT 
    s.seller_id,
    s.seller_state,
    s.seller_city,
    COUNT(DISTINCT oi.order_id) as total_orders,
    COUNT(oi.order_item_id) as total_items_sold,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_item_price,
    SUM(oi.freight_value) as total_freight_earned
FROM olist_sellers_dataset s
LEFT JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_state, s.seller_city;


SELECT * FROM customer_order_summary WHERE total_orders > 0 ORDER BY total_spent DESC;
SELECT * FROM product_performance WHERE times_ordered > 0 ORDER BY total_revenue DESC;
SELECT * FROM seller_performance WHERE total_orders > 0 ORDER BY total_revenue DESC;

WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') as sales_month,
        c.customer_state,
        p.product_category_name,
        COUNT(DISTINCT o.order_id) as order_count,
        SUM(oi.price) as total_revenue,
        AVG(oi.price) as avg_order_value
    FROM olist_orders_dataset o
    INNER JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    INNER JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    INNER JOIN olist_products_dataset p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
    GROUP BY sales_month, c.customer_state, p.product_category_name
),
top_categories AS (
    SELECT 
        customer_state,
        product_category_name,
        total_revenue,
        RANK() OVER (PARTITION BY customer_state ORDER BY total_revenue DESC) as revenue_rank
    FROM monthly_sales
)
SELECT 
    tc.customer_state,
    tc.product_category_name,
    tc.total_revenue,
    ms.order_count,
    ms.avg_order_value
FROM top_categories tc
INNER JOIN monthly_sales ms ON tc.customer_state = ms.customer_state 
    AND tc.product_category_name = ms.product_category_name
WHERE tc.revenue_rank <= 3  -- Top 3 categories per state
ORDER BY tc.customer_state, tc.revenue_rank;














