{{ config(
    schema='bronze'
) }}

SELECT 
    "[GMV_Beverage__LC____KO___COM__]" AS gmv_mkt_dc_lc,
    "[GMV_Beverage_DC__LC_]" AS gmv_ko_dc_lc,
    "Geography[Country]" AS country,
    "Channel[Digital Channel]" AS channel,
    "Channel[Platform Name]" AS platform_name,
    string_split(CAST("Period[Day]" AS STRING), ' ')[1]::date AS day,
    "Product[1.1 - Category]" AS category_1_1,
    "Product[1.2 - Category Group]" cat_group_1_2,
    "Product[1.3 - Beverage Category]" AS bev_cat_1_3,
    "Product[1.4 - Beverage Sub-Category]" AS bev_sub_cat_1_4,
    filename
FROM {{source('brand_performance_sources', 'bronze_mkt_sales')}}