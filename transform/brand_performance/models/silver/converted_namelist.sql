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
),

t2 AS (
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
            'brand'
        )}} AS tm_brand_id,
    {{brand_id(
            'category_1_1',
            'cat_group_1_2',
            'bev_cat_1_3',
            'bev_sub_cat_1_4',
            'TM',
            'brand'
            )}} AS BRAND_ID
FROM t1
)

SELECT 
    *,
    concat(subcat_id, ' -- ', tm_brand_id) AS product_id 
FROM t2 


