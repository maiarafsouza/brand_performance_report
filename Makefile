gen_dates:
	poetry run py -m transform.brand_performance.ingestion.create_dates

ingest:
	poetry run py -m transform.brand_performance.ingestion.create_dates
	poetry run py -m transform.brand_performance.ingestion.ingest

transform_data:
	cd transform/brand_performance && \
	poetry run dbt clean && \
	poetry run dbt seed --full-refresh && \
	poetry run dbt run && \
	poetry run dbt test && \
	poetry run dbt docs generate && \
	poetry run dbt docs serve

serve_docs:
	cd transform/brand_performance && \
	poetry run dbt docs generate && \
	poetry run dbt docs serve

transform_no_test:
	cd transform/brand_performance && \
	poetry run dbt clean && \
	poetry run dbt seed --full-refresh && \
	poetry run dbt run

test_data:
	cd transform/brand_performance && \
	poetry run dbt test

test_macro:
	cd transform/brand_performance && \
	poetry run dbt test --select validate__all_tm_match

test_dates:
	cd transform/brand_performance && \
	poetry run dbt test --select "tag:date_test"

commit_seed_edit:
	cd transform/brand_performance && \
	poetry run dbt seed --full-refresh

update_pbi_source:
	cd transform/brand_performance && \
	poetry run py -m update_gold

test_brand_id_1:
	cd transform/brand_performance && \
	dbt run --select converted_namelist

test_brand_id_2:
	cd transform/brand_performance && \
	dbt run --select std_brand_tm_name

test_ogz_1:
	cd transform/brand_performance && \
	dbt run --select std_ogz

test_ogz_2:
	cd transform/brand_performance && \
	dbt run --select test_std_ogz