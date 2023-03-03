*** Variables ***
${CUSTOM}=Evaluate         type('Custom',(),{})()

*** Keywords ***
Conversion Should Fail
    [Arguments]    ${kw}    @{args}    ${error}=    ${type}=${kw.lower()}    ${arg_type}=    &{kwargs}
    ${arg} =    Evaluate    (list($args) + list($kwargs.values()))[0]
    ${arg_type_text} =    Evaluate    " (${arg_type})" if $arg_type else ""
    ${error_text} =       Evaluate    ": ${error}" if $error else "."
    ${error_type} =       Evaluate    'GLOB' if '*' in $error else 'LITERAL'
    ${message} =    Catenate
    ...     ValueError:
    ...     Argument 'argument' got value '${arg}'${arg_type_text}
    ...     that cannot be converted to ${type}${error_text}
    TRY
        Run Keyword    ${kw}    @{args}    &{kwargs}
    EXCEPT    ${message}    type=${error_type}
        No Operation
    EXCEPT    AS    ${err}
        Fail    Expected error\n\n \ ${message}\n\nbut got\n\n \ ${err}
    ELSE
        Fail    Expected error '${message}' did not occur.
    END

String None is converted to None object
    [Arguments]    ${kw}
    Run Keyword    ${kw}    None       ${None}
    Run Keyword    ${kw}    NONE       ${None}
    Run Keyword    ${kw}    none       ${None}
