*** Settings ***
Library           OperatingSystem
Suite Setup       Set Is Windows Variable

*** Test Cases ***
Tilde in path
    ${path} =    Normalize Path    ~/foo
    ${home} =    Get Home
    Should Be Equal    ${path}    ${home}${/}foo
    Directory Should Exist    ~

Tilde and username in path
    ${user} =    Get User
    ${path} =    Normalize Path    ~${user}/foo    case_normalize=True
    ${home} =    Get Home    case_normalize=True
    Should Be Equal    ${path}    ${home}${/}foo
    Directory Should Exist    ~${user}

Path as `pathlib.Path`
    ${original_path}=     Evaluate    pathlib.Path('~/foo')
    ${path} =    Normalize Path    ${original_path}
    ${home} =    Get Home
    Should Be Equal    ${path}    ${home}${/}foo
    ${original_path}=     Evaluate    pathlib.Path('~')
    Directory Should Exist    ${original_path}

*** Keywords ***
Set Is Windows Variable
    ${WINDOWS}     Evaluate    "${/}" != '/'
    Set Suite Variable   $WINDOWS

Get Home
    [Arguments]    ${case_normalize}=False
    IF    ${WINDOWS}
        ${home} =    Get Environment Variable    USERPROFILE    %{HOMEDRIVE}%{HOMEPATH}
    ELSE
        ${home} =    Get Environment Variable    HOME
    END
    ${home} =    Normalize Path    ${home}    ${case_normalize}
    RETURN    ${home}

Get User
    IF    ${WINDOWS}
        RETURN    %{USERNAME}
    ELSE
        RETURN    %{USER}
    END
