import os
from config import config

config()

from ingestion.ingest import ingest_data
from dagster_pipes import open_dagster_pipes

def ko_sales_dir():
    with open_dagster_pipes() as context:
        context.log.info(f"Calling module from {os.getcwd()}")

        ingest_data(data_name="TM_SALES", source_lvl="RAW", target_lvl="BRONZE")

if __name__ == "__main__":
    ko_sales_dir()