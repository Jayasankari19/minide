WITH transactions AS (
    SELECT * FROM {{ ref('stg_transactions') }}
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

country AS (
    SELECT * FROM {{ ref('stg_country') }}
)

SELECT 
    t.customer_id,
    c.customer_name,
    c.company,
    co.country, 
    co.region,   
    t.product_id,
    p.product_family,
    p.product_sub_family,
    t.payment_month,
    t.revenue,
    t.quantity
FROM transactions t
LEFT JOIN customers c ON t.customer_id = c.customer_id
LEFT JOIN country co ON c.customer_id = co.customer_id  
LEFT JOIN products p ON t.product_id = p.product_id
