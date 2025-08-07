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
Pre-condition - #KO_002_005
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

Testing - #KO_002_005
    ## ----------------------------------------    Adding product to cart:
    Click Button    ${button_product_addtocart}
    Wait Until Element Is Visible    ${l_button_addedproduct_cart}
    Click Link    ${l_button_addedproduct_cart}

    ## ----------------------------------------    Checking if product was added and checking it's available amount:
    Wait Until Element Is Visible    //tr[@data-testid='productItem_6542e0e2-0e30-11f0-ae65-8ee2ab6e4ccb']
    ${available_amount}=    Get Text    //span[@class='availability-amount']
    ${available_amount}=    Evaluate    "".join(c for c in "${available_amount}" if c.isdigit())
    Log    Available amount of product: ${available_amount}

    ## ----------------------------------------    Changing it's amount:
    ${unavailable_amount}=    Evaluate    ${available_amount} + 1
    Input Text    ${input_product_amount_set}   ${unavailable_amount}    

    
    ## ----------------------------------------    Expected result:
    Wait Until Element Is Visible    //span[@data-testid='notifierMessage' and contains(text(), 'Tento produkt má omezený počet kusů, které je možno zakoupit.')]
    ${amount_result}=    Get Text    //span[@class='availability-amount']
    ${amount_result}=    Evaluate    "".join(c for c in "${available_amount}" if c.isdigit())
    Should Be True    ${amount_result}    ${available_amount}

Post-condition - #KO_002_005
    Close Browser
