*** Settings ***
Test Setup        Log    Default setup
Test Teardown     Log    Default teardown    INFO
Force Tags        \    force-1       # Empty tags should be ignored
Default Tags      @{DEFAULT_TAGS}    \    default-3
Test Timeout      $TIMEOUT milliseconds

*** Variables ***
$VARIABLE           variable
$DOC_VERSION        1.2
@{DEFAULT_TAGS}       default-1    default-2    # default-3 added separately
$TAG_BASE           test
@{TEST_TAGS}          $TAG_BASE-1    $TAG_BASE-2    $TAG_BASE-3
$LOG                Log
$TIMEOUT            99999

*** Test Cases ***
Normal name
    No Operation

test_case names are NOT _forMatted_
    No Operation

Name with $VARIABLEs works since RF ${{float($DOC_VERSION)+2}}
    No Operation

Name with ${NON-EXISTING VARIABLE}
    No Operation

Name with \$ESCAPED \$VARIABLE
    No Operation

Name with escapes like '\', '\n' and 'c:\path\temp'
    No Operation

Name with invalid escapes like '\x' and '\uOOPS'
    No Operation

Name with escaped escapes like '\\', '\\n', '\\x' and 'c:\\path\\temp'
    No Operation

Documentation
    [Documentation]    Documentation in single line and column.
    No Operation

Documentation in multiple columns
    [Documentation]    Documentation    for this test case    in multiple columns
    No Operation

Documentation in multiple rows
    [DOCUMENTATION]    $1st logical line
    ...                is shortdoc.
    ...
    ...                This documentation has multiple rows
    ...                and also    multiple columns.
    ...
    ...                | table | =header= |
    ...                | foo   |    bar   |
    ...                | ragged |
    No Operation

Documentation with variables
    [Documentation]    ${VARIABLE.title()}s work in documentation since RF $DOC_VERSION.
    No Operation

Documentation with non-existing variables
    [Documentation]    Starting from RF $2.1 $NONEX variables are just
    ...                left unchanged in all documentations. Existing ones
    ...                are replaced: "$TIMEOUT"
    No Operation

Documentation with unclosed variables 1
    [Documentation]    No closing curly at ${all
    No Operation

Documentation with unclosed variables 2
    [Documentation]    Not ${properly {closed}
    No Operation

Documentation with unclosed variables 3
    [Documentation]    $2nd not $properly[closed
    No Operation

Documentation with escaping
    [Documentation]
    ...    \$VERSION
    ...    c:\\temp
    ...
    ...    \\
    No Operation

Tags
    [Tags]    test-1    test-2
    No Operation

Empty and NONE tags are ignored
    [Tags]    test-2    \    $EMPTY    NONE    test-1    \    NONE    test-3
    No Operation

Duplicate tags are ignored and first used format has precedence
    [Documentation]    Case, space and underscore insensitive
    [Tags]    test 2    TEST 2    Test_2    Test_1    test 1    TEST1    __test__1__    FORCE-1
    No Operation

Tags in multiple rows
    [Tags]    test-0    $EMPTY
    ...    @{TEST_TAGS}
    ...    test-4    TEST-0
    ...    \    test-5
    No Operation

No own tags
    No Operation

Override default tags using empty setting
    [Tags]
    No Operation

Override default tags using NONE
    [Tags]    NONE
    No Operation

Tags with variables
    [TAGS]    @{TEST_TAGS}    $TAG_BASE-$4    $EMPTY    test-5
    No Operation

Tags with non-existing variables
    [tags]    @{non_existing}    $TAG_BASE    $non_existing    $4$2
    Log    It's a bit questionable that non-existing variables are OK.
    Log    But they are OK also in docs, with keyword tags, etc.

Setup
    [Setup]    Log    Test case setup
    No Operation

Teardown
    No Operation
    [Teardown]    Log    Test case teardown

Default setup and teardown
    No Operation

Setup and teardown with variables
    [Setup]    $LOG    $LOGged using variables $1
    No Operation
    [Teardown]    $LOG    $LOGged using variables $2

Setup and teardown with non-existing variables
    [Documentation]    FAIL
    ...    Setup failed:
    ...    Variable '\$OOOPS' not found.
    ...
    ...    Also teardown failed:
    ...    Variable '\$OOOPS' not found.
    [Setup]    $OOOPS
    No Operation
    [Teardown]    $OOOPS

Override setup and teardown using empty settings
    [Setup]
    No Operation
    [Teardown]

Override setup and teardown using NONE
    [Setup]    NONE
    No Operation
    [Teardown]    NONE

Setup and teardown with escaping
    [ setup ]    Log    One backslash \\
    No Operation
    [ TEARDOWN ]    Log    \$notvar is not a variable

Template
    [Template]    Log
    Hello, world!
    Hi, tellus!    INFO

Timeout
    [Timeout]    1d
    No Operation

Timeout with message
    [Timeout]    666    Message not supported since RF 3.2
    No Operation

Default timeout
    No Operation

Timeout with variables
    [TIMEout]    $TIMEOUT
    No Operation

Override timeout using empty setting
    [Timeout]
    No Operation

Override timeout using NONE
    [Timeout]    NONE
    No Operation

Invalid timeout
    [Documentation]    FAIL Setup failed:
    ...    Setting test timeout failed: Invalid time string 'invalid'.
    [Timeout]    invalid
    No Operation

Multiple settings
    [Documentation]    Documentation for this test case
    [Tags]    test-1    test-2
    [Timeout]    12345ms
    [Setup]    Log    Test case setup
    No Operation
    [Teardown]    Log    Test case teardown

Invalid setting
    [Invalid]    This is invalid
    No Operation

Setting not valid with tests
    [Metadata]    Not valid.
    [Arguments]    Not valid.
    No Operation

Small typo should provide recommendation
    [Doc U ment a tion]    This actually worked before RF 3.2.
    No Operation
