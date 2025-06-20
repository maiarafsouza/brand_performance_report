{{ config(
    schema='dim'
) }}

SELECT 
    * 
FROM {{ref('geography')}}