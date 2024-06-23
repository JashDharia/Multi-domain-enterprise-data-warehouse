with stg_creditcards as (
    select * from {{ source('visionmart','creditcards')}}
)

-- Load data into DBT target table
select  
    {{ dbt_utils.generate_surrogate_key(['CREDITCARD_ID']) }} as creditcard_key, 
    stg_creditcards.*,
    current_timestamp() as active_time
from stg_creditcards
