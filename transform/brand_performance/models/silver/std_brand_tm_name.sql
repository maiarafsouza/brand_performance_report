{{ config(
    schema='silver'
) }}



-- creates key for relationship with brand_tm table
WITH sales AS (
    SELECT 
        * EXCLUDE (vertical),
        {{brand_id(
            'category_1_1',
            'cat_group_1_2',
            'bev_cat_1_3',
            'bev_sub_cat_1_4',
            'tm_1_5',
            'brand_1_6'
            )}} AS BRAND_ID,
        CASE 
            WHEN (country = 'Chile') AND (platform_name = 'Lider.cl') AND (left(CAST(day AS VARCHAR), 7) = '2024-01')
            THEN 'UNASSIGNED'
            ELSE vertical END AS vertical
    FROM {{ref('tm_sales')}}
        ),

-- gets standardized names
std_tm AS (
    SELECT 
        sales.* EXCLUDE(BRAND_ID, tm_1_5, brand_1_6, category_1_1, cat_group_1_2, bev_cat_1_3, bev_sub_cat_1_4),
        new_tms.* EXCLUDE (old_id)
    FROM sales
    LEFT JOIN {{ref('converted_namelist')}} as new_tms
        ON sales.BRAND_ID = new_tms.old_id
        ),



-- classifies brand and TM of unassigned products 
-- based on unique ean_product_name, TM combinations to be joined with fact table
classified_tm AS (
    SELECT *,
        {{get_tm_from_id('tm_match')}} AS _TM,
        {{get_brand_from_id('tm_match')}} AS _BRAND
    FROM (
        SELECT DISTINCT 
        ean_product_name, 
        TM,
        {{all_tm_match('ean_product_name', 'TM')}} AS tm_match
        FROM std_tm
        )
    )

SELECT 
    f.* EXCLUDE (TM, brand),
    CASE 
        WHEN 
            t.tm_match NOT NULL 
        THEN t._TM
        ELSE f.TM
    END AS TM,
    CASE 
        WHEN t.tm_match NOT NULL 
        THEN t._BRAND
        ELSE f.brand
    END AS brand
FROM std_tm as f
LEFT JOIN classified_tm as t ON (
    (f.ean_product_name=t.ean_product_name) 
    AND (f.TM=t.TM))