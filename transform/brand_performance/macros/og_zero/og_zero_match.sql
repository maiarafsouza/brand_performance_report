{% macro og_zero_match(ean_product_name, category_1_1, is_zero)%}

CASE
    WHEN 
        ((regexp_matches({{ean_product_name}}, 'zero *a[çc][uú]car|zero', 'i') AND NOT regexp_matches({{ean_product_name}}, 'zero *s[oó]dio', 'i'))
        OR regexp_matches({{ean_product_name}}, 's*a[çc][uú]car', 'i')
        OR regexp_matches({{ean_product_name}}, 'lemon *fresh', 'i')
        OR regexp_matches({{ean_product_name}}, 'aquarius *fresh', 'i')
        OR regexp_matches({{ean_product_name}}, ' s *a *[^0-9A-Za-z_]| s *a *$', 'i')) 
        AND
        ({{category_1_1}} = 'SSDs' AND {{is_zero}} = false)
    THEN TRUE
    ELSE {{is_zero}}
END
{% endmacro %}