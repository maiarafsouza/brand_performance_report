{{ config(
    schema='silver',
    enabled=false
) }}

WITH zero_sugar_exceptions AS (
    SELECT 
        'Coca-Cola Original' AS original_tm,
        'Coca-Cola Zero' AS new_tm,
        'Coca-Cola Zero' AS new_brand
),

-- Step 2: Create a lookup table to find the correct "zero sugar" brand generically.
-- This replaces the slow correlated subquery.
brand_lookup AS (
    SELECT
        subcat_id,
        tm,
        brand
    FROM (
        SELECT
            s.subcat_id,
            s.tm,
            s.brand,
            sum(gmv_ko_dc_lc) AS sales_amount,
            ROW_NUMBER() OVER(PARTITION BY s.subcat_id, s.tm ORDER BY SUM(gmv_ko_dc_lc) DESC) AS rn
        FROM {{ref('std_brand_tm_name')}} AS s
        FULL OUTER JOIN {{ref('converted_namelist')}} AS l ON (
            s.subcat_id=l.subcat_id
            AND s.tm=l.tm
            AND s.brand=l.brand)
        WHERE l.is_zero = true
        GROUP BY s.subcat_id, s.tm, s.brand
        ) AS ranked_is_zero_brands
    WHERE rn = 1
),
        
-- Step 3: Re-classify data in a single, consolidated step
reclassified_data AS (
    SELECT
        base.* EXCLUDE(tm, brand, is_zero),
        
        -- Use the pre-built maps to determine the final TM and Brand
        -- Priority: 1. Hardcoded Exception -> 2. Generic Lookup -> 3. Original Value
        COALESCE(exc.new_tm, base.tm) AS tm,
        COALESCE(exc.new_brand, lu.brand, base.brand) AS brand,
        
        -- Determine the final 'is_zero' flag
        CASE
            WHEN 
                (
                    (base.category_1_1 = 'SSDs') 
                    OR (base.tm IN ['Sprite', 'Fanta', 'Kuat']
                    )
                )
                AND base.is_zero = false
                AND ogz_match = true
            THEN true
            ELSE base.is_zero
        END AS is_zero
        
    FROM (
        SELECT 
            *, 
            {{og_zero_match('ean_product_name')}} AS ogz_match
        FROM {{ref('std_brand_tm_name')}}
        ) AS base

    -- Join to find hardcoded exceptions
    LEFT JOIN zero_sugar_exceptions AS exc ON 
        base.tm = exc.original_tm
        AND ogz_match = true

    -- Join to find the generic "zero sugar" brand from our lookup table
    LEFT JOIN brand_lookup AS lu 
        ON base.tm = lu.tm
        AND base.subcat_id = lu.subcat_id
        -- We only want to join and find a new brand if the logic flips the 'is_zero' flag
        -- and the TM is not one of the hardcoded exceptions.
        AND (
        CASE
                WHEN 
                    (
                        (base.category_1_1 = 'SSDs') 
                        OR (base.tm IN ['Sprite', 'Fanta', 'Kuat']))
                    AND base.is_zero = false
                    AND base.ogz_match = true
                THEN true
                ELSE base.is_zero
            END) = true
        AND base.tm NOT IN ('Aquarius', 'Guarana Jesus') -- TMs to exclude from generic logic
)

-- Final Step: Select from the clean data and generate IDs
SELECT 
    * EXCLUDE(tm_brand_id),
    {{tm_brand_id('tm', 'brand', 'column')}} AS tm_brand_id,
    {{product_id('subcat_id', 'tm_brand_id')}} AS product_id
FROM reclassified_data
