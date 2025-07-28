{% macro product_id(subcat_id, tm_brand_id)%}
CONCAT(
            {{subcat_id}},
            ' -- ',
            {{tm_brand_id}}
            )
{% endmacro %}