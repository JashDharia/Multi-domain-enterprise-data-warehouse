select     
    datekey::int as date_key,
    date,
    year,
    month,
    quarter,
    day, 
    dayofweek,
    weekofyear,
    dayofyear,
    quartername,
    monthname,
    dayname,
    weekday
    from {{ source('visionmart','DateDimension')}}
