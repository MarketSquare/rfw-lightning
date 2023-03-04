*** Settings ***
Variables  import_resource_vars.py  VAR_FROM_VARFILE_1  VALUE FROM VARFILE 1
Resource  import_resource_resource_resource.robot


*** Variables ***
$VAR_FROM_IMPORT_RESOURCE_RESOURCE  value 1
$COMMON_VAR  resource 1


*** Keywords ***
KW From Import Resource Resource
    No Operation
