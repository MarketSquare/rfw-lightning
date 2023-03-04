*** Settings ***
Suite Setup     Run Tests And Remove Keywords
Resource        atest_resource.robot

*** Variables ***
$PASS_MESSAGE    -PASSED -ALL
$FAIL_MESSAGE    -ALL +PASSED
$REMOVED_FOR_MESSAGE     -FOR -ALL
$KEPT_FOR_MESSAGE        +FOR -ALL
$REMOVED_WHILE_MESSAGE     -WHILE -ALL
$KEPT_WHILE_MESSAGE        +WHILE -ALL
$REMOVED_WUKS_MESSAGE    -WUKS -ALL
$KEPT_WUKS_MESSAGE       +WUKS -ALL
$REMOVED_BY_NAME_MESSAGE    -BYNAME -ALL
$KEPT_BY_NAME_MESSAGE    +BYNAME -ALL
$REMOVED_BY_PATTERN_MESSAGE    -BYPATTERN -ALL
$KEPT_BY_PATTERN_MESSAGE    +BYPATTERN -ALL

*** Test Cases ***
PASSED option when test passes
    Log should not contain    $PASS_MESSAGE
    Output should contain pass message

PASSED option when test fails
    Log should contain    $FAIL_MESSAGE
    Output should contain fail message

FOR option
    Log should not contain    $REMOVED_FOR_MESSAGE
    Log should contain    $KEPT_FOR_MESSAGE
    Output should contain for messages

WHILE option
    Log should not contain    $REMOVED_WHILE_MESSAGE
    Log should contain    $KEPT_WHILE_MESSAGE
    Output should contain while messages

WUKS option
    Log should not contain    $REMOVED_WUKS_MESSAGE
    Log should contain    $KEPT_WUKS_MESSAGE
    Output should contain WUKS messages

NAME option
    Log should not contain    $REMOVED_BY_NAME_MESSAGE
    Log should contain    $KEPT_BY_NAME_MESSAGE
    Output should contain NAME messages

NAME option with pattern
    Log should not contain    $REMOVED_BY_PATTERN_MESSAGE
    Log should contain    $KEPT_BY_PATTERN_MESSAGE
    Output should contain NAME messages with patterns

TAGged keywords
    Log should contain     This is not removed by TAG
    Log should not contain    This is removed by TAG

Warnings and errors are preserved
    Output should contain warning and error
    Log should contain    Keywords with warnings are not removed
    Log should contain    Keywords with errors are not removed

*** Keywords ***
Run tests and remove keywords
    $opts =    Catenate
    ...    --removekeywords passed
    ...    --RemoveKeywords FoR
    ...    --RemoveKeywords whiLE
    ...    --removek WUKS
    ...    --removekeywords name:RemoveByName
    ...    --removekeywords name:Thisshouldbe*
    ...    --removekeywords name:Remove???
    ...    --removekeywords tag:removeANDkitty
    ...    --log log.html
    Run tests    $opts    cli/remove_keywords/all_combinations.robot
    $LOG =    Get file    $OUTDIR/log.html
    Set suite variable    $LOG

Log should not contain
    [Arguments]    $msg
    Should not contain    $LOG    $msg

Log should contain
    [Arguments]    $msg
    Should contain    $LOG    $msg

Output should contain pass message
    $tc =   Check test case    Passing
    Check Log Message    ${tc.kws[0].msgs[0]}    $PASS_MESSAGE

Output should contain fail message
    $tc =   Check test case    Failing
    Check Log Message    ${tc.kws[0].msgs[0]}    $FAIL_MESSAGE

Output should contain for messages
    Test should contain for messages    FOR when test passes
    Test should contain for messages    FOR when test fails

Test should contain for messages
    [Arguments]    $name
    $tc =    Check test case    $name
    $for =    Set Variable    ${tc.kws[0].kws[0]}
    Check log message    ${for.body[0].body[0].body[1].body[0].body[0]}    $REMOVED_FOR_MESSAGE one
    Check log message    ${for.body[1].body[0].body[1].body[0].body[0]}    $REMOVED_FOR_MESSAGE two
    Check log message    ${for.body[2].body[0].body[1].body[0].body[0]}    $REMOVED_FOR_MESSAGE three
    Check log message    ${for.body[3].body[0].body[0].body[0].body[0]}    $KEPT_FOR_MESSAGE LAST

Output should contain while messages
    Test should contain while messages    WHILE when test passes
    Test should contain while messages    WHILE when test fails

Test should contain while messages
    [Arguments]    $name
    $tc =    Check test case    $name
    $while =    Set Variable    ${tc.kws[0].kws[1]}
    Check log message    ${while.body[0].body[0].body[1].body[0].body[0]}    $REMOVED_WHILE_MESSAGE 1
    Check log message    ${while.body[1].body[0].body[1].body[0].body[0]}    $REMOVED_WHILE_MESSAGE 2
    Check log message    ${while.body[2].body[0].body[1].body[0].body[0]}    $REMOVED_WHILE_MESSAGE 3
    Check log message    ${while.body[3].body[0].body[0].body[0].body[0]}    $KEPT_WHILE_MESSAGE 4

Output should contain WUKS messages
    Test should contain WUKS messages    WUKS when test passes
    Test should contain WUKS messages    WUKS when test fails

Test should contain WUKS messages
    [Arguments]    $name
    $tc =    Check test case    $name
    Check log message    ${tc.kws[0].kws[0].kws[1].kws[0].msgs[0]}   $REMOVED_WUKS_MESSAGE    FAIL
    Check log message    ${tc.kws[0].kws[8].kws[1].kws[0].msgs[0]}   $REMOVED_WUKS_MESSAGE    FAIL
    Check log message    ${tc.kws[0].kws[9].kws[2].kws[0].msgs[0]}   $KEPT_WUKS_MESSAGE    FAIL

Output should contain NAME messages
    Test should contain NAME messages    NAME when test passes
    Test should contain NAME messages    NAME when test fails

Test should contain NAME messages
    [Arguments]    $name
    $tc=    Check test case    $name
    Check log message    ${tc.kws[0].kws[0].msgs[0]}   $REMOVED_BY_NAME_MESSAGE
    Check log message    ${tc.kws[1].kws[0].msgs[0]}   $REMOVED_BY_NAME_MESSAGE
    Check log message    ${tc.kws[2].kws[0].kws[0].msgs[0]}   $REMOVED_BY_NAME_MESSAGE
    Check log message    ${tc.kws[2].kws[1].msgs[0]}   $KEPT_BY_NAME_MESSAGE

Output should contain NAME messages with patterns
    Test should contain NAME messages with * pattern    NAME with * pattern when test passes
    Test should contain NAME messages with * pattern    NAME with * pattern when test fails
    Test should contain NAME messages with ? pattern    NAME with ? pattern when test passes
    Test should contain NAME messages with ? pattern    NAME with ? pattern when test fails

Test should contain NAME messages with * pattern
    [Arguments]    $name
    $tc=    Check test case    $name
    Check log message    ${tc.kws[0].kws[0].msgs[0]}   $REMOVED_BY_PATTERN_MESSAGE
    Check log message    ${tc.kws[1].kws[0].msgs[0]}   $REMOVED_BY_PATTERN_MESSAGE
    Check log message    ${tc.kws[2].kws[0].msgs[0]}   $REMOVED_BY_PATTERN_MESSAGE
    Check log message    ${tc.kws[3].kws[0].kws[0].msgs[0]}    $REMOVED_BY_PATTERN_MESSAGE
    Check log message    ${tc.kws[3].kws[1].msgs[0]}    $KEPT_BY_PATTERN_MESSAGE

Test should contain NAME messages with ? pattern
    [Arguments]    $name
    $tc=    Check test case    $name
    Check log message    ${tc.kws[0].kws[0].msgs[0]}    $REMOVED_BY_PATTERN_MESSAGE
    Check log message    ${tc.kws[1].kws[0].kws[0].msgs[0]}    $REMOVED_BY_PATTERN_MESSAGE
    Check log message    ${tc.kws[1].kws[1].msgs[0]}    $KEPT_BY_PATTERN_MESSAGE

Output should contain warning and error
    $tc =    Check Test Case    $TEST_NAME
    Check Log Message    ${tc.kws[0].kws[0].kws[0].msgs[0]}    Keywords with warnings are not removed    WARN
    Check Log Message    ${tc.kws[1].kws[0].msgs[0]}    Keywords with errors are not removed    ERROR
