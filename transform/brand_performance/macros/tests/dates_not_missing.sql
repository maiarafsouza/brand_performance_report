{% test dates_not_missing(model) %}

WITH days AS (
    SELECT DISTINCT 
        CONCAT(
            country, '-', channel, '-', 
            platform_name, '-', year(day), '-', 
            month(day)) 
            AS ID, 
        day, 
        year(day) AS year, 
        month(day) AS month
    FROM {{model}}
    GROUP BY 
        country, 
        channel, 
        platform_name, 
        year(day), 
        month(day), 
        day
),

date_range_in as (
    SELECT 
        ID, 
        make_date(year, month, 1) as min_day,
        (date_add(
            make_date("year", "month", 1), 
            INTERVAL 1 MONTH) - INTERVAL 1 DAY)::DATE 
            as max_day,
        list(day) as available_range
    FROM days as d
    GROUP BY 
        ID, 
        year, 
        month
    HAVING len(list(day)) > 1
),
date_range_out AS (
    SELECT 
        ID, 
        list_transform(
            range(min_day, max_day + 1, INTERVAL '1' DAY), 
            x -> CAST(x AS DATE)) 
            as expected_range,
        available_range
    FROM date_range_in
    GROUP BY 
        ID, 
        min_day, 
        max_day, 
        available_range
        
        ),
        missing AS (
        SELECT 
                ID, 
                list_filter(
                    expected_range, 
                    x -> x not in available_range) 
                    AS missing_days
        FROM date_range_out
        )

SELECT * FROM missing WHERE len(missing_days) > 0

{% endtest %}
