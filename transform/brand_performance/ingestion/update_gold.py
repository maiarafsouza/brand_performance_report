# %%
import duckdb
import os
import pandas as pd
# %%
# %%
os.chdir("../")

# %%
con = duckdb.connect("../performance_data.db")

# %%
con.sql("SHOW ALL TABLES").show(max_rows=100)

# %%
con.sql('''
SELECT *
FROM main_dim.dim_subcat   
        ''').to_df().to_csv("data/gold/subcat.csv", index=False)

# %%
con.sql('''
SELECT *
FROM main_dim.dim_tm   
        ''').to_csv("data/gold/tm.csv")


# %%
con.sql('''
SELECT *
FROM main_dim.dim_date   
        ''').to_csv("data/gold/date.csv")

# %%
con.sql('''
SELECT *
FROM main_dim.dim_geography   
        ''').to_csv("data/gold/geography.csv")


# %%
con.sql('''
SELECT *
FROM main_dim.dim_platform   
        ''').to_csv("data/gold/platform.csv")

# %%
con.sql('''
SELECT *
FROM main_gold.ko_sales   
        ''').to_csv("data/gold/ko_sales.csv")

# %%
con.sql('''
SELECT *
FROM main_gold.non_ko_sales   
        ''').to_csv("data/gold/non_ko_sales.csv")

# %%
print("Updated successfuly!")

# %%
