{{ config(
    schema='dim',
    enabled=true
) }}

SELECT DISTINCT 
        subcat_id,
        is_zero,
        TM,
        brand,
        tm_brand_id,
        {{product_id(
            'subcat_id',
            'tm_brand_id'
        )}} AS product_id,
        scoped

FROM {{ref('converted_namelist')}}