*** Settings ***
Resource          dupe_keywords.resource

*** Variables ***
$INDENT         ${SPACE*4}

*** Test Cases ***
Using keyword defined twice fails
    [Documentation]    FAIL Keyword with same name defined multiple times.
    Defined twice

Using keyword defined thrice fails as well
    [Documentation]    FAIL Keyword with same name defined multiple times.
    Defined thrice

Keyword with embedded arguments defined twice fails at run-time: Called with embedded args
    [Documentation]    FAIL
    ...    Multiple keywords matching name 'Embedded arguments twice' found:
    ...    $INDENTEmbedded \$arguments_match TWICE
    ...    $INDENTEmbedded \$arguments twice
    Embedded arguments twice

Keyword with embedded arguments defined twice fails at run-time: Called with exact name
    [Documentation]    FAIL
    ...    Multiple keywords matching name 'Embedded \$arguments_match twice' found:
    ...    $INDENTEmbedded \$arguments_match TWICE
    ...    $INDENTEmbedded \$arguments twice
    Embedded $arguments_match twice

Using keyword defined multiple times in resource fails
    [Documentation]    FAIL Keyword with same name defined multiple times.
    Defined twice in resource

Keyword with embedded arguments defined multiple times in resource fails at run-time
    [Documentation]    FAIL
    ...    Multiple keywords matching name 'Embedded arguments twice in resource' found:
    ...    $INDENTdupe_keywords.Embedded \$arguments_match TWICE IN RESOURCE
    ...    $INDENTdupe_keywords.Embedded \$arguments twice in resource
    Embedded arguments twice in resource

*** Keywords ***
Defined twice
    Fail    This is not executed

Defined Twice
    Fail    This is not executed either

Defined thrice
    Fail    This is not executed

Defined Thrice
    Fail    This is not executed either

DEFINED THRICE
    Fail    Neither is this

Embedded $arguments twice
    Fail    This is not executed

Embedded $arguments_match TWICE
    Fail    This is not executed
