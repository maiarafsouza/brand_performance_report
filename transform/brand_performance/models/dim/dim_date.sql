{{ config(
    schema='dim'
) }}

WITH t AS (
    SELECT
        day, 
        quarter(day) as quarter_n,
        weekofyear(day) as week_n,
        month(day) as month_n,
        year(day) as year_n,
        day(day) as day_n,
        weekday(day) as weekday_n
    FROM {{ref('date_range')}})

SELECT 
    * EXCLUDE (weekday_n),
    CASE 
        WHEN weekday_n < 6 THEN weekday_n + 1
        ELSE 7
    END AS weekday_n
FROM t