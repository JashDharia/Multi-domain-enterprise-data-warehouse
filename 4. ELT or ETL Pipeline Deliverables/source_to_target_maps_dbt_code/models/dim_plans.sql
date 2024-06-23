with stg_plans as (
    select * from {{ source('visionflix','plans')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_plans.plan_id']) }} as plan_key, 
    stg_plans.*,
    current_timestamp() as active_time
from stg_plans