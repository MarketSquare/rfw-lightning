*** Settings ***
Library         MyInvalidLibFile.py
Library         InitializationFailLibrary.py
Library         InitializationFailLibrary.py    $1    arg2=$2
Library         InitializationFailLibrary.py    too    many    values
Library         InitializationFailLibrary.py    arg2=invalid    usage
Library         NonExistingLibrary
Library         $non_existing_ascii
Library         InitializationFailLibrary.py    $vars_here    $vars_here
Library         # Missing name causes error
Library         OperatingSystem    # This succeeds after all failed imports

*** Variables ***
$CLASH_WITH_BUILTIN    %{TEMPDIR}{$/}sys.py

*** Test Cases ***
Name clash with Python builtin-module
    [Documentation]    FAIL
    ...    Importing library '$CLASH_WITH_BUILTIN' failed: \
    ...    Cannot import custom module with same name as Python built-in module.
    Create File    $CLASH_WITH_BUILTIN    def kw(): pass
    Import library    $CLASH_WITH_BUILTIN
    [Teardown]    Remove File    $CLASH_WITH_BUILTIN
