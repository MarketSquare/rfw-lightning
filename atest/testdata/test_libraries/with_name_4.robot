*** Settings ***
Library           ParameterLibrary.V1    ${WITH_NAME}    foo
Library           ParameterLibrary.V2    @{LIST_AS}

*** Variables ***
${WITH_NAME}      WITH NAME
@{LIST_AS}        AS    bar

*** Test Cases ***
'WITH NAME' cannot come from variable
    ParameterLibrary.V1.Parameters should be    WITH NAME    foo
    ParameterLibrary.V2.Parameters should be    AS    bar

'WITH NAME' cannot come from variable with 'Import Library' keyword
    Import Library    ParameterLibrary.V3    ${WITH_NAME}    zap
    Import Library    ParameterLibrary.V4    @{LIST_AS}
    ParameterLibrary.V3.Parameters should be    WITH NAME    zap
    ParameterLibrary.V4.Parameters should be    AS    bar

'WITH NAME' cannot come from variable with 'Import Library' keyword even when list variable opened
    @{must_open_to_find_name} =    Create List    Import Library    ParameterLibrary.V5    ${WITH_NAME}    foo
    Run Keyword    @{must_open_to_find_name}
    ParameterLibrary.V5.Parameters should be    WITH NAME    foo
    @{must_open_to_find_name} =    Create List    Import Library    ParameterLibrary.V6    @{LIST_AS}
    Run Keyword    @{must_open_to_find_name}
    ParameterLibrary.V6.Parameters should be    AS    bar
