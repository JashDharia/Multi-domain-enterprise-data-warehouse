with stg_titles as (
    select * from {{ source('visionflix','titles')}}
),
stg_directors as (
    select * from {{ source('visionflix','directors')}}
),
stg_title_genres as (
    select * from {{ source('visionflix','title_genres')}}
)
select
    {{ dbt_utils.generate_surrogate_key(['s.title_id']) }} as title_key,
    s.title_id, s.title_name, s.title_type,
    s.title_synopsis, s.title_avg_rating,
    s.title_release_year, s.title_runtime,
    s.title_rating, s.title_bluray_available,
    s.title_date_modified, d.director_people_id as director_id,
    t.tg_genre_name as genre
from
    stg_titles s left join stg_directors d on s.title_id = d.director_title_id
    left join stg_title_genres t on s.title_id = t.tg_title_id