{{ config(
    schema='silver'
) }}

WITH t AS (
    SELECT

        * EXCLUDE (category_1_1, cat_group_1_2, bev_cat_1_3, bev_sub_cat_1_4, TM, brand, is_zero, platform_name),

        {{subcat_id(
            'category_1_1',
            'cat_group_1_2',
            'bev_cat_1_3',
            'bev_sub_cat_1_4'
        )}} AS subcat_id,

        {{tm_brand_id(
            'TM',
            'brand'
        )}} AS tm_brand_id,

        {{platform_id(
            'platform_name', 
            'channel'
        )}} AS platform_id

    FROM {{ref('std_ogz')}}
)

SELECT 
    t.* EXCLUDE (channel),
    gmv_ko_dc_lc * sci AS nsr_ko_dc_lc
FROM t
LEFT JOIN {{ref('nsr_sci')}} AS sci_t
    ON t.country=sci_t.country AND t.channel=sci_t.channel