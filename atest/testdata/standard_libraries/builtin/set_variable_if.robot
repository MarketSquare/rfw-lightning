*** Settings ***
Library         Operating System

*** Variables ***
@{LIST}  a  b  c
@{EMPTY_LIST}
@{1_ITEM}  1
@{2_ITEMS}  @{1_ITEM}  2
@{3_ITEMS}  @{2_ITEMS}  3
@{3_ITEMS_2}  0  @{2_ITEMS}
@{4_ITEMS}  @{3_ITEMS}  4
@{4_ITEMS_2}  0  @{3_ITEMS}
@{5_ITEMS}  @{4_ITEMS}  5
@{NEEDS_ESCAPING}  c:\\temp\\foo  \${notvar}
@{NEEDS_ESCAPING_2}  len("\\\\") == 1  @{NEEDS_ESCAPING}
@{NEEDS_ESCAPING_3}  @{3_ITEMS_2}  @{NEEDS_ESCAPING}

*** Test Cases ***
True Condition
    ${var} =  Set Variable If  1 > 0  this is set  this is not
    Should Be Equal  ${var}  this is set
    ${var} =  Set Variable If  True  only one value
    Should Be Equal  ${var}  only one value
    ${var} =  Set Variable If  ${True}  ${LIST[1]}  whatever
    Should Be Equal  ${var}  b
    @{var} =  Set Variable If  "this is also a true value"  ${LIST[:-1]}  whatever
    Should Be True  @{var} == ['a','b']

False Condition
    ${var} =  Set Variable If  0 > 1  this value is not used  ${LIST}
    Should Be True  ${var} == ['a','b','c']
    ${var} =  Set Variable If  ${False}  still not used
    Should Be Equal  ${var}  ${None}

Invalid Expression
    [Documentation]  FAIL STARTS: Evaluating expression 'invalid expr' failed: SyntaxError:
    Set Variable If  invalid expr  whatever  values

Fails Without Values 1
    [Documentation]  FAIL At least one value is required
    Set Variable If  True

Fails Without Values 2
    [Documentation]  FAIL At least one value is required
    Set Variable If  False

Non-Existing Variables In Values 1
    [Documentation]  FAIL Variable '\${now_this_breaks}' not found.
    ${existing} =  Set Variable  ${42}
    ${var} =  Set Variable If  True  ${existing}*2 = ${existing*2}  ${nonex}
    Should Be Equal  ${var}  42*2 = 84
    ${var} =  Set Variable If  ${existing} < 0  ${I_don_t_exist_at_all}
    Should Be Equal  ${var}  ${None}
    ${var} =  Set Variable If  ${existing}  ${now_this_breaks}  Not used

Non-Existing Variables In Values 2
    [Documentation]  FAIL Resolving variable '${nonexisting.extended}' failed: Variable '${nonexisting}' not found.
    ${var} =  Set Variable If  False is True  ${not_used}  ${nonexisting.extended}

Non-Existing Variables In Values 3
    [Documentation]  FAIL Variable '\${ooooops}' not found.
    Set Variable If  False  ${not_used}  True  ${ooooops}

Non-Existing Variables In Values 4
    [Documentation]  FAIL STARTS: Resolving variable '\${SPACE.nonex}' failed: AttributeError:
    Set Variable If  False  ${not_used}  False  ${not_used}  ${SPACE.nonex}

Non-Existing Variables In Values 5
    [Documentation]  FAIL Variable '\${nonexisting}' not found.
    Set Variable If  False  ${not_used}  False  ${not_used}  True  This is ${nonexisting} is enough

Extra Values Are Ignored If First Expression Is True
    ${var} =  Set Variable If  True  This ${1} is set!!  Other  values  are  ${not}
    ...  used
    Should Be Equal  ${var}  This 1 is set!!

If / Else If
    ${var} =  Set Variable If  False  ${nonex} but not used  True  2nd expression is True so this value is set  ${nonex} but not used
    Should Be Equal  ${var}  2nd expression is True so this value is set
    ${var} =  Set Variable If  ${1} == 0  ${whatever}  ${1} < 0  ${whatever}  ${1} > 2  ${whatever}
    ...  ${1} == 1  Here we go!
    Should Be Equal  ${var}  Here we go!

If / Else If / Else
    ${var} =  Set Variable If
    ...  ${False}  this value is not used
    ...  ${None}   this value is not used
    ...  ${0}      this value is not used
    ...  Final else!
    Should Be Equal  ${var}  Final else!
    ${var} =  Set Variable If
    ...  ${False}  this value is not used
    ...  ${None}   this value is not used
    ...  ${0}      this value is not used
    Should Be Equal  ${var}  ${None}

With Empty List Variables 1
    [Documentation]  FAIL At least one value is required
    Set Variable If  True  @{EMPTY_LIST}

With Empty List Variables 2
    [Documentation]  FAIL At least one value is required
    Set Variable If  False  @{EMPTY_LIST}  @{EMPTY_LIST}  @{EMPTY_LIST}

With Empty List Variables 3
    ${v1} =  Set Variable If  True  42  @{EMPTY_LIST}
    ${v2} =  Set Variable If  True  @{EMPTY_LIST}  42
    ${v3} =  Set Variable If  @{EMPTY_LIST}  True  42
    ${v4} =  Set Variable If  @{EMPTY_LIST}  ${True}  ${42}
    ${v5} =  Set Variable If  @{EMPTY_LIST}  @{EMPTY_LIST}  ${True}  @{EMPTY_LIST}  @{EMPTY_LIST}  ${42}  @{EMPTY_LIST}
    Should Be True  ${v1} == ${v2} == ${v3} == ${v4} == ${v5} == 42

With List Variables In Values
    ${var} =  Set Variable If  True  @{1_ITEM}
    Should Be Equal  ${var}  1
    ${var} =  Set Variable If  ${False}  @{1_ITEM}
    Should Be Equal  ${var}  ${None}
    ${var} =  Set Variable If  True  @{2_ITEMS}  @{EMPTY_LIST}
    Should Be Equal  ${var}  1
    ${var} =  Set Variable If  False  @{EMPTY_LIST}  @{2_ITEMS}
    Should Be Equal  ${var}  2
    ${var} =  Set Variable If  True  @{2_ITEMS} as string
    Should Be Equal  ${var}  @{2_ITEMS} as string

With List Variables In Expressions And Values
    ${var} =  Set Variable If  @{1_ITEM}  this is set
    Should Be Equal  ${var}  this is set
    ${var} =  Set Variable If  @{2_ITEMS}
    Should Be Equal  ${var}  2
    ${var} =  Set Variable If  @{2_ITEMS} == @{1_ITEM}  @{2_ITEMS}  value
    Should Be Equal  ${var}  value
    ${var} =  Set Variable If  @{3_ITEMS}
    Should Be Equal  ${var}  2
    ${var} =  Set Variable If  @{3_ITEMS_2}
    Should Be Equal  ${var}  2
    ${var} =  Set Variable If  @{4_ITEMS_2}
    Should Be Equal  ${var}  3

With List Variables Containing Escaped Values
    ${var} =  Set Variable If  True  @{NEEDS_ESCAPING}
    Should Be Equal  ${var}  c:\\temp\\foo
    ${var} =  Set Variable If  False  @{NEEDS_ESCAPING}
    Should Be Equal  ${var}  \${notvar}
    ${var} =  Set Variable If  @{NEEDS_ESCAPING_2}
    Should Be Equal  ${var}  c:\\temp\\foo
    ${var} =  Set Variable If  @{NEEDS_ESCAPING_3}
    Should Be Equal  ${var}  c:\\temp\\foo

