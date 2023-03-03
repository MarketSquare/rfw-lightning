*** Settings ***
Suite Setup       Run Tests    ${EMPTY}    running/for/break_and_continue.robot
Resource          for.resource
Test Template     Test and all keywords should have passed

*** Test Cases ***
With CONTINUE
    allow_not_run=True

With CONTINUE inside IF
    [Template]     None
    ${tc}=    Check test case    ${TEST_NAME}
    Should be FOR loop    ${tc.body[0]}    5    FAIL    IN RANGE

With CONTINUE inside TRY
    allow_not_run=True

With CONTINUE inside EXCEPT and TRY-ELSE
    allow_not_run=True

With BREAK
    allow_not_run=True

With BREAK inside IF
    allow_not_run=True

With BREAK inside TRY
    allow_not_run=True

With BREAK inside EXCEPT
    allow_not_run=True

With BREAK inside TRY-ELSE
    allow_not_run=True

With CONTINUE in UK
    allow_not_run=True

With CONTINUE inside IF in UK
    [Template]     None
    ${tc}=    Check test case    ${TEST_NAME}
    Should be FOR loop    ${tc.body[0].body[0]}    5    FAIL    IN RANGE

With CONTINUE inside TRY in UK
    allow_not_run=True

With CONTINUE inside EXCEPT and TRY-ELSE in UK
    allow_not_run=True

With BREAK in UK
    allow_not_run=True

With BREAK inside IF in UK
    allow_not_run=True

With BREAK inside TRY in UK
    allow_not_run=True

With BREAK inside EXCEPT in UK
    allow_not_run=True

With BREAK inside TRY-ELSE in UK
    allow_not_run=True
