import os
from dotenv import load_dotenv

load_dotenv()

BASE_PATH = os.getenv("BASE_PATH")


def get_local_path(variable_name):
    if ("PATH" in variable_name) or ("DIR" in variable_name):
        return f"{BASE_PATH}{os.getenv(variable_name)}"
    return os.getenv(variable_name)