{{ config(
    schema='tm_staging'
) }}

WITH sales AS (
    SELECT 
        {{brand_id(
            'category_1_1',
            'cat_group_1_2',
            'bev_cat_1_3',
            'bev_sub_cat_1_4',
            'tm_1_5',
            'brand_1_6'
            )}} AS BRAND_ID,
        *
    FROM {{ref('tm_sales')}}
        ),
std_tm AS (
    SELECT 
        * EXCLUDE (BRAND_ID, tm_1_5, brand_1_6, old_id)
    FROM sales
    LEFT JOIN {{ref('brand_tm')}} as new_tms
        ON sales.BRAND_ID = new_tms.old_id
        ),


classified_tm AS (
    SELECT *,
        {{all_tm_match('ean_product_name', 'TM')}} AS tm_match
    FROM std_tm
    )

SELECT 
    * EXCLUDE (tm_match, TM, brand),
    CASE 
        WHEN 
            tm_match NOT NULL 
        THEN {{get_tm_from_id('tm_match')}} 
        ELSE TM 
    END AS TM,
    CASE 
        WHEN tm_match NOT NULL 
        THEN {{get_brand_from_id('tm_match')}} 
        ELSE brand 
    END AS brand
FROM classified_tm