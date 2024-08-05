*** Settings ***
Library    Collections
Library    RequestsLibrary

*** Variables ***
${Base_Url}    http://216.10.245.166

*** Test Cases ***
Add book into library database
    &{request_body}=    Create Dictionary    name=Robot framework   isbn=bcdsdf    aisle=227fxc    author=shaily
    ${response}=    POST    ${Base_Url}/Library/Addbook.php    json=${request_body}    expected_status=200
    Log    ${response.json()}
    Dictionary Should Contain Key    ${response.json()}    ID
    ${book_id}=    Get From Dictionary    ${response.json()}    ID
    Log     ${book_id}
    Should Be Equal As Strings    successfully added    ${response.json()}[Msg]
    Status Should Be    200    ${response}