# %%
import os
from transform.brand_performance.ingestion.source_handlers.log import logger
from transform.brand_performance.ingestion.source_handlers.schemas.validation import PbiCsvValidator
from dotenv import load_dotenv
import pandas as pd
# %%

load_dotenv()
# %%
f_list = []

def list_files_recursive(path:str):
    
    logger.info(f"Initializing file list")
    for entry in os.listdir(path):
        full_path = os.path.join(path, entry)
        if os.path.isdir(full_path):
            logger.info(f"Searching files in {full_path}")
            list_files_recursive(full_path)
        else:
            logger.info(f"Appending {full_path} to file list")
            f_list.append(full_path)
    
    return [i.replace("\\", "/") for i in f_list]

def filter_file_list(files, op_type):
    if op_type == "rm_all_csv":
        return [i for i in files if ".csv" == i[-4:]]
    if op_type == "rm_month_file":
        return [i for i in files if i.split("/")[-1].split("_")[1] in ["Argetina", "Brazil", "Chile", "Uruguay"]]
    else:
        print(f"param '{op_type}' not accepted")

# %%
def get_dir_from_path(path:str, sep:str="/", f_format:str=".csv"):
    logger.info(f"Getting dir from {path}")
    return "/".join([i for i in path.split(sep) if not i.__contains__(f_format)])

def get_new_path(old_path:str, old_dir:str="pbi_csv", new_dir:str="silver"):
    logger.info(f"Getting new path from {old_path} and replacing {old_dir} with {new_dir}")
    return old_path.replace(old_dir, new_dir)

def get_f_name(path:str, sep:str="/"):
    logger.info(f"Getting file name from {path}")
    return path.split(sep)[-1]
# %%
#"/".join([i for i in f_list[0].split("/") if not i.__contains__(".csv")]).replace("pbi_csv", "silver")

# %%
def get_path(var):
    if __name__ == "__main__" and (os.getcwd() == "d:\\Users\\KO\\OneDrive - The Coca-Cola Company\\KO Unified Data Infrastructure\\Brand Performance Report\\transform\\brand_performance\\ingestion\\source_handlers"):
        return f"../../{os.getenv(f"{var}").split("brand_performance/")[1]}"
    return os.getenv(var)

# %%
#def ingest_dir(dir, sep="/", old_dir:str="pbi_csv", new_dir:str="bronze"):
#    f_list=list_files_recursive(dir)
#    for i in f_list:
#        
#        old_path = get_dir_from_path(i, sep=sep)
#        f_name = get_f_name(i, sep=sep)
#        new_path = get_new_path(old_path=old_path, old_dir=old_dir, new_dir=new_dir)
#        create_dir(path=new_path)
#        write_file(old_path=old_path, new_path=new_path, f_name=f_name)
#        logger.info(f"{i} ingested")
#    logger.info(f"Ingestion completed")
# %%
# class DataValidator(pa.DataFrameModel):
#    [IsGrandTotalRowTotal]


# %%
class DirectoryData:
    def __init__(self, data_name, source_lvl="RAW", target_lvl="BRONZE", cleanup=False):
        self.name = data_name
        self.old_path = get_path(f"{data_name}_{source_lvl}_DIR")
        self.new_path = get_path(f"{data_name}_{target_lvl}_DIR")
        self.old_dir_id = [i for i in set(self.old_path.split("/"))-set(self.new_path.split("/"))][0]
        self.new_dir_id = [i for i in set(self.new_path.split("/"))-set(self.old_path.split("/"))][0]
        self.f_list = list_files_recursive(self.old_path)
        self.cleanup = cleanup

    def clean_new_dir(self, op_type="rm_all_csv"):
        curr_contents = list_files_recursive(self.new_path)
        del_contents = filter_file_list(curr_contents, op_type)
        for i in del_contents:
            os.remove(i)
        if filter_file_list(list_files_recursive(self.new_path), op_type) == []:
            logger.info(f"New directory clean")

    def create_new_dir(self, path:str):
        logger.info(f"Checking if dir {path} already exists")
        if os.path.exists(path):
            logger.info(f"Dir {path} already exists. Skipping...")
        else:
            os.makedirs(path)
            logger.info(f"{path} created successfully")

    def ingest_dir(self, stg_list=[]):
        if self.cleanup == True:
            logger.info(f"Cleaning up {self.new_path}")
            self.clean_new_dir()
        if stg_list == []:
            files = self.f_list
        else:
            files = stg_list
        for i in files:
            f_obf = DirectoryFile(i, self)
            f_obf.ingest_file()
        logger.info(f"Directory {self.name} ingested")


# %%
class DirectoryFile:
    d_std_col_name = {
            "[":"_",
            "]":"_",
            ".":"_",
            " - ":"_",
            "____":"_",
            "___":"_",
            "__":"_",
            " ":"_"
        }

    def __init__(self, f_path:str, parent_dir:DirectoryData, sep:str="/"):
        self.f_path = f_path
        self.sep = sep
        self.name: str = get_f_name(f_path, sep=sep)
        self.new_path: str = get_new_path(old_path=f_path, old_dir=parent_dir.old_dir_id, new_dir=parent_dir.new_dir_id)
        self.new_dir: str = sep.join([i for i in self.new_path.split(sep) if not i.__contains__(".")])
        self.parent_dir = parent_dir
        self.df: pd.DataFrame = pd.read_csv(f_path)
        self.validator = PbiCsvValidator

    
    def _new_col_names(self, cols):
        new_names = []

        for c in cols:
            col_n = c
            d = self.d_std_col_name
            for k in self.d_std_col_name:
                col_n = col_n.replace(k, d.get(k))
            if col_n[0] == "_":
                col_n = col_n[1:]
            if col_n[-1] == "_":
                col_n = col_n[:-1]
            new_names.append(col_n)
        logger.info(f"New column names: {new_names}")

        return new_names

    def _std_col_names(self):
        old_cols = self.df.columns
        logger.info(f"Standardizing column names: {old_cols}")
        self.df.columns = self._new_col_names(old_cols)

    def model_df(self):
        if "[IsGrandTotalRowTotal]" in self.df.columns:
            logger.info("Row total found")
            self.df = self.df[self.df["[IsGrandTotalRowTotal]"]==False]
        self.df.drop(columns="[IsGrandTotalRowTotal]", inplace=True)
        self._std_col_names()

    def write_file(self, f_name:str=""):
        logger.info(f"Writing from {self.f_path} to {self.new_path}")
        # if f_name != "":
        #     old_path = f"{self.f_path}{self.sep}{self.name}"
        #     new_path = f"{self.new_path}{self.sep}{self.name}"
        # else:
        #     old_path = f"{self.f_path}"
        #     new_path = f"{self.new_path}"
        # with open(old_path, 'r', encoding='utf-8') as inp, open(new_path, 'w', encoding='utf-8') as out:
        #    content = inp.readlines()
        #     cols = content[0]
        #     if content[0][0:22] == '[IsGrandTotalRowTotal]':
        #         for row in content:
        #             if row[:4]!='True':
        #                 out.write(row)
        #             else:
        #                 logger.info("Row total found")
        self.df.to_csv(self.new_path, index=False)

    def ingest_file(self):
        self.model_df()
        #self.validator(self.df, self.parent_dir.name).assure()
        self.parent_dir.create_new_dir(path=self.new_dir)
        self.write_file()
        logger.info(f"{self.f_path} ingested")
# %%
if __name__ == "__main__":
    m_data = DirectoryData("MKT_SALES")
    m_data.ingest_dir([m_data.f_list[0]])
# %%


# %%



# %%
# df[df["[IsGrandTotalRowTotal]"]==False]
# %%
# cols = [
#     "[IsGrandTotalRowTotal]",
#     "[GMV_Beverage__LC____KO___COM__]",
#     "[GMV_Beverage_DC__LC_]",
#     "Geography[Country]",
#     "Geography[Bottler 2]",
#     "Geography[State]",
#     "Channel[Digital Channel]",
#     "Channel[Platform Name]",
#     "Geography[Vertical]",
#     "Period[Day]",
#     "Product[1.1 - Category]",
#     "Product[1.2 - Category Group]",
#     "Product[1.3 - Beverage Category]",
#     "Product[1.4 - Beverage Sub-Category]"
#     ]


# %%

         
# %%
# std_col_names(cols)
# %%
