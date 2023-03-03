*** Settings ***
Suite Setup     Import Variables In Suite Setup
Library         OperatingSystem

*** Variables ***
${VAR_FILE_1}   ${CURDIR}/variables_to_import_1.py
${VAR_FILE_2}   ${CURDIR}/variables_to_import_2.py

*** Test Cases ***
Import Variables In Suite Setup
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  suite setup
    Should Be Equal  ${COMMON_VARIABLE}  ${2}

Import Variables 1
    Variable Should Not Exist  $IMPORT_VARIABLES_1
    Import Variables  ${VAR_FILE_1}
    Should Be Equal  ${IMPORT_VARIABLES_1}  Simple variable file
    Should Be Equal  ${COMMON_VARIABLE}  ${1}

Import Variables 2
    [Documentation]  Verify that variable imported by earlier kw is still available
    Should Be Equal  ${IMPORT_VARIABLES_1}  Simple variable file

Import Variables With Arguments
    Import Variables  ${VAR_FILE_2}  my  args
    Should Be Equal  ${IMPORT_VARIABLES_2}  Dynamic variable file
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  my args
    Should Be Equal  ${COMMON_VARIABLE}  ${2}
    Import Variables  ${VAR_FILE_2}  one arg only
    Should Be Equal  ${IMPORT_VARIABLES_2}  Dynamic variable file
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  one arg only default
    Should Be Equal  ${COMMON_VARIABLE}  ${2}

Inport Variables With Invalid Arguments
    [Documentation]  FAIL REGEXP:
    ...    Processing variable file '.*variables_to_import_2.py' with arguments \\[ 1 \\| 2 \\| 3 \\] failed: TypeError: .*
    Import Variables  ${VAR_FILE_2}  1  2  3

Import Variables In User Keyword 1
    Import Variables In User Keyword  Set in  user keyword
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  Set in user keyword
    Imported Variable Should Be Set To  Set in user keyword
    Should Be Equal  ${COMMON_VARIABLE}  ${2}

Import Variables In User Keyword 2
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  Set in user keyword
    Imported Variable Should Be Set To  Set in user keyword
    Import Variables In User Keyword  Set again in  user keyword
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  Set again in user keyword
    Imported Variable Should Be Set To  Set again in user keyword

Re-Import Variables
    Re-Import And Verify Variables  ${1}
    Re-Import And Verify Variables  ${2}  arg
    Re-Import And Verify Variables  ${1}
    Re-Import And Verify Variables  ${2}  arg

Import Variables Arguments Are Resolved Only Once
    ${var} =  Set Variable  \${not_var}
    Import Variables  ${CURDIR}${/}variables_to_import_2.py  ${var}  c:\\temp
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  \${not_var} c:\\temp

Import Variables Failure Is Catchable
    Run Keyword And Expect Error  Variable file 'non_existing.py' does not exist.  Import Variables  non_existing.py

Import Variables from Path
    Variable Should Not Exist    ${PPATH_VARFILE}
    Import Variables    variables_in_pythonpath.py
    Should Be Equal    ${PPATH_VARFILE}     Variable from variable file in PYTHONPATH

*** Keywords ***
Import Variables In User Keyword
    [Arguments]  @{value}
    Import Variables  ${VAR_FILE_2}  @{value}
    ${value} =  Catenate  @{value}
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  ${value}
    Imported Variable Should Be Set To  ${value}
    Should Be Equal  ${COMMON_VARIABLE}  ${2}

Imported Variable Should Be Set To
    [Arguments]  ${value}
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  ${value}

Import Variables In Suite Setup
    Import Variables In User Keyword  suite  setup
    Should Be Equal  ${IMPORT_VARIABLES_2_ARGS}  suite setup
    Should Be Equal  ${COMMON_VARIABLE}  ${2}

Re-Import And Verify Variables
    [Arguments]  ${number}  @{args}
    Import Variables  ${CURDIR}/variables_to_import_${number}.py  @{args}
    Should Be Equal  ${COMMON_VARIABLE}  ${number}
    Should Be Equal  ${IMPORT_VARIABLES_1}  Simple variable file
    Should Be Equal  ${IMPORT_VARIABLES_2}  Dynamic variable file

