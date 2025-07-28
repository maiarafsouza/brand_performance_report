{% macro crystal_acqua_lia(ean_product_name)%}

WHEN 
    brand IN ['Packaged Water', 'Sparkling Water'] 
    AND regexp_matches({{ean_product_name}}, 'ac*qua *lia', 'i') 
THEN {{tm_brand_id('Crystal', 'Acqua_Lia', 'text')}}

{% endmacro %}