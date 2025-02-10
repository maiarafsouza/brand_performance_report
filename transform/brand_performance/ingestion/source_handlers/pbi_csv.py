# %%
import os
from .log import logger


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
def create_dir(path:str):
    logger.info(f"Checking if dir {path} already exists")
    if os.path.exists(path):
        logger.info(f"Dir {path} already exists. Skipping...")
    else:
        os.makedirs(path)
        logger.info(f"{path} created successfully")

# %%
def write_file(old_path, new_path, f_name):
    logger.info(f"Writing from {old_path} to {new_path}")
    with open(f"{old_path}/{f_name}", 'r', encoding='utf-8') as inp, open(f"{new_path}/{f_name}", 'w', encoding='utf-8') as out:
        content = inp.readlines()
        if content[0][0:22] == '[IsGrandTotalRowTotal]':
            #writer = csv.writer(out)
            for row in content:
                if row[:4]!='True':
                    out.write(row)
                else:
                    logger.info("Row total found")

# %%
def ingest_dir(dir, sep="/", old_dir:str="pbi_csv", new_dir:str="bronze"):
    f_list=list_files_recursive(dir)
    for i in f_list:
        logger.info(f"Ingesting file {i}")
        old_path = get_dir_from_path(i, sep=sep)
        f_name = get_f_name(i, sep=sep)
        new_path = get_new_path(old_path=old_path, old_dir=old_dir, new_dir=new_dir)
        create_dir(path=new_path)
        write_file(old_path=old_path, new_path=new_path, f_name=f_name)
        logger.info(f"{i} ingested")
    logger.info(f"Ingestion completed")

# %%
