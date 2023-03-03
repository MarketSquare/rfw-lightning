*** Settings ***
Suite Setup      Run Tests    ${EMPTY}    variables/recursive_definition.robot
Resource         atest_resource.robot

*** Test Cases ***
Direct recursion
    Check Test Case    ${TESTNAME}
    Recursion error    \${DIRECT}    4    7

Indirect recursion
    Check Test Case    ${TESTNAME}
    Recursion error    \${VAR_1}    8    8
    Non-existing error    \${VAR_3}    \${VAR_1}    9     10    \${VAR_3}    \${VAR_2}
    Non-existing error    \${VAR_2}    \${VAR_3}    10    9     \${VAR_2}

Case-insensitive recursion
    Check Test Case    ${TESTNAME}
    Recursion error    \${xxx}    11    11

Recursive list variable
    Check Test Case    ${TESTNAME}
    Recursion error    \@{LIST}      5    12
    Recursion error    \@{LIST_1}    6    13
    Non-existing error    \@{LIST_2}    \@{LIST_1}    7    14

Recursion with variables used in imports
    Check Test Case    ${TESTNAME}
    Recursion error    \${IMPORT_1}    0    15
    Non-existing error    \${IMPORT_2}    \${IMPORT_1}    1    16    \${IMPORT_2}
    Import error    Resource    \${IMPORT_1}    2    3
    Import error    Library     \${IMPORT_2}    3    4

*** Keywords ***
Recursion error
    [Arguments]    ${variable}    ${index}    ${lineno}
    Error In File    ${index}     variables/recursive_definition.robot    ${lineno}
    ...    Setting variable '${variable}' failed:
    ...    Recursive variable definition.

Non-existing error
    [Arguments]    ${variable1}    ${variable2}    ${index}    ${lineno}    @{recommendations}
    IF    ${recommendations}
        ${recommendations} =    Get recommendations    @{recommendations}
    ELSE
        ${recommendations} =    Set variable    ${EMPTY}
    END
    Error In File    ${index}    variables/recursive_definition.robot    ${lineno}
    ...    Setting variable '${variable1}' failed:
    ...    Variable '${variable2}' not found.
    ...    ${recommendations}

Import error
    [Arguments]    ${setting}    ${variable}    ${index}    ${lineno}
    Error In File    ${index}    variables/recursive_definition.robot    ${lineno}
    ...    Replacing variables from setting '${setting}' failed:
    ...    Variable '${variable}' not found.

Get recommendations
    [Arguments]    @{recommendations}
    ${recommendations} =    Catenate    SEPARATOR=\n${SPACE*4}
    ...    Did you mean:    @{recommendations}
    [Return]    ${recommendations}
