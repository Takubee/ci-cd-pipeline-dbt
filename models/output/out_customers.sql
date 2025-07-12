WITH customer_orders AS (
    SELECT * FROM {{ ref('trf_customer_orders') }}
),

customer_metrics AS (
    SELECT
        customer_id,
        customer_name,
        email,
        customer_status,
        is_active,
        -- Aggregated metrics
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN is_completed THEN order_id END) AS completed_orders,
        SUM(CASE WHEN is_completed THEN total_amount ELSE 0 END) AS total_spent,
        AVG(CASE WHEN is_completed THEN total_amount END) AS avg_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        -- Customer segmentation
        CASE 
            WHEN SUM(CASE WHEN is_completed THEN total_amount ELSE 0 END) >= 500 THEN 'high_value'
            WHEN SUM(CASE WHEN is_completed THEN total_amount ELSE 0 END) >= 200 THEN 'medium_value'
            ELSE 'low_value'
        END AS customer_segment
    FROM customer_orders
    GROUP BY customer_id, customer_name, email, customer_status, is_active
)

SELECT * FROM customer_metrics