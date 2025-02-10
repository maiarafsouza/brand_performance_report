{{ config(
    schema='maps'
) }}

WITH og AS (
    SELECT 
        CONCAT(
            'TM: ',
            new_tm,
            ' | ',
            category_1_1,
            cat_group_1_2,
            bev_cat_1_3,
            bev_sub_cat_1_4
            ) AS ID,
        new_tm as TM,
        new_brand AS og_brand
    FROM {{ref('product_category')}}
    WHERE is_zero = false
    ORDER BY ID
        ),
zero AS (
    SELECT 
        CONCAT(
            'TM: ',
            new_tm,
            ' | ',
            category_1_1,
            cat_group_1_2,
            bev_cat_1_3,
            bev_sub_cat_1_4
            ) AS ID,
        new_tm AS TM,
        new_brand AS zero_brand
    FROM {{ref('product_category')}}
    WHERE is_zero = true
    ORDER BY ID
        )
SELECT 
    CASE
        WHEN og.ID IS NULL THEN zero.id
        ELSE og.ID 
    END as ID,
    CASE
        WHEN og.TM IS NULL THEN zero.TM
        ELSE og.TM 
    END as TM,
    og_brand,
    zero_brand
FROM og
FULL JOIN zero
    ON zero.ID = og.ID
ORDER BY TM