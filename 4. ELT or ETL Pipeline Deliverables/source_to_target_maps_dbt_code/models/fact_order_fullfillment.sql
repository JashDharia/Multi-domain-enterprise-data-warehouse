with 

stg_customers as (
    select * from {{ source('visionmart','customers')}}
),
stg_dim_date as (
    select * from {{ source('visionmart','DateDimension')}}
),
stg_orders as (
    select * from {{ source('visionmart','orders')}}
),
stg_shipvia_lookup as (
    select * from {{ source('visionmart','shipvia_lookup')}}
)

SELECT 
{{dbt_utils.generate_surrogate_key(['o.order_id'])}} as fact_order_fullfillment_key,
o.order_id,
c.customer_id,
CONCAT(c.customer_firstname, ' ', c.customer_lastname) as customer_name,
o.order_date,
o.shipped_date,
c.customer_city as customer_city,
c.customer_state as customer_state,
c.customer_zip as customer_zip,
DATEDIFF(day, o.order_date, o.shipped_date) as lag_days
FROM
    stg_orders o
JOIN
    stg_customers c on c.customer_id = o.customer_id
JOIN 
    stg_shipvia_lookup s on s.SHIP_VIA = o.ship_via