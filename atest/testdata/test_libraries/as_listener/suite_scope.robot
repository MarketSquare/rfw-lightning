*** Settings ***
Library           suite_listenerlibrary.py
Suite Setup       Events should be    Start suite: Suite Scope
                  ...                 Start kw: suite_listenerlibrary.Events Should Be
Suite Teardown    Events should be    Start suite: Suite Scope
                  ...                 Start kw: suite_listenerlibrary.Events Should Be
                  ...                 End kw: suite_listenerlibrary.Events Should Be
                  ...                 Start test: Suite scope library gets events
                  ...                 Start kw: suite_listenerlibrary.Events Should Be
                  ...                 End kw: suite_listenerlibrary.Events Should Be
                  ...                 End test: Suite scope library gets events
                  ...                 Start test: Suite scope library gets previous events in suite
                  ...                 Start kw: suite_listenerlibrary.Events Should Be
                  ...                 End kw: suite_listenerlibrary.Events Should Be
                  ...                 End test: Suite scope library gets previous events in suite
                  ...                 Start kw: suite_listenerlibrary.Events Should Be

*** Test Cases ***
Suite scope library gets events
    Events should be    Start suite: Suite Scope
    ...                 Start kw: suite_listenerlibrary.Events Should Be
    ...                 End kw: suite_listenerlibrary.Events Should Be
    ...                 Start test: $TEST_NAME
    ...                 Start kw: suite_listenerlibrary.Events Should Be

Suite scope library gets previous events in suite
    Events should be    Start suite: Suite Scope
    ...                 Start kw: suite_listenerlibrary.Events Should Be
    ...                 End kw: suite_listenerlibrary.Events Should Be
    ...                 Start test: $PREV_TEST_NAME
    ...                 Start kw: suite_listenerlibrary.Events Should Be
    ...                 End kw: suite_listenerlibrary.Events Should Be
    ...                 End test: $PREV_TEST_NAME
    ...                 Start test: $TEST_NAME
    ...                 Start kw: suite_listenerlibrary.Events Should Be
