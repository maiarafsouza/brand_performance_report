{% macro geography_id(country, country_state, bo)%}
CONCAT({{country}}, ' | ', {{country_state}}, ' | ', {{bo}})
{% endmacro %}