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
Pre-condition - #KO_001_003
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
    Wait Until Element Is Visible    ${button_product_amount_increase}

Testing - #KO_001_003
    ## ----------------------------------------    Adding product to cart:
    Click Button    ${button_product_amount_increase}
    Click Button    ${button_product_addtocart}
    Wait Until Element Is Visible    ${l_button_addedproduct_cart}
    Click Link    ${l_button_addedproduct_cart}
    Wait Until Location Is    https://www.lokni-shop.cz/kosik/

    ## ----------------------------------------    Expected result:
    Element Should Be Visible
    ...    //tr[@data-testid='productItem_6542e0e2-0e30-11f0-ae65-8ee2ab6e4ccb']

    ${amount}=    Get Element Attribute
    ...    //tr[@class='removeable']//input[@data-testid='cartAmount']    value

    Log    Amount of added same products: ${amount}
    Should Be Equal    ${amount}    2    msg='Amount of added same products has to be 2!'

Post-condition - #KO_001_003
    Close Browser
