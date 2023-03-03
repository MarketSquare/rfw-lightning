*** Settings ***
Library          DateTime
Variables        datesandtimes.py
Test Template    Time Subtraction Should Succeed

*** Variables ***
${DATE1}=Evaluate           datetime.datetime(2014,4,24,21,45,12,123000)
${DATE2}=Evaluate           datetime.datetime(2014,4,24,22,45,12,123000)
${TIMEDELTA1}=Evaluate       datetime.timedelta(0,0,0,0,0,1)
${TIMEDELTA31}=Evaluate      datetime.timedelta(31)
${DATE3}=Evaluate            datetime.datetime(2015,11,1)
${DATE4}=Evaluate            datetime.datetime(2015,10,1)

*** Test Cases ***
Time subtraction from date should succeed
    ${DATE2}               1 hour                  ${DATE1}                datetime
    ${DATE2}               ${TIMEDELTA1}   ${DATE1}                datetime
    23:47:13 2014.04.24    01:02:01.000            22:45:12 2014.04.24     %H:%M:%S %Y.%m.%d    %H:%M:%S %Y.%m.%d
    23:47:13 2014.04.24    00:00:00.100            23:47:12 2014.04.24     %H:%M:%S %Y.%m.%d    %H:%M:%S %Y.%m.%d

Time subtraction over DST boundary
    2015-10-26                1 day                    2015-10-25 00:00:00.000    timestamp
    ${DATE3}    ${TIMEDELTA31}    ${DATE4}     datetime

*** Keywords ***
Time Subtraction Should Succeed
    [Arguments]    ${date}    ${time}    ${expected}    ${result_format}    ${date_format}=${NONE}
    ${new_date} =    Subtract Time From Date    ${date}    ${time}    ${result_format}    date_format=${date_format}
    Should Be Equal    ${new_date}    ${expected}
