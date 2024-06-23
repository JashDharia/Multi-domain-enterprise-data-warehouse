with stg_vendors as (
    select * from {{ source('visionmart','vendors')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['VENDOR_ID']) }} as vendor_key, 
    VENDOR_ID,
    VENDOR_NAME,
    VENDOR_PHONE,
    VENDOR_WEBSITE,
    current_timestamp() as active_time
from stg_vendors