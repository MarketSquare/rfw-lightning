*** Settings ***
Suite Setup        Run Tests    -L DEBUG    running/timeouts.robot
Suite Teardown     Remove Directory    ${TIMEOUT_TEMP}    recursive
Resource           atest_resource.robot

*** Variables ***
${TIMEOUT_TEMP}    %{TEMPDIR}${/}robot_timeout_tests
${TEST_STOPPED}    ${TIMEOUT_TEMP}${/}test_stopped.txt
${KW_STOPPED}      ${TIMEOUT_TEMP}${/}kw_stopped.txt

*** Test Cases ***
Timeouted Test Passes
    Check Test Case    Passing
    Check Test Case    Sleeping But Passing

Timeouted Test Fails Before Timeout
    Check Test Case    Failing Before Timeout

Show Correct Traceback When Failing Before Timeout
    ${tc} =    Check Test Case    ${TEST_NAME}
    ${expected} =    Catenate    SEPARATOR=\n
    ...    Traceback (most recent call last):
    ...    ${SPACE*2}File "*", line *, in exception
    ...    ${SPACE*4}raise exception(msg)
    ...    RuntimeError: Failure before timeout
    Check Log Message    ${tc.kws[0].msgs[-1]}    ${expected}    DEBUG    pattern=True    traceback=True

Timeouted Test Timeouts
    Check Test Case    Sleeping And Timeouting
    Check Test Case    Looping Forever And Timeouting

Total Time Too Long
    Check Test Case    ${TEST_NAME} 1
    Check Test Case    ${TEST_NAME} 2
    Check Test Case    ${TEST_NAME} 3
    Check Test Case    ${TEST_NAME} 4

Timout Defined For One Test
    Check Test Case    ${TEST_NAME}

Stopped After Test Timeout
    Check Test Case    ${TEST_NAME}
    File Should Be Empty    ${TEST_STOPPED}

Timeouted Keyword Passes
    Check Test Case    ${TEST_NAME}

Timeouted Keyword Fails Before Timeout
    Check Test Case    ${TEST_NAME}

Timeouted Keyword Timeouts
    Check Test Case    ${TEST_NAME}

Timeouted Keyword Timeouts Due To Total Time
    Check Test Case    ${TEST_NAME}

Stopped After Keyword Timeout
    Check Test Case    ${TEST_NAME}
    File Should Be Empty    ${KW_STOPPED}

Test Timeouts When Also Keywords Are Timeouted
    Check Test Case    ${TEST_NAME}

Keyword Timeout From Variable
    ${tc} =    Check Test Case    ${TEST_NAME}
    Should Be Equal    ${tc.kws[0].timeout}    1 millisecond

Keyword Timeout From Argument
    ${tc} =    Check Test Case    ${TEST_NAME}
    Should Be Equal    ${tc.kws[0].timeout}    1 second
    Should Be Equal    ${tc.kws[1].timeout}    2 milliseconds

Embedded Arguments Timeout From Argument
    ${tc} =    Check Test Case    ${TEST_NAME}
    Should Be Equal    ${tc.kws[0].timeout}    1 second
    Should Be Equal    ${tc.kws[1].timeout}    3 milliseconds

Local Variables Are Not Visible In Child Keyword Timeout
    Check Test Case    ${TEST_NAME}

Timeout Format
    ${tc} =    Check Test Case    ${TEST_NAME}
    Should Be Equal    ${tc.timeout}    2 days 4 hours 56 minutes 18 seconds

Test Timeout During Setup
    Check Test Case    ${TEST_NAME}

Teardown After Test Timeout
    [Documentation]    Test that teardown is executed after a test has timed out
    ${tc} =    Check Test Case    ${TEST_NAME}
    Check Log Message    ${tc.teardown.msgs[0]}    Teardown executed
    ${tc} =    Check Test Case    Teardown With Sleep After Test Timeout
    Check Log Message    ${tc.teardown.kws[1].msgs[0]}    Teardown executed

Failing Teardown After Test Timeout
    Check Test Case    ${TEST_NAME}

Test Timeout During Teardown
    [Documentation]    Test timeout should not interrupt teardown but test should be failed afterwards
    ${tc} =    Check Test Case    ${TEST_NAME}
    Check Log Message    ${tc.teardown.kws[1].msgs[0]}    Teardown executed

Timeouted Setup Passes
    Check Test Case    ${TEST_NAME}

Timeouted Setup Timeouts
    Check Test Case    ${TEST_NAME}

Timeouted Teardown Passes
    Check Test Case    ${TEST_NAME}

Timeouted Teardown Timeouts
    Check Test Case    ${TEST_NAME}

Timeouted UK Using Non Timeouted UK
    Check Test Case    ${TEST_NAME}

Shortest UK Timeout Should Be Applied
    Check Test Case    ${TEST_NAME}

Shortest Test Or UK Timeout Should Be Applied
    Check Test Case    ${TEST_NAME}

Timeouted Set Keyword
    Check Test Case    ${TEST_NAME}

Test Timeout Should Not Be Active For Run Keyword Variants But To Keywords They Execute
    Check Test Case    ${TEST_NAME}

Keyword Timeout Should Not Be Active For Run Keyword Variants But To Keywords They Execute
    Check Test Case    ${TEST_NAME}

Logging With Timeouts
    [Documentation]    Testing that logging works with timeouts
    ${tc} =    Check Test Case    Timeouted Keyword Passes
    Check Log Message    ${tc.kws[0].msgs[1]}           Testing logging in timeouted test
    Check Log Message    ${tc.kws[1].kws[0].msgs[1]}    Testing logging in timeouted keyword

Timeouted Keyword Called With Wrong Number of Arguments
    Check Test Case    ${TEST_NAME}

Timeouted Keyword Called With Wrong Number of Arguments with Run Keyword
    Check Test Case    ${TEST_NAME}

Test Timeout Logging
    ${tc} =    Check Test Case    Passing
    Timeout should have been active    ${tc.kws[0]}    1 second     1
    ${tc} =    Check Test Case    Failing Before Timeout
    Timeout should have been active    ${tc.kws[0]}    2 seconds    3
    ${tc} =    Check Test Case    Sleeping And Timeouting
    Timeout should have been active    ${tc.kws[0]}    1 second     2    exceeded=True

Keyword Timeout Logging
    ${tc} =    Check Test Case    Timeouted Keyword Passes
    Keyword timeout should have been active    ${tc.kws[1].kws[0]}    5 seconds             2
    ${tc} =    Check Test Case    Timeouted Keyword Fails Before Timeout
    Keyword timeout should have been active    ${tc.kws[0].kws[0]}    2 hours 30 minutes    3
    ${tc} =    Check Test Case    Timeouted Keyword Timeouts
    Keyword timeout should have been active    ${tc.kws[0].kws[0]}    99 milliseconds       2    exceeded=True

Zero timeout is ignored
    ${tc} =    Check Test Case    ${TEST_NAME}
    Should Be Equal    ${tc.timeout}    0 seconds
    Should Be Equal    ${tc.kws[0].timeout}    0 seconds
    Should Be True     ${tc.kws[0].elapsedtime} > 99

Negative timeout is ignored
    ${tc} =    Check Test Case    ${TEST_NAME}
    Should Be Equal    ${tc.kws[0].timeout}    - 1 second
    Should Be Equal    ${tc.kws[0].timeout}    - 1 second
    Should Be True     ${tc.kws[0].elapsedtime} > 99

Invalid test timeout
    Check Test Case    ${TEST_NAME}

Invalid keyword timeout
    Check Test Case    ${TEST_NAME}

*** Keywords ***
Timeout should have been active
    [Arguments]    ${kw}    ${timeout}    ${msg_count}    ${exceeded}=False    ${type}=Test
    Check Log Message    ${kw.msgs[0]}    ${type} timeout ${timeout} active. * left.    DEBUG    pattern=True
    Length Should Be     ${kw.msgs}       ${msg_count}
    Run Keyword If    ${exceeded}
    ...    Timeout should have exceeded    ${kw}    ${timeout}    ${type}

Keyword timeout should have been active
    [Arguments]    ${kw}    ${timeout}    ${msg_count}    ${exceeded}=False
    Timeout should have been active    ${kw}    ${timeout}    ${msg_count}    ${exceeded}    type=Keyword

Timeout should have exceeded
    [Arguments]    ${kw}    ${timeout}    ${type}=Test
    Check Log Message    ${kw.msgs[1]}    ${type} timeout ${timeout} exceeded.    FAIL
