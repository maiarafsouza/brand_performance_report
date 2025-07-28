{% macro tm_brand_id(tm_name, brand_name, source_type)%}

    {% if source_type is string and (source_type == 'text') %}

        REPLACE(CONCAT('{{tm_name}}', '|', '{{brand_name}}'), '_', ' ')

    {% else %}

        CONCAT({{tm_name}}, '|', {{brand_name}})

    {% endif %}

{% endmacro %}