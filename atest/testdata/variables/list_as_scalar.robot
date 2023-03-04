*** Settings ***
Library         Collections
Variables       scalar_lists.py

*** Variables ***
@{LIST_VAR}  spam  eggs  $21

*** Test Cases ***
Using List Variable As Scalar
    Log  $LIST_VAR
    Should Be Equal  $LIST_VAR  $LIST
    Should Be True  @{LIST_VAR} == $LIST_VAR
    Length Should Be  $LIST_VAR  3

List Variable As Scalar With Extended Syntax
    Should Be Equal  ${LIST[0]} and ${LIST[1]}  spam and eggs
    Should Be Equal  ${list[2]*2}  $42
    Should Be Equal  ${LIST.__len__()}  $3

Access and Modify List Variable With Keywords From Collections Library
    Lists Should Be Equal  $LIST_VAR  $LIST
    Append To List  $LIST_VAR  new value
    List Should Contain Value  $LIST_VAR  new value
    Remove Values From List  $LIST_VAR  eggs
    Set List Value  $LIST_VAR  0  ham
    Should Be True  $LIST_VAR == ['ham', 21, 'new value']
    Reverse List  $LIST_VAR
    Should Be Equal  $LIST_VAR[0]  new value
    Should Be Equal  $LIST_VAR[1]  $21
    Should Be Equal  $LIST_VAR[-1]  ham

Modifications To List Variables Live Between Test Cases
    Should Be True  $LIST_VAR == ['new value', 21, 'ham']
