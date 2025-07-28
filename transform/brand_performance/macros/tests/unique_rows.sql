{% test unique_rows(model) %}

-- record in unique file = file not duplicated

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


