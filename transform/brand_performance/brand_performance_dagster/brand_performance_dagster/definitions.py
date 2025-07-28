import os
import yaml
from collections.abc import Sequence
from dagster import Definitions, PipesSubprocessClient, AssetsDefinition
from dagster_dbt import DbtCliResource
from dagster_duckdb import DuckDBResource
from pipes.io import DuckDBCsvIOManager, ConfigurableDuckDBCsvIOManager
from .assets import brand_performance_dbt_assets, date_file, mkt_sales_dir, ko_sales_dir, gold_files
from .project import brand_performance_project
from .schedules import schedules
from dotenv import load_dotenv

load_dotenv("pipes/.env")


# def load_duckdbcsv_jobs_from_yaml(yaml_path: str) -> Sequence[AssetsDefinition]:
#     config = yaml.safe_load(open(yaml_path))
#     factory_assets = [build_duckdbcsv_job(
#                 database_path=job_config["database_path"],
#                 source_schema=job_config["source_schema"],
#                 source_table=job_config["source_table"],
#                 output_path=job_config["target_path"],
#                 output_filename=job_config["output_filename"]
#             ) for job_config in config["etl_jobs"]]
#     return factory_assets

defs = Definitions(
    assets=[date_file, mkt_sales_dir, ko_sales_dir, brand_performance_dbt_assets, gold_files],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=brand_performance_project),
        "pipes_subprocess_client": PipesSubprocessClient(),
        "duckdb_dev": DuckDBResource(database=os.getenv("DUCKDB_DEV_PATH"),
                                            schema="main_gold"),
        "duckdb_prod": DuckDBResource(database=os.getenv("DUCKDB_PROD_PATH"),
                                            schema="main_gold")
    }
)
