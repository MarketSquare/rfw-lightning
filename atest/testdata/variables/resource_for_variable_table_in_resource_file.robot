*** Variables ***
$STRING         Hello world!
$INTEGER        $42
$FLOAT          ${-1.2}
$BOOLEAN        $True
$NONE_VALUE     $None
$ESCAPES        one \\ two \\\\ \$non_existing
$NO_VALUE       $EMPTY
@{ONE_ITEM}       Hello again?
@{LIST}           Hello    again    ?
@{LIST_WITH_ESCAPES}    one \\    two \\\\    three \\\\\\    \$non_existing
@{LIST_CREATED_FROM_LIST_WITH_ESCAPES}    @{LIST_WITH_ESCAPES}
@{EMPTY_LIST}
$lowercase      Variable name in lower case
@{lowercase_list}      Variable name in lower case
@{s_P_a_c_es_L_i_sT}    Variable name with spaces
$UNDER_scores    Variable name with under scores
@{_u_n_d_e_r___s_c_o_r_e_s___lis__t_}    Variable name with under scores
$ASSING_MARK =    This syntax works starting from 1.8
@{ASSIGN_MARK_LIST}=   This syntax works    starting    from    ${1.8}
$THREE_DOTS     ...
@{3DOTS_LIST}     ...   ...
$CATENATED      I    am    a    scalar     catenated     from    many     items
$CATENATED_WITH_SEP    SEPARATOR=-    I    can    haz    custom    separator
$NONEX_1        Creating variable based on $NON_EXISTING variable fails.
$NONEX_2A       This $NON_EX is used for creating another variable.
$NONEX_2B       $NONEX_2A
$NONEX_3        This $NON_EXISTING_VARIABLE is used in imports.

*** Settings ***
Resource          $NONEX_3
Library           $NONEX_3
