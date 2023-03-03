*** Settings ***
Variables         non_string_variables.py
Test Template     Should Be Equal

*** Test Cases ***
Numbers
    [Documentation]  I can has ${INTEGER} and ${FLOAT}?
    ${INTEGER}        ${42}
    -${INTEGER}-      -42-
    ${FLOAT}          ${3.14}
    -${FLOAT}-        -3.14-

Byte string
    [Documentation]  We has ${BYTE_STRING}!
    ${BYTE_STRING}    ${BYTE_STRING}
    -${BYTE_STRING}-  -${BYTE_STRING_STR}-

Collections
    [Documentation]  ${LIST} ${DICT}
    -${LIST}-         -${LIST_STR}-
    -${DICT}-         -${DICT_STR}-

Misc
    [Documentation]  ${BOOLEAN} ${NONE} ${MODULE}
    -${BOOLEAN}-      -True-
    -${NONE}-         -None-
    -${MODULE}-       -${MODULE_STR}-
