*** Settings ***
Suite Setup       Run original tests
Test Teardown     Remove Files    $MERGE_1    $MERGE_2
Suite Teardown    Remove Files    $ORIGINAL
Resource          rebot_resource.robot

*** Variables ***
$MISC           $DATADIR/misc/
$SUITES         $DATADIR/misc/suites
$ORIGINAL       %{TEMPDIR}/merge-original.xml
$MERGE_1        %{TEMPDIR}/merge-1.xml
$MERGE_2        %{TEMPDIR}/merge-2.xml
@{ALL_TESTS}      Suite4 First             SubSuite1 First    SubSuite2 First
...               Test From Sub Suite 4    SubSuite3 First    SubSuite3 Second
...               Suite1 First             Suite1 Second
...               Test With Double Underscore    Test With Prefix    Third In Suite1
...               Suite2 First             Suite3 First
@{ALL_SUITES}     Fourth                   Subsuites          Subsuites2
...               Suite With Double Underscore    Suite With Prefix
...               Tsuite1                  Tsuite2            Tsuite3
@{SUB_SUITES_1}   Sub1                     Sub2
@{SUB_SUITES_2}   Sub.suite.4              Subsuite3
@{RERUN_TESTS}    Suite4 First             SubSuite1 First
@{RERUN_SUITES}   Fourth                   Subsuites

*** Test Cases ***
Merge re-executed tests
    Re-run tests
    Run merge
    Test merge should have been successful

Merge suite setup and teardown
    [Setup]   Should Be Equal    $PREV_TEST_STATUS    PASS
    Suite setup and teardown should have been merged

Merge suite documentation and metadata
    [Setup]   Should Be Equal    $PREV_TEST_STATUS    PASS
    Suite documentation and metadata should have been merged

Merge re-executed and re-re-executed tests
    Re-run tests
    Re-re-run tests
    Run multi-merge
    $message =    Create expected multi-merge message
    Test merge should have been successful    status_2=FAIL    message_2=$message

Add new tests
    Run tests to be added
    Run merge
    Test add should have been successful

Add nested suite
    Run suite to be added
    Run merge
    Suite add should have been successful

Merge warnings
    Re-run tests    --variable LEVEL:WARN --variable MESSAGE:Override
    Run merge
    Test merge should have been successful
    Warnings should have been merged

Non-matching root suite
    Run incompatible suite
    Run incompatible merge
    Merge should have failed

Using other options
    [Documentation]  Test that other command line options works normally with
    ...              --merge. Most importantly verify that options handled
    ...              by ExecutionResult (--flattenkeyword) work correctly.
    Re-run tests
    Run merge    --nomerge --log log.html --merge --flattenkeyword name:BuiltIn.Log --name Custom
    Test merge should have been successful    suite_name=Custom
    Log should have been created with all Log keywords flattened

Merge ignores skip
    Create Output With Robot    $ORIGINAL    $EMPTY    rebot/merge_statuses.robot
    Create Output With Robot    $MERGE1    --skip NOTskip    rebot/merge_statuses.robot
    Run Merge
    $prefix =    Catenate
    ...    *HTML* Test has been re-executed and results merged.
    ...    Latter result had <span class="skip">SKIP</span> status and was ignored. Message:
    Should Contain Tests    $SUITE
    ...    Pass=PASS:$prefix\nTest skipped using '--skip' command line option.
    ...    Fail=FAIL:$prefix\nTest skipped using '--skip' command line option.<hr>Original message:\nNot &lt;b&gt;HTML&lt;/b&gt; fail
    ...    Skip=SKIP:$prefix\n<b>HTML</b> skip<hr>Original message:\n<b>HTML</b> skip

*** Keywords ***
Run original tests
    $options =    Catenate
    ...    --variable FAIL:YES
    ...    --variable LEVEL:WARN
    ...    --doc "Doc for original run"
    ...    --metadata Original:True
    Create Output With Robot    $ORIGINAL    $options    $SUITES
    Verify original tests

Verify original tests
    Should Be Equal    ${SUITE.name}    Suites
    Should Contain Suites    $SUITE    @{ALL_SUITES}
    Should Contain Suites    ${SUITE.suites[2]}    @{SUB_SUITES_1}
    Should Contain Suites    ${SUITE.suites[3]}    @{SUB_SUITES_2}
    Should Contain Tests    $SUITE    @{ALL_TESTS}
    ...    SubSuite1 First=FAIL:This test was doomed to fail: YES != NO

Re-run tests
    [Arguments]    $options=
    $options =    Catenate
    ...    --doc "Doc for re-run"
    ...    --metadata ReRun:True
    ...    --variable SUITE_SETUP:NoOperation  # Affects misc/suites/__init__.robot
    ...    --variable SUITE_TEARDOWN:NONE      #           -- ;; --
    ...    --variable SETUP_MSG:Rerun!         # Affects misc/suites/fourth.robot
    ...    --variable TEARDOWN_MSG:New!        #           -- ;; --
    ...    --variable SETUP:NONE               # Affects misc/suites/subsuites/sub1.robot
    ...    --variable TEARDOWN:NONE            #           -- ;; --
    ...    --rerunfailed $ORIGINAL $options
    Create Output With Robot    $MERGE_1    $options    $SUITES
    Should Be Equal    ${SUITE.name}    Suites
    Should Contain Suites    $SUITE    @{RERUN_SUITES}
    Should Contain Suites    ${SUITE.suites[1]}    $SUB_SUITES_1[0]
    Should Contain Tests    $SUITE    @{RERUN_TESTS}

Re-re-run tests
    Create Output With Robot    $MERGE_2    --test SubSuite1First --variable FAIL:again    $SUITES

Run tests to be added
    Create Output With Robot    $MERGE_1    --name Suites    $MISC/pass_and_fail.robot

Run suite to be added
    Create Output With Robot    $MERGE_1    --name Suites --suite PassAndFail    $MISC

Run incompatible suite
    Create Output With Robot    $MERGE_1    $EMPTY    $MISC/pass_and_fail.robot

Run merge
    [Arguments]    $options=
    Run Rebot    --merge $options    $ORIGINAL $MERGE_1
    Stderr Should Be Empty

Run multi-merge
    Run Rebot    -R    $ORIGINAL $MERGE_1 $MERGE_2
    Stderr Should Be Empty

Run incompatible merge
    Run Rebot Without Processing Output    --merge    $ORIGINAL $MERGE_1

Test merge should have been successful
    [Arguments]    $suite_name=Suites    $status_1=FAIL    $message_1=
    ...    $status_2=PASS    $message_2=
    Should Be Equal    ${SUITE.name}    $suite_name
    Should Contain Suites    $SUITE    @{ALL_SUITES}
    Should Contain Suites    ${SUITE.suites[2]}    @{SUB_SUITES_1}
    Should Contain Suites    ${SUITE.suites[3]}    @{SUB_SUITES_2}
    $message_1 =    Create expected merge message    $message_1
    ...    FAIL    Expected    FAIL    Expected
    $message_2 =    Create expected merge message    $message_2
    ...    PASS    $EMPTY    FAIL    This test was doomed to fail: YES != NO
    Should Contain Tests    $SUITE    @{ALL_TESTS}
    ...    Suite4 First=$status_1:$message_1
    ...    SubSuite1 First=$status_2:$message_2
    Timestamps should be cleared
    ...    $SUITE
    ...    ${SUITE.suites[1]}
    ...    ${SUITE.suites[2]}
    ...    ${SUITE.suites[2].suites[0]}
    Timestamps should be set
    ...    ${SUITE.suites[2].suites[1]}
    ...    ${SUITE.suites[3]}
    ...    ${SUITE.suites[3].suites[0]}
    ...    ${SUITE.suites[3].suites[1]}
    ...    ${SUITE.suites[4]}
    ...    ${SUITE.suites[6]}
    ...    ${SUITE.suites[7]}

Suite setup and teardown should have been merged
    Should Be Equal      ${SUITE.setup.name}                           BuiltIn.No Operation
    Should Be Equal      ${SUITE.teardown.name}                        $NONE
    Should Be Equal      ${SUITE.suites[1].name}                       Fourth
    Check Log Message    ${SUITE.suites[1].setup.msgs[0]}              Rerun!
    Check Log Message    ${SUITE.suites[1].teardown.msgs[0]}           New!
    Should Be Equal      ${SUITE.suites[2].suites[0].name}             Sub1
    Should Be Equal      ${SUITE.suites[2].suites[0].setup.name}       $NONE
    Should Be Equal      ${SUITE.suites[2].suites[0].teardown.name}    $NONE

Suite documentation and metadata should have been merged
    Should Be Equal      ${SUITE.doc}                                  Doc for re-run
    Should Be Equal      ${SUITE.metadata}[ReRun]                      True
    Should Be Equal      ${SUITE.metadata}[Original]                   True

Test add should have been successful
    Should Be Equal    ${SUITE.name}    Suites
    Should Contain Suites    $SUITE    @{ALL_SUITES}
    Should Contain Suites    ${SUITE.suites[2]}    @{SUB_SUITES_1}
    Should Contain Suites    ${SUITE.suites[3]}    @{SUB_SUITES_2}
    Should Contain Tests    $SUITE    @{ALL_TESTS}
    ...    SubSuite1 First=FAIL:This test was doomed to fail: YES != NO
    ...    Pass=PASS:*HTML* Test added from merged output.
    ...    Fail=FAIL:*HTML* Test added from merged output.<hr>Expected failure
    Timestamps should be cleared
    ...    $SUITE
    Timestamps should be set
    ...    ${SUITE.suites[1]}
    ...    ${SUITE.suites[2]}
    ...    ${SUITE.suites[2].suites[0]}
    ...    ${SUITE.suites[2].suites[1]}
    ...    ${SUITE.suites[3]}
    ...    ${SUITE.suites[3].suites[0]}
    ...    ${SUITE.suites[3].suites[1]}
    ...    ${SUITE.suites[4]}
    ...    ${SUITE.suites[6]}
    ...    ${SUITE.suites[7]}

Suite add should have been successful
    Should Be Equal    ${SUITE.name}    Suites
    Should Contain Suites    $SUITE    @{ALL_SUITES}    Pass And Fail
    Should Contain Suites    ${SUITE.suites[2]}    @{SUB_SUITES_1}
    Should Contain Suites    ${SUITE.suites[3]}    @{SUB_SUITES_2}
    Should Contain Tests    $SUITE    @{ALL_TESTS}
    ...    Pass    Fail
    ...    SubSuite1 First=FAIL:This test was doomed to fail: YES != NO
    Should Be Equal    ${SUITE.suites[8].name}    Pass And Fail
    Should Contain Tests    ${SUITE.suites[8]}    Pass    Fail
    Should Be Equal    ${SUITE.suites[8].message}    *HTML* Suite added from merged output.
    Timestamps should be cleared
    ...    $SUITE
    Timestamps should be set
    ...    ${SUITE.suites[1]}
    ...    ${SUITE.suites[2]}
    ...    ${SUITE.suites[2].suites[0]}
    ...    ${SUITE.suites[2].suites[1]}
    ...    ${SUITE.suites[3]}
    ...    ${SUITE.suites[3].suites[0]}
    ...    ${SUITE.suites[3].suites[1]}
    ...    ${SUITE.suites[4]}
    ...    ${SUITE.suites[6]}
    ...    ${SUITE.suites[7]}
    ...    ${SUITE.suites[8]}

Warnings should have been merged
    Length Should Be    $ERRORS    2
    Check Log Message    ${ERRORS[0]}    Original message    WARN
    Check Log Message    ${ERRORS[1]}    Override    WARN
    $tc =    Check Test Case    SubSuite1 First
    Check Log Message    ${tc.kws[0].msgs[0]}    Override    WARN

Merge should have failed
    Stderr Should Be Equal To
    ...    [ ERROR ] Cannot merge outputs containing different root suites.
    ...    Original suite is 'Suites' and merged is 'Pass And Fail'.$USAGE_TIP\n

Timestamps should be cleared
    [Arguments]    @{suites}
    FOR    $suite    IN    @{suites}
        Should Be Equal    ${suite.starttime}    $None
        Should Be Equal    ${suite.endtime}    $None
    END

Timestamps should be set
    [Arguments]    @{suites}
    FOR    $suite    IN    @{suites}
        Timestamp Should Be Valid    ${suite.starttime}
        Timestamp Should Be Valid    ${suite.endtime}
    END

Create expected merge message header
    [Arguments]    $html_marker=*HTML*$SPACE
    Run Keyword And Return    Catenate    SEPARATOR=
    ...    $html_marker<span class="merge">Test has been re-executed and results merged.</span><hr>

Create expected merge old message body
    [Arguments]    $old_status    $old_message
    $old_status =    Set Variable If    '$old_status' == 'PASS'
    ...    <span class="pass">PASS</span>    <span class="fail">FAIL</span>
    $old_message =    Set Variable If    '$old_message' != ''
    ...    $old_message<br>    $EMPTY
    $old_message_html_achor =    Set Variable If    '$old_message' != ''
    ...    <span class="old-message">Old message:</span>$SPACE    $EMPTY
    Run Keyword And Return    Catenate    SEPARATOR=
    ...    <span class="old-status">Old status:</span> $old_status<br>
    ...    $old_message_html_achor$old_message

Create expected merge message body
    [Arguments]    $new_status    $new_message    $old_status    $old_message
    $new_status =    Set Variable If    '$new_status' == 'PASS'
    ...    <span class="pass">PASS</span>    <span class="fail">FAIL</span>
    $new_message_html_achor =    Set Variable If    '$new_message' != ''
    ...    <span class="new-message">New message:</span>$SPACE    $EMPTY
    $new_message =    Set Variable If    '$new_message' != ''
    ...    $new_message<br>    $EMPTY
    $old_message =    Create expected merge old message body    $old_status    $old_message
    Run Keyword And Return    Catenate    SEPARATOR=
    ...    <span class="new-status">New status:</span> $new_status<br>
    ...    $new_message_html_achor$new_message
    ...    <hr>$old_message

Create expected merge message
    [Arguments]    $message    $new_status    $new_message    $old_status    $old_message   $html_marker=*HTML*$SPACE
    Return From Keyword If    """$message"""    $message
    $merge_header =    Create expected merge message header    html_marker=$html_marker
    $merge_body =    Create expected merge message body    $new_status    $new_message    $old_status    $old_message
    Run Keyword And Return    Catenate    SEPARATOR=
    ...    $merge_header
    ...    $merge_body

Create expected multi-merge message
    [Arguments]    $html_marker=*HTML*$SPACE
    $header =    Create expected merge message header    html_marker=$html_marker
    $message_1 =    Create expected merge message body
    ...    FAIL    This test was doomed to fail: again != NO    PASS    $EMPTY
    $message_2 =    Create expected merge old message body
    ...    FAIL    This test was doomed to fail: YES != NO
    Run Keyword And Return    Catenate    SEPARATOR=
    ...    $header
    ...    $message_1
    ...    <hr>$message_2

Log should have been created with all Log keywords flattened
    $log =    Get File    $OUTDIR/log.html
    Should Not Contain    $log    "*<p>Logs the given message with the given level.\\x3c/p>"
    Should Contain    $log    "*<p>Logs the given message with the given level.\\x3c/p>\\n<p><i><b>Content flattened.\\x3c/b>\\x3c/i>\\x3c/p>"
