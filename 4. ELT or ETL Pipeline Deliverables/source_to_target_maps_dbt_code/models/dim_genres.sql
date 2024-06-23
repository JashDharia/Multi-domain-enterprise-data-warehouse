with stg_genres as (
    select * from {{ source('visionflix','genres')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_genres.genre_name']) }} as genre_key, 
    stg_genres.*,
    current_timestamp() as active_time
from stg_genres