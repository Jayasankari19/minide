

WITH invalid_revenue AS (
    SELECT revenue
    FROM {{ source('eventbooking', 'transactions') }}
    WHERE revenue < 0
)

SELECT * FROM invalid_revenue
