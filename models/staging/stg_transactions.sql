WITH transactions_raw AS (
    SELECT * FROM {{ source('eventbooking', 'transactions') }}
),

cleaned_transactions AS (
    SELECT 
        customer_id,
        product_id::STRING AS product_id, -- Ensure stored as STRING
        TRY_CAST(payment_month AS DATE) AS payment_month, -- Convert only valid dates
        COALESCE(revenue, 0)::FLOAT AS revenue, -- Handle NULLs, ensure FLOAT
        COALESCE(quantity, 0)::INTEGER AS quantity, -- Handle NULLs, ensure INTEGER
        companies::STRING AS company -- Ensure stored as STRING
    FROM transactions_raw
    WHERE customer_id IS NOT NULL 
    AND product_id IS NOT NULL
)

SELECT * FROM cleaned_transactions
