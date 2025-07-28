import os
from config import config

config()

from ingestion.create_dates import write_dates as wd
from dagster_pipes import open_dagster_pipes

def write_dates():
    with open_dagster_pipes() as context:
        context.log.info(f"Calling module from {os.getcwd()}")

        wd()

if __name__ == "__main__":
    wd()