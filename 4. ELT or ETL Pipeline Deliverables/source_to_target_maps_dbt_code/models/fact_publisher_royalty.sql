WITH 
stg_publishers as 
(
    select *
       
    from {{ source('VISIONBOOKS','PUBLISHERS') }}
),
stg_title as
(
    select *
       
    from {{ source('VISIONBOOKS', 'TITLES') }}
),
stg_publish as (
select t.PUB_ID,
sum(t.ROYALTY) as royalty_sum
from 
    stg_title t
join stg_publishers p on t.PUB_ID=p.PUB_ID

group by t.PUB_ID
)

select royalty_sum,PUB_ID
from stg_publish


