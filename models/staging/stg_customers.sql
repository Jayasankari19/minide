with rawcustomer as(
    select * from {{source('eventbooking','customers')}}
),

cleansing_customer as(
    select 
    customer_id,
    COALESCE(TRIM(INITCAP(customername)), 'Unknown') AS customer_name, 
    -- TRIM(INITCAP(customername)) AS customername,
    company
    from rawcustomer
    WHERE TRY_CAST(customer_id AS INTEGER) IS NOT NULL
    AND customername IS NOT NULL 

)


select * from cleansing_customer