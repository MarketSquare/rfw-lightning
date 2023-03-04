*** Settings ***
Documentation       A robot to collect the main syntax problems with the current RFW

*** Variables ***
$ROBOTS = Create List        Bender    Johnny5    Terminator    Robocop
$STRING             cute cat
$INT_AS_STRING      1
$INT_AS_INT=Convert To Number    1
$FLOAT=Convert To Number         3.14
$LIST=Create List            one    two    three
$ONE=Convert To Number           1
$DICTIONARY=Create Dictionary      string=cat    number=$ONE    list=$LIST


*** Test Cases ***
Minimal task
    Use Variables in Robot Framework
    Use IF in Robot Framework
    Use FOR in Robot Framework
    Example Keyword    with   arguments
    Log    Done.

*** Keywords ***
Use Variables in Robot Framework
    [Documentation]
    ...    TBD
    ...    Main problem too many options and too much "cursing"
    ...    https://robocorp.com/docs/languages-and-frameworks/robot-framework/variables

    $STRING=Set Variable    cute dog
    Set Global Variable    $STRING    cute bird     # IMHO: This should be re-thinked. Having global values is ok, but maybe out of namespace impacts.
    Log    $STRING
    #$Path_in_variable=Path    C://Temp/testing

Use IF in Robot Framework
    [Documentation]
    ...    TBD
    ...    The problem with IF is that it is different, which is why the docs pages below are
    ...    the most hit docs pages we have:
    ...    https://robocorp.com/docs/languages-and-frameworks/robot-framework/conditional-execution

    #NOPE:  IF    ${True}    Log    This line IS executed.
    #NOPE:  IF    ${False}    Log    This line is NOT executed.
    IF    cat  ==  cat
        Log    This line IS executed.
    END
    IF    cat  !=  dog
        Log    This line IS executed.
    END
    IF    cat  ==  dog
        Log    This line is NOT executed.
    END
    #IF    cat  ==  cat  AND  dog  ==  dog  THEN   Log    This line IS executed.
    #IF    cat  ==  cat  AND  dog  ==  cat  THEN   Log    This line is NOT executed.
    IF    $1  ==  $1
        Log    This line IS executed.
    END
    IF    $2  <  $1
       Log    This line is NOT executed.
    END
    IF    $2  <=  $2
       Log    This line IS executed.
    END
    IF    $21  >  $2
       Log    This line IS ALSO executed.
    END
    #NOPE: IF    len("cat") == 3    Log    This line IS executed.
    #IF    1  ==  1  AND  2  ==  2  AND  3  ==  3
    #    Log    This line IS executed since the expressions evaluate to True.
    #END
    #IF    1  ==  2  OR  3  ==  4  OR  3  ==  3
    #    Log    This line IS executed since one of the expressions evaluates to True.
    #END

Use FOR in Robot Framework
    [Documentation]
    ...    TBD
    ...    The docs page on conditionals and for -loops is even more hit than IF-ELSSe
    ...    And the problem is that the way to use variables is different from IF-ELSE,
    ...    but it also has the typing with the '@' -syntax.
    ...    https://robocorp.com/docs/languages-and-frameworks/robot-framework/for-loops

    FOR  $robot  IN  $ROBOTS
        Log    $robot
    END

Example Keyword    
    [Arguments]   $urg1   $arg2
    Log   $urg1
    Log   $arg2
    Log   Hello:{$urg1},{$arg2}!
