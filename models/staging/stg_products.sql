WITH raw_products AS (
    SELECT * FROM {{ source('eventbooking', 'products') }}
),

cleansing_products AS (
    SELECT 
        product_id::STRING AS product_id, 
        TRIM(UPPER(product_family)) AS product_family, 
        TRIM(product_sub_family) AS product_sub_family
    FROM raw_products
    WHERE product_id IS NOT NULL 
    AND product_family IS NOT NULL 
)

SELECT * FROM cleansing_products
