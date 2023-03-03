*** Settings ***
Variables        valid.yaml
Variables        valid.yml
Variables        pythonpath.yaml
Variables        ./invalid.YAML
Variables        ..${/}variables${/}non_dict.yaml
Variables        valid.yaml    arguments    not    accepted
Variables        non_existing.Yaml
Variables        invalid_encoding.yaml
Test Template    Should Be Equal

*** Variables ***
@{EXPECTED_LIST}      one    ${2}
&{EXPECTED_DICT}      a=1    b=${2}    ${3}=${EXPECTED_LIST}    key with spaces=value with spaces

*** Test Cases ***
Valid YAML file
    ${STRING}     Hello, YAML!
    ${INTEGER}    ${42}
    ${FLOAT}      ${3.14}
    ${LIST}       ${EXPECTED_LIST}
    ${DICT}       ${EXPECTED_DICT}

Valid YML file
    ${STRING_IN_YML}     Hello, YML!
    ${INTEGER_IN_YML}    ${42}
    ${FLOAT_IN_YML}      ${3.14}
    ${LIST_IN_YML}       ${EXPECTED_LIST}
    ${DICT_IN_YML}       ${EXPECTED_DICT}

Non-ASCII strings
    ${NON}    äscii

Dictionary is dot-accessible
    ${DICT.a}                1
    ${DICT.b}                ${2}

Nested dictionary is dot-accessible
    ${NESTED_DICT.dict}      ${EXPECTED_DICT}
    ${NESTED_DICT.dict.a}    1
    ${NESTED_DICT.dict.b}    ${2}

Dictionary inside list is dot-accessible
    ${LIST_WITH_DICT[1].key}               value
    ${LIST_WITH_DICT[2].dict}              ${EXPECTED_DICT}
    ${LIST_WITH_DICT[2].nested[0].leaf}    value

YAML file in PYTHONPATH
    ${YAML_FILE_IN_PYTHONPATH}    ${TRUE}

Import Variables keyword
    [Setup]    Import Variables    ${CURDIR}/valid2.yaml
    ${VALID_2}    imported successfully

YAML file from CLI
    ${YAML_FILE_FROM_CLI}    woot!
    ${YML_FILE_FROM_CLI}     kewl!
