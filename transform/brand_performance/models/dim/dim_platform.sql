{{ config(
    schema='dim'
) }}

SELECT 
    * 
FROM {{ref('platform')}}