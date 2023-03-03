*** Settings ***
Suite Setup     Run Tests  --rpa --skip skip-this --SkipOnFailure skip-on-failure --variable test_or_task:Task   running/skip/
Resource        atest_resource.robot

*** Test Cases ***
Skipped with --skip
    Check Test Case    ${TEST_NAME}

Skipped with --SkipOnFailure
    Check Test Case    ${TEST_NAME}

