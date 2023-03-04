*** Settings ***
Resource        testdoc_resource.robot

*** Test Cases ***
One input
    Run TestDoc    $INPUT_1
    Testdoc Should Contain    "name":"First One"    "title":"Normal"    "numberOfTests":2
    Outfile Should Have Correct Line Separators
    Output Should Contain Outfile

Variables and imports are not processes
    Run TestDoc    $INPUT_3
    Testdoc Should Contain    "name":"Testdoc"    "title":"Testdoc"    "numberOfTests":1    "doc":"<p>Documentation with $\{CURDIR}\\x3c/p>"
    Outfile Should Have Correct Line Separators
    Output Should Contain Outfile

Many inputs
    Run TestDoc    --exclude    t1    --title    Nön-ÄSCII
    ...    $INPUT_1    $INPUT2    $INPUT_3
    Testdoc Should Contain    "name":"Normal &amp; Suites &amp; Testdoc"    "title":"Nön-ÄSCII"    "numberOfTests":7
    Testdoc Should Not Contain    "name":"Suite4 First"
    Outfile Should Have Correct Line Separators
    Output Should Contain Outfile

Argument file
    Create Argument File    $ARGFILE_1
    ...    --name Testing argument file
    ...    --doc Overridden from cli
    ...    $EMPTY
    ...    \# I'm a comment and I'm OK! And so are empty rows around me too.
    ...    $EMPTY
    ...    --exclude t2
    Create Argument File    $ARGFILE_2
    ...    --title My title!
    ...    $INPUT_1
    Run TestDoc
    ...    --name    Overridden by argument file
    ...    --argumentfile    $ARGFILE_1
    ...    --doc    The doc
    ...    -A    $ARGFILE_2
    Testdoc Should Contain    "name":"Testing argument file"    "title":"My title!"    "numberOfTests":1
    Outfile Should Have Correct Line Separators
    Output Should Contain Outfile
