with stg_tracks as (
    select * from {{ source('visionmusic','Tracks')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_tracks.track_id']) }} as trackkey, 
    stg_tracks.* 
from stg_tracks
