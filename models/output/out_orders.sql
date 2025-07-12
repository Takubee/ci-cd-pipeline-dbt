WITH orders AS (
    SELECT * FROM {{ ref('src_orders') }}
),

customers AS (
    SELECT * FROM {{ ref('out_customers') }}
),

order_facts AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_name,
        c.customer_segment,
        o.order_date,
        o.order_month,
        o.total_amount,
        o.status AS order_status,
        o.is_completed,
        -- Order metrics
        CASE 
            WHEN o.total_amount >= 200 THEN 'high_value'
            WHEN o.total_amount >= 100 THEN 'medium_value'
            ELSE 'low_value'
        END AS order_value_category,
        -- Time-based metrics
        EXTRACT(day FROM o.order_date) AS day_of_month,
        EXTRACT(dow FROM o.order_date) AS day_of_week,
        EXTRACT(month FROM o.order_date) AS month,
        EXTRACT(year FROM o.order_date) AS year
    FROM orders o
    left join customers c ON o.customer_id = c.customer_id
)

SELECT * FROM order_facts 