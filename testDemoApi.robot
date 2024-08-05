*** Settings ***
Library    Collections

*** Test Cases ***
Play Around with Dictionary
    &{data} =    Create Dictionary    name=shalini    course=robot    website=rahulshettyacademy.com
    Log    ${data}
    Dictionary Should Contain Key    ${data}    name
    Log    ${data}[name]
    ${url} =    Get From Dictionary    ${data}    website
    Log    ${url}