{% macro get_tm_from_id(id)%}

string_split({{id}}, '|')[1]

{% endmacro %}