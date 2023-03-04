*** Settings ***
Variables         variables_to_verify.py

*** Test Cases ***
Should Match
    [Documentation]    FAIL    Failure: 'NOK' does not match 'H*K'
    [Template]    Should Match
    abcdefghijklmnopqrstuvwxyz    *
    abcdefghijklmnopqrstuvwxyz    ?*?efg*p*t?vw*z
    NOK                           ???
    foo\n                         foo\n
    NOK                           H*K    Failure

Should Match with extra trailing newline
    [Template]    Run Keyword And Expect Error
    'foo\n' does not match 'foo'    Should Match    foo\n    foo
    'foo' does not match 'foo\n'    Should Match    foo      foo\n

Should Match case-insensitive
    [Template]    Should Match
    Hello!    heLLo!    ignore_case=True
    Hillo?    h?ll*     ignore_case=yes

Should Match does not work with bytes
    [Documentation]    FAIL    GLOB: Several failures occurred:\n\n
    ...    1) TypeError: *\n\n
    ...    2) TypeError: *
    [Template]    Should Match
    $BYTES_WITHOUT_NON_ASCII    pattern
    text                          $BYTES_WITHOUT_NON_ASCII

Should Not Match
    [Documentation]    FAIL    'Hello world' matches '?ello*'
    [Template]    Should Not Match
    this string does not    match this pattern
    Case matters            case matters
    foo\n                   foo
    foo                     foo\n
    Hello world             ?ello*

Should Not Match case-insensitive
    [Documentation]    FAIL    Fails: 'Hillo?' matches 'h?ll*'
    [Template]    Should Not Match
    Hello!    heLLo    ignore_case=True
    Hillo?    h?ll*    ignore_case=yes    msg=Fails

Should Match Regexp
    [Documentation]    FAIL    Something failed
    [Template]    Should Match Regexp
    Foo: 42        \\w+: \\d{2}
    IGNORE CASE    (?i)case
    IGNORE CASE    case    flags=IGNORECASE
    abc\nDEFG      ab.*fg  flags=IGNORECASE|DOTALL
    $EMPTY       whatever    Something failed    No values

Should Match Regexp returns match and groups
    $ret =    Should Match Regexp    This is a multiline\nstring!!    (?im)^STR\\w+!!
    $match    $group =    Should Match Regexp    $ret    ^(\\w+)!!$
    Should Be Equal    $match    $ret
    Should Be Equal    $group    string
    $match    @{groups} =    Should Match Regexp    Foo: 42 (xxx)    ^(Fo+)([:.;]) (\\d+?)
    Should Be Equal    $match    Foo: 4
    Should Be True    @{groups} == ['Foo', ':', '4']
    $match    @{groups} =    Should Match Regexp    FOO: 42 (xxx)    ^(fo+)([:.;]) (\\d+?)    flags=I
    Should Be Equal    $match    FOO: 4
    Should Be True    @{groups} == ['FOO', ':', '4']
    $match    $group1    $group2 =    Should Match Regexp    Hello, (my) World!!!!!    (?ix)^hel+o,\\s # Comment \n\\((my|your)\\)\\ WORLD(!*)$
    Should Be Equal    $match    Hello, (my) World!!!!!
    Should Be Equal    $group1    my
    Should Be Equal    $group2    !!!!!

Should Match Regexp with bytes containing non-ascii characters
    [Documentation]    FAIL    '$BYTES_WITH_NON_ASCII' does not match 'hyva'
    [Template]    Should Match Regexp
    $BYTES_WITH_NON_ASCII    $BYTES_WITHOUT_NON_ASCII

Should Not Match Regexp
    [Documentation]    FAIL    'James Bond 007' matches '^J\\w{4}\\sB[donkey]+ \\d*$'
    [Template]    Should Not Match Regexp
    this string does not    match this pattern
    James Bond 007          ^J\\w{4}\\sB[donkey]+ \\d*$
    this string does not    match this pattern    flags=DOTALL
