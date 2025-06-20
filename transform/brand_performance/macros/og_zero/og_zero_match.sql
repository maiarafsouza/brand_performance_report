{% macro og_zero_match(ean_product_name)%}

CASE
    WHEN 
        (
            (regexp_matches(ean_product_name, 'zero *a[çc][uú]car|zero', 'i') 
            AND NOT regexp_matches(ean_product_name, 'zero *s[oó]dio', 'i')
            )
            OR regexp_matches(ean_product_name, 's*a[çc][uú]car', 'i')
            OR regexp_matches(ean_product_name, 'lemon *fresh', 'i')
            OR regexp_matches(ean_product_name, 'aquarius *fresh', 'i')
            OR regexp_matches(ean_product_name, ' s *a *[^0-9A-Za-z_]| s *a *$', 'i')
        )

    THEN TRUE
    ELSE FALSE
END
{% endmacro %}