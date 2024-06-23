with stg_products as (
    select * from {{ source('visionmart','products')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} as product_key, 
    stg_products.*,
    current_timestamp() as active_time
from stg_products