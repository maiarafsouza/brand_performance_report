{% macro platform_id(platform_name, channel)%}
CONCAT({{platform_name}}, ' | ', {{channel}})
{% endmacro %}