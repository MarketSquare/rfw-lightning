*** Settings ***
Test Template      Should Be Equal
Resource           catenate_scalars_in_variable_table.resource

*** Variables ***
${DEFAULT_SEP}     Values    catenated    with    space    by    default
${NEWLINE_SEP}     SEPARATOR=\n    Newline    used    as    custom separator
${EMPTY_SEP}       SEPARATOR=    Empty    string    as separator
${SEPARATOR}       ---
${VARIABLE_SEP}    SEPARATOR=${SEPARATOR}    Variable    as    separator
${EXTENDED_SEP}    SEPARATOR=${SPACE*3}    Extended variable    as    separator
${NON_STRING_SEP}  SEPARATOR=${42}    Separator    is    not    string
${NONEX_IN_SEP}    SEPARATOR=${NON_EXISTING}    This fails
${VARIABLE_VALUE}  ${EMPTY_SEP}    ${SPACE}    ...
${NON_STRING_1}    ${0}    1    ${2.0}    ${True}
${NON_STRING_2}    SEPARATOR=-    ${0}    1    ${2.0}    ${True}
@{VALUES}          1    2    ${3}    ${4}    5
${LIST_VALUES}     @{VALUES}
${LIST_EMPTY}      @{EMPTY}
${LIST_EXTENDED}   @{VALUES[1:-1]}
${LIST_INTERNAL}   @{${DEFAULT_SEP.split()[${0}]}_[${1}:${-1}]}
${LIST_WITH_SEP_1}   SEPARATOR=${EMPTY}    0    @{VALUES}    6    ${7}    8    9
...                ${SPACE}    ${0}    @{VALUES}    6789
${LIST_WITH_SEP_2}   SEPARATOR=${SEPARATOR.split()}[0]    @{NON_STRING_1.split()}
${NONEX_IN_VALUE}  Having    ${NON_EXISTING}    variable    causes    failure
${ESCAPED}         \SEPARATOR=Default    separator    used
${NON_UPPER_1}     separator=not    upper
${NON_UPPER_2}     Separator=Not    upper
${NOT_FIRST_1}     This    SEPARATOR=is not    first    and    thus    not used
${NOT_FIRST_2}     SEPARATOR==    Only    first    SEPARATOR=    is    used
@{NOT_SEPARATOR}   SEPARATOR=This    is    not    separator
${NO_SEPARATOR_1}  @{NOT_SEPARATOR}
${NO_SEPARATOR_2}  ${NOT_SEPARATOR}[0]    not    separator    either
${NO_SEPARATOR_3}  ${NOT_SEPARATOR[0]}    neither
${NO_VALUES}
# Testing that one scalar variable alone is not converted to string.
${NON_STRING_RESULT_1}    ${42}
${NON_STRING_RESULT_2}    ${VALUES}
${NON_STRING_RESULT_3}    ${VALUES}[2]
${STRING_RESULT_1}        SEPARATOR=    ${42}
${STRING_RESULT_2}        SEPARATOR=whatever    ${VALUES[2:4]}
${STRING_RESULT_3}        ${42}    ${VALUES}[2]

*** Test Cases ***
Default separator is space
    ${DEFAULT_SEP}       Values catenated with space by default

Custom separator
    ${NEWLINE_SEP}       Newline\nused\nas\ncustom separator
    ${EMPTY_SEP}         Emptystringas separator

Custom separator from variable
    ${VARIABLE_SEP}      Variable---as---separator
    ${EXTENDED_SEP}      Extended variable${SPACE*3}as${SPACE*3}separator

Non-string separator
    ${NON_STRING_SEP}    Separator42is42not42string

Non-existing variable in separator
    [Template]    Variable should not exist
    ${NONEX_IN_SEP}

Value containing variables
    ${VARIABLE_VALUE}    Emptystringas separator${SPACE*3}...
    ${NON_STRING_1}      0 1 2.0 True
    ${NON_STRING_2}      0-1-2.0-True

Value containing list variables
    ${LIST_VALUES}       1 2 3 4 5
    ${LIST_EMPTY}        ${EMPTY}
    ${LIST_EXTENDED}     2 3 4
    ${LIST_INTERNAL}     2 3 4
    ${LIST_WITH_SEP_1}     0123456789 0123456789
    ${LIST_WITH_SEP_2}     0---1---2.0---True

Non-existing variable in value
    [Template]    Variable should not exist
    ${NONEX_IN_VALUE}

'SEPARATOR=' can be escaped
    ${ESCAPED}           SEPARATOR=Default separator used

'SEPARATOR=' must be upper case
    ${NON_UPPER_1}       separator=not upper
    ${NON_UPPER_2}       Separator=Not upper

'SEPARATOR=' must be first
    ${NOT_FIRST_1}       This SEPARATOR=is not first and thus not used
    ${NOT_FIRST_2}       Only=first=SEPARATOR==is=used

'SEPARATOR=' cannot come from variable
    ${NO_SEPARATOR_1}    SEPARATOR=This is not separator
    ${NO_SEPARATOR_2}    SEPARATOR=This not separator either
    ${NO_SEPARATOR_3}    SEPARATOR=This neither

Having no values creates empty string
    ${NO_VALUES}         ${EMPTY}

One scalar variable is not converted to string
    ${NON_STRING_RESULT_1}    ${42}
    ${NON_STRING_RESULT_2}    ${VALUES}
    ${NON_STRING_RESULT_3}    ${3}

With separator even one scalar variable is converted to string
    ${STRING_RESULT_1}        42
    ${STRING_RESULT_2}        [3, 4]
    ${STRING_RESULT_3}        42 3

Catenated in resource 1
    ${CATENATED_IN_RESOURCE_1}    aaabbbcccddd
    ${CATENATED_IN_RESOURCE_2}    1sep2
