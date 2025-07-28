{% macro treat_cola_string(cola_string)%}

    REPLACE(
        REPLACE(
            {{cola_string}}, '-COCA-COLA -', ''
            ),
        'coca-cola company',
        '')

{% endmacro %}