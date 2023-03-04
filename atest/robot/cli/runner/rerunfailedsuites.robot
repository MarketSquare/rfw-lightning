*** Settings ***
Suite Setup       Suite initialization
Suite Teardown    Remove Directory    $RERUN_SUITE_DIR    recursive
Resource          atest_resource.robot

*** Variables ***
$ORIG_DIR           $DATADIR/cli/runfailed
$RERUN_SUITE_DIR    %{TEMPDIR}/rerunsuites-dir
$SUITE_DIR          $RERUN_SUITE_DIR/suite
$RUN_FAILED_FROM    $RERUN_SUITE_DIR/rerun-suites-output.xml

*** Test Cases ***
Passing suite is not re-executed
    Test Should Not Have Been Executed    Passing

Failing suite is re-executed
    Test Should Have Been Executed   Failing
    Test Should Have Been Executed   Not Failing

Suite teardown failures are noticed
    Test Should Have Been Executed   Test passed but suite teardown fails

Excluded failing is not executed
    Test Should Not Have Been Executed    Failing with tag

Non-existing failing from output file is not executed
    Test Should Not Have Been Executed    Only in one suite

*** Keywords ***
Suite initialization
    Copy Directory    $ORIG_DIR/suite    $SUITE_DIR
    Copy File    $ORIG_DIR/runfailed1.robot     $SUITE_DIR/runfailed.robot
    Run Tests    $SUITE_DIR
    Copy File    $OUTFILE    $RUN_FAILED_FROM
    Copy File    $ORIG_DIR/runfailed2.robot     $SUITE_DIR/runfailed.robot
    Run Tests    --rerunfailedsuites $RUN_FAILED_FROM --exclude excluded_tag $SUITE_DIR

Test Should Have Been Executed
    [Arguments]    $name
    Check Test Case    $name

Test Should Not Have Been Executed
    [Arguments]    $name
    Run Keyword And Expect Error    No test '$name' found*    Check Test Case    $name
