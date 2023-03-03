*** Settings ***
Suite Setup       Set lxml availability to suite metadata
Library           XML    use_lxml=yes
Resource          xml_resource.robot

*** Test Cases ***
Get element from parent element
    ${root}=   Parse XML     ${TEST}
    ${element}=    Get Element    ${root}    another
    Should Be Equal    ${element.tag}    another
    ${element}=    Get Element    ${element}    child
    Should Be Equal    ${element.tag}    child

Get element from xml file
    ${child}=    Get Element    ${TEST}    another
    Should Be Equal    ${child.tag}    another
    ${child}=    Get Element    ${TEST}    another/child
    Should Be Equal    ${child.text}    nöŋ-äŝĉíï tëxt

Get element from xml file using pathlib.Path
    ${test_path}=Evaluate  pathlib.Path($TEST)
    ${child}=    Get Element    ${test_path}    another
    Should Be Equal    ${child.tag}    another
    ${child}=    Get Element    ${TEST}    another/child
    Should Be Equal    ${child.text}    nöŋ-äŝĉíï tëxt

Get element from xml string
    ${child}=    Get Element    <root><tag>text</tag></root>    tag
    Should Be Equal    ${child.text}    text

Get element from xml bytes
    ${child}=    Run With Bytes
    ...    Get Element    <root><tag>text</tag></root>    tag
    Should Be Equal    ${child.text}    text

Get element with named xpath
    ${child}=    Get Element    <root><tag>text</tag></root>    xpath=tag
    Should Be Equal    ${child.text}    text

Get element without xpath
    ${root}=    Get Element    <root><tag>text</tag></root>
    Should Be Equal    ${root.tag}    root

Get element fails when multiple elements match
    [Documentation]    FAIL Multiple elements (3) matching 'child' found.
    Get Element    ${TEST}    child

Get element fails when no elements match
    [Documentation]    FAIL No element matching 'non-existing' found.
    Get Element    ${TEST}    non-existing

Get elements
    ${elements}=    Get Elements    ${TEST}    child
    Length Should Be    ${elements}    3
    Should Be Equal    ${elements[0].text}    child 1 text

Get elements using pathlib.Path
    ${test_path}=Evaluate    pathlib.Path($TEST)
    ${elements}=    Get Elements    ${test_path}    child
    Length Should Be    ${elements}    3
    Should Be Equal    ${elements[0].text}    child 1 text

Get elements from xml string
    ${elements}=    Get Elements    <root><c/><c>xxx</c></root>    c
    Length Should Be    ${elements}    2
    Should Be Equal    ${elements[1].text}    xxx

Get elements from xml bytes
    ${elements}=    Run With Bytes
    ...    Get Elements    <root><c/><c>xxx</c></root>    c
    Length Should Be    ${elements}    2
    ${result}=   Evaluate    $elements[1].text
    Should Be Equal    ${result}    xxx

Get elements returns empty list when no elements match
    ${elements}=    Get Elements    ${TEST}    non-existing
    Should Be Empty    ${elements}

Get child elements
    ${children}=    Get Child Elements    ${TEST}
    Length Should Be    ${children}    4
    ${result}=   Evaluate    $children[0].text
    Should Be Equal    ${result}    child 1 text
    ${result}=   Evaluate    $children[1].attrib['id']
    Should Be Equal    ${result}    2
    ${result}=   Evaluate    $children[2].attrib['id']
    Should Be Equal    ${result}    3
    ${result}=   Evaluate  $children[3].tag
    Should Be Equal    ${result}    another
    ${children}=    Get Child Elements    ${TEST}    another/child
    Should Be Empty    ${children}

Get child elements fails when multiple parent elements match
    [Documentation]    FAIL Multiple elements (3) matching 'child' found.
    Get Child Elements    ${TEST}    child

Get child elements fails when no parent element matches
    [Documentation]    FAIL No element matching 'non-existing' found.
    Get Child Elements    ${TEST}    non-existing

Non-ASCII
    ${elem}=    Get Element    <root><täg/></root>    täg
    Should Be Equal    ${elem.tag}    täg
    ${elems}=    Get Elements    <root><täg/><other/></root>    täg
    Length Should Be    ${elems}    1
    Should Be Equal    ${elems[0].tag}    täg
