*** Settings ***
Resource          atest_resource.robot

*** Keywords ***
Check test and get loop
    [Arguments]    ${test_name}    ${loop_index}=0
    ${tc} =    Check Test Case    ${test_name}
    RETURN    ${tc.kws}[${loop_index}]

Check test and failed loop
    [Arguments]    ${test_name}    ${type}=FOR    ${loop_index}=0
    ${loop} =    Check test and get loop    ${test_name}    ${loop_index}
    Length Should Be    ${loop.body}    2
    Should Be Equal     ${loop.body[0].type}    ITERATION
    Should Be Equal     ${loop.body[1].type}    MESSAGE
    Run Keyword    Should Be ${type} loop    ${loop}    1    FAIL

Should be FOR loop
    [Arguments]    ${loop}    ${iterations}    ${status}=PASS    ${flavor}=IN
    Should Be Equal     ${loop.type}      FOR
    Should Be Equal     ${loop.flavor}    ${flavor}
    ${bodylength}=Evaluate    $loop.body.filter(None,False)
    Length Should Be    ${bodylength}    ${iterations}
    Should Be Equal     ${loop.status}    ${status}

Should be IN RANGE loop
    [Arguments]    ${loop}    ${iterations}    ${status}=PASS
    Should Be FOR Loop   ${loop}    ${iterations}    ${status}    flavor=IN RANGE

Should be IN ZIP loop
    [Arguments]    ${loop}    ${iterations}    ${status}=PASS
    Should Be FOR Loop   ${loop}    ${iterations}    ${status}    flavor=IN ZIP

Should be IN ENUMERATE loop
    [Arguments]    ${loop}    ${iterations}    ${status}=PASS
    Should Be FOR Loop   ${loop}    ${iterations}    ${status}    flavor=IN ENUMERATE

Should be FOR iteration
    [Arguments]    ${iteration}    &{variables}
    Should Be Equal    ${iteration.type}    ITERATION
    Should Be Equal    ${iteration.variables}    ${variables}
