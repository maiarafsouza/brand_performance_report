{{ config(
    schema='silver'
) }}

WITH 
t1 AS (
    SELECT 
        * EXCLUDE (new_tm, new_brand),
        new_tm AS TM,
        new_brand as brand
    FROM {{ref('old_to_new_tmb')}}
)


SELECT 
    *,
    {{brand_id(
    'category_1_1',
    'cat_group_1_2',
    'bev_cat_1_3',
    'bev_sub_cat_1_4',
    'tm_1_5_from_ost',
    'brand_1_6_from_ost'
    )}} AS old_id,
    {{subcat_id(
            'category_1_1',
            'cat_group_1_2',
            'bev_cat_1_3',
            'bev_sub_cat_1_4'
        )}} AS subcat_id,
    {{tm_brand_id(
            'TM',
            'brand',
            'column'
        )}} AS tm_brand_id
FROM t1



