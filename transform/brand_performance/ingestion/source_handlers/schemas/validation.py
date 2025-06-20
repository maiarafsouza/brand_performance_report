# %%
import pandera as pa
from transform.brand_performance.ingestion.source_handlers.schemas.market_sales import schema as mkt_schema
from transform.brand_performance.ingestion.source_handlers.schemas.tm_sales import schema as tm_schema
from transform.brand_performance.ingestion.source_handlers.log import logger


# %%
class Validator:
    def __init__(self):
        pass

class PbiCsvValidator(Validator):
    d_schemas = {
    "MKT_SALES": mkt_schema,
    "TM_SALES": tm_schema
    }
    def __init__(self, df, data_name):
        super().__init__()
        self.df = df
        self.data_name = data_name
        self.schema = self.d_schemas.get(data_name)


    def is_invalid(self):
        try:
            self.schema.validate(self.df, lazy=True)
        except pa.errors.SchemaErrors as exc:
            logger.error(f"{exc}")
            return exc
        return False

    def assure(self):
        r = self.is_invalid()
        if r:
            raise pa.errors.SchemaErrors(r.schema, r.schema_errors, r.data)
        logger.info(f"Passed data quality validation")
        
# %%
