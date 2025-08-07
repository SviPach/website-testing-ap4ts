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
Pre-condition - #PP_002_001
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
    Open Browser    ${product_3}    chrome    options=add_argument("--no-sandbox")
    Wait Until Location Is    ${product_3}
    Log    Website opened!
    ## ----------------------------------------    Rejecting the cookies:
    Wait Until Element Is Visible    ${button_cookies_reject}
    Click Button    ${button_cookies_reject}
    ## ----------------------------------------    Checking website's elements to start TC:
    ${element_exists}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    (//a[contains(text(), 'hodnocení')])[1]    2s
    IF    not ${element_exists}
        Wait Until Element Is Visible    (//a[contains(text(), 'hodnocení')])[2]
    END


Testing - #PP_002_001
    ## ----------------------------------------    Going to the rating tab:
    ${element_exists}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    (//a[contains(text(), 'hodnocení')])[1]    2s
    IF    not ${element_exists}
        Click Element    (//a[contains(text(), 'hodnocení')])[2]
    ELSE
        Click Element    (//a[contains(text(), 'hodnocení')])[1]
    END

    ## ----------------------------------------    Expected result:
    Element Should Not Be Visible
    ...    //html[@class='header-background-light external-fonts-loaded js-focus-visible']
    Element Should Be Visible
    ...    //html[@class='header-background-light external-fonts-loaded js-focus-visible scrolled scrolled-down']

Post-condition - #PP_002_001
    Close Browser
