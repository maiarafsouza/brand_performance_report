{% macro all_tm_match(ean_product_name, TM)%}

CASE 
    WHEN 
        {{TM}} in ['Unassigned', 'Tea', 'Not NARTD', 'Alcoholic Beverages', 'Packaged Water']
        OR {{TM}} IS NULL
    THEN 
        CASE
            WHEN regexp_matches({{ean_product_name}}, 'e*strell*a *gall*[ií]cia|estrell*a| 1906 ', 'i') THEN {{tm_brand_id('Estrella Gallicia', 'Estrella Gallicia')}}
            WHEN regexp_matches({{ean_product_name}}, 'th*erez[oó]polis|thz', 'i') THEN {{tm_brand_id('Therezopolis', 'Therezopolis')}}
            {{crystal_acqua_lia(ean_product_name)}}
            WHEN regexp_matches({{ean_product_name}}, 'cr[yi]stal|ac*qua *lia|ac*qua', 'i') 
            AND NOT regexp_matches({{ean_product_name}}, 'amaciante|tira[ -]*manchas|lava[ -]*roupas|refrigerante|guaran[aá]|cerv|cerveja|pilsen|desodorante|a[cç][uú]car', 'i') THEN {{tm_brand_id('Crystal', 'Crystal')}}
            WHEN regexp_matches({{ean_product_name}}, 'le[aã]o', 'i')
            AND NOT regexp_matches({{ean_product_name}}, 'sorvete|vassoura|caixa|[0-9] *g|[0-9] *un', 'i') THEN {{tm_brand_id('Leao', 'Leao')}}
            WHEN regexp_matches({{ean_product_name}}, 'coca-*cola *zero|coca-*cola *cero', 'i') THEN {{tm_brand_id('Coca-Cola Zero', 'Coca-Cola Zero')}}
            WHEN regexp_matches({{ean_product_name}}, 'schwepp*es|schw', 'i') THEN {{tm_brand_id('Schweppes', 'Schweppes')}}
            WHEN regexp_matches({{ean_product_name}}, 'lemon[ -]*dou', 'i') THEN {{tm_brand_id('Lemon-Dou', 'Lemon-Dou')}}
            WHEN regexp_matches({{ean_product_name}}, 'ades', 'i') THEN {{tm_brand_id('Ades', 'Ades')}}
            WHEN regexp_matches({{ean_product_name}}, 'del *vall*e', 'i') THEN {{tm_brand_id('Del Valle', 'Del Valle')}}
            WHEN regexp_matches({{ean_product_name}}, 'powerade', 'i') THEN {{tm_brand_id('Powerade', 'Powerade')}}
            WHEN regexp_matches({{ean_product_name}}, 'simba', 'i') THEN {{tm_brand_id('Simba', 'Simba')}}
            WHEN regexp_matches({{ean_product_name}}, 'fanta|fta', 'i') THEN {{tm_brand_id('Fanta', 'Fanta')}}
            WHEN regexp_matches({{ean_product_name}}, 'sprite', 'i') THEN {{tm_brand_id('Sprite', 'Sprite')}}
            WHEN regexp_matches({{ean_product_name}}, 'kuat', 'i') THEN {{tm_brand_id('Kuat', 'Kuat')}}
            WHEN regexp_matches({{ean_product_name}}, 'monster', 'i')
                    AND NOT regexp_matches({{ean_product_name}}, 'cracker', 'i') THEN {{tm_brand_id('Monster', 'Monster')}}
            WHEN regexp_matches({{ean_product_name}}, 'guarapan', 'i') THEN {{tm_brand_id('Guarapan', 'Guarapan')}}
            WHEN regexp_matches({{ean_product_name}}, 'aquarius *fresh', 'i') THEN {{tm_brand_id('Aquarius', 'Aquarius Fresh')}}
            WHEN regexp_matches({{ean_product_name}}, 'H2[0O]', 'i') THEN {{tm_brand_id('H2O', 'H2O')}}
            WHEN regexp_matches({{ean_product_name}}, 'burn', 'i') THEN {{tm_brand_id('Burn', 'Burn')}}
            WHEN regexp_matches({{ean_product_name}}, 'i9', 'i')
                    AND NOT regexp_matches({{ean_product_name}}, 'slime|brinquedo', 'i') THEN {{tm_brand_id('i9', 'i9')}}
            WHEN regexp_matches({{ean_product_name}}, 'yas', 'i') THEN {{tm_brand_id('Yas', 'Yas')}}
            WHEN regexp_matches({{ean_product_name}}, 'jack *[e&] *coke|coke|jack|marca coca[ -]*cola', 'i') THEN {{tm_brand_id('Coca-Cola Original', 'Jack & Coke')}}
            WHEN regexp_matches({{ean_product_name}}, 'topo[ -]*chico', 'i') THEN {{tm_brand_id('Topo Chico', 'Topo Chico')}}
            WHEN regexp_matches({{ean_product_name}}, 'jesus', 'i') 
                    AND NOT regexp_matches({{ean_product_name}}, '[aá]gua sanit[aá]ria', 'i') THEN {{tm_brand_id('Guarana Jesus', 'Guarana Jesus')}}
            WHEN regexp_matches({{ean_product_name}}, 'taí|tai ', 'i') 
                    AND NOT regexp_matches({{ean_product_name}}, 'a[cç][uú]car|cristal', 'i') THEN {{tm_brand_id('Tai', 'Tai')}}
            WHEN regexp_matches({{ean_product_name}}, 'reign', 'i') THEN {{tm_brand_id('Reign', 'Reign')}}
            WHEN regexp_matches({{ean_product_name}}, 'charr*ua', 'i') THEN {{tm_brand_id('Charrua', 'Charrua')}}
            WHEN regexp_matches({{ean_product_name}}, 'tuchaua', 'i') THEN {{tm_brand_id('Tuchaua', 'Tuchaua')}}
            ELSE NULL
        END
        

    ELSE NULL
END

{% endmacro %}