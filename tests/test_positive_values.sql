-- Custom test to ensure values are positive
SELECT *
FROM {{ ref('raw_orders') }}
WHERE total_amount <= 0