
    
      WITH stg_authors AS (
          SELECT * FROM {{ source('VISIONBOOKS', 'AUTHORS') }}
      )
      SELECT 
          {{ dbt_utils.generate_surrogate_key(['stg_authors.au_id']) }} AS authorkey, 
          AU_ID,
          CONCAT(AU_LNAME, ', ', AU_FNAME) AS authornamelastfirst,
          CONCAT(AU_FNAME, ' ', AU_LNAME) AS authornamefirstlast,
          PHONE,
          ADDRESS,
          CITY,
          STATE,
          ZIP,
          CONTRACT
      FROM stg_authors
