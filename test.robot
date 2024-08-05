*** Settings ***
Documentation    To validate the login form
Library    SeleniumLibrary
Test Teardown    Close Browser
#Resource

*** Variables ***
${Error_Message_Login}    css:.alert-danger

*** Test Cases ***
Validate UnSuccesful Login
    open the browser with the mortgage payment url
    fill the login form
    wait until it checks and display error message
    verify error message is correct

Validate Cards Display in the Shopping Page



*** Keywords ***
open the browser with the mortgage payment url
    Create Webdriver    Chrome    executable_path=C:\\Users\\shali\\chromedriver-win64\\chromedriver.exe 
    Go To    https://rahulshettyacademy.com/loginpagePractise/
     
fill the login form
    Input Text        xpath://input[@id='username']    rahulshettyacademy 
    Input Password    id:password    56789789
    Click Button      signInBtn

wait until it checks and display error message
    Wait Until Element Is Visible    ${Error_Message_Login}
verify error message is correct
    # ${result}=     Get Text    ${Error_Message_Login}   
    # Should Be Equal As Strings    ${result}    Incorrect username/password.
    Element Text Should Be    ${Error_Message_Login}    Incorrect username/password.

Close Browser
