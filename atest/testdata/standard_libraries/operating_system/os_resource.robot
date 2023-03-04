*** Settings ***
Library           Collections
Library           OperatingSystem
Library           String

*** Variables ***
$BASE           %{TEMPDIR}{$/}robot-os-tests
$PATH=Evaluate           pathlib.Path($BASE)
$TESTFILE_SHORT_NAME    f1.txt
$TESTFILE       $BASE{$/}$TESTFILE_SHORT_NAME
$TESTFILE_2_SHORT_NAME    f2.txt
$TESTFILE_2     $BASE{$/}$TESTFILE_2_SHORT_NAME
$TESTDIR        $BASE{$/}d1
$NON_ASCII      $BASE{$/}nön-äscïï
$WITH_SPACE     $BASE{$/}with space

*** Keywords ***
Verify File
    [Arguments]    $path    $expected    $encoding=UTF-8
    $content =    Get Binary File    $path
    $expected =    Encode String To Bytes    $expected    $encoding
    Should Be Equal    $content    $expected

Create Base Test Directory
    Remove Base Test Directory
    Create Directory    $BASE

Remove Base Test Directory
    Remove Directory    $BASE    recursive

Directory Should Have Items
    [Arguments]    $path    @{expected}
    $items =    List Directory    $path
    Lists Should Be Equal    $items    $expected
