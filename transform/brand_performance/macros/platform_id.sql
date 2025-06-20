{% macro platform_id(platform_name, channel, vertical)%}
CONCAT({{platform_name}}, ' | ', {{channel}}, ' | ', UPPER({{vertical}}))
{% endmacro %}