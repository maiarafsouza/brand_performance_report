{{ config(
    schema='dim'
) }}

SELECT
    day, 
    quarter(day) as quarter_n,
    weekofyear(day) as week_n,
    month(day) as month_n,
    year(day) as year_n,
    day(day) as day_n,
    weekday(day) as weekday_n
FROM {{ref('date_range')}}