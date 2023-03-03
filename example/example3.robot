*** Test Cases ***
Direct variable
    $variable=  World
    IF  $variable  ==  World
        Log   Hello {$variable}!
    ELSE
        Fail  Should not come here
    END