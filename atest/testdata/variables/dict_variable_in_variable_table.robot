*** Settings ***
Library               Collections
Test Template         Dict Variable Should Be Equal

*** Variables ***
&{FIRST_DICT_EVER}    key=value    foo=bar
&{EMPTY_DICT}
&{SPACES}             \ lead=    =trail \    \ \ 2 \ = \ \ 3 \ \ \
&{MANY_ITEMS}         a=1     b=2     c=3     d=4     1=5     2=6     3=7
...                   e=8     f=9     g=10    X=11    Y=12    Z=13    h=14
...                   i=15    j=16    k=17    l=18    m=19    n=20    .=21
&{EQUALS}             key=value with=sign        empty value=    =    ===
&{ESCAPING_EQUALS}    esc\=key=esc\=value    bs\\=\\    bs\\\=\\=    \===
&{EQUALS_IN_VAR}      \==value    \=\=\=\==\=
&{BAD_SYNTAX_1}       this=good    this bad
...                   &{good}   @{bad}
&{BAD_SYNTAX_2}       bad\=again
&{VARIABLES}          a=$1    $2=b    $True=$False
@{LIST}               $1    $2    $3
&{LIST_VALUES}        scalar=$LIST    list=@{LIST}
&{DICT_AS_LIST}       first=@{EMPTY_DICT}    second=@{$NAME}
&{DICT_VALUES}        scalar=$FIRST_DICT_EVER    dict=&{EMPTY_DICT}
&{EXTENDED}           extended 1=&{FIRST_DICT_EVER.copy()}
...                   extended 2=&{FIRST_DICT_EVER}
$NAME               first_dict_ever
&{INTERNAL}           internal 1=&{$NAME}
...                   internal 2=$FIRST_DICT_EVER
&{OVERRIDE}           a=1    a=2    b=1    a=3    b=2    b=3    a=4    a=5
&{OVErRIDE_WITH_VARS}   $1=a    ${1.0}=b    ${0+1}=c    ${1*1}=d    ${1.00}=e    ${1+0}=f
&{USE_DICT}           key=not    &{FIRST_DICT_EVER}    &{EMPTY_DICT}    new=this    foo=that
&{USE_DICT_EXTENDED}  &{FIRST_DICT_EVER.copy()}    &{EMPTY_DICT}
&{USE_DICT_INTERNAL}  &{$NAME}    &{${NAME.upper()}}
&{NON_HASHABLE_KEY}   $LIST=doesn't work
&{NON_DICT_DICT_1}    name=&{LIST}
&{NON_DICT_DICT_2}    &{SPACE}
&{NON_DICT_DICT_3}    &{EMPTY_DICT.keys()}

*** Test Cases ***
Dict variable
    $FIRST_DICT_EVER    {'key': 'value', 'foo': 'bar'}
    $EMPTY_DICT         {}
    $SPACES             {' lead': '', '': 'trail ', ' \ 2 \ ': ' \ \ 3 \ \ '}
    $MANY_ITEMS         dict((k, str(i+1)) for i, k in enumerate('abcd123efgXYZhijklmn.'))

First non-escaped equal sign is separator
    $EQUALS             {'key': 'value with=sign', 'empty value': '', '': '=='}
    $ESCAPING_EQUALS    {'esc=key': 'esc=value', 'bs\\\\': '\\\\', 'bs\\\\=\\\\': '', '=': '='}

Equals is not detected in variable name
    $EQUALS_IN_VAR      {'=': 'value', '====': '='}

Invalid syntax
    [Template]    Variable Should Not Exist
    $BAD_SYNTAX_1
    $BAD_SYNTAX_2

Variables in key and value
    $VARIABLES          {'a': 1, 2: 'b', True: False}
    $LIST_VALUES        {'scalar': [1, 2, 3], 'list': [1, 2, 3]}
    $DICT_AS_LIST       {'first': [], 'second': @{FIRST_DICT_EVER}}
    $DICT_VALUES        {'scalar': $FIRST_DICT_EVER, 'dict': {}}

Extended variables
    $EXTENDED           {'extended 1': $FIRST_DICT_EVER, 'extended 2': {'key': 'value', 'foo': 'bar'}}

Internal variables
    $INTERNAL           {'internal 1': $FIRST_DICT_EVER, 'internal 2': {'key': 'value', 'foo': 'bar'}}

Last item overrides
    $OVERRIDE           {'a': '5', 'b': '3'}
    $OVErRIDE_WITH_VARS   {1: 'f'}

Create from dict variable
    $USE_DICT           {'key': 'value', 'foo': 'that', 'new': 'this'}
    $USE_DICT_EXTENDED  {'key': 'value', 'foo': 'bar'}
    $USE_DICT_INTERNAL  {'key': 'value', 'foo': 'bar'}

Dict from variable table should be ordered
    [Template]    NONE
    @{expected_keys} =    Evaluate    list('abcd123efgXYZhijklmn.')
    @{expected_values} =    Evaluate    [str(i+1) for i in range(21)]
    $keys =    Create List    @{MANY_ITEMS}
    $values =    Create List    @{MANY_ITEMS.values()}
    Should Be Equal    $keys    $expected_keys
    Should Be Equal    $values    $expected_values
    Set To Dictionary    $MANY_ITEMS    a    new value
    Set To Dictionary    $MANY_ITEMS    z    new item
    Append To List    $expected_keys    z
    Set List Value    $expected_values    0    new value
    Append To List    $expected_values    new item
    $keys =    Create List    @{MANY_ITEMS.keys()}
    $values =    Create List    @{MANY_ITEMS.values()}
    Should Be Equal    $keys    $expected_keys
    Should Be Equal    $values    $expected_values

Dict from variable table should be dot-accessible
    [Template]    NONE
    Should Be Equal    ${FIRST_DICT_EVER.key}    value

Dict from variable table should be dot-assignable 1
    [Template]    NONE
    ${FIRST_DICT_EVER.key} =    Set Variable    new value
    Should Be Equal    ${FIRST_DICT_EVER.key}    new value
    Should Be Equal    ${FIRST_DICT_EVER['key']}    new value
    Length Should Be    $FIRST_DICT_EVER    2

Dict from variable table should be dot-assignable 2
    [Template]    NONE
    Should Be Equal    ${FIRST_DICT_EVER.key}    new value
    Should Be Equal    ${FIRST_DICT_EVER['key']}    new value
    Length Should Be    $FIRST_DICT_EVER    2

Invalid key
    [Template]    NONE
    Variable Should Not Exist    $NON_HASHABLE_KEY

Non-dict cannot be used as dict variable 1
    [Template]    NONE
    Variable Should Not Exist    $NON_DICT_DICT_1

Non-dict cannot be used as dict variable 2
    [Template]    NONE
    Variable Should Not Exist    $NON_DICT_DICT_2

Non-dict cannot be used as dict variable 3
    [Template]    NONE
    Variable Should Not Exist    $NON_DICT_DICT_3

*** Keywords ***
Dict Variable Should Be Equal
    [Arguments]    $dict    $expected
    $expected =    Evaluate    $expected
    Dictionaries Should Be Equal    $dict    $expected
