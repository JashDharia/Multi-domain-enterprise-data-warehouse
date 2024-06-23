with f_top_artists as (
    select * from {{ ref('fact_top_artists') }}
)

select * from f_top_artists
