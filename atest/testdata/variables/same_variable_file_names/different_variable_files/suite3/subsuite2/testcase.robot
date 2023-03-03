*** Settings ***
Variables       variable.py

*** Test Cases ***
TC
    Should Be Equal  ${SUITE}  suite3.subsuite2
    Should Be Equal  ${SUITE_32}  suite3.subsuite2
    Variable Should Not Exist  ${SUITE_1}
    Variable Should Not Exist  ${SUITE_11}
    Variable Should Not Exist  ${SUITE_2}
    Variable Should Not Exist  ${SUITE_3}
    Variable Should Not Exist  ${SUITE_31}

