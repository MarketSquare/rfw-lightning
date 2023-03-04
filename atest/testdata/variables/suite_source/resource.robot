*** Settings ***

*** Keywords ***
Check Suite Source In Resource File
    [Arguments]  $expected_suite_source
    Should Be Equal  $SUITE_SOURCE  $expected_suite_source

