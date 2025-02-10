{% macro tm_brand_id(tm, brand)%}

CONCAT({{'tm'}}, '|', {{'brand'}})

{% endmacro %}