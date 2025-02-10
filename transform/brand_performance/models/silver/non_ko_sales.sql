{{ config(
    schema='silver'
) }}

SELECT 
    * EXCLUDE (
        gmv_mkt_dc_lc,
        gmv_ko_dc_lc,
        channel,
        platform_name,
        category_1_1,
        cat_group_1_2,
        bev_cat_1_3,
        bev_sub_cat_1_4
    ),

    gmv_mkt_dc_lc - gmv_ko_dc_lc AS gmv_non_ko_dc_lc,

    {{platform_id(
        'platform_name', 
        'channel'
    )}} AS platform_id,

    {{subcat_id(
        'category_1_1',
        'cat_group_1_2',
        'bev_cat_1_3',
        'bev_sub_cat_1_4'
    )}} AS subcat_id
FROM {{ref('mkt_sales')}}