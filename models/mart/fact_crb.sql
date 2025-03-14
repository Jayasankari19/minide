WITH mart AS (
    SELECT * FROM {{ ref('martview') }}
)

SELECT 
    customer_id,
    product_id,
    payment_month,
    revenue,
    LAG(revenue) OVER (PARTITION BY customer_id ORDER BY payment_month) AS previous_revenue,
    CASE 
        WHEN revenue = 0 THEN 'Churned'
        WHEN previous_revenue = 0 THEN 'New'
        WHEN revenue > previous_revenue THEN 'Expansion'
        WHEN revenue < previous_revenue THEN 'Contraction'
        ELSE 'Stable'
    END AS revenue_category
FROM mart;




SELECT 
    payment_month,
    COUNT(DISTINCT CASE WHEN revenue_category = 'New' THEN customer_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN revenue_category = 'Churned' THEN customer_id END) AS churned_customers
FROM {{ ref('fact_crb') }}
GROUP BY payment_month;



SELECT 
    customer_id, 
    COUNT(DISTINCT product_id) AS total_products_bought,
    COUNT(DISTINCT CASE WHEN revenue_category = 'Churned' THEN product_id END) AS products_churned
FROM {{ ref('fact_crb') }}
GROUP BY customer_id
ORDER BY total_products_bought DESC;




SELECT 
    payment_month,
    SUM(CASE WHEN revenue_category IN ('New', 'Expansion') THEN revenue ELSE 0 END) / 
    SUM(CASE WHEN revenue_category NOT IN ('Churned') THEN revenue ELSE 0 END) AS NRR,
    SUM(CASE WHEN revenue_category NOT IN ('Churned', 'New') THEN revenue ELSE 0 END) / 
    SUM(CASE WHEN revenue_category NOT IN ('Churned') THEN revenue ELSE 0 END) AS GRR
FROM {{ ref('fact_crb') }}
GROUP BY payment_month;





SELECT 
    payment_month,
    SUM(CASE WHEN revenue_category = 'Contraction' THEN previous_revenue - revenue ELSE 0 END) AS revenue_lost
FROM {{ ref('fact_crb') }}
GROUP BY payment_month;




SELECT 
    YEAR(payment_month) AS fiscal_year, 
    COUNT(DISTINCT customer_id) AS new_logos
FROM {{ ref('fact_crb') }}
WHERE revenue_category = 'New'
GROUP BY fiscal_year;





SELECT 
    product_id, 
    SUM(revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS product_rank
FROM {{ ref('fact_crb') }}
GROUP BY product_id;



SELECT 
    customer_id, 
    SUM(revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS customer_rank
FROM {{ ref('fact_crb') }}
GROUP BY customer_id;




