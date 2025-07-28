import dagster as dg
import pandas as pd
from dagster_duckdb import DuckDBResource


class DuckDBCsvIOManager(dg.ConfigurableIOManager):
    output_path: str
    output_filename: str
    duckdb: DuckDBResource
    def __init__(self, output_path, output_filename, duckdb, source_schema, source_table):
        self.output_path = output_path
        self.output_filename = output_filename
        self.duckdb = duckdb
        self.source_schema = source_schema
        self.source_table = source_table

    def _get_path(self, context) -> str:
        return "/".join(context.asset_key.path)
    
    def handle_output(self, context, obj):
        obj.to_csv(f"{self.output_path}/{self.output_filename}.csv", index=False)
        pd.write_csv(self._get_path(context), obj)

    def load_input(self, context) -> pd.DataFrame:
        with self.duckdb.get_connection() as conn:
            df = conn.sql(f"SELECT * FROM {self.source_schema}.{self.source_table}").to_df()
        # return read_csv(self._get_path(context))

class ConfigurableDuckDBCsvIOManager(dg.ConfigurableIOManagerFactory):
    output_path: str
    output_filename: str
    duckdb: str
    source_schema: str
    source_table: str

    def create_io_manager(self, context) -> DuckDBCsvIOManager:
        return DuckDBCsvIOManager(self.output_path, self.output_filename, self.duckdb, self.source_schema, self.source_table)