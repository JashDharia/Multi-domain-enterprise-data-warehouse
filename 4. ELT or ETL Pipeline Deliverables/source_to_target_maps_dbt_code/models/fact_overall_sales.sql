with
    stg_account_billing as (
        select * from {{ source("visionflix", "account_billing") }}
    ),
    stg_plans as (select * from {{ source("visionflix", "plans") }}),
    stg_dim_date as (select * from {{ source("visionmart", "DateDimension") }}),
    stg_order_details as (select * from {{ source("visionmart", "order_details") }}),
    stg_customers as (select * from {{ source("visionmart", "customers") }}),
    stg_products as (select * from {{ source("visionmart", "products") }}),
    stg_orders as (select * from {{ source("visionmart", "orders") }}),
    stg_visionflix_fact as (
        select
            {{ dbt_utils.generate_surrogate_key(["a.ab_id"]) }}
            as fact_overall_sales_key,
            a.ab_account_id as customer_key,
            a.ab_plan_id as plan_key,
            month,
            year,
            sum((p.plan_price * p.discount) / 100) as visionflix_total_discount,
            sum((p.plan_price - p.discount)) as visionflix_total_amount
        from stg_account_billing a
        inner join stg_plans p on a.ab_plan_id = p.plan_id
        inner join stg_dim_date d on a.ab_date = d.datetime
        group by fact_overall_sales_key, customer_key, plan_key, month, year
    ),
    stg_visionmart_fact as (
        select
            {{ dbt_utils.generate_surrogate_key(["c.customer_id"]) }}
            as fact_customer_order_per_day_key,
            c.customer_id as customer_key,
            month,
            year,
            sum(p.product_retail_price * od.order_qty) as visionmart_total_amount
        from stg_orders o
        inner join stg_order_details od on o.order_id = od.order_id
        inner join stg_dim_date d on o.order_date = d.date
        inner join stg_products p on p.product_id = od.product_id
        inner join stg_customers c on c.customer_id = o.customer_id
        group by customer_key, month, year
    ),
    stg_music_billing as (select * from {{ source("visionmusic", "Membership_Billing") }}),
    stg_membership as (select * from {{ source("visionmusic", "Membership") }}),
    stg_visionmusic_fact as (
        SELECT 
            mb.customer_id AS customer_key,
            EXTRACT(month FROM mb.membership_date) AS month,
            EXTRACT(year FROM mb.membership_date) AS year,
            sum(m.price) AS visionmusic_total_amount
        FROM
            stg_music_billing mb
        JOIN 
            stg_membership m ON mb.membership_id = m.membership_id
        group by
            customer_key, month, year
    )
select f.customer_key, f.month, f.year, visionflix_total_amount, visionmart_total_amount,
    visionmusic_total_amount, 
from stg_visionflix_fact f
inner join stg_visionmart_fact m on f.customer_key = m.customer_key
inner join stg_visionmusic_fact c on f.customer_key = c.customer_key
where
    f.month = m.month and f.year = m.year and f.month = c.month and f.year = c.year
-- group by f.customer_key, f.month, f.year
order by f.customer_key, f.month, f.year


    