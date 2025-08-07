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
Pre-condition - #SP_001_003
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
    Wait Until Element Is Visible    ${panel_sidebar}
    Wait Until Element Is Visible    ${panel_sidebar}//a[@href='/domaci-filtrace/']

Testing - #SP_001_003
    ## ----------------------------------------    Going to page "Domácí filtrace":
    Click Link    ${panel_sidebar}//a[@href='/domaci-filtrace/']
    Wait Until Location Is    https://www.lokni-shop.cz/domaci-filtrace/
    Click Element    //label[@for='order5']

    ## ----------------------------------------    Getting product count on the page:
    ${product_count}=    Get Element Count    //div[contains(@class, 'product no-code')]
    Log    Product count: ${product_count}
    Run Keyword If    ${product_count} == 0    Fail    No products!
    Run Keyword If    ${product_count} == 1    Fail    Not enough of products to test!

     ## ----------------------------------------    Getting all the product's names:
    @{products_list}=    Get Webelements    //div[@id='products']/div[@class='product no-code']
    Log Many    @{products_list}
    ${counter}=    Set Variable    1
    ${products_names}    Create List
    FOR    ${product}    IN    @{products_list}
        ${name}=    Get Text    (//div[@data-testid='productCards']//span[@data-micro='name'])[${counter}]
        Append To List    ${products_names}    ${name}
        Log     ${name}
        ${counter}=    Evaluate    ${counter} + 1
        Run Keyword If    ${counter} == ${product_count} + 1    Exit For Loop
    END
    Log Many    Got names: @{products_names}

    ## ----------------------------------------    Sorting the names:
    ${products_names_sorted}=    Copy List    ${products_names}
    Sort List    ${products_names_sorted}
    Log Many    Sorted list: ${products_names_sorted}
    
    ## ----------------------------------------    Expected result:
    Lists Should Be Equal    ${products_names}    ${products_names_sorted}    msg=Products aren't sorted!

Post-condition - #SP_001_003
    Close Browser
