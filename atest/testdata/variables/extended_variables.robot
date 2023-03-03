*** Settings ***
Variables         extended_variables.py

*** Variables ***
${X}              X
${Y}              Y
@{LIST}           ${42}    foo    ${None}

*** Test Cases ***
Using Attribute
    Should Be Equal    ${OBJ.name}    dude
    Should Be Equal    ${o_BJ__.name}    dude

Calling Method
    ${result}=Evaluate   $OBJ.greet()
    Should Be Equal    ${result}    dude says hi!
    ${result}=Evaluate   $OBJ.greet('dudette')
    Should Be Equal    ${result}    dude says hi to dudette!
    ${result}=Evaluate   $OBJ.name.capitalize()
    Should Be Equal    ${result}    Dude
    ${result}=Evaluate   $SPACE.__len__()
    Should Be Equal    ${result}    ${1}

Accessing List
    Should Be Equal    ${LIST}[0] ${LIST}[1]    42 foo
    Should Be Equal    ${LIST}[2]    ${None}
    Should Be Equal    ${LIST}[-1] ${LIST}[-2]    None foo

Accessing Dictionary
    ${dict} =    Evaluate    {'a': 1, 42: 'b'}
    Should Be Equal    ${dict}[a]    ${1}
    Should Be Equal    ${dict}[42]    b

Multiply
    [Documentation]    FAIL STARTS: Resolving variable '\${3.0*2}' failed: SyntaxError:
    Should Be Equal    ${SPACE*3}    ${SPACE}${SPACE}${SPACE}
    Should Be Equal    ${3*42}    ${126}
    Should Be Equal    ${3*2.0}    ${6}
    Log Many    Having float first fails    ${3.0*2}

Failing When Base Name Does Not Exist
    [Documentation]    FAIL Evaluating expression '\$nonexisting.whatever' failed: Variable '\$nonexisting' not found.
    Evaluate    $nonexisting.whatever

Failing When Base Name Starts With Existing Variable 1
    [Documentation]    FAIL Variable '\${nonexisting}' not found.
    Log    ${None}
    Log    ${nonexisting}

Failing When Base Name Starts With Existing Variable 2
    [Documentation]    FAIL STARTS: Variable '\${lista}' not found.
    Log    ${list}
    Log    ${lista}

Testing Extended Var Regexp
    [Documentation]    FAIL STARTS: Resolving variable '\${var..upper()}' failed: SyntaxError:
    Length Should Be    ${/*3}    ${1*3}
    Should Be Equal    ${/.upper()}    ${/*1}
    ${var}    ${var.}    ${var.upper} =    Set Variable    value    Value    VALUE
    Should Be Equal    ${var.}    Value
    Should Be Equal    ${__VAR.UPPER__}    VALUE
    Should Be Equal    ${var.}    ${var.capitalize()}
    Should Be Equal    ${var.upper}    ${_V_A_R_.upper()}
    Log Many    So this works ${var.upper()}    but this does not ${var..upper()}

Failing When Attribute Does Not exists 1
    [Documentation]    FAIL STARTS: Evaluating expression '\$OBJ.nonex' failed: AttributeError:
    Evaluate    $OBJ.nonex

Failing When Attribute Does Not exists 2
    [Documentation]    FAIL STARTS: Evaluating expression '\$OBJ.nonex_method()' failed: AttributeError:
    Evaluate    $OBJ.nonex_method()

Failing When Calling Method With Wrong Number Of Arguments
    [Documentation]    FAIL STARTS: Evaluating expression '$OBJ.greet('too','many')' failed: TypeError:
    Evaluate   $OBJ.greet('too','many')

Failing When Method Raises Exception
    [Documentation]    FAIL STARTS: Evaluating expression '\$OBJ.greet('FAIL')' failed: ValueError
    Evaluate    $OBJ.greet('FAIL')

Fail When Accessing Item Not In List
    [Documentation]    FAIL STARTS: Resolving variable '\${LIST[30]}' failed: IndexError:
    Log    ${LIST[30]}

Fail When Accessing Item Not In Dictionary
    [Documentation]    FAIL Dictionary '${dict}' has no key 'xxx'.
    ${dict} =    Evaluate    {}
    Log    ${dict}[xxx]

Failing For Syntax Error
    [Documentation]    FAIL STARTS: Evaluating expression '\$OBJ.greet('no_end_quote)' failed: SyntaxError:
    Evaluate    $OBJ.greet('no_end_quote)
