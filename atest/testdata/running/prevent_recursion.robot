*** Settings ***
Suite Teardown       Recursion With Run Keyword

*** Variables ***
${LIMIT_EXCEEDED}    Maximum limit of started keywords and control structures exceeded.
${PSTD_FAILED}       \n\nAlso parent suite teardown failed:\n${LIMIT_EXCEEDED}

*** Test Cases ***
Infinite recursion
    [Documentation]    FAIL ${LIMIT_EXCEEDED}${PSTD_FAILED}
    Recursion

Infinite cyclic recursion
    [Documentation]    FAIL ${LIMIT_EXCEEDED}${PSTD_FAILED}
    Cyclic recursion

Infinite recursion with Run Keyword
    [Documentation]    FAIL ${LIMIT_EXCEEDED}${PSTD_FAILED}
    Recursion with Run Keyword

Infinitely recursive for loop
    [Documentation]    FAIL ${LIMIT_EXCEEDED}${PSTD_FAILED}
    Infinitely recursive for loop

Recursion below the recursion limit is ok
    [Documentation]    FAIL Still below recursion limit!${PSTD_FAILED}
    Limited recursion
    Recursive for loop    10
    Failing limited recursion

*** Keywords ***
Recursion
    Recursion

Limited recursion
    [Arguments]    ${limit}=${25}
    Log    ${limit}
    IF    ${limit} > 0    Limited recursion   ${limit-1}

Failing limited recursion
    [Arguments]    ${limit}=${50}
    Log    ${limit}
    IF    ${limit} < 0    Fail    Still below recursion limit!
    Failing limited recursion     ${limit-1}

Cyclic recursion
    Cyclic recursion 2

Cyclic recursion 2
    Cyclic recursion 3

Cyclic recursion 3
    Cyclic recursion

Recursion With Run Keyword
    Run Keyword    Recursion With Run Keyword

Recursive for loop
    [Arguments]    ${rounds}
    FOR    ${i}    IN RANGE    ${rounds}
        Recursive for loop    ${i}
    END

Infinitely recursive for loop
    FOR    ${var}    IN    recursion
        Infinitely recursive for loop
    END
