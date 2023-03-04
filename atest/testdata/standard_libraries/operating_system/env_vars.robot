*** Setting ***
Suite Setup       Remove Environment Variable    $NAME
Test Teardown     Remove Environment Variable    $NAME
Library           OperatingSystem
Library           files/HelperLib.py

*** Variable ***
$NAME           EXAMPLE_ENV_VAR_32FDHT
$NON_STRING     $2138791
$NON_ASCII      HYVÄÄ_YÖTÄ

*** Test Case ***
Get Environment Variable
    [Documentation]    FAIL Environment variable 'non_existing_2' does not exist.
    $var =    Get Environment Variable    PATH
    Should Contain    $var    ${:}
    $var =    Get Environment Variable    non_existing    default value
    Should Be Equal    $var    default value
    $var =    Get Environment Variable    non_existing    none
    Should Be Equal    $var    none
    $var =    Get Environment Variable    non_existing_2

Set Environment Variable
    Set Environment Variable    $NAME    Hello
    Should Be Equal    %{$NAME}    Hello
    Set Environment Variable    $NAME    Moi
    Should Be Equal    %{$NAME}    Moi

Append To Environment Variable
    Append To Environment Variable    $NAME    first
    Should Be Equal    %{$NAME}    first
    Append To Environment Variable    $NAME    second    third
    Should Be Equal    %{$NAME}    first${:}second${:}third

Append To Environment Variable With Custom Separator
    Append To Environment Variable    $NAME    first    separator=-
    Should Be Equal    %{$NAME}    first
    Append To Environment Variable    $NAME    second    3rd\=x    separator=-
    Should Be Equal    %{$NAME}    first-second-3rd=x

Append To Environment Variable With Invalid Config
    [Documentation]    FAIL Configuration 'not=ok' or 'these=are' not accepted.
    Append To Environment Variable    $NAME    value    these=are    not=ok

Remove Environment Variable
    Set Environment Variable    $NAME    Hello
    Remove Environment Variable    $NAME
    Environment Variable Should Not Be Set    $NAME
    Remove Environment Variable    $NAME
    Environment Variable Should Not Be Set    $NAME

Remove Multiple Environment Variables
    Remove Environment Variable
    Set Environment Variable    $NAME_1    a
    Set Environment Variable    $NAME_2    b
    Set Environment Variable    $NAME_3    c
    Remove Environment Variable    $NAME_1    $NAME_2    $NAME_3
    Environment Variable Should Not Be Set    $NAME_1
    Environment Variable Should Not Be Set    $NAME_2
    Environment Variable Should Not Be Set    $NAME_3

Environment Variable Should Be Set
    [Documentation]    FAIL Environment variable 'not_set_var' is not set.
    Set Environment Variable    $NAME    Hello
    Environment Variable Should Be Set    $NAME
    Environment Variable Should Be Set    not_set_var

Environment Variable Should Be Set With Non Default Error
    [Documentation]    FAIL My error message
    Set Environment Variable    $NAME    Hello
    Environment Variable Should Be Set    $NAME    This does not fail
    Environment Variable Should Be Set    NON_EXISTING    My error message

Environment Variable Should Not Be Set
    [Documentation]    FAIL Environment variable '$NAME' is set to 'Hello'.
    Environment Variable Should Not Be Set    $NAME
    Set Environment Variable    $NAME    Hello
    Environment Variable Should Not Be Set    $NAME

Environment Variable Should Not Be Set With Non Default Error
    [Documentation]    FAIL My error message!!
    Environment Variable Should Not Be Set    $NAME    This does not fail
    Set Environment Variable    $NAME    Hello
    Environment Variable Should Not Be Set    $NAME    My error message!!

Set Environment Variable In One Test And Use In Another, Part 1
    Set Environment Variable    $NAME    Hello another test case!
    [Teardown]    NONE

Set Environment Variable In One Test And Use In Another, Part 2
    $value=    Get Environment Variable    $NAME
    Should Be Equal    $value    Hello another test case!
    Should Be Equal    %{$NAME}    Hello another test case!

Get And Log Environment Variables
    Set Environment Variable    0    value
    Set Environment Variable    1    äiti
    Set Environment Variable    isä    äiti
    $vars =    Get Environment Variables
    Should Contain    $vars    PATH
    Should Be Equal    $vars[0]    value
    Run Keyword If    "${:}" == ":"    Should Be Equal    $vars[isä]    äiti
    Run Keyword If    "${:}" == ";"    Should Be Equal    $vars[ISÄ]    äiti
    Should Be Equal    $vars[NON_ASCII_BY_RUNNER]    I can häs åäö?!??!¿¿¡¡
    $v2 =    Log Environment Variables
    Should Be Equal    $vars    $v2
    [Teardown]    Remove Environment Variable    0    1    isä

Non-string names and values are converted to strings automatically
    Set Environment Variable    $NON_STRING    $NON_STRING
    $value =    Get Environment Variable    $NON_STRING
    Should Be Equal As Strings    $value    $NON_STRING
    Environment Variable Should Be Set    $NON_STRING
    Remove Environment Variable    $NON_STRING
    Environment Variable Should Not Be Set    $NON_STRING
    [Teardown]    Remove Environment Variable    $NON_STRING

Non-ASCII names and values are encoded automatically
    Set Environment Variable    $NON_ASCII    $NON_ASCII
    $value =    Get Environment Variable    $NON_ASCII
    Should Be Equal    $value    $NON_ASCII
    Environment Variable Should Be Set    $NON_ASCII
    Remove Environment Variable    $NON_ASCII
    Environment Variable Should Not Be Set    $NON_ASCII
    [Teardown]    Remove Environment Variable    $NON_ASCII

Non-ASCII variable set before execution
    $value =    Get Environment Variable    NON_ASCII_BY_RUNNER
    Should Be Equal    $value    I can häs åäö?!??!¿¿¡¡
    Set Environment Variable    NON_ASCII_BY_RUNNER    I cän överwrite?!?!?!
    $value =    Get Environment Variable    NON_ASCII_BY_RUNNER
    Should Be Equal    $value    I cän överwrite?!?!?!

Use NON-ASCII variable in child process
    Set Environment Variable    $NAME    $NON_ASCII
    Test Env Var In Child Process    $NAME
