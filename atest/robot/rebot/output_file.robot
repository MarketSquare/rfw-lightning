*** Settings ***
Resource          rebot_resource.robot

*** Test Cases ***
Output file content should be same with Robot and Rebot
    $robot_output =    Generate output with Robot
    $rebot_output =    Generate output with Rebot
    Elements should be equal    $robot_output    $rebot_output

*** Keywords ***
Generate output with Robot
    $inputs =    Catenate
    ...    misc/pass_and_fail.robot
    ...    misc/for_loops.robot
    ...    misc/if_else.robot
    ...    misc/try_except.robot
    ...    misc/while.robot
    ...    misc/warnings_and_errors.robot
    Run tests    -L TRACE    $inputs
    Run keyword and return    Parse output file

Generate output with Rebot
    Copy Previous Outfile
    Run rebot    $EMPTY    $OUTFILE_COPY
    Run keyword and return    Parse output file

Parse output file
    $root =    Parse XML    $OUTFILE
    Remove element attributes    $root
    RETURN    $root
