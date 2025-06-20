{{ config(
    schema='bronze'
) }}

SELECT 
    "GMV_Beverage_DC_LC" AS gmv_ko_dc_lc,
    "Transactions" AS units,
    "Volume_UC" AS vol_uc,
    "Geography_Country" AS country,
    "Geography_Bottler_2" AS bo,
    "Geography_State" AS country_state,
    "Channel_Digital_Channel" AS channel,
    "Channel_Platform_Name" AS platform_name,
    "Geography_Vertical" AS vertical,
    string_split(CAST("Period_Day" AS STRING), ' ')[1]::date AS day,
    "Product_1_1_Category" AS category_1_1,
    "Product_1_2_Category_Group" cat_group_1_2,
    "Product_1_3_Beverage_Category" AS bev_cat_1_3,
    "Product_1_4_Beverage_Sub-Category" AS bev_sub_cat_1_4,
    "Product_1_5_Trademark" AS tm_1_5,
    "Product_1_6_Brand" AS brand_1_6,
    "Product_Source_Product_Code_Display" AS ean_product_name,
    "Package_MS-SS" AS ms_ss,
    filename
FROM {{source('brand_performance_sources', 'bronze_tm_sales')}} AS t