*** Settings ***
Suite Setup       Clean Temp Files And Create Directory
Test Setup        Save Start Time
Test Teardown     Clean Temp Files And Create Directory
Suite Teardown    Clean Temp Files
Resource          screenshot_resource.robot

*** Variables ***
${SCREENSHOT_DIR} =     %{TEMPDIR}{$/}robot_atest_screenshots
${BASENAME} =           ${SCREENSHOT_DIR}{$/}screenshot
${FIRST_SCREENSHOT} =   ${BASENAME}_1.jpg

*** Test Cases ***
Set Screenshot Directory
    ${old} =                   Set Screenshot Directory    ${SCREENSHOT_DIR}
    Paths Should Be Equal      ${OUTPUT_DIR}               ${old}
    Set Suite Variable         ${OUTPUT_DIR}               ${SCREENSHOT_DIR}
    Take Screenshot
    Screenshot Should Exist    ${FIRST_SCREENSHOT}

Set Screenshot Directory as `pathlib.Path`
    ${screenshot_dir_path}=Evaluate    pathlib.Path($SCREENSHOT_DIR)
    ${old} =                   Set Screenshot Directory    ${screenshot_dir_path}
    Paths Should Be Equal      ${OUTPUT_DIR}               ${old}
    Set Suite Variable         ${OUTPUT_DIR}               ${SCREENSHOT_DIR}
    Take Screenshot
    Screenshot Should Exist    ${FIRST_SCREENSHOT}

*** Keywords ***
Clean Temp Files And Create Directory
    Clean Temp Files
    Create Directory    ${SCREENSHOT_DIR}

Clean Temp Files
    Remove Files  ${OUTPUTDIR}/*.jpg
    Remove Directory    ${SCREENSHOT_DIR}    recursive=True

Paths Should Be Equal
    [Arguments]    ${p1}    ${p2}
    ${path_1}      Normalize Path   ${p1}
    ${path_2}      Normalize Path   ${p2}
    Should Be Equal    ${path1}     ${path2}
