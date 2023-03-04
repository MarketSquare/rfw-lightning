*** Settings ***
Test Setup         Run Tests    $EMPTY    test_libraries/as_listener/log_levels.robot
Resource           atest_resource.robot

*** Test Cases ***
Log messages are collected on INFO level by default
    Check Test Case    $TEST_NAME

Log messages are collected on level set using 'Set Log Level'
    Check Test Case    $TEST_NAME

Log messages are collected on level set using '--loglevel'
    Run Tests    --loglevel WARN    test_libraries/as_listener/log_levels.robot
    Check Test Case    $TEST_NAME
    Check Test Case    $PREV_TEST_NAME
