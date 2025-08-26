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
Pre-condition - #KO_002_004
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
    Wait Until Element Is Visible    ${button_product_addtocart}
    Wait Until Element Is Visible    (//div[@class='click-cart'])[1]

Testing - #KO_002_004
    ## ----------------------------------------    Adding product to cart:
    Click Button    ${button_product_addtocart}
    Wait Until Element Is Visible    ${button_addedproduct_back}
    Click Button    ${button_addedproduct_back}

    ## ----------------------------------------    Checking if product was added and increasing it's amount:
    Mouse Over    (//div[@class='click-cart'])[1]
    Wait Until Element Is Visible    //button[@data-testid='increase']
    Click Button    (//button[@data-testid='increase'])[1]
    
    ## ----------------------------------------    Expected result:
    Wait Until Element Is Visible    //span[@data-testid='notifierMessage' and contains(text(), 'Množství bylo úspěšně změněno.')]
    ${amount}=    Get Element Attribute    (//input[@data-testid='cartAmount'])[1]    value
    Should Be Equal    ${amount}    2

Post-condition - #KO_002_004
    Close Browser
