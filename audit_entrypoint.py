# %%
import duckdb
import pandas as pd

# %%
con = duckdb.connect("transform/performance_data_dev.db")
# %%
con.sql("SHOW ALL TABLES").show(max_rows=100)

# %%
con.sql('''
SELECT *
FROM main_dim.dim_subcat   
        ''').to_df().to_csv("transform/brand_performance/data/gold/subcat.csv", index=False)

# %%
con.sql('''
SELECT *
FROM main_dim.dim_tm   
        ''').to_csv("transform/brand_performance/data/gold/tm.csv")


# %%
con.sql('''
SELECT *
FROM main_dim.dim_date   
        ''').to_csv("transform/brand_performance/data/gold/date.csv")

# %%
con.sql('''
SELECT *
FROM main_dim.dim_geography   
        ''').to_csv("transform/brand_performance/data/gold/geography.csv")


# %%
con.sql('''
SELECT *
FROM main_dim.dim_platform   
        ''').to_csv("transform/brand_performance/data/gold/platform.csv")

# %%
con.sql('''
SELECT *
FROM main_gold.ko_sales   
        ''').to_csv("transform/brand_performance/data/gold/ko_sales.csv")

# %%
con.sql('''
SELECT *
FROM main_gold.non_ko_sales   
        ''').to_csv("transform/brand_performance/data/gold/non_ko_sales.csv")

# %%
con.sql("DESCRIBE main_bronze.tm_sales").show(max_rows=100)

# %%
con.sql('''
        SELECT DISTINCT * FROM main_dbt_test__audit.relationships_ko_sales_product_id__product_id__ref_dim_tm_
        ''')
# %%
con.sql("SELECT * FROM main_silver.test_std_ogz WHERE ean_product_name = '00000000000000000000000007894900680539 - sprite lemon fresh 1,5l'").show(max_width=10000000, max_rows=100)

# %%
con.sql("SELECT DISTINCT tm_1_5_from_ost, brand_1_6_from_ost, tm_brand_id, tm_match, change_subcat, ogz_match, tm, brand, is_zero FROM main_silver.test_std_ogz ORDER BY ogz_match, tm, brand").show(max_width=10000000, max_rows=500)

# %%
con.sql("SELECT SUM(gmv_ko_dc_lc) FROM main_silver.test_std_ogz").show(max_width=10000000, max_rows=100)

# %%
con.sql("SELECT SUM(gmv_ko_dc_lc) FROM main_silver.std_ogz").show(max_width=10000000, max_rows=100)

# %%
