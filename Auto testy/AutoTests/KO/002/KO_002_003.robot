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
Pre-condition - #KO_002_003
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

Testing - #KO_002_003
    ## ----------------------------------------    Adding product to cart:
    Click Button    ${button_product_addtocart}
    Wait Until Element Is Visible    ${button_addedproduct_back}
    Click Button    ${button_addedproduct_back}

    ## ----------------------------------------    Removing the product:
    Mouse Over    (//div[@class='click-cart'])[1]
    Wait Until Element Is Visible    //button[@data-testid='buttonDeleteItem']
    Click Button    //button[@data-testid='buttonDeleteItem']
    
    ## ----------------------------------------    Expected result:
    Element Should Be Visible    //span[@data-testid='notifierMessage' and contains(text(), 'Položka košíku byla odebrána.')]
    Page Should Contain    Košík je prázdný.

Post-condition - #KO_002_003
    Close Browser
