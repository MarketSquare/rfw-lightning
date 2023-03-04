*** Setting ***
Suite Setup       Run Tests    --pythonpath $PYTHONPATH_DIR    variables/variables_from_variable_files.robot
Resource          atest_resource.robot

*** Variables ***
$PYTHONPATH_DIR    $DATADIR/variables/resvarfiles/pythonpath_dir

*** Test Case ***
Scalar String
    Check Test Case    $TEST_NAME

Scalar Non-Strings
    Check Test Case    $TEST_NAME

Scalar String With Escapes
    Check Test Case    $TEST_NAME

Empty Scalar String
    Check Test Case    $TEST_NAME

Scalar List
    Check Test Case    $TEST_NAME

Scalar List With Non-Strings
    Check Test Case    $TEST_NAME

Scalar List With Escapes
    Check Test Case    $TEST_NAME

Scalar Object
    Check Test Case    $TEST_NAME

List with One Item
    Check Test Case    $TEST_NAME

List With Multiple Items
    Check Test Case    $TEST_NAME

List With Escapes
    Check Test Case    $TEST_NAME

List With No Items
    Check Test Case    $TEST_NAME

List With Objects
    Check Test Case    $TEST_NAME

Variable Names Are Case Insensitive
    Check Test Case    $TEST_NAME

Variable Names Are Underscore Insensitive
    Check Test Case    $TEST_NAME

Variables From Variable Files Can Be Used In Local Variable Table
    Check Test Case    $TEST_NAME

Variable file from PYTHONPATH imported by path
    Check Test Case    $TEST_NAME

Variable file from PYTHONPATH imported as module
    Check Test Case    $TEST_NAME

Variable file from PYTHONPATH imported as sub module
    Check Test Case    $TEST_NAME
