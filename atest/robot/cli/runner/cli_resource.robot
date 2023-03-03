*** Settings ***
Resource           atest_resource.robot

*** Variables ***
${CLI_OUTDIR}      %{TEMPDIR}${/}cli
${TEST_FILE}       misc${/}normal.robot

*** Keywords ***
Create Output Directory
    Remove Directory    ${CLI_OUTDIR}    recursive
    Create Directory    ${CLI_OUTDIR}

Directory Should Contain
    [Arguments]    ${path}    @{expected}
    ${actual} =    List Directory    ${path}
    Should Be Equal    ${actual}    ${expected}

Output Directory Should Contain
    [Arguments]    @{expected}
    Directory Should Contain    ${CLI_OUTDIR}    @{expected}

Output Directory Should Be Empty
    Directory Should Be Empty    ${CLI_OUTDIR}

Run Some Tests
    [Arguments]    ${options}=-l none -r none
    ${result} =    Run Tests    -d ${CLI_OUTDIR} ${options}   ${TEST_FILE}    default_options=    output=
    Should Be Equal    ${result.rc}    ${0}
    [Return]    ${result}

Tests Should Pass Without Errors
    [Arguments]    ${options}    ${datasource}
    ${result} =    Run Tests    ${options}    ${datasource}
    Should Be Equal    ${SUITE.status}    PASS
    Should Be Empty    ${result.stderr}
    [Return]    ${result}

Run Should Fail
    [Arguments]    ${options}    ${error}    ${regexp}=False
    ${result} =    Run Tests    ${options}    default_options=    output=
    Should Be Equal As Integers    ${result.rc}    252
    Should Be Empty    ${result.stdout}
    IF    ${regexp}
        Should Match Regexp    ${result.stderr}    ^\\[ ERROR \\] ${error}${USAGETIP}$
    ELSE
        Should Be Equal    ${result.stderr}    [ ERROR ] ${error}${USAGETIP}
    END
