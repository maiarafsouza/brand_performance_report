# %%
import sys
import os
from transform.brand_performance.ingestion.source_handlers.pbi_csv import f_list, ingest_dir
from dotenv import load_dotenv
from transform.brand_performance.ingestion.source_handlers.log import logger
# %%
load_dotenv()

# %%
#raw_csv_dirs = [
    #"TM_SALES",
    #"CATEGORY_SALES",
    #"NSR_SCI",
    #"NSR_TM_SALES"
#]

# %%
def ingest_csv(data_name):
    SRC_DIR = os.getenv(f"{data_name}_RAW_DIR")
    TARGET_DIR = os.getenv(f"{data_name}_BRONZE_DIR")
    logger.info(f"Set source as {SRC_DIR}")
    logger.info(f"Set target as {TARGET_DIR}")
    n_dir = set(TARGET_DIR.split("/"))-set(SRC_DIR.split("/"))
    n_dir = [i for i in n_dir][0]
    ingest_dir(dir=SRC_DIR, sep="/", old_dir="pbi_csv", new_dir=n_dir)

# %%
if __name__ == "__main__":
    #data_name = sys.argv[1]
    ingest_csv(data_name="TM_SALES")#)(data_name=data_name)
    ingest_csv(data_name="MKT_SALES")

# %%
