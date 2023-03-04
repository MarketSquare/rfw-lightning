*** Variables ***
$scalar=            Some Test
$Say_Something=     Hello World
$World=             Something

*** Keywords ***
Check Scalar in Default
    [Arguments]
    ...     $current=some\$text and $scalar \ ell\ with\n\t $Say_Something Space
    ...    $expected=some\$text and $scalar \ ${{'Hello'[1:3]}}\ with\n\t $Say_Something Space
    Log    current: '$current'
    Log    expected: '$expected'
    Should Be Equal    $current    $expected
