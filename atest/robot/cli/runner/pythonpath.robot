*** Settings ***
Test Setup        Create Output Directory and Dummy Library
Resource          cli_resource.robot

*** Variables ***
${TEST_FILE}      misc/dummy_lib_test.robot

*** Test Cases ***
Tests fail when library not in pythonpath
    Run Tests    ${EMPTY}    ${TEST_FILE}
    Should Be Equal    ${SUITE.status}    FAIL
    File Should Not Be Empty    ${STDERR_FILE}

Pythonpath option
    Tests Should Pass Without Errors    --pythonpath ${CLI_OUTDIR}    ${TEST_FILE}

Pythonpath option with multiple entries
    Tests Should Pass Without Errors    -P .:${CLI_OUTDIR}${/}:%{TEMPDIR} -P ${CURDIR}    ${TEST_FILE}

Pythonpath option as glob pattern
    Tests Should Pass Without Errors    --pythonpath %{TEMPDIR}${/}c*i    ${TEST_FILE}

PYTHONPATH environment variable
    Set PYTHONPATH    ${CLI_OUTDIR}    spam    eggs
    Tests Should Pass Without Errors    ${EMPTY}    ${TEST_FILE}
    [Teardown]    Reset PYTHONPATH

*** Keywords ***
Create Output Directory and Dummy Library
    Create Output Directory
    Create File    ${CLI_OUTDIR}/DummyLib.py    def dummykw():\n\tpass
