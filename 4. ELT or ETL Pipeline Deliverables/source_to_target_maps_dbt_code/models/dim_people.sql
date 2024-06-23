with stg_people as (
    select * from {{ source('visionflix','people')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_people.people_id']) }} as people_key, 
    stg_people.*,
    case
        when exists (select 1 from vision.visionflix.directors where director_people_id = people_id) then TRUE
        ELSE FALSE
    END AS is_director,
    current_timestamp() as active_time
from stg_people