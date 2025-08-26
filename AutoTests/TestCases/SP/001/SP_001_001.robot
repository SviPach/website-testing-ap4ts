*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #SP_001_001
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

Testing - #SP_001_001
    ## ----------------------------------------    Going to page "Domácí filtrace":
    Click Link    ${panel_sidebar}//a[@href='/domaci-filtrace/']
    Wait Until Location Is    https://www.lokni-shop.cz/domaci-filtrace/
    Click Element    //label[@for='order2']
    
    ## ----------------------------------------    Getting product count on the page:
    ${product_count}=    Get Element Count    //div[contains(@class, 'product no-code')]
    Log    Product count: ${product_count}
    Run Keyword If    ${product_count} == 0    Fail    No products!
    Run Keyword If    ${product_count} == 1    Fail    Not enough of products to test!

    ## ----------------------------------------    Getting all the products and checking their prices:
    @{products_list}=    Get Webelements    //div[@id='products']/div[@class='product no-code']
    FOR    ${product}    IN    @{products_list}
        ${product_price_first}=    Get Text    (//div[@data-testid='productCards']//div[@class='price price-final']/strong)[${product_count}]
        ${product_price_first}=    Evaluate    "".join(c for c in "${product_price_first}" if c.isdigit())
        Log    1st product's price: ${product_price_first}
        ${product_count}=    Evaluate    ${product_count} - 1
        ${product_price_second}=    Get Text    (//div[@data-testid='productCards']//div[@class='price price-final']/strong)[${product_count}]
        ${product_price_second}=    Evaluate    "".join(c for c in "${product_price_second}" if c.isdigit())
        Log    2nd product's price: ${product_price_second}

        ## ----------------------------------------    Converting to numbers:
        ${num1}=    Convert To Number    ${product_price_first}
        ${num2}=    Convert To Number    ${product_price_second}

        ## ----------------------------------------    Expected result:
        Should Be True    ${num1} > ${num2}    msg=First number must be greater than the second one!
        Log    ${num1} is greater than ${num2}!

        ## ----------------------------------------    Loop exit condition:
        Run Keyword If    ${product_count} == 1    Exit For Loop
    END

Post-condition - #SP_001_001
    Close Browser
