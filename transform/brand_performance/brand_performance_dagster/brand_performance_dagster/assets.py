import shutil
import yaml
import duckdb
import pandas as pd
from dagster import AssetExecutionContext, PipesSubprocessClient, asset, Definitions
from dagster_duckdb import DuckDBResource
from dagster_dbt import DbtCliResource, dbt_assets, get_asset_key_for_model
from pipes.io import ConfigurableDuckDBCsvIOManager, DuckDBCsvIOManager
from .project import brand_performance_project


@asset(compute_kind="python")
def date_file(context: AssetExecutionContext, pipes_subprocess_client: PipesSubprocessClient) -> None:
    external_code_path = "./pipes/dates.py"
    return pipes_subprocess_client.run(
        command=[shutil.which("python"), external_code_path],
        context=context,
    ).get_results()

@asset(compute_kind="python", deps=["date_file"])
def mkt_sales_dir(context: AssetExecutionContext, pipes_subprocess_client: PipesSubprocessClient) -> None:
    external_code_path = "./pipes/mkt_sales.py"
    return pipes_subprocess_client.run(
        command=[shutil.which("python"), external_code_path],
        context=context,
    ).get_results()

@asset(compute_kind="python", deps=["date_file"])
def ko_sales_dir(context: AssetExecutionContext, pipes_subprocess_client: PipesSubprocessClient) -> None:
    external_code_path = "./pipes/ko_sales.py"
    return pipes_subprocess_client.run(
        command=[shutil.which("python"), external_code_path],
        context=context,
    ).get_results()


@dbt_assets(manifest=brand_performance_project.manifest_path)
def brand_performance_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()

# def build_duckdbcsv_job(
#         my_duckdb_resource: str,
#         output_path: str,
#         output_filename: str,
#         source_schema: str,
#         source_table: str
#     ) -> Definitions:
#     asset_key = f"gold_{source_table}_csv"
#     obj = ConfigurableDuckDBCsvIOManager(
#                         output_path=output_path,
#                         output_filename=output_filename,
#                         duckdb=my_duckdb_resource,
#                         source_schema=source_schema,
#                         source_table=source_table)
#     @asset(name=asset_key)
#     def duckdbcsv_asset(context: AssetExecutionContext):
#         return obj
#     return Definitions(assets=[duckdbcsv_asset])

# def build_duckdbcsv_job(
#         database_path: str,
#         output_path: str,
#         output_filename: str,
#         source_schema: str,
#         source_table: str
#     ) -> Definitions:
#     asset_key = f"gold_{source_table}_csv"
#     @asset(name=asset_key,
#            compute_kind="python",
#            deps=[get_asset_key_for_model([brand_performance_dbt_assets], source_table)])
#     def duckdbcsv_asset(context: AssetExecutionContext):
#         with duckdb.connect(database_path) as conn:
#             df: pd.DataFrame = conn.sql(f"SELECT * FROM {source_schema}.{source_table}").df()
#             df.to_csv(f"{output_path}{output_filename}.csv", index=False)

#     return duckdbcsv_asset

@asset(compute_kind="python", deps=[get_asset_key_for_model([brand_performance_dbt_assets], "ko_sales"),
                                    get_asset_key_for_model([brand_performance_dbt_assets], "non_ko_sales"),
                                    get_asset_key_for_model([brand_performance_dbt_assets], "dim_subcat"),
                                    get_asset_key_for_model([brand_performance_dbt_assets], "dim_tm"),
                                    get_asset_key_for_model([brand_performance_dbt_assets], "dim_date"),
                                    get_asset_key_for_model([brand_performance_dbt_assets], "dim_geography"),
                                    get_asset_key_for_model([brand_performance_dbt_assets], "dim_platform")])
def gold_files(context: AssetExecutionContext, pipes_subprocess_client: PipesSubprocessClient) -> None:
    external_code_path = "./pipes/load_gold.py"
    return pipes_subprocess_client.run(
        command=[shutil.which("python"), external_code_path],
        context=context,
    ).get_results()




