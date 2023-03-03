*** Settings ***
Resource          resource_for_variable_table_in_resource_file.robot

*** Test Case ***
Scalar String
    Should Be Equal    ${STRING}    Hello world!
    Should Be Equal    I said: "${STRING}"    I said: "Hello world!"

Scalar Non-Strings
    Should Be True    ${INTEGER} == 42
    Should Be True    ${FLOAT} == -1.2
    Should Be True    ${BOOLEAN} == True
    Should Be True    ${NONE_VALUE} == None

Scalar String With Escapes
    Should Be Equal    ${ESCAPES}    one \\ two \\\\ \${non_existing}

Empty Scalar String
    Should Be Equal    ${NO_VALUE}    ${EMPTY}
    Should Be Equal    "${NO_VALUE}${NO_VALUE}"    ""

List with One Item
    Should Be True    ${ONE_ITEM} == ['Hello again?']
    Should Be Equal    ${ONE_ITEM}[0]    Hello again?

List With Multiple Items
    Should Be Equal    ${LIST}[0]    Hello
    Should Be Equal    ${LIST}[1]    again
    Should Be Equal    ${LIST}[2]    ?
    Should Be True    ${LIST} == ['Hello', 'again', '?']

List With Escapes
    Should Be Equal    ${LIST_WITH_ESCAPES}[0]    one \\
    Should Be Equal    ${LIST_WITH_ESCAPES}[1]    two \\\\
    Should Be Equal    ${LIST_WITH_ESCAPES}[2]    three \\\\\\
    Should Be Equal    ${LIST_WITH_ESCAPES}[3]    \${non_existing}

List Created From List With Escapes
    Should Be Equal    ${LIST_CREATED_FROM_LIST_WITH_ESCAPES}[0]    one \\
    Should Be Equal    ${LIST_CREATED_FROM_LIST_WITH_ESCAPES}[1]    two \\\\
    Should Be Equal    ${LIST_CREATED_FROM_LIST_WITH_ESCAPES}[2]    three \\\\\\
    Should Be Equal    ${LIST_CREATED_FROM_LIST_WITH_ESCAPES}[3]    \${non_existing}
    Should Be True    ${LIST_WITH_ESCAPES} == ${LIST_CREATED_FROM_LIST_WITH_ESCAPES}
    Should Be Equal    ${LIST_WITH_ESCAPES}    ${LIST_CREATED_FROM_LIST_WITH_ESCAPES}

List With No Items
    Should Be True    ${EMPTY_LIST} == []
    ${ret} =    Catenate    @{EMPTY_LIST}    @{EMPTY_LIST}    only value    @{EMPTY_LIST}
    Should Be Equal    ${ret}    only value

Variable Names Are Case Insensitive
    Should Be Equal    ${lowercase}    Variable name in lower case
    Should Be Equal    ${LOWERCASE}    Variable name in lower case
    Should Be Equal    ${LoWerCAse}    Variable name in lower case
    Should Be Equal    ${lowercaselist}[0]    Variable name in lower case
    Should Be Equal    ${LOWERCASE_LIST}[0]    Variable name in lower case
    Should Be Equal    ${lOWErcasE_List}[0]    Variable name in lower case

Variable Names Are Underscore Insensitive
    Should Be Equal    ${underscores}    Variable name with under scores
    Should Be Equal    ${_U_N_D_er_Scores__}    Variable name with under scores
    Should Be Equal    ${underscoreslist}[0]    Variable name with under scores
    Should Be Equal    ${_u_N_de__r_SCores_____L_I_S_T__}[0]    Variable name with under scores

Assign Mark With Scalar variable
    Should Be Equal    ${ASSING_MARK}    This syntax works starting from 1.8

Assign Mark With List variable
    Should Be Equal    ${ASSIGN_MARK_LIST}[0]    This syntax works
    Should Be Equal    ${ASSIGN_MARK_LIST}[1]    starting
    Should Be Equal    ${ASSIGN_MARK_LIST}[2]    from
    Should Be Equal    ${ASSIGN_MARK_LIST}[3]    ${1.8}

Three dots on the same line should be interpreted as string
    Should Be Equal    ${THREE_DOTS}    ...
    ${sos} =    Catenate    SEPARATOR=---    @{3DOTS_LIST}
    Should Be Equal    ${sos}    ...---...

Scalar catenated from multile values
    Should Be Equal    ${CATENATED}      I am a scalar catenated from many items
    Should Be Equal    ${CATENATED_WITH_SEP}    I-can-haz-custom-separator

Creating variable using non-existing variable fails
    Variable Should Not Exist    ${NONEX_1}
    Variable Should Not Exist    ${NONEX_2A}
    Variable Should Not Exist    ${NONEX_2B}
    Variable Should Not Exist    ${NONEX_3}
