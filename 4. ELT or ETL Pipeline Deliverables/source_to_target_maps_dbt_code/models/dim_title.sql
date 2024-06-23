 WITH stg_title AS (
          SELECT * FROM {{ source('VISIONBOOKS', 'TITLES') }}
      )
      SELECT 
          {{ dbt_utils.generate_surrogate_key(['stg_title.title_id']) }} AS titlekey, 
          TITLE_ID,
          TITLE,
          PRICE,
          ADVANCE,
          ROYALTY,
          YTD_SALES,
          NOTES,
          PUBTIME,
          PUB_ID
      FROM stg_title