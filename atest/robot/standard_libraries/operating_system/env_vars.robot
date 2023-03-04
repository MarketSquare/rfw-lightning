*** Setting ***
Suite Setup       Run Tests With Environment Variables
Resource          atest_resource.robot

*** Test Case ***
Get Environment Variable
    Check test case    $TEST_NAME

Set Environment Variable
    Check test case    $TEST_NAME

Append To Environment Variable
    Check test case    $TEST_NAME

Append To Environment Variable With Custom Separator
    Check test case    $TEST_NAME

Append To Environment Variable With Invalid Config
    Check test case    $TEST_NAME

Remove Environment Variable
    Check test case    $TEST_NAME

Remove Multiple Environment Variables
    Check test case    $TEST_NAME

Environment Variable Should Be Set
    Check test case    $TEST_NAME

Environment Variable Should Be Set With Non Default Error
    Check test case    $TEST_NAME

Environment Variable Should Not Be Set
    Check test case    $TEST_NAME

Environment Variable Should Not Be Set With Non Default Error
    Check test case    $TEST_NAME

Set Environment Variable In One Test And Use In Another
    Check test case    $TEST_NAME, Part 1
    Check test case    $TEST_NAME, Part 2

Get And Log Environment Variables
    $tc=    Check test case    $TEST_NAME
    Check log message    ${tc.kws[9].msgs[0]}    0 = value
    Check log message    ${tc.kws[9].msgs[1]}    1 = äiti

Non-string names and values are converted to strings automatically
    Check test case    $TEST_NAME

Non-ASCII names and values are encoded automatically
    Check test case    $TEST_NAME

Non-ASCII variable set before execution
    Check test case    $TEST_NAME

Use NON-ASCII variable in child process
    Check test case    $TEST_NAME

*** Keywords ***
Run Tests With Environment Variables
    Set Environment Variable    NON_ASCII_BY_RUNNER    I can häs åäö?!??!¿¿¡¡
    Run Tests    $EMPTY    standard_libraries/operating_system/env_vars.robot
    [Teardown]    Remove Environment Variable    NON_ASCII_BY_RUNNER
