*** Settings ***
Variables    PythonClass.py
Variables    DynamicPythonClass.py    hello    world
Variables    InvalidClass.py

*** Test Cases ***
Python Class
    Should Be Equal    ${PYTHON_STRING}    hello
    Should Be Equal    ${PYTHON_INTEGER}    ${42}
    Should Be True    ${PYTHON_LIST} == ['a', 'b', 'c']

Methods in Python Class Do Not Create Variables
    Variable Should Not Exist    ${python_method}

Properties in Python Class
    Should Be Equal    ${PYTHON_PROPERTY}    value

Dynamic Python Class
    Should Be Equal    ${DYNAMIC_PYTHON_STRING}    hello world
    Should Be True    @{DYNAMIC_PYTHON_LIST} == ['hello', 'world']
    Should Be True    ${DYNAMIC_PYTHON_LIST} == ['hello', 'world']
