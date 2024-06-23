with stg_shipvia_lookup as (
    select * from {{ source('visionmart','shipvia_lookup')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['SHIP_VIA']) }} as shipvia_key, 
    stg_shipvia_lookup.*,
    current_timestamp() as active_time
from stg_shipvia_lookup
