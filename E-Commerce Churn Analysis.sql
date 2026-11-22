COPY ecommerce_events
FROM 'D:\Download\E-Commerce Customer\ecommerce_full_month_sample.csv'
DELIMITER ','
CSV HEADER;


ALTER TABLE ecommerce_events 
ALTER COLUMN category_code TYPE character varying(255);

ALTER TABLE ecommerce_events 
ALTER COLUMN brand TYPE character varying(100);

ALTER TABLE ecommerce_events 
ALTER COLUMN user_session TYPE character varying(100);


SELECT COUNT(*) FROM ecommerce_events;
SELECT * FROM ecommerce_events Limit 10;


-- Query 1: Get total count and distribution of each event type

SELECT 
    event_type, 
    COUNT(*) AS total_count
FROM ecommerce_events
GROUP BY event_type
ORDER BY total_count DESC;

-- Query 2: Calculate view-to-purchase conversion rate

SELECT 
    COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS total_views,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_purchases,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 / 
        COUNT(CASE WHEN event_type = 'view' THEN 1 END), 
        2
    ) AS conversion_rate_percent
FROM ecommerce_events;

-- Query 3: Find top 10 brands by number of purchases

SELECT 
    brand,
    COUNT(*) AS purchase_count
FROM ecommerce_events
WHERE event_type = 'purchase' AND brand IS NOT NULL
GROUP BY brand
ORDER BY purchase_count DESC
LIMIT 10;

-- Query 4: Calculate total revenue and top revenue-generating brands

SELECT 
    brand,
    COUNT(*) AS total_purchases,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_order_value
FROM ecommerce_events
WHERE event_type = 'purchase' AND brand IS NOT NULL
GROUP BY brand
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 5: Find top 10 categories by purchase count and revenue

SELECT 
    category_code,
    COUNT(*) AS total_purchases,
    SUM(price) AS total_revenue
FROM ecommerce_events
WHERE event_type = 'purchase' AND category_code IS NOT NULL
GROUP BY category_code
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 6: Find the hour of the day with highest number of purchases

SELECT 
    EXTRACT(HOUR FROM event_time) AS purchase_hour,
    COUNT(*) AS total_purchases
FROM ecommerce_events
WHERE event_type = 'purchase'
GROUP BY purchase_hour
ORDER BY total_purchases DESC;

-- Query 7: Analyze repeat vs one-time purchase customers

SELECT 
    purchase_count,
    COUNT(*) AS number_of_users
FROM (
    SELECT 
        user_id, 
        COUNT(*) AS purchase_count
    FROM ecommerce_events
    WHERE event_type = 'purchase'
    GROUP BY user_id
) AS user_purchases
GROUP BY purchase_count
ORDER BY purchase_count;

-- Query 8: Find each user's last purchase date and days since last purchase

SELECT 
    user_id,
    MAX(event_time) AS last_purchase_date,
    DATE '2019-10-31' - MAX(event_time)::date AS days_since_last_purchase
FROM ecommerce_events
WHERE event_type = 'purchase'
GROUP BY user_id
ORDER BY days_since_last_purchase DESC
LIMIT 20;

-- Query 9: Segment users into churn risk categories based on purchase recency

SELECT 
    user_id,
    MAX(event_time) AS last_purchase_date,
    DATE '2019-10-31' - MAX(event_time)::date AS days_since_last_purchase,
    CASE 
        WHEN DATE '2019-10-31' - MAX(event_time)::date <= 7 THEN 'Active'
        WHEN DATE '2019-10-31' - MAX(event_time)::date <= 15 THEN 'At Risk'
        ELSE 'Churned'
    END AS churn_status
FROM ecommerce_events
WHERE event_type = 'purchase'
GROUP BY user_id
ORDER BY days_since_last_purchase DESC;

-- Query 10: Get total count of users in each churn status category

SELECT 
    churn_status,
    COUNT(*) AS number_of_users
FROM (
    SELECT 
        user_id,
        CASE 
            WHEN DATE '2019-10-31' - MAX(event_time)::date <= 7 THEN 'Active'
            WHEN DATE '2019-10-31' - MAX(event_time)::date <= 15 THEN 'At Risk'
            ELSE 'Churned'
        END AS churn_status
    FROM ecommerce_events
    WHERE event_type = 'purchase'
    GROUP BY user_id
) AS user_status
GROUP BY churn_status
ORDER BY number_of_users DESC;

-- Quick check: What date range does our sample actually cover?
SELECT 
    MIN(event_time) AS earliest_date,
    MAX(event_time) AS latest_date
FROM ecommerce_events;