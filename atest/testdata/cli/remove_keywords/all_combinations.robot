*** Variables ***
${COUNTER}         ${0}
${PASS_MESSAGE}    -PASSED -ALL
${FAIL_MESSAGE}    -ALL +PASSED
${REMOVED_FOR_MESSAGE}     -FOR -ALL
${KEPT_FOR_MESSAGE}        +FOR -ALL
${REMOVED_WHILE_MESSAGE}     -WHILE -ALL
${KEPT_WHILE_MESSAGE}        +WHILE -ALL
${REMOVED_WUKS_MESSAGE}    -WUKS -ALL
${KEPT_WUKS_MESSAGE}       +WUKS -ALL
${REMOVED_BY_NAME_MESSAGE}    -BYNAME -ALL
${KEPT_BY_NAME_MESSAGE}    +BYNAME -ALL
${REMOVED_BY_PATTERN_MESSAGE}    -BYPATTERN -ALL
${KEPT_BY_PATTERN_MESSAGE}    +BYPATTERN -ALL

*** Test Case ***
Passing
    Log    ${PASS_MESSAGE}

Failing
    [Documentation]    FAIL Message
    Log     ${FAIL_MESSAGE}
    Fail    Message

FOR when test fails
    [Documentation]    FAIL Cannot pass
    My FOR
    Fail    Cannot pass

FOR when test passes
    My FOR

WHILE when test fails
    [Documentation]    FAIL Cannot pass
    My WHILE
    Fail    Cannot pass

WHILE when test passes
    My WHILE

WUKS when test fails
    [Documentation]    FAIL Cannot pass
    Wait Until Keyword Succeeds    2s    0.01s    My WUKS
    Fail    Cannot pass

WUKS when test passes
     Wait Until Keyword Succeeds    2s    0.01s    My WUKS

NAME when test passes
    Remove By Name
    ${var} =    Remove By Name    with assignment
    Do not remove by name

NAME when test fails
    [Documentation]    FAIL this fails
    Remove By Name
    ${var} =    Remove By Name    with assignment
    Do not remove by name
    Fail    this fails

NAME with * pattern when test passes
    This should be removed
    ${var} =    This should be removed    also with assignment
    This should be removed also
    This should not be removed

NAME with * pattern when test fails
    [Documentation]    FAIL this fails
    This should be removed
    ${var} =    This should be removed    also with assignment
    This should be removed also
    This should not be removed
    Fail    this fails

NAME with ? pattern when test passes
    RemoveYES
    RemoveNO

NAME with ? pattern when test fails
    [Documentation]    FAIL this fails
    [Tags]   these should not effect kw matching:   hello    kitty     remove
    RemoveYES
    RemoveNO
    Fail    this fails

TAGged keywords
    [Documentation]    FAIL this fails
    [Tags]   these should not effect kw matching:   hello    kitty     remove
    Tag but no remove
    Tag and remove
    Fail    this fails

Warnings and errors are preserved
    This should be removed but contains warnings
    This should be removed but contains error

*** Keywords ***
My FOR
    FOR    ${item}    IN    one    two    three    LAST
        IF    "${item}" == "LAST"
            Log    ${KEPT_FOR_MESSAGE} ${item}
        ELSE
            Log    ${REMOVED_FOR_MESSAGE} ${item}
        END
    END

My WHILE
    ${i}=    Set variable     ${1}
    WHILE    $i < 5
        IF    $i == 4
            Log    ${KEPT_WHILE_MESSAGE} ${i}
        ELSE
            Log    ${REMOVED_WHILE_MESSAGE} ${i}
        END
        ${i}=    Evaluate    $i + 1
    END

My WUKS
    Set Test Variable    $COUNTER    ${COUNTER+1}
    Run Keyword If    ${COUNTER} < 10    Fail    ${REMOVED_WUKS_MESSAGE}
    Run Keyword If    ${COUNTER} == 10    Fail    ${KEPT_WUKS_MESSAGE}

Remove By Name
    [Arguments]    ${whatever}=default
    Log    ${REMOVED_BY_NAME_MESSAGE}
    [Return]    ${whatever}

Do not remove by name
    Remove By Name
    Log    ${KEPT_BY_NAME_MESSAGE}

This should be removed
    [Arguments]    ${whatever}=default
    Log    ${REMOVED_BY_PATTERN_MESSAGE}
    [Return]    ${whatever}

This should be removed also
    Log    ${REMOVED_BY_PATTERN_MESSAGE}

This should not be removed
    This should be removed
    Log    ${KEPT_BY_PATTERN_MESSAGE}

RemoveYES
    Log    ${REMOVED_BY_PATTERN_MESSAGE}

RemoveNO
    RemoveYES
    Log    ${KEPT_BY_PATTERN_MESSAGE}

Tag but no remove
    [Tags]   hello    kitty
    Log   This is not removed by TAG

Tag and remove
    [Tags]   hello    kitty     remove
    Log   This is removed by TAG

This should be removed but contains warnings
    [Tags]   hello    kitty     remove
    This should be removed but contains warnings 2

This should be removed but contains warnings 2
    [Tags]   hello    kitty     remove
    Log    Keywords with warnings are not removed    WARN

This should be removed but contains error
    [Tags]   hello    kitty     remove
    Log    Keywords with errors are not removed    ERROR
