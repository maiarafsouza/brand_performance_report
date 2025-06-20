# %%
import re
from pandera import Check

# %%
def check_date(date_str):
    if re.match("202[0-9]-[0-9][0-9]-[0-9][0-9]T00:00:00", date_str)!=None:
        month_n = int(date_str.split("-")[1])
        day_n = int(date_str.split("-")[2][0:2])
        if month_n in range(1, 13) and day_n in range(1, 32):
            return True
    return False

# %%            

valid_date = Check(lambda d: check_date(d), element_wise=True)


# %%
