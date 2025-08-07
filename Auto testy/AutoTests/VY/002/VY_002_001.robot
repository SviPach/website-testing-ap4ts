*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #VY_002_001
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
    Wait Until Element Is Visible    ${input_search}
    Wait Until Element Is Visible    ${button_search_confirm}

Testing - #VY_002_001
    ## ----------------------------------------    Searching for a products:
    Input Text    ${input_search}    Proaquap
    Click Element    ${button_search_confirm}
    Wait Until Location Is    https://www.lokni-shop.cz/vyhledavani/?string=Proaquap

    ## ----------------------------------------    Getting count of found products:
    ${product_count}=    Get Element Count    //div[contains(@class, 'product no-code')]
    Log    Product count: ${product_count}

    ## ----------------------------------------    Expected result:
    Should Be Equal As Numbers    ${product_count}    0    msg=Searched products were found!

Post-condition - #VY_002_001
    Close Browser
