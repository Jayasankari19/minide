WITH rawcustomer as (
    SELECT * FROM {{source('eventbooking', 'country')}}
)

select * from rawcustomer