{% test platform_not_missing(model) %}

WITH from_fact_0 AS (
    SELECT DISTINCT
        platform_name, 
        channel,
        UPPER(vertical) AS vertical
        FROM {{ref('tm_sales')}}
    WHERE (country = 'Chile') AND (platform_name = 'Lider.cl') AND (left(CAST(day AS VARCHAR), 7) = '2024-01')
    UNION
    SELECT DISTINCT
        platform_name, 
        channel,
        UPPER(vertical) AS vertical
    FROM {{ref('mkt_sales')}}
    ),

from_fact AS (
    SELECT *,
    {{platform_id('platform_name', 'channel', 'vertical')}} AS ID
    FROM from_fact_0
),

from_seed AS (
    SELECT *
    FROM {{model}}
)

SELECT *
FROM from_fact

EXCEPT

SELECT *
FROM from_seed

{% endtest %}