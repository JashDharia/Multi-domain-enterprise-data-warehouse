with stg_departments_lookup as (
    select * from {{ source('visionmart','departments_lookup')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['DEPARTMENT_ID']) }} as department_key, 
    DEPARTMENT_ID,
    current_timestamp() as active_time
from stg_departments_lookup
