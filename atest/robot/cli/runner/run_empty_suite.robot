*** Settings ***
Resource        cli_resource.robot

*** Variables ***
$NO_TESTS_DIR     %{TEMPDIR}/robot_test_run_empty_suite
$NO_TESTS_FILE    $NO_TESTS_DIR.robot

*** Test Cases ***
No tests in file
     [Setup]    Create file    $NO_TESTS_FILE    *** Test Cases ***
     Run empty suite    --runemptysuite    $NO_TESTS_FILE
     [Teardown]    Remove file    $NO_TESTS_FILE

No tests in directory
     [Setup]    Create directory    $NO_TESTS_DIR
     Run empty suite    --runemptysuite    $NO_TESTS_DIR
     [Teardown]    Remove directory    $NO_TESTS_DIR

Empty suite after filtering by tags
     Run empty suite   --Run-Empty-Suite --include nonex   $TEST_FILE

Empty suite after filtering by names
     Run empty suite   --RunEmptySuite --test nonex   $TEST_FILE

Empty multi source suite after filtering
     Run empty suite   --RunEmptySuite --test nonex   $TEST_FILE $TEST_FILE

*** Keywords ***
Run empty suite
     [Arguments]    $options    $sources
     Run tests     $options -l log.html -r report.html    $sources
     Should be empty    ${SUITE.tests}
     Should be empty    ${SUITE.suites}
     Stderr should be empty
