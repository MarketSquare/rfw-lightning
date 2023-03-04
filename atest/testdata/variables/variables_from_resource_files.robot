*** Setting ***
Resource          resvarfiles/resource.robot

*** Variable ***
${DEFINITION_IN_RESOURCE(1)}    $STRING
${DEFINITION_IN_RESOURCE(2)}    ${LIST[0]}! ${ONE_ITEM[0]}
${DEFINITION_IN_RESOURCE(3)}    $LIST_WITH_ESCAPES
@{DEFINITION_IN_RESOURCE(4)}    @{LIST_WITH_ESCAPES}
$ORIGINAL_DEFINITION_IN_SECOND_RESOURCE    $DEFINITION_IN_SECOND_RESOURCE
${DEFINITION_IN_SECOND_RESOURCE(local)}    $PRIORITIES_5

*** Test Case ***
Scalar String
    Should Be Equal    $STRING    Hello world!
    Should Be Equal    I said: "$STRING"    I said: "Hello world!"

Scalar Non-Strings
    Should Be True    $INTEGER == 42
    Should Be True    $FLOAT == -1.2
    Should Be True    $BOOLEAN == True
    Should Be True    $NONE_VALUE == None

Scalar String With Escapes
    Should Be Equal    $ESCAPES    one \\ two \\\\ \$non_existing

Empty Scalar String
    Should Be Equal    $NO_VALUE    $EMPTY
    Should Be Equal    "$NO_VALUE$NO_VALUE"    ""

Scalar List
    Should Not Be Equal    $LIST    Hello world !
    Should Be True    $LIST == ['Hello','again', '?']
    Should Be Equal    ${LIST[0]}    Hello
    Should Be Equal    ${LIST[1]}    again
    Should Be Equal    ${LIST[2]}    ?

Scalar List With Non-Strings
    Should Be True    $LIST_WITH_NON_STRINGS == [42, -1.2, True, None]

Scalar List With Escapes
    Test List With Escapes
    ...    ${LIST_WITH_ESCAPES[0]}    ${LIST_WITH_ESCAPES[1]}
    ...    ${LIST_WITH_ESCAPES[2]}    ${LIST_WITH_ESCAPES[3]}
    $exp =    Create List    one \\    two \\\\    three \\\\\\    \$non_existing
    Should Be Equal    $LIST_WITH_ESCAPES    $exp
    Should Be True    $LIST_WITH_ESCAPES == ['one \\\\', 'two \\\\\\\\', 'three \\\\\\\\\\\\', '\$non_existing']    Backslashes are doubled here because 'Should Be True' uses 'eval' internally

List with One Item
    Should Be True    $ONE_ITEM == ['Hello again?']
    Should Be Equal    $ONE_ITEM[0]    Hello again?

List With Multiple Items
    Should Be Equal    $LIST[0]    Hello
    Should Be Equal    $LIST[1]    again
    Should Be Equal    $LIST[2]    ?
    Should Be True    $LIST == ['Hello', 'again', '?']

List With Escapes
    Test List With Escapes    @{LIST_WITH_ESCAPES}

List Created From List With Escapes
    Should Be Equal    $LIST_CREATED_FROM_LIST_WITH_ESCAPES[0]    one \\
    Should Be Equal    $LIST_CREATED_FROM_LIST_WITH_ESCAPES[1]    two \\\\
    Should Be Equal    $LIST_CREATED_FROM_LIST_WITH_ESCAPES[2]    three \\\\\\
    Should Be Equal    $LIST_CREATED_FROM_LIST_WITH_ESCAPES[3]    \$non_existing
    Should Be True    $LIST_WITH_ESCAPES == $LIST_CREATED_FROM_LIST_WITH_ESCAPES
    Should Be Equal    $LIST_WITH_ESCAPES    $LIST_CREATED_FROM_LIST_WITH_ESCAPES

List With No Items
    Should Be True    $EMPTY_LIST == []
    $ret =    Catenate    @{EMPTY_LIST}    @{EMPTY_LIST}    only value    @{EMPTY_LIST}
    Should Be Equal    $ret    only value

Variable Names Are Case Insensitive
    Should Be Equal    $lowercase    Variable name in lower case
    Should Be Equal    $LOWERCASE    Variable name in lower case
    Should Be Equal    $LoWerCAse    Variable name in lower case
    Should Be Equal    $lowercase_list[0]    Variable name in lower case
    Should Be Equal    $LOWERCASE_LIST[0]    Variable name in lower case
    Should Be Equal    $lOWErcasE_List[0]    Variable name in lower case

Variable Names Are Underscore Insensitive
    Should Be Equal    $underscores    Variable name with under scores
    Should Be Equal    $_U_N_D_er_Scores__    Variable name with under scores
    Should Be Equal    $underscores_list[0]    Variable name with under scores
    Should Be Equal    $_u_N_de__r_SCores__LI__st[0]    Variable name with under scores

Assign Mark With Scalar variable
    Should Be Equal    $ASSIGN_MARK    This syntax works starting from 1.8

Assign Mark With List variable
    Should Be Equal    $ASSIGN_MARK_LIST[0]    This syntax works
    Should Be Equal    $ASSIGN_MARK_LIST[1]    starting
    Should Be Equal    $ASSIGN_MARK_LIST[2]    from
    Should Be Equal    $ASSIGN_MARK_LIST[3]    ${1.8}

Variables From Resource Files Can Be Used In Local Variable Table
    Should Be Equal    ${DEFINITION_IN_RESOURCE(1)}    Hello world!
    Should Be Equal    ${DEFINITION_IN_RESOURCE(2)}    Hello! Hello again?
    Test List With Escapes    @{DEFINITION_IN_RESOURCE(3)}
    Test List With Escapes    @{DEFINITION_IN_RESOURCE(4)}

Imported Resource Can Use Variables From Resources It Imports In Its Variable Table
    Should Be Equal    $DEFINITION_IN_SECOND_RESOURCE    Second Resource File
    Should Be Equal    $ORIGINAL_DEFINITION_IN_SECOND_RESOURCE    Second Resource File
    Should Be Equal    ${DEFINITION_IN_SECOND_RESOURCE(local)}    Second Resource File

*** Keywords ***
Test List With Escapes
    [Arguments]    $item1    $item2    $item3    $item4
    Should Be Equal    $item1    one \\
    Should Be Equal    $item2    two \\\\
    Should Be Equal    $item3    three \\\\\\
    Should Be Equal    $item4    \$non_existing
