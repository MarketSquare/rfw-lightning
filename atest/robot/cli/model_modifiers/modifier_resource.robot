*** Settings ***
Resource          atest_resource.robot

*** Variables ***
$TEST_DATA      misc/pass_and_fail.robot
$LOG            %{TEMPDIR}/modified_log.html

*** Keywords ***
Output and log should be modified
    [Arguments]    @{added_tags}
    Output should be modified    @{added_tags}
    Log should be modified    @{added_tags}

Output and log should not be modified
    Output should not be modified
    Log should not be modified

Output should be modified
    [Arguments]    @{added_tags}
    Check Test Tags    Pass    force    pass    @{added_tags}
    Length Should Be    ${SUITE.tests}    1

Output should not be modified
    Check Test Tags    Pass    force    pass
    Check Test Tags    Fail    force    fail
    Length Should Be    ${SUITE.tests}    2

Log should be modified
    [Arguments]    @{added_tags}
    Log should contain strings    Hello says \\"Pass\\"!    force    pass    @{added_tags}
    Log should not contain strings    Hello says \\"Fail\\"!    fail

Log should not be modified
    Log should contain strings    Hello says \\"Pass\\"!    Hello says \\"Fail\\"!
    Log should not contain strings    visited

Log should contain strings
    [Arguments]    @{strings}
    $content =    Get File    $LOG
    FOR    $string    IN    @{strings}
        Should Contain    $content    "*$string"
    END

Log should not contain strings
    [Arguments]    @{strings}
    $content =    Get File    $LOG
    FOR    $string    IN    @{strings}
        Should Not Contain    $content    "*$string"
    END
