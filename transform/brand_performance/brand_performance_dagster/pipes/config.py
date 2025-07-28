import os
import sys
from dotenv import load_dotenv

def config():
    load_dotenv()
    ETLTOOLS_PATH = os.getenv("ETLTOOLS_PATH")
    sys.path.append(ETLTOOLS_PATH)