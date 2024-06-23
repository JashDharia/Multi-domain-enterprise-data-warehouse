with stg_artists as (
    select * from {{ source('visionmusic','Artists')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_artists.artist_id']) }} as artistkey, 
    stg_artists.* 
from stg_artists
