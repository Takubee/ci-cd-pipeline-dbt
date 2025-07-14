WITH source AS (
    SELECT * FROM {{ ref('raw_customers') }}
),

renamed AS (
    SELECT
        customer_id,
        customer_name,
        email,
        created_at,
        status,
        -- Add some data quality checks
        CASE 
            WHEN email like '%@%' THEN 'valid'
            ELSE 'invalid'
        END AS email_validity,
        -- Add business logic
        CASE 
            WHEN status = 'active' THEN TRUE
            ELSE FALSE
        END AS is_active
    FROM source
)

SELECT * FROM renamed