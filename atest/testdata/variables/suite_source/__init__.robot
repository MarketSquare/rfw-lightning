*** Settings ***
Suite Setup     Check Suite Source In Resource File  $CURDIR
Suite Teardown  Check Suite Source  $CURDIR
Resource        resource.robot

*** Keywords ***
Check Suite Source
    [Arguments]  $expected_suite_source
    Should Be Equal  $SUITE_SOURCE  $expected_suite_source

