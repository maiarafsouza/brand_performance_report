{% macro all_tm_match(ean_product_name, TM)%}

CASE 
    WHEN 
        {{TM}} in ['Unassigned', 'Tea', 'Not NARTD', 'Alcoholic Beverages', 'Packaged Water']
        OR {{TM}} IS NULL
    THEN 
        CASE
            WHEN regexp_matches({{ean_product_name}}, 'e*strell*a *gall*[ií]cia|estrell*a| 1906 ', 'i') THEN 'Estrella Gallicia'
            WHEN regexp_matches({{ean_product_name}}, 'th*erez[oó]polis|thz', 'i') THEN 'Therezópolis'
            {{crystal_acqua_lia(ean_product_name)}}
            WHEN regexp_matches({{ean_product_name}}, 'cr[yi]stal|ac*qua *lia|ac*qua', 'i') 
            AND NOT regexp_matches({{ean_product_name}}, 'amaciante|tira[ -]*manchas|lava[ -]*roupas|refrigerante|guaran[aá]|cerv|cerveja|pilsen|desodorante|a[cç][uú]car', 'i') THEN 'Crystal'
            WHEN regexp_matches({{ean_product_name}}, 'le[aã]o', 'i')
            AND NOT regexp_matches({{ean_product_name}}, 'sorvete|vassoura|caixa|[0-9]*g|[0-9]* *un', 'i') THEN 'Leão'
            WHEN regexp_matches({{ean_product_name}}, 'coca-*cola *zero|coca-*cola *cero', 'i') THEN 'Coca-Cola Zero'
            WHEN regexp_matches({{ean_product_name}}, 'schwepp*es|schw', 'i') THEN 'Schweppes'
            WHEN regexp_matches({{ean_product_name}}, 'lemon[ -]*dou', 'i') THEN 'Lemon-Dou'
            WHEN regexp_matches({{ean_product_name}}, 'ades', 'i') THEN 'Ades'
            WHEN regexp_matches({{ean_product_name}}, 'del *vall*e', 'i') THEN 'Del Valle'
            WHEN regexp_matches({{ean_product_name}}, 'powerade', 'i') THEN 'Powerade'
            WHEN regexp_matches({{ean_product_name}}, 'simba', 'i') THEN 'Simba'
            WHEN regexp_matches({{ean_product_name}}, 'fanta|fta', 'i') THEN 'Fanta'
            WHEN regexp_matches({{ean_product_name}}, 'sprite', 'i') THEN 'Sprite'
            WHEN regexp_matches({{ean_product_name}}, 'kuat', 'i') THEN 'Kuat'
            WHEN regexp_matches({{ean_product_name}}, 'monster', 'i')
                    AND NOT regexp_matches({{ean_product_name}}, 'cracker', 'i') THEN 'Monster'
            WHEN regexp_matches({{ean_product_name}}, 'guarapan', 'i') THEN 'Guarapan'
            WHEN regexp_matches({{ean_product_name}}, 'aquarius *fresh', 'i') THEN 'Aquarius Fresh'
            WHEN regexp_matches({{ean_product_name}}, 'H2[0O]', 'i') THEN 'H2O'
            WHEN regexp_matches({{ean_product_name}}, 'burn', 'i') THEN 'Burn'
            WHEN regexp_matches({{ean_product_name}}, 'i9', 'i')
                    AND NOT regexp_matches({{ean_product_name}}, 'slime|brinquedo', 'i') THEN 'i9'
            WHEN regexp_matches({{ean_product_name}}, 'yas', 'i') THEN 'Yas'
            WHEN regexp_matches({{ean_product_name}}, 'jack *[e&] *coke|coke|jack|marca coca[ -]*cola', 'i') THEN 'Coca-Cola'
            WHEN regexp_matches({{ean_product_name}}, 'topo[ -]*chico', 'i') THEN 'Topo-Chico'
            WHEN regexp_matches({{ean_product_name}}, 'jesus', 'i') 
                    AND NOT regexp_matches({{ean_product_name}}, '[aá]gua sanit[aá]ria', 'i') THEN 'Jesus'
            WHEN regexp_matches({{ean_product_name}}, 'taí|tai ', 'i') 
                    AND NOT regexp_matches({{ean_product_name}}, 'a[cç][uú]car|cristal', 'i') THEN 'Taí'
            WHEN regexp_matches({{ean_product_name}}, 'reign', 'i') THEN 'Reign'
            WHEN regexp_matches({{ean_product_name}}, 'charr*ua', 'i') THEN 'Charrua'
            WHEN regexp_matches({{ean_product_name}}, 'tuchaua', 'i') THEN 'Tuchaua'
            ELSE 'Non identified'
        END
        

    ELSE NULL
END

{% endmacro %}