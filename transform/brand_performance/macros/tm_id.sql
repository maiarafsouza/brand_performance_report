{% macro tm_id(TM, category_1_1, cat_group_1_2, bev_cat_1_3, bev_sub_cat_1_4)%}
CONCAT(
            'TM: ',
            {{TM}},
            ' | ',
            {{category_1_1}},
            {{cat_group_1_2}},
            {{bev_cat_1_3}},
            {{bev_sub_cat_1_4}}
            )
{% endmacro %}