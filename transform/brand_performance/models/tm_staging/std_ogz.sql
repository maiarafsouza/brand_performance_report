{{ config(
    schema='tm_staging'
) }}

WITH t1 AS (
    SELECT 
        *,
        
        CASE
            WHEN 
                ((regexp_matches(ean_product_name, 'zero *a[çc][uú]car|zero', 'i') AND NOT regexp_matches(ean_product_name, 'zero *s[oó]dio', 'i'))
                OR regexp_matches(ean_product_name, 's*a[çc][uú]car', 'i')
                OR regexp_matches(ean_product_name, 'lemon *fresh', 'i')
                OR regexp_matches(ean_product_name, 'aquarius *fresh', 'i')
                OR regexp_matches(ean_product_name, ' s *a *[^0-9A-Za-z_]| s *a *$', 'i')) 
                AND
                (category_1_1 = 'SSDs'AND is_zero = false)
                THEN TRUE
            ELSE is_zero
        END AS is_zero_regex
        FROM {{ref('std_brand_tm_name')}}
        ),
t2 AS (
    SELECT 
        *,
        CASE 
            WHEN 
                is_zero <> is_zero_regex 
                AND TM NOT IN ['Coca-Cola', 'Aquarius', 'Guarana Jesus'] 
                THEN (SELECT FIRST(brand) from {{ref('brand_tm')}} as btm where btm.TM=t.TM AND is_zero=TRUE)
            WHEN 
                is_zero <> is_zero_regex 
                AND TM = 'Coca-Cola' 
                THEN 'Coca-Cola Zero'
            ELSE t.brand
        END AS brand_regex
    FROM t1 AS t
        )
SELECT
    gmv_ko_dc_lc,
    units,
    vol_uc,
    country,
    channel,
    platform_name,
    day,
    category_1_1,
    cat_group_1_2,
    bev_cat_1_3,
    bev_sub_cat_1_4,
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