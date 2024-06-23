with stg_customer_product_reviews as (
    select * from {{ source('visionmart','customer_product_reviews')}}
)

select  
    {{ dbt_utils.generate_surrogate_key(['review_id']) }} as review_key, 
    stg_customer_product_reviews.*,
    current_timestamp() as active_time
from stg_customer_product_reviews
