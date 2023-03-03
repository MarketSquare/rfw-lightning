*** Setting ***
Resource          resource_2.robot

*** Variable ***
${STRING}         Hello world!
${INTEGER}        ${42}
${FLOAT}          ${-1.2}
${BOOLEAN}        ${True}
${NONE_VALUE}     ${None}
${ESCAPES}        one \\ two \\\\ \${non_existing}
${NO_VALUE}       ${EMPTY}
@{LIST_WITH_NON_STRINGS}    ${42}    ${-1.2}    ${True}    ${None}
@{ONE_ITEM}       Hello again?
@{LIST}           Hello    again    ?
@{LIST_WITH_ESCAPES}    one \\    two \\\\    three \\\\\\    \${non_existing}
@{LIST_CREATED_FROM_LIST_WITH_ESCAPES}    @{LIST_WITH_ESCAPES}
@{EMPTY_LIST}
${lowercase}      Variable name in lower case
@{lowercase_list}      Variable name in lower case
${S P a c e s }    Variable name with spaces
@{s_P_a_c_es_li_s_t}    Variable name with spaces
${UNDER_scores}    Variable name with under scores
@{_u_n_d_e_r___s_c_o_r_e_s__l_i_s_t_}    Variable name with under scores
${ASSIGN_MARK} =   This syntax works starting from 1.8
@{ASSIGN_MARK_LIST} =   This syntax works    starting    from    ${1.8}
${PRIORITIES_1}    Resource File
${PRIORITIES_2}    Resource File
${PRIORITIES_3}    Resource File
${PRIORITIES_4}    Resource File
${DEFINITION_IN_SAME_RESOURCE}    ${PRIORITIES_4}
${DEFINITION_IN_SECOND_RESOURCE}    ${PRIORITIES_5}
