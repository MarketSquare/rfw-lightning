*** Settings ***
Suite Setup     Run Tests    ${EMPTY}    parsing/escaping.robot
Resource        atest_resource.robot

*** Test Cases ***
Spaces In Variable Table
    Check Test Case    ${TEST_NAME}

Leading And Trailing Spaces In Variable Table
    Check Test Case    ${TEST_NAME}

Backslash In Variable Table
    Check Test Case    ${TEST_NAME}

Newline, Tab And Carriage Return In Variable Table
    Check Test Case    ${TEST_NAME}

Escaping Variables In Variable Table
    Check Test Case    ${TEST_NAME}

Escaping From List Variable In Variable Table
    Check Test Case    ${TEST_NAME}

Non Strings Are Ok In Variable Table
    Check Test Case    ${TEST_NAME}

Remove Spaces Before And After
    Check Test Case    ${TEST_NAME}

Remove Extra Spaces Between
    Check Test Case    ${TEST_NAME}

Escaping Space
    Check Test Case    ${TEST_NAME}

Backslash
    Check Test Case    ${TEST_NAME}

New Line
    Check Test Case    ${TEST_NAME}

Space After Newline Is parsed
    Check Test Case    ${TEST_NAME}

Carrriage Return
    Check Test Case    ${TEST_NAME}

Tabulator
    Check Test Case    ${TEST_NAME}

Valid \\x Escape
    Check Test Case    ${TEST_NAME}

Invalid \\x Escape
    Check Test Case    ${TEST_NAME}

Valid \\u Escape
    Check Test Case    ${TEST_NAME}

Invalid \\u Escape
    Check Test Case    ${TEST_NAME}

Valid \\U (32bit) Escape
    Check Test Case    ${TEST_NAME}

Invalid \\U (32bit) Escape
    Check Test Case    ${TEST_NAME}

\\U (32bit) Escape Above Valid Range
    Check Test Case    ${TEST_NAME}

Hash
    Check Test Case    ${TEST_NAME}

Any Character Escaped
    Check Test Case    ${TEST_NAME}

Escaping Variables
    Check Test Case    ${TEST_NAME}

Escaping Variables With User Keywords
    Check Test Case    ${TEST_NAME}

No Errors Should Have Occurred
    Length should be      ${ERRORS}    0

Pipe
    Check Test Case    ${TEST_NAME}
