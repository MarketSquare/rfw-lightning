*** Settings ***
Variables       variable.py

*** Test Cases ***
TC
    Should Be Equal  ${SUITE}  suite3.subsuite1
    Should Be Equal  ${SUITE_31}  suite3.subsuite1
    Variable Should Not Exist  ${SUITE_1}
    Variable Should Not Exist  ${SUITE_11}
    Variable Should Not Exist  ${SUITE_2}
    Variable Should Not Exist  ${SUITE_3}
    Variable Should Not Exist  ${SUITE_32}

