with 

stg_order_details as (
    select * from {{ source('visionmart','order_details')}}
),
stg_customers as (
    select * from {{ source('visionmart','customers')}}
),

stg_dim_date as (
    select * from {{ source('visionmart','DateDimension')}}
),
stg_products as (
    select * from {{ source('visionmart','products')}}
),

stg_orders as (
    select * from {{ source('visionmart','orders')}}
)

SELECT 
{{dbt_utils.generate_surrogate_key(['p.product_id'])}} as fact_product_sales_per_day,
o.order_date,
p.product_id, 
p.product_name,
od.order_qty,
sum (p.product_retail_price * od.order_qty) as price
FROM
    stg_orders o
JOIN
    stg_order_details od ON o.ORDER_ID = od.ORDER_ID
JOIN 
    stg_products p on p.product_id = od.product_id
GROUP BY 
o.order_date,
p.product_id,
p.product_name,
od.order_qty
Order BY
p.product_id,
o.order_date