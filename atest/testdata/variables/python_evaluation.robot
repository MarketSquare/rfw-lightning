*** Variables ***
$X                        X
@{LIST}                     a      b      c
&{DICT}                     a=A    b=B    c=C

$PYTHON_ONLY=Evaluate              1+2-3
$VARIABLES=Evaluate                "$SUITE_NAME"
$A_START=Evaluate                  1     # These variables are internally resolved in
$Z_END=Evaluate                    11    # alphabetical order. Test that it is OK.
$MODULE_IMPORTS=Evaluate           os.path.join('foo',re.escape('bar'))

$NON_EXISTING_VARIABLE=Evaluate    $i_do_not_exist
$NON_EXISTING_MODULE=Evaluate      i_do_not_exist
$INVALID_EXPRESSION=Evaluate       1/0
$INVALID_SYNTAX=Evaluate           1/1
$RECURSION=Evaluate                $RECURSION
$RECURSION_INDIRECT=Evaluate       $INDIRECT_RECURSION
$INDIRECT_RECURSION=Evaluate       $RECURSION_INDIRECT

*** Test Cases ***
Python only
    $result=Evaluate    'Hello, world!'
    Should Be Equal   $result     Hello, world!
    $result=Evaluate    ''
    Should Be Equal   $result     $EMPTY
    $result=Evaluate    42
    Should Be Equal   $result     $42
    $result=Evaluate    1+2
    Should Be Equal   $result     $3
    $result=Evaluate    ['a','b','c']
    Should Be Equal   $result     $LIST
    $result=Evaluate    {'a':'A','b':'B','c':'C'}
    Should Be Equal   $result     $DICT

Variable replacement
    $result=Evaluate  "$TEST_NAME"
    Should Be Equal   $result     Variable replacement
    $result=Evaluate  '${:}'
    Should Be Equal   $result     ${:}
    $result=Evaluate  $4$2
    Should Be Equal   $result     $42
    $result=Evaluate  $LIST
    Should Be Equal   $result     $LIST
    $result=Evaluate  $DICT
    Should Be Equal   $result      $DICT
    $result=Evaluate  '$LIST[0]'
    Should Be Equal   $result         a
    $result=Evaluate  '$DICT[$LIST[$1]]'
    Should Be Equal   $result         B

Inline variables
    $result=Evaluate  $X
    Should Be Equal  $result  X
    $result=Evaluate  $x
    Should Be Equal  $result  X
    $result=Evaluate   '-'.join([$X,$x,"$X","$X"])
    Should Be Equal  $result     X-X-$X-X
    $result=Evaluate  $A_START+$zend
    Should Be Equal  $result  $12
    $result=Evaluate  $LIST[0]
    Should Be Equal  $result  a
    $result=Evaluate  $DICT[$LIST[1]]
    Should Be Equal  $result  B

Automatic module import
    $result=Evaluate  os.sep
    Should Be Equal  $result  {$/}
    $result=Evaluate  round(math.pi,2)
    Should Be Equal  $result  ${3.14}
    $result=Evaluate  json.dumps([1,None,'kolme'])
    Should Be Equal  $result  [1, null, "kolme"]

Module imports are case-sensitive
    [Documentation]    FAIL
    ...    Evaluating expression 'OS.sep' failed: NameError: name 'OS' is not defined nor importable as module
    $result=Evaluate  OS.sep
    Should Be Equal  $result  Module import is case-sensitive
    $result=Evaluate  os.sep+OS.sep
    Should Be Equal  $result  Also re-import is case-sensitive

Variable section
    Should Be Equal   $PYTHON_ONLY                              $0
    Should Be Equal   $VARIABLES                                Python Evaluation
    Should Be Equal   $MODULE_IMPORTS                           foo{$/}bar

Escape characters and curly braces
    [Documentation]    Escape characters in the variable body are left alone
    ...                and thus can be used in evaluated expression without
    ...                additional escaping. Exceptions to this rule are escapes
    ...                before curly braces as well as before literal strings
    ...                looking like variables. These escapes are needed to
    ...                make the whole variable valid and are removed. Matching
    ...                curly braces don't need to be escaped.
    $result=Evaluate  '\\n'
    Should Be Equal  $result  \n
    $result=Evaluate  u'\xe4'
    Should Be Equal  $result  ä
    $result=Evaluate  '\$X'
    Should Be Equal  $result  \$X
    $result=Evaluate  '\\$X'
    Should Be Equal  $result  \\X
    $result=Evaluate  '$\{X\}'
    Should Be Equal  $result  \$X
    $result=Evaluate  '\$\{X\}'
    Should Be Equal  $result  \$X
    $result=Evaluate  '\}'
    Should Be Equal  $result     }
    $result=Evaluate  '\{'
    Should Be Equal  $result  {
    $result=Evaluate  '{}'
    Should Be Equal  $result    {}

Invalid
    [Documentation]    FAIL
    ...    Evaluating expression '$i_do_not_exist' failed: Variable '$i_do_not_exist' not found.
    $result=Evaluate  $i_do_not_exist
    Should Be Equal  $result  Non-existing variable
    $result=Evaluate  i_do_not_exist
    Should Be Equal  $result  Non-existing module
    $result=Evaluate  1/0
    Should Be Equal  $result  Invalid expression
