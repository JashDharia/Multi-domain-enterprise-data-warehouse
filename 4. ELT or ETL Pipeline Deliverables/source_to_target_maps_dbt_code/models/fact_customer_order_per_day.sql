with
    stg_order_details as (select * from {{ source("visionmart", "order_details") }}),
    stg_customers as (select * from {{ source("visionmart", "customers") }}),
    stg_dim_date as (select * from {{ source("visionmart", "DateDimension") }}),
    stg_products as (select * from {{ source("visionmart", "products") }}),
    stg_orders as (select * from {{ source("visionmart", "orders") }})

select
    {{ dbt_utils.generate_surrogate_key(["c.customer_id"]) }}
    as fact_customer_order_per_day_key,
    c.customer_id,
    o.order_date,
    o.order_id,
    sum(p.product_retail_price * od.order_qty) as price
from stg_orders o
join stg_order_details od on o.order_id = od.order_id
join stg_products p on p.product_id = od.product_id
join stg_customers c on c.customer_id = o.customer_id
group by o.order_date, c.customer_id, o.order_id
