*** Settings ***
Suite Setup       Run Keywords
...               Remove Environment Variable    PYTHONCASEOK    AND
...               Run Tests    ${EMPTY}    variables/python_evaluation.robot
Suite Teardown    Set Environment Variable    PYTHONCASEOK    True
Resource          atest_resource.robot

*** Test Cases ***
Python only
    Check Test Case    ${TESTNAME}

Variable replacement
    Check Test Case    ${TESTNAME}

Inline variables
    Check Test Case    ${TESTNAME}

Automatic module import
    Check Test Case    ${TESTNAME}

Module imports are case-sensitive
    Check Test Case    ${TESTNAME}

Variable section
    Check Test Case    ${TESTNAME}

Escape characters and curly braces
    Check Test Case    ${TESTNAME}

Invalid
    Check Test Case    ${TESTNAME}

*** Keywords ***
Validate invalid variable error
    [Arguments]    ${index}    ${lineno}    ${name}    @{error}    ${pattern}=False
    Error In File    ${index}    variables/python_evaluation.robot    ${lineno}
    ...    Setting variable '${name}' failed:
    ...    @{error}
    ...    pattern=${pattern}
