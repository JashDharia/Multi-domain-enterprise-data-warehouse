-- Staging Employees table from Snowflake into DBT
with stg_employees as (
    select * from {{ source('visionmart','employees')}}
)

-- Load data into DBT target table
select  
    {{ dbt_utils.generate_surrogate_key(['EMPLOYEE_ID']) }} as employee_key, 
    stg_employees.*,
    current_timestamp() as active_time
from stg_employees
