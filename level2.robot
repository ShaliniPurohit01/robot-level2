*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...                 Saves the order HTML receipt as a PDF file.
...                 Saves the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archive of the receipts and the images.
Library             RPA.Browser.Selenium    auto_close=${False}
Library             RPA.HTTP
Library             RPA.Tables
Library             OperatingSystem
Library             RPA.Desktop
Library             RPA.PDF
Library             RPA.Smartsheet
Library             RPA.Archive
*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open website to order
    Download file
    Read csv file as table
    Zip the pdfs
*** Keywords ***
Open website to order
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
Download file
    Download
    ...    https://robotsparebinindustries.com/orders.csv
    # ...        ...    https://robotsparebinindustries.com/orders.csv      https://1drv.ms/f/s!Aj1BcQrL4xUqgbAeQ_WFLRe0kWm3DQ?e=RwdVd0/dummy.csv
Read csv file as table
    ${orders}=    Read table from CSV    ${CURDIR}${/}orders.csv    header=${True}
    FOR    ${order}    IN    @{orders}
        Order robot for one person    ${order}
    END
Order robot for one person
    [Arguments]    ${order}
    Click Button When Visible    xpath://button[contains(text(),'Yep')]
    Select From List By Index    head    ${order}[Head]
    Select Radio Button    body    ${order}[Body]
    Input Text    xpath://input[@placeholder='Enter the part number for the legs']    ${order}[Legs]
    Input Text    address    ${order}[Address]
    Click Button    preview
    Wait Until Element Is Visible    robot-preview-image
    FOR    ${i}    IN RANGE    0    5
        Click Button    order
        ${element_visible}=    Run Keyword And Return Status    Element Should Be Visible    order-another
        IF    ${element_visible}    BREAK
        Sleep    1s
    END
    ${pdf}=    Store the receipt as a Pdf file    ${order}
    Click Button When Visible    order-another
Store the receipt as a Pdf file
    [Arguments]    ${order}
    Wait Until Element Is Visible    id:receipt
    ${receipt}=    Get Element Attribute    id:receipt    outerHTML
    ${screenshot}=    Take a screenshot of the robot    ${order}
    Html To Pdf    ${receipt}    output/${order}[Order number].pdf
    ${pdf_file}=    Set Variable    output/${order}[Order number].pdf
    Embed screenshot in pdf    ${screenshot}    ${pdf_file}
Take a screenshot of the robot
    [Arguments]    ${order}
    ${screenshot_path}=    Screenshot    id:robot-preview-image    output/${order}[Order number].png
    RETURN    ${screenshot_path}
Embed screenshot in pdf
    [Arguments]    ${screenshot}    ${pdf_file}
    Open Pdf    ${pdf_file}
    Add Watermark Image To Pdf    ${screenshot}    ${pdf_file}
    # Add Files To Pdf    ${screenshot}    ${pdf_file}
    Close Pdf
Zip the pdfs
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIR}/receipts.zip
    ${pdfs_path}=    Set Variable    output
    Archive Folder With Zip    ${pdfs_path}    ${zip_file_name}    *.pdf
