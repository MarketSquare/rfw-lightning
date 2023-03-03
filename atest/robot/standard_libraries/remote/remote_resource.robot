*** Settings ***
Resource          atest_resource.robot
Resource          ../../libdoc/libdoc_resource.robot

*** Variables ***
${PORT_FILE}      %{TEMPDIR}${/}remote_port.txt
${STDOUT_FILE}    %{TEMPDIR}${/}remote_output.txt

*** Keywords ***
Run Remote Tests
    [Arguments]    ${tests}    ${server}    ${stop_server}=yes
    ${port} =    Start Remote Server    ${server}
    Run Tests    --variable PORT:${port}    standard_libraries/remote/${tests}
    [Teardown]    Run Keyword If    '${stop_server}' == 'yes'
    ...    Stop Remote Server    ${server}
    [Return]    ${port}

Start Remote Server
    [Arguments]    ${server}    ${port}=0
    Remove File    ${PORT_FILE}
    ${path} =    Normalize Path    ${DATADIR}/standard_libraries/remote/${server}
    ${python} =    Evaluate    sys.executable    modules=sys
    Start Process    ${python}    ${path}    ${port}    ${PORT_FILE}
    ...    alias=${server}    stdout=${STDOUT_FILE}    stderr=STDOUT
    Wait Until Created    ${PORT_FILE}    30s
    ${port} =    Get File    ${PORT_FILE}
    [Return]    ${port}

Stop Remote Server
    [Arguments]    ${server}
    ${result} =    Terminate Process    handle=${server}
    Log    ${result.stdout}
