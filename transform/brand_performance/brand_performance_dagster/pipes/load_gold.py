import os
import yaml
import duckdb
import pandas as pd
from config import config

config()

from dagster_pipes import open_dagster_pipes

yaml_config = yaml.safe_load(open("pipes/config_duckdb_csv.yaml"))

con = duckdb.connect(yaml_config["duckdb_dev"])

def load_file(source_schema, source_table, target_path, output_filename):
    con.sql(f'''
        SELECT *
        FROM {source_schema}.{source_table}   
        ''').to_df().to_csv(f"{target_path}/{output_filename}.csv", index=False)
    

def load_gold():
    with open_dagster_pipes() as context:
        context.log.info(f"Loading gold files to folder")
        for job in yaml_config["etl_jobs"]:
            context.log.info(f"Loading {job["output_filename"]}")
            load_file(source_schema=job["source_schema"],
                      source_table=job["source_table"],
                      target_path=job["target_path"],
                      output_filename=job["output_filename"])

if __name__ == "__main__":
    load_gold()