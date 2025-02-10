import logging
logger = logging.getLogger()
cli_handler = logging.StreamHandler()
logger.addHandler(cli_handler)
formatter = logging.Formatter("{levelname}: {name} - {filename}s:{lineno}d - {funcName}():{message}", style="{")
cli_handler.setFormatter(formatter)
logger.setLevel("INFO")
logger.info(msg="Logging configured")