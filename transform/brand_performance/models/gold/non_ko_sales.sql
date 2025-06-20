{{ config(
    schema='gold'
) }}

WITH t AS (
    SELECT
    * EXCLUDE (
        vertical
    ),
    CASE 
        WHEN (country = 'Chile') AND (platform_name = 'Lider.cl') AND (left(CAST(day AS VARCHAR), 7) = '2024-01')
        THEN 'UNASSIGNED'
        ELSE vertical 
    END AS vertical
    FROM  {{ref('mkt_sales')}}
)

SELECT 
    * EXCLUDE (
        gmv_mkt_dc_lc,
        gmv_ko_dc_lc,
        channel,
        platform_name,
        vertical,
        category_1_1,
        cat_group_1_2,
        bev_cat_1_3,
        bev_sub_cat_1_4,
        country,
        country_state,
        bo
    ),
    CASE 
        WHEN gmv_ko_dc_lc NOT NULL
        THEN ROUND(gmv_mkt_dc_lc, 2) - ROUND(gmv_ko_dc_lc, 2)
        ELSE ROUND(gmv_mkt_dc_lc, 2)
        END AS gmv_non_ko_dc_lc,

    {{platform_id(
        'platform_name', 
        'channel',
        'vertical'
    )}} AS platform_id,

    {{geography_id(
        'country', 
        'country_state',
        'bo'
    )}} AS geography_id,

    {{subcat_id(
        'category_1_1',
        'cat_group_1_2',
        'bev_cat_1_3',
        'bev_sub_cat_1_4'
    )}} AS subcat_id

FROM t