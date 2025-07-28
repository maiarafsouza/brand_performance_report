# %%
from ingestion.__get_path import get_local_path
from ingestion.source_handlers.log import logger
from ingestion.source_handlers.pbi_csv import list_files_recursive
import datetime
# %%

START_DATE = get_local_path(f"START_DATE_SERIES")
SRC_DIR = get_local_path(f"TM_SALES_RAW_DIR")
TARGET_PATH = get_local_path(f"DATE_FILEPATH")
FILENAME = TARGET_PATH.split("/")[-1]

logger.info(f"Searching dates in {SRC_DIR}")


def next_month(period:tuple):
    year = period[0]
    month = period[1]
    if month==12:
        return (year+1, 1)
    else:
        return (year, month+1)
# %%
def get_last_date():
    logger.info(f"Calculating last date")
    f = list_files_recursive(SRC_DIR)
    f = [i.replace("\\", "/") for i in f]
    f.sort(reverse=True, )

    periods = [(int(i.split("/")[-3]), int(i.split("/")[-2])) for i in f]
    periods.sort(reverse=True)
    last_period = periods[0]

    nm = next_month(period=(last_period))

    return datetime.date(year=nm[0], month=nm[1], day=1)

# %%
def generate_date_range():
    logger.info(f"Generating date range")
    last_date = get_last_date()
    first_date = datetime.date.fromisoformat(START_DATE)
    return [(first_date+datetime.timedelta(days=x)).isoformat() for x in range((last_date-first_date).days)]

def create_file_if_not_exists():
    try:
        with open(TARGET_PATH, 'x') as file:
            logger.info(f"File {FILENAME} created")
    except FileExistsError:
        logger.info(f"The file {FILENAME} already exists")
# %%
def write_dates():
    d_range = generate_date_range()
    logger.info(f"Writing dates between {d_range[0]} and {d_range[-1]}")
    lines = ["day"]+d_range

    create_file_if_not_exists()

    with open(TARGET_PATH, "w") as file:
        for i in lines:
            file.write(f'{i}\n')
    logger.info(f"Date creation successful")

# %%
if __name__ == "__main__":
    write_dates()