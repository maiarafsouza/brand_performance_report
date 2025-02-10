gen_dates:
	poetry run py -m transform.brand_performance.ingestion.create_dates

ingest:
	poetry run py -m transform.brand_performance.ingestion.ingest

transform_data:
	cd transform/brand_performance && \
	poetry run dbt seed && \
	poetry run dbt run && \
	poetry run dbt test && \
	poetry run dbt docs generate && \
	poetry run dbt docs serve

test_data:
	cd transform/brand_performance && \
	poetry run dbt test