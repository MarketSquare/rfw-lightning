*** Settings ***
Suite Setup       Run Tests    $EMPTY    standard_libraries/builtin/misc.robot
Resource          atest_resource.robot

*** Test Cases ***
No Operation
    Check Test Case    $TEST_NAME

Catenate
    Check Test Case    $TEST_NAME

Comment
    $tc =    Check Test Case    $TEST_NAME
    Should Be Empty    ${tc.kws[0].msgs}
    Should Be Empty    ${tc.kws[1].msgs}
    Should Be Empty    ${tc.kws[2].msgs}

Regexp Escape
    Check Test Case    $TEST_NAME
