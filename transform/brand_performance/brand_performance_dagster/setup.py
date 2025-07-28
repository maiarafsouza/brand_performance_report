from setuptools import find_packages, setup

setup(
    name="brand_performance_dagster",
    version="0.0.1",
    packages=find_packages(),
    package_data={
        "brand_performance_dagster": [
            "dbt-project/**/*",
        ],
    },
    install_requires=[
        "dagster",
        "dagster-cloud",
        "dagster-dbt",
        "dbt-core<1.10",
        "dbt-duckdb<1.10",
        "dbt-duckdb<1.10",
    ],
    extras_require={
        "dev": [
            "dagster-webserver",
        ]
    },
)