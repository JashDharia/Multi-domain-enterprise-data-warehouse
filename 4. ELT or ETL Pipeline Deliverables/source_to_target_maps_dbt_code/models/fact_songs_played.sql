with stg_tracks as 
(
    select
        track_id,
        artist_id,
        track_name,
        track_genre,
        TO_VARCHAR(track_duration, 'HH24:MI:SS') as track_duration_time,
        {{ dbt_utils.generate_surrogate_key(['artist_id']) }} as artistkey
    from {{ source('visionmusic','Tracks') }}
),
stg_artists as 
(
    select
        artist_id,  
        artist_name
    from {{ source('visionmusic','Artists') }}
),
stg_songs_played as
(
    select
        track_id,
        date_time 
    from {{ source('visionmusic', 'Songs_Played') }}
)

select  sp.date_time,
    t.*,
    a.artist_name
from 
    stg_tracks t
join 
    stg_artists a on t.artist_id = a.artist_id
join 
    stg_songs_played sp on t.track_id = sp.track_id
ORDER BY 
    sp.date_time DESC
