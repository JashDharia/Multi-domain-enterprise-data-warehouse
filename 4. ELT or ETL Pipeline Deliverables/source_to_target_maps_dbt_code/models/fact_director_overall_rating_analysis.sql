with
    stg_directors as (select * from {{ source("visionflix", "directors") }}),
    stg_titles as (select * from {{ source("visionflix", "titles") }}),
    stg_title_genres as (select * from {{ source("visionflix", "title_genres") }}),
    stg_dim_date as (select * from {{ source("visionmart", "DateDimension") }})
select
    {{ dbt_utils.generate_surrogate_key(["d.director_people_id"]) }}
    as fact_director_overall_rating_analysis_key,
    d.director_people_id as director_key,
    d.director_title_id as title_key,
    tg.tg_genre_name as genre_key,
    dt.year as release_year,
    t.title_avg_rating as avg_popularity_rating,
    t.title_rating
from stg_titles t
inner join stg_directors d on t.title_id = d.director_title_id
inner join stg_dim_date dt on t.title_release_year = dt.year
inner join stg_title_genres tg on t.title_id = tg.tg_title_id
order by director_key, title_key
