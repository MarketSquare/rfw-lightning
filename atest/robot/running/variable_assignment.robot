*** Settings ***
Suite Setup        Run Tests    -L DEBUG    running/variable_assignment.robot
Resource           atest_resource.robot

*** Test Cases ***
Variable assignment keyword call
    Check Test Case    ${TEST_NAME}

Variable assignment inside a keyword
    Check Test Case    ${TEST_NAME}

Variable assignment with library keyword from variables section
    Check Test Case    ${TEST_NAME}

Variable assignment with user keyword from variables section
    Check Test Case    ${TEST_NAME}

Variable assignment in a for loop
    Check Test Case    ${TEST_NAME}

Variable assignment in if
    Check Test Case    ${TEST_NAME}

Variable assignment in try
   Check Test Case    ${TEST_NAME}

Variable assignment in while
    Check Test Case    ${TEST_NAME}

Variable assignment from resource file
    Check Test Case    ${TEST_NAME}