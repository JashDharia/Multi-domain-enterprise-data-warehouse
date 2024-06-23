with f_top_tracks as (
    select * from {{ ref('fact_top_tracks') }}
)

select * from f_top_tracks
