with stg_playlists as (
    select * from {{ source('visionmusic','Playlists')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_playlists.playlist_id']) }} as playlistkey, 
    stg_playlists.* 
from stg_playlists
