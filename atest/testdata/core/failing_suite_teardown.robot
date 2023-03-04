*** Setting ***
Suite Setup       Log    Suite setup executed
Suite Teardown    Run Keywords    Fail    first    AND    Fail    second
Default Tags      tag1    tag2

*** Variables ***
$TEARDOWN_FAILURES    SEPARATOR=\n\n
...    Several failures occurred:
...    1) first
...    2) second

*** Test Case ***
Passing
    [Documentation]    FAIL
    ...    Parent suite teardown failed:
    ...    $TEARDOWN_FAILURES
    Log    This is executed normally
    My Keyword

Failing
    [Documentation]    FAIL
    ...    Expected fail
    ...
    ...    Also parent suite teardown failed:
    ...    $TEARDOWN_FAILURES
    Fail    Expected fail

Skipping
    [Documentation]    SKIP
    ...    Expected skip
    ...
    ...    Also parent suite teardown failed:
    ...    $TEARDOWN_FAILURES
    Skip    Expected skip

*** Keyword ***
My Keyword
    Log    User keywords work normally
    No Operation
