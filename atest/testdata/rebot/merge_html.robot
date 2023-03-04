*** Setting ***
Documentation     Merge test cases for test doc HTML formatting

*** Variables ***
$USE_HTML       $false
$TEXT_MESSAGE   Test message
$HTML_MESSAGE   *HTML* <b>Test</b> message

*** Test Case ***
Html1
    Set Test Documentation   FAIL $TEXT_MESSAGE
    Fail    $TEXT_MESSAGE

Html2
    $msg  Set Variable If  $USE_HTML   $HTML_MESSAGE   $TEXT_MESSAGE
    Set Test Documentation   FAIL $msg
    Fail    $msg

Html3
    Set Test Documentation   FAIL $HTML_MESSAGE
    Fail    $HTML_MESSAGE

Html4
    $msg  Set Variable If  not $USE_HTML   $HTML_MESSAGE   $TEXT_MESSAGE
    Set Test Documentation   FAIL $msg
    Fail    $msg
