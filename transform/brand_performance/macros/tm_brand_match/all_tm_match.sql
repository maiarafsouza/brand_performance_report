{% macro all_tm_match(ean_product_name, TM)%}

CASE 
    WHEN 
        regexp_matches({{TM}}, 'Unassigned|Tea|Not NARTD|Alcoholic Beverages|Packaged Water|Schweppes|Coca-Cola|Sprite', 'i')
        OR ({{TM}} IS NULL) 
        OR ({{TM}} = '')
    THEN 
        CASE
            WHEN regexp_matches({{ean_product_name}}, 'jack *[e&] *coke|jack|daniel', 'i') THEN {{tm_brand_id('Jack_&_Coke', 'Jack_&_Coke', 'text')}}
            WHEN regexp_matches({{treat_cola_string(ean_product_name)}}, 'coca[ -]*cola *zero|coca[ -]*cola *cero|coca[ -]*cola light', 'i') THEN {{tm_brand_id('Coca-Cola_Zero', 'Coca-Cola_Zero', 'text')}}
            WHEN regexp_matches({{treat_cola_string(ean_product_name)}}, 'coke|coca[ -]*cola|coca', 'i') THEN {{tm_brand_id('Coca-Cola_Original', 'Coca-Cola_Original', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'fanta|fta', 'i') THEN {{tm_brand_id('Fanta', 'Fanta', 'text')}}
            WHEN (
                regexp_matches({{ean_product_name}}, 'sprite', 'i') 
                AND regexp_matches({{ean_product_name}}, 'absolut|vodka', 'i') 
                AND (NOT regexp_matches({{ean_product_name}}, 'monster|energy', 'i'))) 
                THEN {{tm_brand_id('Absolut_Vodka_&_Sprite', 'Absolut_Vodka_&_Sprite', 'text')}}
            WHEN (
                regexp_matches({{ean_product_name}}, 'sprite', 'i')
                AND regexp_matches({{ean_product_name}}, 'lemon[ ]*fresh|fresh[ ]*lemon', 'i'))
                THEN {{tm_brand_id('Sprite', 'Sprite_Lemon_Fresh', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'sprite', 'i') THEN {{tm_brand_id('Sprite', 'Sprite', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'kuat', 'i') THEN {{tm_brand_id('Kuat', 'Kuat', 'text')}}
            
            WHEN (
                regexp_matches({{ean_product_name}}, 'schwep*s|schw', 'i') 
                AND regexp_matches({{ean_product_name}}, 'drink|mix|gt|gin |spritz|vodka|mista|alc*lica|alc|vdk|pink|intense|prem', 'i') 
                AND (NOT regexp_matches({{ean_product_name}}, 'gin ale|ginger ale|gordon|campari', 'i'))) 
                THEN {{tm_brand_id('Schweppes_ARTD', 'Schweppes_ARTD', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'schwep*s|schw', 'i') THEN {{tm_brand_id('Schweppes', 'Schweppes', 'text')}}
            
            WHEN regexp_matches({{ean_product_name}}, 'e*strell*a *gall*[ií]cia|estrell*a| 1906 ', 'i') THEN {{tm_brand_id("Estrella_Gallicia", "Estrella_Gallicia", "text")}}
            WHEN regexp_matches({{ean_product_name}}, 'th*erez[oó]polis|thz', 'i') THEN {{tm_brand_id('Therezopolis', 'Therezopolis', 'text')}}
            {{crystal_acqua_lia(ean_product_name)}}
            WHEN 
                regexp_matches({{ean_product_name}}, 'cr[yi]stal|ac*qua *lia|ac*qua', 'i') 
                AND NOT regexp_matches({{ean_product_name}}, 'amaciante|tira[ -]*manchas|lava[ -]*roupas|refrigerante|guaran[aá]|cerv|cerveja|pilsen|desodorante|a[cç][uú]car', 'i') 
                THEN {{tm_brand_id('Crystal', 'Crystal', 'text')}}
            WHEN 
                regexp_matches({{ean_product_name}}, 'le[aã]o', 'i')
                AND NOT regexp_matches({{ean_product_name}}, 'sorvete|vassoura|caixa|[0-9] *g|[0-9] *un', 'i') 
                THEN {{tm_brand_id('Leao', 'Leao', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'lemon[ -]*dou', 'i') THEN {{tm_brand_id('Lemon-Dou', 'Lemon-Dou', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, ' ades', 'i') THEN {{tm_brand_id('Ades', 'Ades', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'del *val*e|DV', 'i') THEN {{tm_brand_id('Del_Valle', 'Del_Valle', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'powerade', 'i') THEN {{tm_brand_id('Powerade', 'Powerade', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'simba', 'i') THEN {{tm_brand_id('Simba', 'Simba', 'text')}}
            WHEN 
                regexp_matches({{ean_product_name}}, 'monster', 'i')
                AND NOT regexp_matches({{ean_product_name}}, 'cracker', 'i') 
                THEN {{tm_brand_id('Monster', 'Monster', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'guarapan', 'i') THEN {{tm_brand_id('Guarapan', 'Guarapan', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'aquarius *fresh', 'i') THEN {{tm_brand_id('Aquarius', 'Aquarius_Fresh', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'H2[0O]', 'i') THEN {{tm_brand_id('H2O', 'H2O', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'burn', 'i') THEN {{tm_brand_id('Burn', 'Burn', 'text')}}
            WHEN 
                regexp_matches({{ean_product_name}}, 'i9', 'i')
                AND NOT regexp_matches({{ean_product_name}}, 'slime|brinquedo', 'i') 
                THEN {{tm_brand_id('i9', 'i9', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'yas', 'i') THEN {{tm_brand_id('Yas', 'Yas', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'topo[ -]*chico', 'i') THEN {{tm_brand_id('Topo_Chico', 'Topo_Chico', 'text')}}
            WHEN 
                regexp_matches({{ean_product_name}}, 'jesus', 'i') 
                AND NOT regexp_matches({{ean_product_name}}, '[aá]gua sanit[aá]ria', 'i') 
                THEN {{tm_brand_id('Guarana_Jesus', 'Guarana_Jesus', 'text')}}
            WHEN 
                regexp_matches({{ean_product_name}}, 'taí|tai ', 'i') 
                AND NOT regexp_matches({{ean_product_name}}, 'a[cç][uú]car|cristal', 'i') 
                THEN {{tm_brand_id('Tai', 'Tai', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'reign', 'i') THEN {{tm_brand_id('Reign', 'Reign', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'charr*ua', 'i') THEN {{tm_brand_id('Charrua', 'Charrua', 'text')}}
            WHEN regexp_matches({{ean_product_name}}, 'tuchaua', 'i') THEN {{tm_brand_id('Tuchaua', 'Tuchaua', 'text')}}
            ELSE NULL
        END
        

    ELSE NULL
END

{% endmacro %}