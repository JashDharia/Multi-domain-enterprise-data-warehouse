with
    stg_authors as (select * from {{ source("VISIONBOOKS", "AUTHORS") }}),
    stg_publishers as (select * from {{ source("VISIONBOOKS", "PUBLISHERS") }}),
    stg_title as (select * from {{ source("VISIONBOOKS", "TITLES") }}),
    stg_sales as (select * from {{ source("VISIONBOOKS", "SALES") }}),
    stg_discounts as (select * from {{ source("VISIONBOOKS", "DISCOUNTS") }})

select
    s.sales_id,
    s.qty * t.price as sales_amount,
    qty,
    (s.qty * t.price * d.discount)/100 as discount_amount,
    (s.qty * t.price * (1 - d.discount/100)) as sold_amount,
    s.qty * t.price * t.advance as advance_amount
from stg_title t
join stg_publishers p on t.pub_id = p.pub_id
join stg_sales s on s.title_id = t.title_id
join stg_discounts d on s.sales_id = d.sales_id
