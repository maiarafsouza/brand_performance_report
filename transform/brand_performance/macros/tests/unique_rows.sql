{% test unique_rows(model) %}

WITH t AS (
    SELECT 
        *, 
        COUNT(filename) as occurrences
    FROM {{model}}
    GROUP BY ALL 
)

SELECT 
    * 
FROM t
WHERE 
    occurrences > 1 

{% endtest %}


