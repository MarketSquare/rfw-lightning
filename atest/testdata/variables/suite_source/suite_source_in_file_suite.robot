*** Settings ***
Suite Setup     Check Suite Source  ${EXPECTED_SUITE_SOURCE}
Suite Teardown  Check Suite Source  ${EXPECTED_SUITE_SOURCE}
Test Setup      Check Suite Source  ${EXPECTED_SUITE_SOURCE}
Test Teardown   Check Suite Source  ${EXPECTED_SUITE_SOURCE}
Resource        resource.robot

*** Variables ***
${EXPECTED_SUITE_SOURCE}  ${CURDIR}${/}suite_source_in_file_suite.robot

*** Test Cases ***
\${SUITE_SOURCE} in file suite
    Should Be Equal  ${SUITE_SOURCE}  ${EXPECTED_SUITE_SOURCE}

\${SUITE_SOURCE} in user keyword
    Check Suite Source  ${EXPECTED_SUITE_SOURCE}

\${SUITE_SOURCE} in resource file
    Check Suite Source In Resource File  ${EXPECTED_SUITE_SOURCE}

*** Keywords ***
Check Suite Source
    [Arguments]  ${expected_suite_source}
    Should Be Equal  ${SUITE_SOURCE}  ${expected_suite_source}

