{{ config(
    schema='silver'
) }}

-- selects * from std_brand_tm_name
-- selects is_zero from brand_tm
-- creates subcat_id from brand_tm

-- selects * from previous query
-- classifies zero sugar products based on regex criteria

WITH t1 AS (
    SELECT 
        *,
        
        CASE
            WHEN 
                (category_1_1 = 'SSDs'AND is_zero = false)
                AND
                {{og_zero_match('ean_product_name')}} 
                THEN TRUE
            ELSE is_zero
        END AS is_zero_regex
        FROM {{ref('std_brand_tm_name')}}
        ),

-- changes brand and tm name according is_zero regex classification if needed

t2 AS (
    SELECT 
        *,
        CASE 
            WHEN 
                is_zero <> is_zero_regex 
                AND TM NOT IN ['Coca-Cola Original', 'Aquarius', 'Guarana Jesus'] 
                THEN (
                    SELECT FIRST(brand) 
                    from {{ref('std_brand_tm_name')}} as btm 
                    where 
                    btm.TM=t.TM 
                    AND btm.subcat_id=t.subcat_id 
                    AND btm.is_zero=t.is_zero_regex)
            WHEN 
                is_zero <> is_zero_regex 
                AND TM = 'Coca-Cola Original' 
                THEN 'Coca-Cola Zero'
            ELSE t.brand
        END AS brand_regex
    FROM t1 AS t
        )

-- select prefered brand, tm and is_zero values        
SELECT
    gmv_ko_dc_lc,
    units,
    vol_uc,
    country,
    bo,
    country_state,
    channel,
    platform_name,
    vertical,
    day,
    category_1_1,
    cat_group_1_2,
    bev_cat_1_3,
    bev_sub_cat_1_4,
    subcat_id,
    product_id,
    tm_brand_id,
    product_id,
    ms_ss,
    CASE 
        WHEN 
            brand <> brand_regex 
            AND brand_regex = 'Coca-Cola Zero' 
            THEN brand_regex
        ELSE TM
    END AS TM,
    brand_regex as brand,
    is_zero_regex as is_zero,
    ean_product_name,
    filename
        
FROM t2