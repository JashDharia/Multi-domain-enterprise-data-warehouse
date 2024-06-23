with stg_albums as (
    select * from {{ source('visionmusic','Albums')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_albums.album_id']) }} as albumkey, 
    stg_albums.* 
from stg_albums
