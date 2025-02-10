{% test rows_not_missing(model) %}

WITH row_count AS (
    SELECT filename, COUNT(*) as row_qtd
    FROM {{model}}
    GROUP BY filename
)

SELECT filename, row_qtd
FROM row_count
WHERE row_qtd >= 20000

{% endtest %}


