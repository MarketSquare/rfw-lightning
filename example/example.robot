*** Variables ***
$SIMPLEVAR   1
$SIMPLELIST=Create List   1  2  3
$SIMPLEDICT=Create Dictionary    a=123  b=456

*** Test Cases ***
Testing
    Should Be Equal   $SIMPLEVAR   1
    IF  $SIMPLEVAR   ==   1
       Log   $SIMPLEVAR
    END
    IF  $SIMPLEVAR   is   $TRUE
       Fail
    END
    IF  5  not in  $SIMPLELIST
       No Operation
    END
    IF  2  in  $SIMPLELIST
       Log   All is fine
    END
    FOR  $SIMPLE  IN   $SIMPLELIST
       Log   $SIMPLE
    END