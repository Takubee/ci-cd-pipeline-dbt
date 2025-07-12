WITH customers AS (
    SELECT * FROM {{ ref('src_customers') }}
),

orders AS (
    SELECT * FROM {{ ref('src_orders') }}
),

customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.email,
        c.status AS customer_status,
        c.is_active,
        o.order_id,
        o.order_date,
        o.total_amount,
        o.status AS order_status,
        o.is_completed,
        o.order_month
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
)

SELECT * FROM customer_orders 