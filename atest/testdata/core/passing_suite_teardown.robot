*** Setting ***
Documentation     Passing suite teardown using base keyword.
Suite Teardown    Create File    ${TEARDOWN_FILE}
Library           OperatingSystem

*** Variables ***
${TEARDOWN_FILE}    %{TEMPDIR}/robot-suite-teardown-executed.txt

*** Test Case ***
Test
    No Operation
