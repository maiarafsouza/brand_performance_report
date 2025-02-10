{% macro get_brand_from_id(id)%}

string_split({{id}}, '|')[2]

{% endmacro %}