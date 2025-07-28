{{ config(
    schema='bronze'
) }}

SELECT 
    SUM("GMV_Beverage_LC_KO_COM") AS gmv_mkt_dc_lc,
    SUM("GMV_Beverage_DC_LC") AS gmv_ko_dc_lc,
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
    filename
FROM {{source('brand_performance_sources', 'bronze_mkt_sales')}}
GROUP BY 
    "Geography_Country",
    "Geography_Bottler_2",
    "Geography_State",
    "Channel_Digital_Channel",
    "Channel_Platform_Name",
    "Geography_Vertical",
    "Period_Day",
    "Product_1_1_Category",
    "Product_1_2_Category_Group",
    "Product_1_3_Beverage_Category",
    "Product_1_4_Beverage_Sub-Category",
    filename