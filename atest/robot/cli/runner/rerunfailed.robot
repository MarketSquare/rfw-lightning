*** Settings ***
Suite Setup       Suite initialization
Suite Teardown    Remove Directory    ${RERUN_DIR}    recursive
Resource          atest_resource.robot

*** Variables ***
${ORIG_DIR}           ${DATADIR}/cli/runfailed
${RERUN_DIR}          %{TEMPDIR}/rerun-dir
${SUITE_DIR}          ${RERUN_DIR}/suite
${RUN_FAILED_FROM}    ${RERUN_DIR}/rerun-output.xml

*** Test Cases ***
Passing is not re-executed
    Test Should Not Have Been Executed    Passing
    Test Should Not Have Been Executed    Not Failing

Skipping test in not re-executed
    Test Should Not Have Been Executed    Skipped

Failing is re-executed
    Test Should Have Been Executed        Failing

Failing from subsuite is executed
    Test Should Have Been Executed        Really Failing

Glob meta characters are ignored in names
    Test Should Have Been Executed        Glob [seq]
    Test Should Have Been Executed        Glob question?
    Test Should Have Been Executed        Glob asterisk*
    Test Should Not Have Been Executed    Glob question!
    Test Should Not Have Been Executed    Glob asteriskXXX

Explicitly selected is executed
    Test Should Have Been Executed        Selected

Excluded failing is not executed
    Test Should Not Have Been Executed    Failing with tag

Non-existing failing from output file is not executed
    Test Should Not Have Been Executed    Only in one suite

Suite teardown failures are noticed
    Test Should Have Been Executed        Test passed but suite teardown fails

*** Keywords ***
Suite initialization
    Copy Directory    ${ORIG_DIR}/suite    ${SUITE_DIR}
    Copy File    ${ORIG_DIR}/runfailed1.robot    ${SUITE_DIR}/runfailed.robot
    Run Tests    ${EMPTY}    ${SUITE_DIR}
    Copy File    ${OUTFILE}    ${RUN_FAILED_FROM}
    Copy File    ${ORIG_DIR}/runfailed2.robot    ${SUITE_DIR}/runfailed.robot
    Run Tests    --rerunfailed ${RUN_FAILED_FROM} --test Selected --exclude excluded_tag    ${SUITE_DIR}

Test Should Have Been Executed
    [Arguments]    ${name}
    Check Test Case    ${name}

Test Should Not Have Been Executed
    [Arguments]    ${name}
    Run Keyword And Expect Error    No test '${name}' found*    Check Test Case    ${name}
