*** Settings ***
Variables       variable.py

*** Test Cases ***
TC
    Should Be Equal  $SUITE  suite2
    Should Be Equal  $SUITE_2  suite2
    Variable Should Not Exist  $SUITE_1
    Variable Should Not Exist  $SUITE_11
    Variable Should Not Exist  $SUITE_3
    Variable Should Not Exist  $SUITE_31
    Variable Should Not Exist  $SUITE_32

