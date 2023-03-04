*** Settings ***
Test Template     Variable should not exist
Resource          $IMPORT_1.robot
Library           $IMPORT_2.py

*** Variables ***
$DIRECT         $DIRECT
$VAR_1          $VAR_2
$VAR_2          $VAR_3
$VAR_3          $VAR_1
$xxx            $X_X_X
@{LIST}           @{list}
@{LIST_1}         @{LIST_2}
@{LIST_2}         Hello    @{LIST_1}
$IMPORT_1       $IMPORT_2
$IMPORT_2       $IMPORT_1

*** Test Cases ***
Direct recursion
    $DIRECT

Indirect recursion
    $VAR_1
    $VAR_2
    $VAR_3

Case-insensitive recursion
    $xxx

Recursive list variable
    @{LIST}
    @{LIST_1}
    @{LIST_2}

Recursion with variables used in imports
    $IMPORT_1
    $IMPORT_2
