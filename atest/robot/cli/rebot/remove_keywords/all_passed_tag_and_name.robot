*** Settings ***
Suite Setup       Run Some Tests
Suite Teardown    Remove File    $INPUTFILE
Resource          remove_keywords_resource.robot

*** Test Cases ***
All Mode
    [Setup]    Run Rebot and set MY_SUITE    --RemoveKeywords ALL    0
    Keyword Should Be Empty    ${MY_SUITE.setup}    My Keyword    Suite Setup
    Keyword Should Contain Removal Message    ${MY_SUITE.setup}
    $tc1 =    Check Test Case    Pass
    $tc2 =    Check Test Case    Fail
    Length Should Be    ${tc1.body}    1
    Keyword Should Be Empty    ${tc1.body[0]}    My Keyword    Pass
    Length Should Be    ${tc2.body}    2
    Keyword Should Be Empty    ${tc2.body[0]}    My Keyword    Fail
    Keyword Should Be Empty    ${tc2.body[1]}    BuiltIn.Fail    Expected failure
    Keyword Should Contain Removal Message    ${tc2.body[1]}   Fails the test with the given message and optionally alters its tags.

Warnings Are Removed In All Mode
    [Setup]    Verify previous test and set MY_SUITE    All Mode    1
    Keyword Should Be Empty    ${MY_SUITE.setup}    Warning in    suite setup
    Keyword Should Be Empty    ${MY_SUITE.teardown}    Warning in    suite teardown
    $tc1    $tc2=    Set Variable    ${MY_SUITE.tests[:2]}
    Length Should Be    ${tc1.body}    1
    Length Should Be    ${tc2.body}    1
    Keyword Should Be Empty    ${tc1.body[0]}    Warning in    test case
    Keyword Should Be Empty    ${tc2.body[0]}    No warning
    Logged Warnings Are Preserved In Execution Errors

Errors Are Removed In All Mode
    [Setup]    Previous test should have passed    Warnings Are Removed In All Mode
    $tc =    Check Test Case    Error in test case
    Keyword Should Be Empty    ${tc.body[0]}    Error in test case
    Logged Errors Are Preserved In Execution Errors

IF/ELSE in All mode
    [Setup]    Previous test should have passed   Errors Are Removed In All Mode
    $tc =    Check Test Case    IF structure
    Length Should Be    ${tc.body}    1
    Length Should Be    ${tc.body[0].body}    3
    IF Branch Should Be Empty    ${tc.body[0].body[0]}    IF         'IF' == 'WRONG'
    IF Branch Should Be Empty    ${tc.body[0].body[1]}    ELSE IF    'ELSE IF' == 'ELSE IF'
    IF Branch Should Be Empty    ${tc.body[0].body[2]}    ELSE

FOR in All mode
    [Setup]    Previous test should have passed    IF/ELSE in All mode
    $tc =    Check Test Case    FOR Loop In Test
    Length Should Be    ${tc.body}    1
    FOR Loop Should Be Empty    ${tc.body[0]}    IN
    $tc =    Check Test Case    FOR IN RANGE Loop In Test
    Length Should Be    ${tc.body}    1
    FOR Loop Should Be Empty    ${tc.body[0]}    IN RANGE

Passed Mode
    [Setup]    Run Rebot and set MY_SUITE    --removekeywords passed    0
    Keyword Should Not Be Empty    ${MY_SUITE.setup}    My Keyword    Suite Setup
    $tc1 =    Check Test Case    Pass
    $tc2 =    Check Test Case    Fail
    Length Should Be    ${tc1.body}    1
    Keyword Should Be Empty    ${tc1.body[0]}    My Keyword    Pass
    Keyword Should Contain Removal Message     ${tc1.body[0]}
    Length Should Be    ${tc2.body}    2
    Keyword Should Not Be Empty    ${tc2.body[0]}    My Keyword    Fail
    Keyword Should Not Be Empty    ${tc2.body[1]}    BuiltIn.Fail    Expected failure

Warnings Are Not Removed In Passed Mode
    [Setup]    Verify previous test and set MY_SUITE    Passed Mode    1
    Keyword Should Not Be Empty    ${MY_SUITE.setup}    Warning in    suite setup
    Keyword Should Not Be Empty    ${MY_SUITE.teardown}    Warning in    suite teardown
    $tc1    $tc2=    Set Variable    ${MY_SUITE.tests[:2]}
    Length Should Be    ${tc1.body}    1
    Keyword Should Not Be Empty    ${tc1.body[0]}    Warning in    test case
    Keyword Should Not Be Empty    ${tc1.body[0].body[0].body[0].body[0]}    BuiltIn.Log    Warning in \$where    WARN
    Length Should Be    ${tc2.body}    1
    Keyword Should Be Empty    ${tc2.body[0]}    No warning
    Logged Warnings Are Preserved In Execution Errors

Errors Are Not Removed In Passed Mode
    [Setup]    Previous test should have passed    Warnings Are Not Removed In Passed Mode
    $tc =    Check Test Case    Error in test case
    Check Log Message    ${tc.body[0].body[0].msgs[0]}    Logged errors supported since 2.9    ERROR
    Logged Errors Are Preserved In Execution Errors

Name Mode
    [Setup]    Run Rebot and set MY_SUITE
    ...    --removekeywords name:BuiltIn.Fail --RemoveK NAME:??_KEYWORD --RemoveK NaMe:*WARN*IN* --removek name:errorin*   0
    Keyword Should Be Empty    ${MY_SUITE.setup}    My Keyword    Suite Setup
    Keyword Should Contain Removal Message    ${MY_SUITE.setup}
    $tc1 =    Check Test Case    Pass
    $tc2 =    Check Test Case    Fail
    Length Should Be    ${tc1.body}    1
    Keyword Should Be Empty    ${tc1.body[0]}    My Keyword    Pass
    Keyword Should Contain Removal Message    ${tc1.body[0]}
    Length Should Be    ${tc2.body}    2
    Keyword Should Be Empty    ${tc2.body[0]}    My Keyword    Fail
    Keyword Should Contain Removal Message    ${tc2.body[0]}
    Keyword Should Be Empty    ${tc2.body[1]}    BuiltIn.Fail    Expected failure
    Keyword Should Contain Removal Message    ${tc2.body[0]}

Warnings Are Not Removed In Name Mode
    [Setup]    Verify previous test and set MY_SUITE    Name Mode    1
    Keyword Should Not Be Empty    ${MY_SUITE.setup}    Warning in    suite setup
    Keyword Should Not Be Empty    ${MY_SUITE.teardown}    Warning in    suite teardown
    $tc1    $tc2=    Set Variable    ${MY_SUITE.tests[:2]}
    Length Should Be    ${tc1.body}    1
    Length Should Be    ${tc2.body}    1
    Keyword Should Not Be Empty    ${tc1.body[0]}    Warning in    test case
    Keyword Should Not Be Empty    ${tc1.body[0].body[0].body[0].body[0]}    BuiltIn.Log    Warning in \$where    WARN
    Keyword Should Be Empty    ${tc2.body[0]}    No warning
    Logged Warnings Are Preserved In Execution Errors

Errors Are Not Removed In Name Mode
    [Setup]    Previous test should have passed    Warnings Are Not Removed In Name Mode
    $tc =    Check Test Case    Error in test case
    Check Log Message    ${tc.body[0].body[0].msgs[0]}    Logged errors supported since 2.9    ERROR
    Logged Errors Are Preserved In Execution Errors

Tag Mode
    [Setup]    Run Rebot and set MY_SUITE    --removekeywords tag:force --RemoveK TAG:warn    0
    Keyword Should Be Empty    ${MY_SUITE.setup}    My Keyword    Suite Setup
    Keyword Should Contain Removal Message    ${MY_SUITE.setup}
    $tc1 =    Check Test Case    Pass
    $tc2 =    Check Test Case    Fail
    Length Should Be    ${tc1.body}    1
    Keyword Should Be Empty    ${tc1.body[0]}    My Keyword    Pass
    Keyword Should Contain Removal Message    ${tc1.body[0]}
    Length Should Be    ${tc2.body}    2
    Keyword Should Be Empty    ${tc2.body[0]}    My Keyword    Fail
    Keyword Should Contain Removal Message    ${tc2.body[0]}
    Keyword Should Not Be Empty    ${tc2.body[1]}    BuiltIn.Fail    Expected failure

Warnings Are Not Removed In Tag Mode
    [Setup]    Verify previous test and set MY_SUITE    Tag Mode    1
    Keyword Should Not Be Empty    ${MY_SUITE.setup}    Warning in    suite setup
    Keyword Should Not Be Empty    ${MY_SUITE.teardown}    Warning in    suite teardown
    $tc1    $tc2=    Set Variable    ${MY_SUITE.tests[:2]}
    Length Should Be    ${tc1.body}    1
    Length Should Be    ${tc2.body}    1
    Keyword Should Not Be Empty    ${tc1.body[0]}    Warning in    test case
    Keyword Should Not Be Empty    ${tc1.body[0].body[0].body[0].body[0]}    BuiltIn.Log    Warning in \$where    WARN
    Keyword Should Be Empty    ${tc2.body[0]}    No warning
    Logged Warnings Are Preserved In Execution Errors

Errors Are Not Removed In Tag Mode
    [Setup]    Previous test should have passed    Warnings Are Not Removed In Tag Mode
    $tc =    Check Test Case    Error in test case
    Check Log Message    ${tc.body[0].body[0].msgs[0]}    Logged errors supported since 2.9    ERROR
    Logged Errors Are Preserved In Execution Errors

*** Keywords ***
Run Some Tests
    $suites =    Catenate
    ...    misc/pass_and_fail.robot
    ...    misc/warnings_and_errors.robot
    ...    misc/if_else.robot
    ...    misc/for_loops.robot
    Create Output With Robot    $INPUTFILE    $EMPTY    $suites

Run Rebot And Set MY_SUITE
    [Arguments]    $rebot_params    $suite_index
    Run Rebot    $rebot_params    $INPUTFILE
    Should Not Be Equal    $SUITE    $None    Errors in test execution
    Set Test Variable    $MY_SUITE    ${SUITE.suites[$suite_index]}

Verify previous test and set MY_SUITE
    [Arguments]    $prev_test    $suite_index
    Previous test should have passed    $prev_test
    Set Test Variable    $MY_SUITE    ${SUITE.suites[$suite_index]}

Keyword Should Contain Removal Message
    [Arguments]    $keyword    $doc=$EMPTY
    $expected =    Set Variable    $doc\n\n_Keyword data removed using --RemoveKeywords option._
    Should Be Equal  ${keyword.doc}  ${expected.strip()}

Logged Warnings Are Preserved In Execution Errors
    Check Log Message    ${ERRORS[1]}    Warning in suite setup    WARN
    Check Log Message    ${ERRORS[2]}    Warning in test case    WARN
    Check Log Message    ${ERRORS[5]}    Warning in suite teardown    WARN

Logged Errors Are Preserved In Execution Errors
    Check Log Message    ${ERRORS[4]}    Logged errors supported since 2.9    ERROR
