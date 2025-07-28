# %%
import os
# %%
y = ['2022', '2023', '2024', '2025']
m = ['1', '10', '11', '12', '2', '3', '4', '5', '6', '7', '8', '9']

# %%
pbi_mkt_base = "../../data/pbi_csv/market_sales"
bronze_mkt_base = "../../data/bronze/market_sales"


def list_files(base):
    file_list = []
    for i in [i for i in os.listdir(base) if not "." in i]:
        file_path = f"{base}/{i}"
        for p in [i for i in os.listdir(file_path) if not "." in i]:
            file_path = f"{base}/{i}/{p}"
            for c in [i for i in os.listdir(file_path) if "." in i]:
                file_list.append(f"{file_path}/{c}")
    return file_list

# %%
def filter_file_list(files, op_type):
    if op_type == "rm_all_csv":
        return [i for i in files if ".csv" == i[-4:]]
    if op_type == "rm_month_file":
        return [i for i in files if i.split("/")[-1].split("_")[1] in ["Argetina", "Brazil", "Chile", "Uruguay"]]
    else:
        print(f"param '{op_type}' not accepted")
# %%
def clean_dirs(base, op_type):
    for i in filter_file_list(list_files(base), op_type):
        os.remove(i)
    if filter_file_list(list_files(base), op_type) == []:
        print(f"Directory {base} clean")

    
# %%
clean_dirs(pbi_mkt_base, op_type="rm_all_csv")

# %%
clean_dirs(bronze_mkt_base, op_type="rm_month_file")
# %%

# %%
filter_file_list(list_files(bronze_mkt_base), op_type="rm_month_file")
# %%
