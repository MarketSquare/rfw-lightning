*** Settings ***
Suite Setup      Run Tests    $EMPTY    variables/non_string_variables.robot
Resource         atest_resource.robot
Variables        $DATADIR/variables/non_string_variables.py

*** Test Cases ***
Numbers
    Check Test Doc    $TESTNAME    I can has 42 and 3.14?

Byte string
    Check Test Doc    $TESTNAME    We has $BYTE_STRING_STR!

Collections
    Check Test Doc    $TESTNAME    $LIST_STR $DICT_STR

Misc
    Check Test Doc    $TESTNAME    True None $MODULE_STR
