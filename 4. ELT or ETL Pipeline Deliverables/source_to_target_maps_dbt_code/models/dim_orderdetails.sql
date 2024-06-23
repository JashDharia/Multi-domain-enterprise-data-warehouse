with stg_order_details as (
    select * from {{ source('visionmart','order_details')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['ORDER_ID', 'PRODUCT_ID']) }} as order_detail_key, 
    stg_order_details.*,
    current_timestamp() as active_time
from stg_order_details
