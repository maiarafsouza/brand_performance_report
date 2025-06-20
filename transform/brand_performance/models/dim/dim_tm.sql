{{ config(
    schema='dim'
) }}

SELECT DISTINCT 
        subcat_id,
        is_zero,
        TM,
        brand,
        tm_brand_id,
        product_id,
        scoped

FROM {{ref('converted_namelist')}}