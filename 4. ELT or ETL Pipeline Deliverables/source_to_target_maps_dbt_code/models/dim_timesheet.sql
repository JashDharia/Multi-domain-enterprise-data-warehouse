with stg_employee_timesheets as (
    select * from {{ source('visionmart','employee_timesheets')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['TIMESHEET_ID']) }} as timesheet_key, 
    stg_employee_timesheets.*,
    current_timestamp() as active_time
from stg_employee_timesheets
