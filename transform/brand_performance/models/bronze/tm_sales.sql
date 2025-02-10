{{ config(
    schema='bronze'
) }}

SELECT 
    "[GMV_Beverage_DC__LC_]" AS gmv_ko_dc_lc,
    "[Transactions]" AS units,
    "[Volume__UC__]" AS vol_uc,
    "Geography[Country]" AS country,
    "Channel[Digital Channel]" AS channel,
    "Channel[Platform Name]" AS platform_name,
    string_split(CAST("Period[Day]" AS STRING), ' ')[1]::date AS day,
    "Product[1.1 - Category]" AS category_1_1,
    "Product[1.2 - Category Group]" cat_group_1_2,
    "Product[1.3 - Beverage Category]" AS bev_cat_1_3,
    "Product[1.4 - Beverage Sub-Category]" AS bev_sub_cat_1_4,
    "Product[1.5 - Trademark]" AS tm_1_5,
    "Product[1.6 - Brand]" AS brand_1_6,
    "Product[Source_Product_Code_Display]" AS ean_product_name,
    filename
FROM {{source('brand_performance_sources', 'bronze_tm_sales')}} AS t