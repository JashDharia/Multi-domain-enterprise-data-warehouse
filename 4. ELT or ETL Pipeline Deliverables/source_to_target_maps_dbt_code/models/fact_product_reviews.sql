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
),
stg_customer_product_reviews as (
    select * from {{ source('visionmart','customer_product_reviews')}}
),
stg_products as (
    select * from {{ source('visionmart','products')}}
)

SELECT 
{{dbt_utils.generate_surrogate_key(['r.review_id'])}} as fact_product_review_key,
p.product_id,
c.customer_id,
r.review_id,
r.review_date,
r.review_stars

FROM
    stg_customer_product_reviews r
JOIN
    stg_customers c on c.customer_id = r.customer_id
JOIN 
    stg_products p on p.product_id = r.product_id

group by
p.product_id,
c.customer_id,
r.review_date,
r.review_stars,
r.review_id

order by
p.product_id
    