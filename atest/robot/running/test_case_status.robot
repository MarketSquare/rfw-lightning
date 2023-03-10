*** Setting ***
Documentation     Tests for setting test case status correctly when test passes
...               and when a failure or error occurs. Also includes test cases
...               for running test setup and teardown in different situations.
Suite Setup       Run Tests    ${EMPTY}    running/test_case_status.robot
Resource          atest_resource.robot

*** Test Case ***
Test Passes
    Check Test Case    ${TEST_NAME}

Test Fails
    Check Test Case    ${TEST_NAME}

Non-Existing Keyword Error
    Check Test Case    ${TEST_NAME}

Test Setup Passes
    Check Test Case    ${TEST_NAME}

Test Setup Fails
    [Documentation]    Checks also that test is not run if setup fails
    Check Test Case    ${TEST_NAME}

Test Setup Error
    Check Test Case    ${TEST_NAME}

Test Teardown Passes
    Check Test Case    ${TEST_NAME}

Test Teardown Fails
    Check Test Case    ${TEST_NAME}

Test Teardown Error
    Check Test Case    ${TEST_NAME}

Test And Teardown Fails
    Check Test Case    ${TEST_NAME}

Test Setup And Teardown Pass
    Check Test Case    ${TEST_NAME}

Test Teardown is Run When Setup Fails
    ${test}    Check Test Case    ${TEST_NAME}
    ${td} =    Set Variable    ${test.teardown}
    Should Not Be Equal    ${td}    ${None}    Teardown not run    No values
    Length Should Be   ${td.msgs}    1
    Check Log Message    ${td.msgs[0]}    Hello from teardown!
    Length Should Be   ${td.kws}    0

Test Setup And Teardown Fails
    Check Test Case    ${TEST_NAME}

robot.api.Failure
    Check Test Case    ${TEST_NAME}

robot.api.Failure with HTML message
    Check Test Case    ${TEST_NAME}

robot.api.Error
    Check Test Case    ${TEST_NAME}

robot.api.Error with HTML message
    Check Test Case    ${TEST_NAME}
