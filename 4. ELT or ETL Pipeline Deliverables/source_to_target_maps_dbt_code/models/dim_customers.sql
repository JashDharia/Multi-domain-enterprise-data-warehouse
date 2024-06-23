with stg_customers as (
    select * from {{ source('visionmart','customers')}}
)
select
    {{ dbt_utils.generate_surrogate_key(['stg_customers.customer_id']) }} as customer_key, 
    stg_customers.*,
    current_timestamp() as active_time
from stg_customers