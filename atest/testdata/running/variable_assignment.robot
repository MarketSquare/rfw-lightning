*** Settings ***
Resource   variable_assignment.resource

*** Variables ***
${SUITEVAR}=Evaluate    5*5
${SUITEVAR2}=UK     bar

*** Test Cases ***
Variable assignment keyword call
    ${variable}=Evaluate   1+2+3
    Should Be Equal   ${variable}  ${6}

Variable assignment inside a keyword
    Variable assignment in a keyword

Variable assignment with library keyword from variables section
    Should Be Equal   ${SUITEVAR}  ${25}

Variable assignment with user keyword from variables section
    Should Be Equal   ${SUITEVAR2}  foo bar zoo

Variable assignment in a for loop
   FOR  ${i}  IN  1  2  3
        ${var}=Set Variable   ${i}
        Should Be Equal   ${var}   ${i}
   END
   Should Be Equal   ${var}   3

Variable assignment in if
   IF  1==1
        ${var}=Set Variable   if
        Should Be Equal   ${var}   if
   END
   Should Be Equal   ${var}   if

Variable assignment in try
   TRY
        ${var}=Set Variable   try
        Should Be Equal   ${var}   try
   FINALLY
        Should Be Equal   ${var}   try
   END

Variable assignment in while
   ${var}=Set Variable  0
   WHILE  ${var}==0
        ${var}=Set Variable   1
        Should Be Equal   ${var}   1
   END
   Should Be Equal   ${var}   1

Variable assignment from resource file
   Should Be Equal   ${NORMAL}  normal
   Should Be Equal   ${RESU}    mikko

*** Keywords ***
Variable assignment in a keyword
   ${another_var}=Set Variable      moikka
   Should Be Equal   ${another_var}   moikka

UK
   [Arguments]  ${arg}
   RETURN   foo ${arg} zoo