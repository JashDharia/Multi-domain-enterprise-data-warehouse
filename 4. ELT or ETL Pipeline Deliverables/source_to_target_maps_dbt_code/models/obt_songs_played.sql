with f_songs_played as (
    select * from {{ ref('fact_songs_played') }}
),
d_artist as (
    select * from {{ ref('dim_artist') }}
)

select 
    f.*, d_artist.artist_popularity, d_artist.ARTIST_FOLLOWERS
    from f_songs_played as f
    left join d_artist on f.artistkey = d_artist.artistkey
