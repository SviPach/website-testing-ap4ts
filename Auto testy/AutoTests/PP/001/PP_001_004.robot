*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Library    Collections
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #PP_001_004
    ## ----------------------------------------    Setting up Selenium:
    Set Selenium Speed    0.2
    ## ----------------------------------------    Checking Windows version:
    Verify Windows Version
    Log    Windows version is OK!
    ## ----------------------------------------    Checking WI-FI status:
    Check WI-FI Status
    Log    Wi-Fi is ON!
    ## ----------------------------------------    Checking browser:
    Close browser if opened
    Log    Browser is closed!
    ## ----------------------------------------    Opening website:
    Open Browser    ${product_1}    chrome    options=add_argument("--no-sandbox")
    Wait Until Location Is    ${product_1}
    Log    Website opened!
    ## ----------------------------------------    Rejecting the cookies:
    Wait Until Element Is Visible    ${button_cookies_reject}
    Click Button    ${button_cookies_reject}
    ## ----------------------------------------    Checking website's elements to start TC:
    Wait Until Element Is Visible    //div[@class='p-thumbnails-wrapper']

Testing - #PP_001_004
    ## ----------------------------------------    Clicking the image next to the main on the panel:
    Click Element    //img[contains(@src, '92c8')]

    ## ----------------------------------------    Expected result:
    Element Should Not Be Visible    //div[@id='wrap']/a[contains(@href, '92c0')]
    Element Should Be Visible    //div[@id='wrap']/a[contains(@href, '92c8')]

Post-condition - #PP_001_004
    Close Browser
