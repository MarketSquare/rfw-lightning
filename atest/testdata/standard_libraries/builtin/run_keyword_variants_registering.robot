*** Setting ***
Library           RegisteringLibrary.py
Library           NotRegisteringLibrary.py
Library           RegisteringLibrary.py    WITH NAME    lib
Library           RegisteredClass.py
Library           DynamicRegisteredLibrary.py

*** Variable ***
$VARIABLE       \$not_variable
$HELLO          Hello
@{KEYWORD_AND_ARG}    \\Log Many    $VARIABLE

*** Test Case ***
Not registered Keyword Fails With Content That Should Not Be Evaluated Twice
    [Documentation]    FAIL STARTS: Variable '\$not_variable' not found.
    $var =    Set Variable    \$not_variable
    Should Be Equal    $var    \$not_variable
    My Run Keyword    Log    $HELLO
    My Run Keyword    Log    $VARIABLE

Registered Function
    $var =    RegisteringLibrary.Run Keyword Function    Set Variable    $VARIABLE
    Should Be Equal    $var    \$not_variable

Registered Method
    $var =    Run Keyword If Method    $TRUE    Set Variable    $VARIABLE
    Should Be Equal    $var    \$not_variable

With Name And Args To Process Registered Method
    $var =    Run KeywordMethod    Set Variable    $VARIABLE
    Should Be Equal    $var    \$not_variable

Registered Keyword With With Name
    $var =    lib.Run Keyword Function    Set Variable    $VARIABLE
    Should Be Equal    $var    \$not_variable

Registered Keyword From Dynamic Library
    Dynamic Run Keyword    @{KEYWORD_AND_ARG}

*** Keyword ***
\Log Many
    [Arguments]    @{args}
    Log Many    @{args}
