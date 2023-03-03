*** Setting ***
Documentation     Passing suite setup and teardon using user keywords.
Suite Setup       My Setup
Suite Teardown    My Teardown
Library           OperatingSystem

*** Variables ***
${TEARDOWN_FILE}    %{TEMPDIR}/robot-suite-teardown-executed.txt

*** Test Case ***
Verify Suite Setup
    [Documentation]    PASS
    Should Be Equal    ${SUITE_SETUP}    Suite Setup Executed

*** Keyword ***
My Setup
    Comment    Testing that suite setup can be also a user keyword
    My Keyword

My Teardown
    Comment    Testing that suite teardown can be also a user keyword
    No Operation
    Create File    ${TEARDOWN_FILE}

My keyword
    Set Suite Variable    $SUITE_SETUP    Suite Setup Executed
