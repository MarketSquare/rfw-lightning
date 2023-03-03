*** Settings ***
Resource  import_resource_resource_resource.robot
Variables  import_resource_vars.py  VAR_FROM_VARFILE_X  ${VARFILE_VALUE}
Library  ${LIBRARY}

*** Variables ***
${VAR_FROM_IMPORT_RESOURCE_RESOURCE_RESOURCE}  value x
${LIBRARY}  OperatingSystem
${VARFILE_VALUE}  Default varfile value

*** Keywords ***
KW From Import Resource Resource Resource
    No Operation
