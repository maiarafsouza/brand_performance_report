{% macro subcat_id(category_1_1, cat_group_1_2, bev_cat_1_3, bev_sub_cat_1_4)%}
CONCAT(
            {{category_1_1}},
            ' | ',
            {{cat_group_1_2}},
            ' | ',
            {{bev_cat_1_3}},
            ' | ',
            {{bev_sub_cat_1_4}}
            )
{% endmacro %}