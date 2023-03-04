*** Settings ***
Suite Setup       Run Tests    $EMPTY    variables/suite_source
Resource          atest_resource.robot

*** Test Cases ***
\$SUITE_SOURCE in dir suite
    Check Test Suite    Suite Source    3 tests, 3 passed, 0 failed

\$SUITE_SOURCE in file suite
    Check Test Case    $TEST_NAME

\$SUITE_SOURCE in user keyword
    Check Test Case    $TEST_NAME

\$SUITE_SOURCE in resource file
    Check Test Case    $TEST_NAME
