*** Settings ***
Test Template      Should Be Equal
Resource           catenate_scalars_in_variable_table.resource

*** Test Cases ***
Catenated in resource 2
    ${CATENATED_IN_RESOURCE_1}    aaabbbcccddd
    ${CATENATED_IN_RESOURCE_2}    1sep2
