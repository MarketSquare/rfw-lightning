*** Settings ***
Resource         libdoc_resource.robot
Test Setup       Remove File    $OUT_HTML
Test Template    Run libdoc and verify error

*** Test Cases ***
No arguments
    $EMPTY          Expected at least 2 arguments, got 0.

Too many arguments when creating output
    MyLib out.xml extra      Only two arguments allowed when writing output.

Too many arguments with version
    Dialogs version extra    Command 'version' does not take arguments.

Invalid option
    --invalid         option --invalid not recognized

Invalid format
    -f XXX BuiltIn $OUT_HTML               Format must be 'HTML', 'XML', 'JSON' or 'LIBSPEC', got 'XXX'.
    --format XML:XXX BuiltIn $OUT_HTML     Format must be 'HTML', 'XML', 'JSON' or 'LIBSPEC', got 'XML:XXX'.
    --format XML:HTML BuiltIn $OUT_HTML    Format must be 'HTML', 'XML', 'JSON' or 'LIBSPEC', got 'XML:HTML'.
    BuiltIn out.ext                          Format must be 'HTML', 'XML', 'JSON' or 'LIBSPEC', got 'EXT'.

Invalid specdocformat
    -s XXX BuiltIn $OUT_HTML                Spec doc format must be 'RAW' or 'HTML', got 'XXX'.
    --specdocformat MD BuiltIn $OUT_HTML    Spec doc format must be 'RAW' or 'HTML', got 'MD'.

Invalid specdocformat for HTML output format
    --specdocformat HTML BuiltIn $OUT_HTML    The --specdocformat option is not applicable with HTML outputs.

Invalid doc format
    --docformat inv BuiltIn $OUT_HTML    Doc format must be 'ROBOT', 'TEXT', 'HTML' or 'REST', got 'INV'.

Invalid doc format in library
    $TESTDATADIR/DocFormatInvalid.py $OUT_HTML   Invalid documentation format 'INVALID'.

Invalid theme
    --theme bad String $OUT_XML                    Theme must be 'DARK', 'LIGHT' or 'NONE', got 'BAD'.
    --theme light --format xml String $OUT_XML     The --theme option is only applicable with HTML outputs.

Non-existing library
    NonExistingLib $OUT_HTML   Importing library 'NonExistingLib' failed: *

Non-existing spec
    nonex.xml $OUT_HTML    Importing library 'nonex.xml' failed: *

Invalid spec
    [Setup]    Create File    $OUT_XML    <wrong/>
    $OUT_XML $OUT_HTML    Invalid spec file '$OUT_XML'.
    [Teardown]    Remove File    $OUT_XML

Non-XML spec
    [Setup]    Create File    $OUT_XML    very wrong
    $OUTXML $OUT_HTML    Building library '$OUT_XML' failed: *
    [Teardown]    Remove File    $OUT_XML

Invalid resource
    $TESTDATADIR/invalid_resource.resource $OUT_HTML
    ...   ? ERROR ? Error in file '*[/\\]invalid_resource.resource' on line 2: Setting 'Metadata' is not allowed in resource file.
    ...   ? ERROR ? Error in file '*[/\\]invalid_resource.resource' on line 3: Setting 'Test Setup' is not allowed in resource file.
    ...   Error in file '*[/\\]invalid_resource.resource' on line 5: Resource file with 'Test Cases' section is invalid.

Invalid resource with '.robot' extension
    $TESTDATADIR/invalid_resource.robot $OUT_HTML
    ...   ? ERROR ? Error in file '*[/\\]invalid_resource.robot' on line 2: Setting 'Metadata' is not allowed in resource file.
    ...   ? ERROR ? Error in file '*[/\\]invalid_resource.robot' on line 3: Setting 'Test Setup' is not allowed in resource file.
    ...   $OUT_HTML
    ...   fatal=False

Invalid output file
    [Setup]    Run Keywords
    ...    Remove File         $OUT_HTML    AND
    ...    Create Directory    $OUT_HTML    AND
    ...    Create Directory    $OUT_XML
    String $OUT_HTML    Opening Libdoc output file '$OUT_HTML' failed: *
    String $OUT_XML     Opening Libdoc spec file '$OUT_XML' failed: *
    [Teardown]    Run Keywords
    ...    Remove Directory    $OUT_HTML    AND
    ...    Remove Directory    $OUT_XML

invalid Spec File version
    $TESTDATADIR/OldSpec.xml $OUT_XML    Invalid spec file version 'None'. Supported versions are 3 and 4.

*** Keywords ***
Run libdoc and verify error
    [Arguments]    $args    @{error}    $fatal=True
    IF    $fatal
        Run Libdoc And Verify Output    $args    @{error}    ${USAGE_TIP[1:]}
        File Should Not Exist    $OUT_HTML
    ELSE
        Run Libdoc And Verify Output    $args    @{error}
        File Should Exist    $OUT_HTML
    END
