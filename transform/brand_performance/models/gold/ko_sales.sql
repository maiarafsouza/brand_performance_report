{{ config(
    schema='gold'
) }}

WITH t AS (
    SELECT

        * EXCLUDE (category_1_1, cat_group_1_2, bev_cat_1_3, bev_sub_cat_1_4, TM, brand, is_zero, platform_name, country_state, bo),

        {{platform_id(
            'platform_name', 
            'channel',
            'vertical'
        )}} AS platform_id,

        {{geography_id(
            'country', 
            'country_state',
            'bo'
        )}} AS geography_id

    FROM {{ref('std_ogz')}}
)

SELECT 
    t.* EXCLUDE (channel, country),
    gmv_ko_dc_lc * sci AS nsr_ko_dc_lc
FROM t
LEFT JOIN {{ref('nsr_sci')}} AS sci_t
    ON t.country=sci_t.country AND t.channel=sci_t.channel