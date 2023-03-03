*** Settings ***
Documentation     Normal test cases
Suite Setup       Log    ${SETUP_MSG}
Suite Teardown    Log    ${TEARDOWN_MSG}
Test Tags         f1
Metadata          Something    My Value

*** Variables ***
${SETUP_MSG}     Suite Setup of Fourth
${TEARDOWN_MSG}  Suite Teardown of Fourth

*** Test Cases ***
Suite4 First
    [Documentation]    FAIL Expected
    [Tags]    t1
    Log    Suite4_First
    Sleep    0.01    Make sure elapsed time > 0
    Fail    Expected
    [Teardown]    Log    Huhuu
