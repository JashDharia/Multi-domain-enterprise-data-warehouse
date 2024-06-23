with stg_account_billing as (
    select * from {{ source('visionflix','account_billing')}}
),
stg_plans as (
    select * from {{ source('visionflix','plans')}}
),
stg_dim_date as (
    select * from {{ source('visionmart','DateDimension')}}
)
select
    {{dbt_utils.generate_surrogate_key(['a.ab_id'])}} as fact_account_bill_analysis_key,
    a.ab_account_id as customer_key,
    a.ab_plan_id as plan_key,
    a.ab_date as date_key,
    month,
    year,
    p.discount,
    p.plan_price as amount,
    (p.plan_price*p.discount)/100 as total_discount,
    (p.plan_price-p.discount) as total_amount
from
    stg_account_billing a inner join stg_plans p on a.ab_plan_id = p.plan_id
    inner join stg_dim_date d on a.ab_date = d.datetime
order by
    customer_key