*** Settings ***
Test Setup      Create Output Directory
Resource        rebot_cli_resource.robot

*** Variables ***
${ARG_FILE}     %{TEMPDIR}/arguments.txt

*** Test Cases ***
Argument File
    ${content} =    Catenate    SEPARATOR=\n
    ...    --name From Arg File
    ...    -D= Leading space is ignored
    ...    -M${SPACE*5}No:Spaces
    ...    \# comment line
    ...    ${EMPTY}
    ...    --log=none
    ...    -r=none
    ...    -o myout.xml
    ...    --outputdir ${CLI_OUTDIR}
    ...    ${INPUT_FILE}
    Create File    ${ARG_FILE}    ${content}
    ${result} =  Run Rebot    --log disable_me.html --argumentfile ${ARG_FILE}
    ...    output=${CLI_OUTDIR}/myout.xml
    Should Be Empty    ${result.stderr}
    Directory Should Contain    ${CLI_OUTDIR}    myout.xml
    Should Be Equal    ${SUITE.name}    From Arg File
    Should Be Equal    ${SUITE.doc}    Leading space is ignored
    Should Be Equal    ${SUITE.metadata}[No]    Spaces
