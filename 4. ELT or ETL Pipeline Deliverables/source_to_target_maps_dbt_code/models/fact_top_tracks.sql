with stg_tracks as 
(
    select
        track_id,
        track_name,
        track_genre
    from {{ source('visionmusic','Tracks') }}
),
stg_likes as
(
    select
        track_id, ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS track_rank
    from {{ source('visionmusic', 'Likes') }}
    GROUP BY track_id

)

select  
sl.track_rank, st.track_id, st.track_name, st.track_genre
from stg_tracks st
JOIN stg_likes sl
ON st.track_id = sl.track_id
