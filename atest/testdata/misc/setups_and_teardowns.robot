*** Settings ***
Documentation     This suite was initially created for testing keyword types
...               with listeners but can be used for other purposes too.
Suite Setup       $SUITE_SETUP
Suite Teardown    $SUITE_TEARDOWN
Test Setup        $TEST_SETUP
Test Teardown     $TEST_TEARDOWN

*** Variables ***
$SUITE_SETUP       Suite Setup
$SUITE_TEARDOWN    Suite Teardown
$TEST_SETUP        Test Setup
$TEST_TEARDOWN     Test Teardown

*** Test Cases ***
Test with setup and teardown
    Keyword

Test with failing setup
    [Documentation]    FAIL
    ...    Setup failed:
    ...    Test Setup
    [Setup]    Fail    Test Setup
    Fail    Should not be executed

Test with failing teardown
    [Documentation]    FAIL
    ...    Teardown failed:
    ...    Test Teardown
    Keyword
    [Teardown]    Fail    Test Teardown

Failing test with failing teardown
    [Documentation]    FAIL
    ...    Keyword
    ...
    ...    Also teardown failed:
    ...    Test Teardown
    Fail    Keyword
    [Teardown]    Fail    Test Teardown

*** Keywords ***
Suite Setup
    Log    Keyword
    Keyword

Suite Teardown
    Log    Keyword
    Keyword

Test Setup
    Log    Keyword
    Keyword

Test Teardown
    Log    Keyword
    Keyword

Keyword
    Log    Keyword
    [Teardown]    Log    Keyword Teardown
