*** Settings ***
Test Template     Time conversion should succeed
Library           DateTime
Variables         datesandtimes.py

*** Variables ***
${TIMEDELTA10}=Evaluate    datetime.timedelta(0,10)
${TIMEDELTA20}=Evaluate    datetime.timedelta(0,-2.3,0,0,-1)
${TIMEDELTA30}=Evaluate    datetime.timedelta(0,0,123457)
${TIMEDELTA40}=Evaluate    datetime.timedelta(2)
${TIMEDELTA50}=Evaluate    datetime.timedelta(0,0,500000)
${TIMEDELTA60}=Evaluate    datetime.timedelta(0,62)

*** Test Cases ***    INPUT              FORMAT       EXPECTED
Convert to number     10 s               number       ${10}
                      ${-62.3}           NUMBER       ${-62.3}
                      ${0.123456789}     number       ${0.123456789}
                      ${TIMEDELTA40}        NUMber       ${172800}
                      0.5                number       ${0.5}

Convert to string     10 s               verbose      10 seconds
                      ${-62.3}           VERBOSE      - 1 minute 2 seconds 300 milliseconds
                      ${0.123456789}     verbose      123 milliseconds
                      ${0.1239}          verbose      124 milliseconds
                      ${TIMEDELTA40}        VERbose      2 days
                      0.5                verbose      500 milliseconds

Convert to compact string
                      10 s               compact      10s
                      ${-62.3}           COMPACT      - 1min 2s 300ms
                      ${0.123456789}     compact      123ms
                      ${TIMEDELTA40}       COMpact      2d
                      0.5                compact      500ms

Convert to timer      10 s               timer        00:00:10.000
                      ${-62.3}           TIMER        -00:01:02.300
                      ${0.123456789}     timer        00:00:00.123
                      ${timedelta(5)}    TImeR        120:00:00.000
                      0.5                timer        00:00:00.500

Convert to timedelta
                      10 s               timedelta    ${TIMEDELTA10}
                      ${-62.3}           TIMEDELTA    ${TIMEDELTA20}
                      ${0.123456789}     timedelta    ${TIMEDELTA30}
                      ${TIMEDELTA40}        TIMEdelta    ${TIMEDELTA40}
                      0.5                timedelta    ${TIMEDELTA50}

Ignore millis         [Template]         Time conversion without millis should succeed
                      61.5               number       ${62}
                      61.5               verbose      1 minute 2 seconds
                      61.5               compact      1min 2s
                      61.5               timer        00:01:02
                      61.5               timedelta    ${TIMEDELTA60}
                      # Due to "bankers rounding" algorithm used by `round`, 0.5 is
                      # rounded to 0, not to 1, as we learned in school.
                      0.5                number       ${0}
                      1.5                number       ${2}

Number is float regardless are millis included or not
                      [Template]    Number format should be
                      ${1000.123}        1000.123     no
                      ${1000}            1000.0       ${0}
                      ${1000.123}        1000.0       ${1}
                      ${1000}            1000.0       no millis

Invalid format        [Documentation]    FAIL ValueError: Unknown format 'invalid'.
                      10s                invalid      0

*** Keywords ***
Time conversion should succeed
    [Arguments]    ${input}    ${format}    ${expected}
    ${result} =    Convert Time    ${input}    ${format}
    Should Be Equal    ${result}    ${expected}

Time conversion without millis should succeed
    [Arguments]    ${input}    ${format}    ${expected}
    ${result} =    Convert Time    ${input}    ${format}    exclude_millis=Yes
    Should Be Equal    ${result}    ${expected}

Number format should be
    [Arguments]    ${input}    ${expected}    ${millis}
    ${result} =    Convert Time    ${input}    result_format=number    exclude_millis=${millis}
    Should Be Equal As Strings    ${result}    ${expected}
