*** Settings ***
Variables  dyn_vars.py  dict
Variables  dyn_vars.py  mydict
Variables  dyn_vars.py  Mapping
Variables  dyn_vars.py  UserDict
Variables  dyn_vars.py  MyUserDict

*** Test Cases ***
Variables From Dict Should Be Loaded
    Should Be Equal  ${from_dict}  This From Dict
    Should Be Equal  ${from_dict2}  ${2}

Variables From My Dict Should Be Loaded
    Should Be Equal  ${from_my_dict}  This From My Dict
    Should Be Equal  ${from_my_dict2}  ${2}

Variables From Mapping Should Be Loaded
    Should Be Equal  ${from_Mapping}  This From Mapping
    Should Be Equal  ${from_Mapping2}  ${2}

Variables From UserDict Should Be Loaded
    Should Be Equal  ${from_userdict}  This From UserDict
    Should Be Equal  ${from_userdict2}  ${2}

Variables From My UserDict Should Be Loaded
    Should Be Equal  ${from_my_userdict}  This From MyUserDict
    Should Be Equal  ${from_my_userdict2}  ${2}
