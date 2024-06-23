with stg_jobtitles_lookup as (
    select * from {{ source('visionmart','jobtitles_lookup')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['JOBTITLE_ID']) }} as jobtitle_key, 
    stg_jobtitles_lookup.*,
    current_timestamp() as active_time
from stg_jobtitles_lookup
