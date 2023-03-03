*** Settings ***
Suite Setup     Run tests    ${EMPTY}    variables/variable_table_in_resource_file.robot
Resource        atest_resource.robot

*** Variables ***
${PATH}         variables/resource_for_variable_table_in_resource_file.robot

*** Test Cases ***
Scalar String
    Check Test Case    ${TEST_NAME}

Scalar Non-Strings
    Check Test Case    ${TEST_NAME}

Scalar String With Escapes
    Check Test Case    ${TEST_NAME}

Empty Scalar String
    Check Test Case    ${TEST_NAME}

List With One Item
    Check Test Case    ${TEST_NAME}

List With Multiple Items
    Check Test Case    ${TEST_NAME}

List With Escapes
    Check Test Case    ${TEST_NAME}

List Created From List With Escapes
    Check Test Case    ${TEST_NAME}

List With No Items
    Check Test Case    ${TEST_NAME}

Variable Names Are Case Insensitive
    Check Test Case    ${TEST_NAME}

Variable Names Are Underscore Insensitive
    Check Test Case    ${TEST_NAME}

Assign Mark With Scalar Variable
    Check Test Case    ${TEST_NAME}

Assign Mark With List Variable
    Check Test Case    ${TEST_NAME}

Three dots on the same line should be interpreted as string
    Check Test Case     ${TEST_NAME}

Scalar catenated from multile values
    Check Test Case     ${TEST_NAME}

Creating variable using non-existing variable fails
    Check Test Case    ${TEST_NAME}
    Creating Variable Should Have Failed    3    \${NONEX_1}     25
    ...    Variable '\${NON_EXISTING}' not found.
    Creating Variable Should Have Failed    4    \${NONEX_2A}    26
    ...    Variable '\${NON_EX}' not found.
    ...    Did you mean:*
    Creating Variable Should Have Failed    5    \${NONEX_2B}    27
    ...    Variable '\${NONEX_2A}' not found.
    ...    Did you mean:*

Using variable created from non-existing variable in imports fails
    Creating Variable Should Have Failed    0    \${NONEX_3}     28
    ...    Variable '\${NON_EXISTING_VARIABLE}' not found.
    Import Should Have Failed               1    Resource        31
    ...    Variable '\${NONEX_3}' not found.
    ...    Did you mean:*
    Import Should Have Failed               2    Library         32
    ...    Variable '\${NONEX_3}' not found.
    ...    Did you mean:*

*** Keywords ***
Creating Variable Should Have Failed
    [Arguments]    ${index}    ${name}    ${lineno}    @{message}
    Error In File    ${index}    ${PATH}    ${lineno}
    ...    Setting variable '${name}' failed:
    ...    @{message}

Import Should Have Failed
    [Arguments]    ${index}    ${name}    ${lineno}    @{message}
    Error In File    ${index}    ${PATH}    ${lineno}
    ...    Replacing variables from setting '${name}' failed:
    ...    @{message}
