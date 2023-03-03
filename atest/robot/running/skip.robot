*** Settings ***
Suite Setup     Run Tests  --skip skip-this --SkipOnFailure skip-on-failure    running/skip/
Resource        atest_resource.robot

*** Test Cases ***
Skip keyword
    Check Test Case    ${TEST_NAME}

Skip with SkipExecution exception in library
    Check Test Case    ${TEST_NAME}

Skip with SkipExecution exception in library using HTML
    Check Test Case    ${TEST_NAME}

Skip with custom exception
    Check Test Case    ${TEST_NAME}

Skip If Keyword with True Condition
    Check Test Case    ${TEST_NAME}

Skip If Keyword with True Condition And Custom Message
    Check Test Case    ${TEST_NAME}

Skip If Keyword with False Condition
    Check Test Case    ${TEST_NAME}

Skip Keyword with Custom Message
    Check Test Case    ${TEST_NAME}

Skip in Setup
    Check Test Case    ${TEST_NAME}

Remaining setup keywords aren't run after skip
    Check Test Case    ${TEST_NAME}

Skip in Teardown
    Check Test Case    ${TEST_NAME}

Remaining teardown keywords aren't run after skip
    Check Test Case    ${TEST_NAME}

Skip in Teardown After Failure In Body
    Check Test Case    ${TEST_NAME}

Teardown is executed after skip
    ${tc} =    Check Test Case    ${TEST_NAME}
    Check log message    ${tc.teardown.msgs[0]}    Teardown is executed!

Fail in Teardown After Skip In Body
    Check Test Case    ${TEST_NAME}

Skip in Teardown After Skip In Body
    Check Test Case    ${TEST_NAME}

Skip After Continuable Failure
    Check Test Case    ${TEST_NAME}

Skip After Multiple Continuable Failures
    Check Test Case    ${TEST_NAME}

Skip After Continuable Failure with HTML Message
    Check Test Case    ${TEST_NAME}

Skip After Multiple Continuable Failure with HTML Messages
    Check Test Case    ${TEST_NAME}

Skip with Pass Execution in Teardown
    Check Test Case    ${TEST_NAME}

Skip in Teardown with Pass Execution in Body
    Check Test Case    ${TEST_NAME}

Skip in Teardown After Continuable Failures
    Check Test Case    ${TEST_NAME}

Skip in Suite Setup
    Check Test Case    ${TEST_NAME}

Skip in Directory Suite Setup
    Check Test Case    ${TEST_NAME}

Skip In Suite Teardown
    Check Test Case    ${TEST_NAME}

Skip In Suite Setup And Teardown
    Check Test Case    ${TEST_NAME}

Skip In Suite Teardown After Fail In Setup
    Check Test Case    ${TEST_NAME}

Skip In Directory Suite Teardown
    Check Test Case    ${TEST_NAME}

Skip with Run Keyword and Ignore Error
    Check Test Case    ${TEST_NAME}

Skip with Run Keyword and Expect Error
    Check Test Case    ${TEST_NAME}

Skip with Run Keyword and Return Status
    Check Test Case    ${TEST_NAME}

Skip with Wait Until Keyword Succeeds
    Check Test Case    ${TEST_NAME}

Skipped with --skip
    Check Test Case    ${TEST_NAME}

Skipped when test is tagged with robot:skip
    Check Test Case    ${TEST_NAME}

Skipped with --SkipOnFailure
    Check Test Case    ${TEST_NAME}

Skipped with --SkipOnFailure when Failure in Test Setup
    Check Test Case    ${TEST_NAME}

Skipped with --SkipOnFailure when Failure in Test Teardown
    Check Test Case    ${TEST_NAME}

Skipped with --SkipOnFailure when Set Tags Used in Teardown
    Check Test Case    Skipped with --SkipOnFailure when Set Tags Used in Teardown

Skipped although test fails since test is tagged with robot:skip-on-failure
    Check Test Case    ${TEST_NAME}

Using Skip Does Not Affect Passing And Failing Tests
    Check Test Case    Passing Test
    Check Test Case    Failing Test
