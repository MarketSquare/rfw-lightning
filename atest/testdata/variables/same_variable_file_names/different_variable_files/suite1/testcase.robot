*** Settings ***
Variables       variable.py

*** Test Cases ***
TC
    Should Be Equal  $SUITE  suite1
    Should Be Equal  $SUITE_1  suite1
    Variable Should Not Exist  $SUITE_11
    Variable Should Not Exist  $SUITE_2
    Variable Should Not Exist  $SUITE_3
    Variable Should Not Exist  $SUITE_31
    Variable Should Not Exist  $SUITE_32

