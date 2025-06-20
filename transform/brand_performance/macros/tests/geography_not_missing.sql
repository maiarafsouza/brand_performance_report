{% test geography_not_missing(model) %}

WITH from_fact_0 AS (
    SELECT DISTINCT
        country,
        country_state, 
        bo
        FROM {{ref('tm_sales')}}
    UNION
    SELECT DISTINCT
        country,
        country_state, 
        bo
    FROM {{ref('mkt_sales')}}
    ),

from_fact AS (
    SELECT *,
    {{geography_id('country', 'country_state', 'bo')}} AS ID
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