*** Variables ***
@{RUN_KWS_ARGS}      Logging keyword    AND    Non-existing and not used keyword
@{RUN_KWS}           Run Keywords    @{RUN_KWS_ARGS}
@{RUN_KW_IF_ARGS}    ${FALSE}    Fail    Not executed
...                  ELSE IF    ${FALSE}    Fail    Not executed
...                  ELSE    Fail    Not executed
@{RUN_KW_IF}         Run Keyword If    @{RUN_KW_IF_ARGS}
@{RUN_KW_IF_FAIL_ARGS}    ${TRUE}    Fail    Expected failure
@{RUN_KW_IF_FAIL}    Run Keyword If    @{RUN_KW_IF_FAIL_ARGS}

*** Test Cases ***
Run Keyword with Run Keywords With Arguments Inside List variable should escape AND
    [Documentation]    FAIL No keyword with name 'AND' found.
    Run Keyword    Run Keywords    @{RUN_KWS_ARGS}

Run Keyword with Run Keywords And Arguments Inside List variable should escape AND
    [Documentation]    FAIL No keyword with name 'AND' found.
    Run Keyword    @{RUN_KWS}

Run Keyword If with Run Keywords With Arguments Inside List variable should escape AND
    [Documentation]    FAIL No keyword with name 'AND' found.
    Run Keyword If    ${TRUE}    Run Keywords    @{RUN_KWS_ARGS}

Run Keyword If with Run Keywords And Arguments Inside List variable should escape AND
    [Documentation]    FAIL No keyword with name 'AND' found.
    Run Keyword If    ${TRUE}    Run Keyword    @{RUN_KWS}

Run Keywords With Run Keyword If should not escape ELSE and ELSE IF
    [Documentation]    FAIL Expected failure
    Run Keywords
    ...    Run Keyword If    ${FALSE}    Fail    Not executed
    ...    ELSE IF    ${FALSE}    Fail    Not executed
    ...    ELSE    Log    log message
    ...    AND    Log    that
    ...    AND    Run Keyword If    ${TRUE}    Fail    Expected failure
    ...    ELSE IF    ${TRUE}    Fail    Not executed
    ...    ELSE    Fail    Not executed

Run Keywords With Run Keyword If In List Variable Should Escape ELSE and ELSE IF From List Variable
    [Documentation]    FAIL Expected failure
    Run Keywords
    ...    @{RUN_KW_IF}
    ...    AND    Log    that
    ...    AND    @{RUN_KW_IF_FAIL}

Run Keywords With Run Keyword If With Arguments From List Variable should escape ELSE and ELSE IF From List Variable
    [Documentation]    FAIL Expected failure
    Run Keywords
    ...    Run Keyword If    @{RUN_KW_IF_ARGS}
    ...    AND    Log    that
    ...    AND    Run Keyword If    @{RUN_KW_IF_FAIL_ARGS}

*** Keywords ***
Logging keyword
    Log    log message
