-- Common Table Expressions (CTEs)
WITH stg_music_billing AS (
    SELECT * FROM {{ source('visionmusic', 'Membership_Billing') }}
),
stg_membership AS (
    SELECT * FROM {{ source('visionmusic', 'Membership') }}
)

-- Main Query
SELECT 
    {{ dbt_utils.generate_surrogate_key(['mb.billing_id']) }} AS fact_music_plan_billing_key,
    mb.customer_id AS customer_key,
    EXTRACT(month FROM mb.membership_date) AS month,
    EXTRACT(year FROM mb.membership_date) AS year,
    sum(m.price) AS amount
FROM
    stg_music_billing mb
JOIN 
    stg_membership m ON mb.membership_id = m.membership_id
group by
     fact_music_plan_billing_key, customer_key, month, year
ORDER BY 
    customer_key, month, year
