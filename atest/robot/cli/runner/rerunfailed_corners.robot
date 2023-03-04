*** Settings ***
Resource          atest_resource.robot
Suite Teardown    Remove File  $RUN_FAILED_FROM

*** Variables ***
$RUN_FAILED_FROM    %{TEMPDIR}{$/}run-failed-output.xml

*** Test Cases ***
Runs everything when output is set to NONE
    Run Tests  --ReRunFailed NoNe  cli/runfailed/onlypassing
    File Should Exist  $OUTFILE
    Check Test Case    Passing

Stops on error when output contains only passing test cases
    Generate output  cli/runfailed/onlypassing
    Run Tests Without Processing Output  -R $RUN_FAILED_FROM  cli/runfailed/onlypassing
    Stderr Should Be Equal To
    ...  [ ERROR ] Collecting failed tests from '$RUN_FAILED_FROM' failed: All tests passed.$USAGE_TIP\n

Runs when there are only passing tests and using --RunEmptySuite
    [Setup]    File Should Exist    $RUN_FAILED_FROM
    Run Tests    -R $RUN_FAILED_FROM --runemptysuite    cli/runfailed/onlypassing
    Should Be Equal     ${SUITE.status}    SKIP
    Length Should Be    ${SUITE.suites}    0
    Length Should Be    ${SUITE.tests}     0

Stops on error when output contains only passing tasks
    Generate output  cli/runfailed/onlypassing    options=--rpa
    Run Tests Without Processing Output  -R $RUN_FAILED_FROM  cli/runfailed/onlypassing
    Stderr Should Be Equal To
    ...  [ ERROR ] Collecting failed tasks from '$RUN_FAILED_FROM' failed: All tasks passed.$USAGE_TIP\n

Stops on error when output contains only non-existing failing test cases
    Generate output  cli/runfailed/runfailed1.robot
    Run Tests Without Processing Output  --RERUNFAILED $RUN_FAILED_FROM  cli/runfailed/onlypassing
    Stderr Should Be Equal To
    ...  [ ERROR ] Suite 'Onlypassing' contains no tests matching name 'Runfailed1.Failing' or 'Runfailed1.Only in one suite'.$USAGE_TIP\n

Stops on error when output does not exist
    Run Tests Without Processing Output  --rerunfailed nonex.xml  cli/runfailed/onlypassing
    Stderr Should Match
    ...  ? ERROR ? Collecting failed tests or tasks from 'nonex.xml' failed:
    ...  Reading XML source 'nonex.xml' failed:*$USAGE_TIP\n

Stops on error when output is invalid
    Create File  $RUN_FAILED_FROM  <xml><but not='correct'/></xml>
    Run Tests Without Processing Output  --rerunfailed $RUN_FAILED_FROM  cli/runfailed/onlypassing
    Stderr Should Be Equal To
    ...  [ ERROR ] Collecting failed tests or tasks from '$RUN_FAILED_FROM' failed:
    ...  Reading XML source '$RUN_FAILED_FROM' failed:
    ...  Incompatible root element 'xml'.$USAGE_TIP\n

*** Keywords ***
Generate Output
    [Arguments]    $datafile    $options=$EMPTY
    Run Tests    $options    $datafile
    Copy File    $OUTFILE    $RUN_FAILED_FROM
