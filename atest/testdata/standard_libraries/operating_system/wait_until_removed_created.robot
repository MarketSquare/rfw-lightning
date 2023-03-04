*** Settings ***
Suite Teardown    Remove Items
Test Setup        Remove Items
Library           OperatingSystem
Library           ./wait_until_library.py

*** Variables ***
$FILE              %{TEMPDIR}{$/}ROBOTEST-F.txt
$FILE_2            %{TEMPDIR}{$/}ROBOTEST-F-2.txt
$DIR               %{TEMPDIR}{$/}ROBOTEST-D
$FILE_PATTERN      %{TEMPDIR}{$/}ROBOTEST-*.txt
$DIR_PATTERN       %{TEMPDIR}{$/}ROBOTEST-?
$BOTH_PATTERN      %{TEMPDIR}{$/}ROBOTEST-*
$FILE_WITH_GLOB    %{TEMPDIR}{$/}ROBOTEST[glob].txt

*** Test Cases ***
File And Dir Already Removed
    File Should Not Exist    $FILE
    Directory Should Not Exist    $DIR
    Wait Until Removed    $FILE
    Wait Until Removed    $DIR

File And Dir Removed Before Timeout
    Create Items
    Remove After Sleeping    $FILE
    Wait Until Removed    $FILE    5 second
    Remove After Sleeping    $DIR
    Wait Until Removed    $DIR    32 seconds 44 millis

File And Dir Removed With Pattern
    Create Items
    Remove After Sleeping    $FILE    $FILE_2
    Wait Until Removed    $FILE_PATTERN    23
    Remove After Sleeping    $DIR
    Wait Until Removed    $DIR_PATTERN    12 s
    Create Items
    Remove After Sleeping    $FILE    $FILE_2    $DIR
    Wait Until Removed    $BOTH_PATTERN

File Not Removed Before Timeout
    [Documentation]    FAIL '$FILE' was not removed in 111 milliseconds.
    Create Items
    Wait Until Removed    $FILE    0.111

Dir Not Removed Before Timeout
    [Documentation]    FAIL '$DIR' was not removed in 123 milliseconds.
    Create Items
    Wait Until Removed    $DIR    0day 0sec 123 millis

Not Removed Before Timeout With Pattern
    [Documentation]    FAIL '$BOTH_PATTERN' was not removed in 42 milliseconds.
    Create Items
    Wait Until Removed    $BOTH_PATTERN    0.042

Invalid Remove Timeout
    [Documentation]    FAIL ValueError: Invalid time string 'invalid timeout'.
    Wait Until Removed    non-existing    invalid timeout

File And Dir Already Created
    Create Items
    Wait Until Created    $FILE
    Wait Until Created    $DIR

File And Dir Created Before Timeout
    Create File After Sleeping    $FILE
    Wait Until Created    $FILE    1111 ms
    Create Dir After Sleeping    $DIR
    Wait Until Created    $DIR    1.111 seconds

File And Dir Created With Pattern
    Create File After Sleeping    $FILE
    Wait Until Created    $FILE_PATTERN
    Create Dir After Sleeping    $DIR
    Wait Until Created    $DIR_PATTERN

File Not Created Before Timeout
    [Documentation]    FAIL '$FILE' was not created in 1 second 1 millisecond.
    Wait Until Created    $FILE    1.001

Dir Not Created Before Timeout
    [Documentation]    FAIL '$DIR' was not created in 42 milliseconds.
    Wait Until Created    $DIR    0 s 42 ms

Not Created Before Timeout With Pattern
    [Documentation]    FAIL '$BOTH_PATTERN' was not created in 22 milliseconds.
    Wait Until Created    $BOTH_PATTERN    0.022

Invalid Create Timeout
    [Documentation]    FAIL ValueError: Invalid time string 'invalid timeout'.
    Wait Until Created    $CURDIR    invalid timeout

Wait Until File With Glob Like Name
    Create Items
    Wait Until Created    $FILE_WITH_GLOB    1ms

Wait Until Removed File With Glob Like Name
    [Documentation]    FAIL '$FILE_WITH_GLOB' was not removed in 42 milliseconds.
    Create Items
    Wait Until Removed    $FILE_WITH_GLOB    0.042

Path as `pathlib.Path`
    Create Items
    Remove After Sleeping    $FILE
    $filepath=Evaluate   pathlib.Path($FILE)
    Wait Until Removed    $filepath    5 second
    Remove After Sleeping    $DIR
    $filedir=Evaluate    pathlib.Path($DIR)
    Wait Until Removed    $filedir    32 seconds 44 millis

*** Keywords ***
Remove Items
    Remove File    $FILE_WITH_GLOB
    Remove File    $FILE
    Remove File    $FILE_2
    Remove Directory    $DIR

Create Items
    Create File    $FILE_WITH_GLOB
    Create File    $FILE
    Create File    $FILE_2
    Create Directory    $DIR
