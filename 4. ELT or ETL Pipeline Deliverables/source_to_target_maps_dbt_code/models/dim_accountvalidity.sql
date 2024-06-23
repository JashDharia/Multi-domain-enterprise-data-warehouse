with stg_account_validity as (
    select * from {{ source('visionmart','account_validity')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['CUSTOMER_ID']) }} as account_validity_key, 
    stg_account_validity.*,
    current_timestamp() as active_time
from stg_account_validity