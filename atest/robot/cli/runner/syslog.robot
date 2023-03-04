*** Settings ***
Test Setup              Run Keywords
...                     Create Output Directory    AND
...                     Reset syslog
Suite Teardown          Reset syslog
Resource                cli_resource.robot

*** Variables ***
$SYSLOG               %{TEMPDIR}{$/}syslog.txt
$SYSLOG_IN_EXECDIR    ${INTERPRETER.output_name}-syslog.txt
$SYSLOG_IN_NEW_DIR    %{TEMPDIR}/new-dir-and/also-unix-separator-always/with/sys.log

*** Test Cases ***
No syslog environment variable file
    Run Some Tests
    File Should Not Exist    $SYSLOG

Setting syslog sile
    [Documentation]    Also tests that syslog has correct line separators
    Set Environment Variable    ROBOT_SYSLOG_FILE    $SYSLOG
    Run Some Tests
    File Should Not Be Empty    $SYSLOG
    File Should Have Correct Line Separators    $SYSLOG

Syslog as name only
    Set Environment Variable    ROBOT_SYSLOG_FILE    $SYSLOG_IN_EXECDIR
    Run Some Tests
    File Should Not Be Empty    $EXECDIR/$SYSLOG_IN_EXECDIR
    File Should Have Correct Line Separators    $EXECDIR/$SYSLOG_IN_EXECDIR

Syslog directory is automatically created
    Set Environment Variable    ROBOT_SYSLOG_FILE    $SYSLOG_IN_NEW_DIR
    Run Some Tests
    File Should Not Be Empty    $SYSLOG_IN_NEW_DIR
    File Should Have Correct Line Separators    $SYSLOG_IN_NEW_DIR

Syslog file set to NONE
    Set Environment Variable    ROBOT_SYSLOG_FILE    none
    Run Some Tests
    File Should Not Exist    $SYSLOG
    File Should Not Exist    $SYSLOG_IN_EXECDIR
    File Should Not Exist    $SYSLOG_IN_NEW_DIR

Invalid syslog file
    Set Environment Variable    ROBOT_SYSLOG_FILE    $CLI_OUTDIR
    $result =    Run Some Tests
    Should Start With    ${result.stderr}    [ ERROR ] Opening syslog file '$CLI_OUTDIR' failed:

Setting syslog Level
    Set Environment Variable    ROBOT_SYSLOG_FILE    $SYSLOG
    Set Environment Variable    ROBOT_SYSLOG_LEVEL    INFO
    Run Some Tests
    $size1 =    Get File Size    $SYSLOG
    Set Environment Variable    ROBOT_SYSLOG_LEVEL    DEBUG
    Run Some Tests
    $size2 =    Get File Size    $SYSLOG
    Should Be True    0 < $size1 < $size2
    Set Environment Variable    ROBOT_SYSLOG_LEVEL    warn
    Run Some Tests
    File Should Be Empty    $SYSLOG

Invalid syslog level
    Set Environment Variable    ROBOT_SYSLOG_FILE    $SYSLOG
    Set Environment Variable    ROBOT_SYSLOG_LEVEL    invalid
    $result =    Run Some Tests
    Should Start With    ${result.stderr}    [ ERROR ] Opening syslog file '$SYSLOG' failed: Invalid log level 'invalid'

*** Keywords ***
Reset syslog
    Set Suite Variable    $SET_SYSLOG    False
    Remove Environment Variable    ROBOT_SYSLOG_FILE
    Remove Environment Variable    ROBOT_SYSLOG_LEVEL
    Remove Files    $SYSLOG    $EXECDIR/$SYSLOG_IN_EXECDIR
    $syslog_dir    $_ =    Split Path    $SYSLOG_IN_NEW_DIR
    Remove Directory    $syslog_dir    recursive=True
