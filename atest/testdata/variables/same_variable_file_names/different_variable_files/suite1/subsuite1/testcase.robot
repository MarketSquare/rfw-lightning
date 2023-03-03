*** Settings ***
Variables       variable.py

*** Test Cases ***
TC
    Should Be Equal  ${SUITE}  suite1.subsuite1
    Should Be Equal  ${SUITE_11}  suite1.subsuite1
    Variable Should Not Exist  ${SUITE_1}
    Variable Should Not Exist  ${SUITE_2}
    Variable Should Not Exist  ${SUITE_3}
    Variable Should Not Exist  ${SUITE_31}
    Variable Should Not Exist  ${SUITE_32}

