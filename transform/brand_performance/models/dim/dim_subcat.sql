{{ config(
    schema='dim'
) }}

SELECT DISTINCT 
        category_1_1,
        cat_group_1_2,
        bev_cat_1_3,
        bev_sub_cat_1_4,
        subcat_id
FROM {{ref('converted_namelist')}}