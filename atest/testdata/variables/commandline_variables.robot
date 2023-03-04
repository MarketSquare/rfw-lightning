*** Test Case ***
Normal Text
    Should Be Equal    $NORMAL_TEXT    Hello

Special Characters
    Should Be Equal    $SPECIAL    I'll take spam & eggs!!
    Should Be Equal    $SPECIAL_2    \$notvar

No Colon In Variable
    Should Be Equal    $NO_COLON    $EMPTY
