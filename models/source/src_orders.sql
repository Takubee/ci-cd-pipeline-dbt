WITH source AS (
    SELECT * FROM {{ ref('raw_orders') }}
),

renamed AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        total_amount,
        status,
        -- Add business logic
        CASE 
            WHEN status = 'completed' THEN TRUE
            ELSE FALSE
        END AS is_completed,
        -- Add data quality checks
        CASE 
            WHEN total_amount > 0 THEN 'valid'
            ELSE 'invalid'
        END AS amount_validity,
        -- Add date formatting
        date_trunc('month', order_date) AS order_month
    FROM source
)

SELECT * FROM renamed 