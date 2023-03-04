*** Settings ***
Suite Setup       Set Some Variables
Library           Collections
Resource          resource_for_get_variables.robot
Variables         vars_for_get_variables.py

*** Variables ***
${SCALAR}         dhrfad
@{LIST}           first    second
&{DICT}           a=1    b=2

*** Test Cases ***
Automatic and Command Line Variables
    Variables Should Contain    \{$/}    \${cmd_line}

Variable Table Scalar
    Variables Should Contain    \${SCALAR}

Variable Table List
    Variables Should Contain    \@{LIST}

Variable Table Dict
    Variables Should Contain    \&{DICT}

Global Variables
    Set Global In Resource
    Variables Should Contain    \${Global_from_suite_setup}    \${GLOBAL_FROM_RESOURCE}

Suite Variables
    Set Suite Variable    ${Suite_Var_From_Test}    Other value
    Variables Should Contain    \${Suite_Var_from_suite_setup}    \${Suite_Var_From_Test}

Suite Variables 2
    Variables Should Contain    \${Suite_Var_from_suite_setup}    \${Suite_Var_From_Test}

Resource File
    Variables Should Contain    \${RESOURCE_VAR}

Variable File
    Variables Should Contain    \${var_in_variable_file}

Local Variables in Test Case do not Leak
    Variables Should Not Contain    \${local}
    ${local}=    Set Variable    lolcat
    Variables Should Not Contain    \${local}

Test Case Variable
    Set Test Variable    ${tc_var}    tc
    Variables Should Contain    \${tc_var}

Variables Are Returned as NormalizedDict
    ${variables}=    Get Variables
    Should Be Equal    ${variables.__class__.__name__}    NormalizedDict
    Dictionary Should Contain Key    ${variables}    \${SCALAR}
    Dictionary Should Contain Key    ${variables}    \${__Scala___R}
    ${copy}=    Copy Dictionary    ${variables}
    Dictionary Should Contain Key    ${copy}    \${SCALAR}
    Dictionary Should Contain Key    ${copy}    \${__Scala___R}

Modifying Returned Variables Has No Effect On Real Variables
    ${variables}=    Get Variables    no_decoration=false
    Set To Dictionary    ${variables}    \${name}    value
    Variable Should Not Exist    ${name}

Getting variables without decoration
    ${variables} =    Get Variables    no_decoration=true
    Should be equal   ${variables}[SCALAR]    ${SCALAR}

Getting variables without decoration has no effect on real variables
    ${original} =    Set variable  ${SCALAR}
    ${variables} =    Get Variables    no_decoration=yes
    Should be equal   ${variables}[SCALAR]    ${SCALAR}
    Set to dictionary   ${variables}    scalar    MY_VALUE
    Should be equal   ${variables}[SCALAR]    MY_VALUE
    Should be equal   ${SCALAR}    ${original}

*** Keywords ***
Set Some Variables
    Set Suite Variable    ${Suite_Var_from_suite_setup}    Some value
    Set Global Variable    ${Global_from_Suite_setup}    Some value

Variables Should Contain
    [Arguments]    @{keys}
    ${variables}=    Get Variables
    FOR    ${key}    IN    @{keys}
        Dictionary Should Contain Key    ${variables}    ${key}
    END

Variables Should Not Contain
    [Arguments]    @{keys}
    ${variables}=    Get Variables
    FOR    ${key}    IN    @{keys}
        Dictionary Should Not Contain Key    ${variables}    ${key}
    END
