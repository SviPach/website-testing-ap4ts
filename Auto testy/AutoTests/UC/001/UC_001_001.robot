*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #UC_001_001
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
    Open Browser    ${URL_main}    chrome    options=add_argument("--no-sandbox")
    Wait Until Location Is    ${URL_main}
    Log    Website opened!
    ## ----------------------------------------    Rejecting the cookies:
    Wait Until Element Is Visible    ${button_cookies_reject}
    Click Button    ${button_cookies_reject}
    ## ----------------------------------------    Checking website's elements to start TC:
    Wait Until Element Is Visible    ${e_button_login}

Testing - #UC_001_001
    ## ----------------------------------------    Logging in:
    Click Element    ${e_button_login}
    Wait Until Element Is Visible    ${button_login_confirm}
    Click Button    ${button_login_confirm}

    ## ----------------------------------------    Expected result:
    Element Should Be Visible    //input[@type='email' and @class='form-control focus-visible']

Post-condition - #UC_001_001
    Close Browser
