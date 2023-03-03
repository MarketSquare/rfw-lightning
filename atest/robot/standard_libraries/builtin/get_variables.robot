*** Settings ***
Suite Setup       Run Tests    --variable cmd_line:cmd_value    standard_libraries/builtin/get_variables.robot
Resource          atest_resource.robot

*** Test Cases ***
Automatic and Command Line Variables
    Check test Case    ${TEST_NAME}

Variable Table Scalar
    Check test Case    ${TEST_NAME}

Variable Table List
    Check test Case    ${TEST_NAME}

Variable Table Dict
    Check test Case    ${TEST_NAME}

Global Variables
    Check test Case    ${TEST_NAME}

Suite Variables
    Check test Case    ${TEST_NAME}
    Check test Case    ${TEST_NAME} 2

Resource File
    Check test Case    ${TEST_NAME}

Variable File
    Check test Case    ${TEST_NAME}

Test Case Variable
    Check test Case    ${TEST_NAME}

Local Variables in Test Case do not Leak
    Check test Case    ${TEST_NAME}

Variables Are Returned as NormalizedDict
    Check test Case    ${TEST_NAME}

Modifying Returned Variables Has No Effect On Real Variables
    Check test Case    ${TEST_NAME}

Getting variables without decoration
    Check test Case    ${TEST_NAME}

Getting variables without decoration has no effect on real variables
    Check test Case    ${TEST_NAME}
