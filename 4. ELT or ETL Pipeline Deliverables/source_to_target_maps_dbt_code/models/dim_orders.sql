with stg_orders as (
    select * from {{ source('visionmart','orders')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['ORDER_ID']) }} as order_key, 
    stg_orders.*,
    current_timestamp() as active_time
from stg_orders