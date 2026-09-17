-- FINTECH PAYMENT ANALYTICS PROJECT--

CREATE DATABASE payment_analytics;
USE payment_analytics;

--  CUSTOMERS TABLE--

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

--  MERCHANT TABLE--

CREATE TABLE merchant (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(100),
    category VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);


--  TRANSACTIONS TABLE--

CREATE TABLE transcations (
    transcation_id INT PRIMARY KEY,
    customer_id INT,
    merchant_id INT,
    transcation_date DATETIME,
    amount DECIMAL(12,2),
    payment_method VARCHAR(30),
    transcation_status VARCHAR(30),
    failure_reason VARCHAR(100),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (merchant_id)
        REFERENCES merchant(merchant_id)
);

--  INSERT CUSTOMERS--

INSERT INTO customers VALUES
(1,'Sakshi Mundhe','Pune','2026-02-11'),
(2,'Shreya Magar','Mumbai','2026-03-20'),
(3,'Payal Dhokale','Delhi','2026-04-20'),
(4,'Pratik Mundhe','Bangluru','2026-05-13'),
(5,'Bharat Walunj','Hydrabad','2026-07-24');

-- INSERT MERCHANTS--

INSERT INTO merchant VALUES
(101,'Amazon','E-Commerce','Pune','2026-01-15'),
(102,'Swiggy','Food Delivery','Mumbai','2026-02-20'),
(103,'Flipkart','E-Commerce','Bengaluru','2026-03-10'),
(104,'Apollo Pharmacy','Healthcare','Hyderabad','2026-04-15'),
(105,'IRCTC','Travel','Delhi','2026-05-25');

-- INSERT TRANSACTIONS--

INSERT INTO transcations VALUES
(1001,1,101,'2025-03-01 10:15:00',4500,'UPI','Success',NULL),
(1002,2,102,'2025-03-01 12:30:00',850,'Credit Card','Success',NULL),
(1003,3,103,'2025-03-02 15:45:00',7200,'UPI','Failed','Insufficient Balance'),
(1004,4,104,'2025-03-03 09:20:00',1200,'Debit Card','Success',NULL),
(1005,5,105,'2025-03-03 18:10:00',3500,'Net Banking','Success',NULL),
(1006,1,102,'2025-03-04 20:15:00',1800,'UPI','Failed','Technical Error'),
(1007,3,101,'2025-03-05 11:40:00',12500,'Credit Card','Success',NULL),
(1008,2,104,'2025-03-06 14:25:00',2500,'UPI','Success',NULL);

SELECT * FROM customers;

SELECT * FROM merchant;

SELECT * FROM transcations;

SHOW TABLES;

--  TOTAL TRANSACTIONS--

SELECT COUNT(*) AS total_transactions
FROM transcations;

--  TOTAL TRANSACTION AMOUNT--

SELECT SUM(amount) AS total_transaction_amount
FROM transcations;

-- TRANSACTION STATUS ANALYSIS--

SELECT transcation_status,
    COUNT(*) AS total_transactions
FROM transcations
GROUP BY transcation_status;

--  SUCCESS RATE--

SELECT COUNT(*) AS total_transactions,

    SUM(CASE WHEN transcation_status = 'Success' THEN 1 ELSE 0
        END
    ) AS successful_transactions,

    SUM(CASE WHEN transcation_status = 'Failed' THEN 1 ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        SUM(CASE WHEN transcation_status = 'Success' THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS success_rate
FROM transcations;

--  PAYMENT METHOD ANALYSIS --

SELECT payment_method,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM transcations
GROUP BY payment_method
ORDER BY total_amount DESC;

--  FAILURE REASON ANALYSIS--

SELECT failure_reason,
    COUNT(*) AS total_failed_transactions
FROM transcations
WHERE transcation_status = 'Failed'
GROUP BY failure_reason;

--  CUSTOMER-WISE ANALYSIS--

SELECT c.customer_name,
    COUNT(*) AS total_transactions,
    SUM(t.amount) AS total_spent
FROM transcations t
JOIN customers c
    ON t.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

--  MERCHANT-WISE ANALYSIS--

SELECT m.merchant_name,
    COUNT(*) AS total_transactions,
    SUM(t.amount) AS total_amount
FROM transcations t
JOIN merchant m
    ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_name
ORDER BY total_amount DESC;

-- CATEGORY-WISE ANALYSIS--

SELECT m.category,
    SUM(t.amount) AS total_amount
FROM transcations t
JOIN merchant m
    ON t.merchant_id = m.merchant_id
GROUP BY m.category
ORDER BY total_amount DESC;

--  AVERAGE TRANSACTION AMOUNT--

SELECT ROUND(AVG(amount), 2) AS average_transaction_amount
FROM transcations;

--  HIGHEST TRANSACTION AMOUNT--

SELECT MAX(amount) AS highest_transaction_amount
FROM transcations;

--  LOWEST TRANSACTION --

SELECT MIN(amount) AS lowest_transaction_amount
FROM transcations;

--  SUCCESS VS FAILED AMOUNT--

SELECT transcation_status,
    SUM(amount) AS total_amount
FROM transcations
GROUP BY transcation_status;

--  PAYMENT METHOD /STATUS--

SELECT payment_method, transcation_status,
    COUNT(*) AS total_transactions
FROM transcations
GROUP BY payment_method, transcation_status
ORDER BY payment_method, transcation_status;

-- MERCHANT-WISE SUCCESS / FAILED--

SELECT m.merchant_name,
    t.transcation_status,
    COUNT(*) AS total_transactions
FROM transcations t
JOIN merchant m
    ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_name, t.transcation_status
ORDER BY m.merchant_name, t.transcation_status;

--  DAILY TRANSACTION ANALYSIS--

SELECT DATE(transcation_date) AS transaction_date, 
COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM transcations
GROUP BY DATE(transcation_date)
ORDER BY transaction_date;

--  TOP CUSTOMER BY SPENDING--

SELECT c.customer_name, SUM(t.amount) AS total_spent
FROM transcations t
JOIN customers c
    ON t.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;