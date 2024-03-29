*** Settings ***
Test Setup        Create Output Directory
Resource          cli_resource.robot

*** Test Cases ***
Output Only
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR --output myoutput.xml --report none --log none    $TESTFILE
    Output Directory Should Contain    myoutput.xml

Output And Report
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR --output myoutput.xml --report myreport.html --log none    $TESTFILE
    Output Directory Should Contain    myoutput.xml    myreport.html

Output And Log
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR --output myoutput.xml --report none --log mylog.html    $TESTFILE
    Output Directory Should Contain    mylog.html    myoutput.xml

Disabling output XML only disables log with a warning
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR -o nOnE -r report.html -l mylog.html    $TESTFILE
    Output Directory Should Contain    report.html
    Stderr Should Match Regexp    \\[ ERROR \\] Log file cannot be created if output.xml is disabled.

All output files disabled
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR -o nOnE -r NONE -l none    $TESTFILE
    Output Directory Should Be Empty

Debug, Xunit And Report File Can Be Created When Output Is NONE
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR -o NONE -r myreport.html -b mydebug.txt -x myxunit.xml    $TESTFILE
    Output Directory Should Contain    mydebug.txt    myreport.html    myxunit.xml

All Outputs
    Run Tests Without Processing Output    --outputdir=$CLI_OUTDIR --output=myoutput.xml --report=myreport.html --log=mylog.html    $TESTFILE
    Output Directory Should Contain    mylog.html    myoutput.xml    myreport.html

All Outputs With Default Names
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR    $DATADIR/$TESTFILE    default_options=
    Output Directory Should Contain    log.html    output.xml    report.html

All Outputs Without Extensions
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR -o myoutput -r myreport -l mylog    $TESTFILE
    Output Directory Should Contain    mylog.html    myoutput.xml    myreport.html

Outputs Into Different Dirs
    Run Tests Without Processing Output    --outputdir ::invalid:: -o $CLI_OUTDIR/o/o.xml -r $CLI_OUTDIR/r/r.html -l $CLI_OUTDIR/l.html    $TESTFILE
    Directory Should Contain    $CLI_OUTDIR/o    o.xml
    Directory Should Contain    $CLI_OUTDIR/r    r.html
    Directory Should Contain    $CLI_OUTDIR    l.html    o    r

Split Log
    Run Tests Without Processing Output    --outputdir $CLI_OUTDIR --output o.xml --report r.html --log l.html --splitlog    $TESTFILE
    Directory Should Contain    $CLI_OUTDIR    l-1.js    l-2.js    l.html    o.xml    r.html

Non-writable Output File
    Create Directory    $CLI_OUTDIR/diréctöry.xml
    Run Tests Without Processing Output    --output $CLI_OUTDIR/diréctöry.xml    $TESTFILE
    Stderr Should Match Regexp
    ...    \\[ ERROR \\] Opening output file '.*diréctöry.xml' failed: [^ ]+Error: .*$USAGE_TIP

Non-writable Log and Report
    $directory =    Normalize Path    $CLI_OUTDIR/diréctöry.html
    Create Directory    $directory
    Run Tests    --log $directory --report $directory    $TESTFILE
    Should Be Equal    ${SUITE.status}    PASS
    Stderr Should Match Regexp    SEPARATOR=\n
    ...    \\[ ERROR \\] Opening log file '.*diréctöry.html' failed: [^ ]+Error: .*
    ...    \\[ ERROR \\] Opening report file '.*diréctöry.html' failed: [^ ]+Error: .*
    Stdout Should Contain    Output:
    Stdout Should Not Contain    Log:
    Stdout Should Not Contain    Report:

Non-writable Split Log
    Create Directory    $CLI_OUTDIR/dir-1.js
    Run Tests    --splitlog --log $CLI_OUTDIR/dir.html --report r.html    $TESTFILE
    Should Be Equal    ${SUITE.status}    PASS
    Stderr Should Match Regexp    \\[ ERROR \\] Opening log file '.*dir-1.js' failed: [^ ]+Error: .*
    Stdout Should Contain    Output:
    Stdout Should Not Contain    Log:
    Stdout Should Contain    Report:
