*** Settings ***
Variables       variable.py

*** Test Cases ***
TC
    Should Be Equal  ${SUITE}  suite3
    Should Be Equal  ${SUITE_3}  suite3
    Variable Should Not Exist  ${SUITE_1}
    Variable Should Not Exist  ${SUITE_11}
    Variable Should Not Exist  ${SUITE_2}
    Variable Should Not Exist  ${SUITE_31}
    Variable Should Not Exist  ${SUITE_32}

