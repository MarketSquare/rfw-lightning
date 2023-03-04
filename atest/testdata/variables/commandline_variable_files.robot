*** Variables ***
@{EXPECTED_LIST}  List  variable  value

*** Test Cases ***
Variables From Variable File
    Should Be Equal  $SCALAR  Scalar from variable file from CLI
    Should Be Equal  $SCALAR_WITH_ESCAPES  1 \\ 2\\\\ \$inv
    Should Be Equal  $SCALAR_LIST  $EXPECTED_LIST
    Should Be True  @{LIST} == $EXPECTED_LIST

Arguments To Variable Files
    Should Be Equal  $ANOTHER_SCALAR  Variable from CLI var file with get_variables
    Should Be True  @{ANOTHER_LIST} == ['List variable from CLI var file', 'with get_variables']
    Should Be Equal  $ARG  default value
    Should Be Equal  $ARG_2  value;with;semi;colons

Arguments To Variable Files Using Semicolon Separator
    Should Be Equal  $SEMICOLON  separator
    Should Be Equal  ${SEMI:COLON}  separator:with:colons

Variable File From PYTHONPATH
    Should Be Equal  $PYTHONPATH_VAR_0  Varfile found from PYTHONPATH
    Should Be Equal  $PYTHONPATH_ARGS_0  $EMPTY

Variable File From PYTHONPATH with arguments
    Should Be Equal  $PYTHONPATH_VAR_3  Varfile found from PYTHONPATH
    Should Be Equal  $PYTHONPATH_ARGS_3  1-2-3

Variable File From PYTHONPATH as module
    Should Be Equal  $PYTHONPATH_VAR_2    Varfile found from PYTHONPATH
    Should Be Equal  $PYTHONPATH_ARGS_2   as-module

Variable File From PYTHONPATH as submodule
    Should be Equal    $VARIABLE_IN_SUBMODULE    VALUE IN SUBMODULE
