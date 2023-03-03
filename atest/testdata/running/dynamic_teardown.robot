*** Settings ***
Suite teardown    ${suite_teardown}   World!

*** Test Cases ***
Setting teardowns with variables dynamically
    Set test variable    ${test_teardown}   Log
    Set suite variable   ${suite_teardown}   Log
    [teardown]   ${test_teardown}    Hello
