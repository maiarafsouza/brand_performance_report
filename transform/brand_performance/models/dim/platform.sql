{{ config(
    schema='dim'
) }}

WITH t AS (
    SELECT DISTINCT
        platform_name, 
        channel
        FROM {{ref('tm_sales')}}
    UNION
    SELECT DISTINCT
        platform_name, 
        channel 
    FROM {{ref('mkt_sales')}}
    )
SELECT 
     *,
    {{platform_id('platform_name', 'channel')}} AS ID
FROM t