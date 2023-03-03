*** Settings ***
Library    String
Library    Collections

*** Variables ***
${TEXT_IN_COLUMNS}    abcdefg123\tabcdefg123\nabcdefg123\tabcdefg123
${TEXT_IN_LINES}      ab\ncd\ef\n
${TEXT_REPEAT_COUNT}    4
${REGULAR_EXPRESSION}    abcdefg
${REGULAR_EXPRESSION_WITH_GROUP}    ab(?P<group_name>cd)e(?P<group_name2>fg)
${REGULAR_EXPRESSION_CASEIGNORE}    ABCdefg
${REGULAR_EXPRESSION_WITH_GROUP_CASEIGNORE}    AB(?P<group_name>cd)e(?P<group_name2>fg)
${REGULAR_EXPRESSION_DOTALL}        AB.*ef
${UNMATCH_REGULAR_EXPRESSION}    hijk
${MATCH}    abcdefg
${GROUP_MATCH}    cd
${SECOND_GROUP_MATCH}    fg
${MATCH_DOTALL}    ab\ncd\ef

*** Test Cases ***
Get Regexp Matches With No Match
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${UNMATCH_REGULAR_EXPRESSION}
    ${expect_result}=    Create List
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Without Group
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION}
    ${expect_result}=    Create List    ${MATCH}    ${MATCH}    ${MATCH}    ${MATCH}
    Should be Equal    ${result}    ${expect_result}
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_CASEIGNORE}   flags=I
    ${expect_result}=    Create List    ${MATCH}    ${MATCH}    ${MATCH}    ${MATCH}
    Should be Equal    ${result}    ${expect_result}
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_CASEIGNORE}   flags=IGNORECASE
    ${expect_result}=    Create List    ${MATCH}    ${MATCH}    ${MATCH}    ${MATCH}
    Should be Equal    ${result}    ${expect_result}
    ${result}=    Get Regexp Matches    ${TEXT_IN_LINES}    ${REGULAR_EXPRESSION_DOTALL}   flags=I|dotALL
    ${expect_result}=    Create List    ${MATCH_DOTALL}
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Insert Group Regex Without Groups
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP}
    ${expect_result}=    Create List    ${MATCH}    ${MATCH}    ${MATCH}    ${MATCH}
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Insert Group Regex With Group Name
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP}    group_name
    ${expect_result}=    Create List    ${GROUP_MATCH}    ${GROUP_MATCH}    ${GROUP_MATCH}    ${GROUP_MATCH}
    Should be Equal    ${result}    ${expect_result}
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP_CASEIGNORE}    group_name    flags=I
    ${expect_result}=    Create List    ${GROUP_MATCH}    ${GROUP_MATCH}    ${GROUP_MATCH}    ${GROUP_MATCH}
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Insert Group Regex With Group Names
    @{result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP}    group_name    group_name2
    ${expect_result}=    Evaluate    [('${GROUP_MATCH}', '${SECOND_GROUP_MATCH}') for i in range(${TEXT_REPEAT_COUNT})]
    Should be Equal    ${result}    ${expect_result}
    @{result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP_CASEIGNORE}    group_name    group_name2   flags=IGNORECASE|S
    ${expect_result}=    Evaluate    [('${GROUP_MATCH}', '${SECOND_GROUP_MATCH}') for i in range(${TEXT_REPEAT_COUNT})]
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Insert Group Regex With Group Index
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP}    2
    ${expect_result}=    Create List    ${SECOND_GROUP_MATCH}    ${SECOND_GROUP_MATCH}    ${SECOND_GROUP_MATCH}    ${SECOND_GROUP_MATCH}
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Insert Group Regex With Group Indexes
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP}    ${2}    ${1.0}
    ${expect_result}=    Evaluate    [('${SECOND_GROUP_MATCH}', '${GROUP_MATCH}') for i in range(${TEXT_REPEAT_COUNT})]
    Should be Equal    ${result}    ${expect_result}

Get Regexp Matches Insert Group Regex With Group Name And Index
    ${result}=    Get Regexp Matches    ${TEXT_IN_COLUMNS}    ${REGULAR_EXPRESSION_WITH_GROUP}    2    group_name
    ${expect_result}=    Evaluate    [('${SECOND_GROUP_MATCH}', '${GROUP_MATCH}') for i in range(${TEXT_REPEAT_COUNT})]
    Should be Equal    ${result}    ${expect_result}
