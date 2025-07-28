{{ config(
    schema='silver'
) }}



-- Cleans and creates key for relationship with brand_tm table
-- TO DO: Implement dynamic rule application with config file or table with rules and code being responsible only for applying those rules
WITH sales AS (
    SELECT 
        * EXCLUDE (vertical, country_state),
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
            ELSE vertical 
        END AS vertical,
        CASE
            WHEN (NOT regexp_matches(country, 'Bra[sz]il', 'i')) AND (country_state = 'SP')
            THEN NULL
            ELSE country_state
        END AS country_state
    FROM {{ref('tm_sales')}}
        ),

-- Gets standardized names
std_tm AS (
    SELECT 
        sales.* EXCLUDE(BRAND_ID, tm_1_5, brand_1_6, category_1_1, cat_group_1_2, bev_cat_1_3, bev_sub_cat_1_4),
        new_tms.* EXCLUDE(old_id)
    FROM sales
    LEFT JOIN {{ref('converted_namelist')}} as new_tms
        ON sales.BRAND_ID = new_tms.old_id
        ),



-- Classifies products brand and TM 
-- based on unique ean_product_name, TM combinations
-- to be joined with fact table
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
    ),

-- Updates brands and TMs on sales table
fact_classified_tm AS (
    SELECT 
        f.* EXCLUDE (TM, brand),
        t.tm_match,
        COALESCE(t._TM, f.TM) AS TM,
        COALESCE(t._BRAND, f.brand) AS brand
    FROM std_tm as f
    LEFT JOIN classified_tm as t ON (
        CASE 
        WHEN f.tm IS NULL or t.TM IS NULL THEN
            (f.ean_product_name=t.ean_product_name)
        ELSE
            (f.ean_product_name=t.ean_product_name)
            AND
            (f.TM=t.TM)
        END)),

-- Flags records that need to be recategorized and joins new category values
fact_to_classify_subcat AS (
    SELECT 
        f.*,
        CASE 
            WHEN (b.target_category = 'ARTD') AND (NOT regexp_matches(subcat_id, 'alcoholic', 'i')) 
            THEN 'recat to ARTD'
            ELSE NULL
        END AS change_subcat
    FROM fact_classified_tm AS f
    LEFT JOIN {{ref('tms_to_new_category')}} AS b ON f.TM=b.tm
)


-- Selects new category values when available
SELECT 
    f.* EXCLUDE(
        'category_1_1',
        'cat_group_1_2',
        'bev_cat_1_3',
        'bev_sub_cat_1_4',
        'subcat_id'
    ),
    COALESCE(n.subcat_id, f.subcat_id) AS subcat_id,
    COALESCE(n.category_1_1, f.category_1_1) AS category_1_1,
    COALESCE(n.cat_group_1_2, f.cat_group_1_2) AS cat_group_1_2,
    COALESCE(n.bev_cat_1_3, f.bev_cat_1_3) AS bev_cat_1_3,
    COALESCE(n.bev_sub_cat_1_4, f.bev_sub_cat_1_4) AS bev_sub_cat_1_4


FROM fact_to_classify_subcat AS f
LEFT JOIN {{ref('new_category')}} AS n ON n.to_subcat=f.change_subcat