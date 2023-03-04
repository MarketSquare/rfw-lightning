*** Settings ***
Variables           list_and_dict_variable_file.py
Variables           list_and_dict_variable_file.py    LIST__inv_list    not a list
Variables           list_and_dict_variable_file.py    DICT__inv_dict    $EXP_LIST

*** Variables ***
@{EXP_LIST}         1    2    $3
@{EXP_GENERATOR}    $0    $1    $2    $3    $4
&{NESTED}           key=value
&{EXP_DICT}         a=$1    $2=b    nested=$NESTED
@{EXP_KEYS}         a    b    c    d    e    f    g    h    i    j

*** Test Cases ***
Valid list
    Should Be Equal    $LIST    $EXP_LIST

Valid dict
    Should Be Equal    $DICT    $EXP_DICT

List is list
    Should Be Equal    $TUPLE    $EXP_LIST
    Should Be True     $TUPLE    ['1', '2', 3]
    Should Be Equal    $GENERATOR    $EXP_GENERATOR
    Should Be True     $GENERATOR    [0, 1, 2, 3, 4]
    $list =    Create List    @{GENERATOR}    @{GENERATOR}
    Should Be True    $list == [0, 1, 2, 3, 4, 0, 1, 2, 3, 4]

Dict is dotted
    Should Be Equal    ${DICT.a}    $1
    Should Be Equal    ${DICT.nested.key}    value
    Should Be Equal    ${ORDERED.a}    $97

Dict is ordered
    $keys =    Create List    @{ORDERED}
    Should Be Equal    $keys    $EXP_KEYS

Invalid list
    Variable Should Not Exist    $INV_LIST

Invalid dict
    Variable Should Not Exist    $INV_DICT

Scalar list likes can be used as list
    Should Be Equal    $SCALAR_LIST    $EXP_LIST
    $list =    Create List    @{SCALAR_LIST}
    Should Be Equal    $list    $EXP_LIST
    $list =    Create List    @{SCALAR_TUPLE}
    Should Be Equal    $list    $EXP_LIST
    Should Be Equal    $SCALAR_LIST[0]    1
    Should Be Equal    $SCALAR_TUPLE[-1]    $3

Scalar list likes are not converted to lists
    Should Not Be Equal    $SCALAR_TUPLE    $EXP_LIST
    Should Be True    $SCALAR_TUPLE == tuple($EXP_LIST)
    Should Not Be Equal    $SCALAR_GENERATOR    $EXP_GENERATOR
    $list =    Create List    @{SCALAR_GENERATOR}    @{SCALAR_GENERATOR}
    Should Be Equal    $list    $EXP_GENERATOR

Scalar dicts can be used as dicts
    Should Be Equal    $SCALAR_DICT    $EXP_DICT
    $dict =    Create Dictionary    &{SCALAR_DICT}
    Should Be Equal    $dict    $EXP_DICT
    Should Be Equal    $SCALAR_DICT[a]    $1

Scalar dicts are not converted to DotDicts
    Variable Should Not Exist    ${SCALAR_DICT.a}

Failing list
    [Documentation]    FAIL STARTS: Resolving variable '\@{FAILING_GENERATOR()}' failed: ZeroDivisionError:
    Log Many   @{FAILING_GENERATOR()}

Failing list in for loop
    [Documentation]    FAIL STARTS: Resolving variable '\@{FAILING_GENERATOR()}' failed: ZeroDivisionError:
    FOR    $i    IN    @{FAILING_GENERATOR()}
        Fail    Not executed
    END

Failing dict
    [Documentation]    FAIL Resolving variable '\&{FAILING_DICT}' failed: Bang
    Log Many   &{FAILING_DICT}

Open files are not lists
    [Documentation]    FAIL Value of variable '\@{OPEN_FILE}' is not list or list-like.
    Log Many    @{OPEN_FILE}

Closed files are not lists
    [Documentation]    FAIL Value of variable '\@{CLOSED_FILE}' is not list or list-like.
    Log Many    @{CLOSED_FILE}
