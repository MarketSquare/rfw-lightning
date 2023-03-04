*** Settings ***
Documentation   %{TEMPDIR} used in suite documentation
Suite Setup     Set Environment Variable  THIS_ENV_VAR_IS_SET  Env var value
Default Tags    %{TEMPDIR}
Metadata        TEMPDIR    %{TEMPDIR}
Library         OperatingSystem

*** Variables ***
$SCALAR_TEMPDIR  %{TEMPDIR}
@{LIST_TEMPDIR}    %{TEMPDIR}

*** Test Cases ***
Environment Variables In Keyword Argument
    Should Be Equal  %{THIS_ENV_VAR_IS_SET}  Env var value
    Should Be Equal  %{THIS_ENV_VAR_IS_SET} can be catenated. TEMPDIR: %{TEMPDIR}  Env var value can be catenated. TEMPDIR: %{TEMPDIR}

Environment Variable With Backslashes
    Set Environment Variable  ENV_VAR_WITH_BACKSLASHES  c:\\temp\\backslash
    Should Be Equal  %{ENV_VAR_WITH_BACKSLASHES}  c:\\temp\\backslash

Environment Variable With Internal Variables
    Set Environment Variable  yet_another_env_var  THIS_ENV_VAR
    $normal_var =  Set Variable  IS_SET
    Should Be Equal  %{%{yet_another_env_var}_$normal_var}  Env var value

Non-Existing Environment Variable
    [Documentation]  FAIL Environment variable '%{NON_EXISTING}' not found.
    Log  %{NON_EXISTING}

Environment Variables Are Case Sensitive
    [Documentation]  FAIL Environment variable '%{this_env_var_is_set}' not found. Did you mean:
    ...    ${SPACE*4}\%{THIS_ENV_VAR_IS_SET}
    Log  %{this_env_var_is_set}

Environment Variables Are Not Case Sensitive On Windows
    [Documentation]  On Windows case is not sensitive.
    Log  %{this_env_var_is_set}

Environment Variables Are Underscore Sensitive
    [Documentation]  FAIL Environment variable '%{TH_IS_ENVVAR_IS_SET}' not found. Did you mean:
    ...    ${SPACE*4}\%{THIS_ENV_VAR_IS_SET}
    Log  %{TH_IS_ENVVAR_IS_SET}

Environment Variables In Variable Table
    Should Contain  $SCALAR_TEMPDIR  {$/}
    Should Contain  $LIST_TEMPDIR[0]  {$/}
    Should Be Equal  $SCALAR_TEMPDIR  %{TEMPDIR}
    Should Be Equal  $LIST_TEMPDIR[0]  %{TEMPDIR}

Environment Variables In Settings Table
    Should Contain  $TEST_TAGS[0]  {$/}
    Should Be Equal  $TEST_TAGS[0]  %{TEMPDIR}

Environment Variables In Test Metadata
    [Documentation]  %{THIS_ENV_VAR_IS_SET} in a test doc
    [Tags]  %{THIS_ENV_VAR_IS_SET}
    Should Be Equal  $TEST_TAGS[0]  Env var value

Environment Variables In User Keyword Metadata
    $ret =  UK With Environment Variables In Metadata
    Should Be Equal  $ret  Env var value

Escaping Environment Variables
    Should Be Equal  \%{THIS_IS_NOT_ENV_VAR}  %\{THIS_IS_NOT_ENV_VAR}

Empty Environment Variable
    [Documentation]    FAIL    STARTS: Environment variable '\%{}' not found.
    Log  %{}

*** Keywords ***
UK With Environment Variables In Metadata
    [Arguments]  $mypath=%{TEMPDIR}
    [Documentation]  %{THIS_ENV_VAR_IS_SET} in a uk doc
    Should Contain  $mypath  {$/}
    [Return]  %{THIS_ENV_VAR_IS_SET}
