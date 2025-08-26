*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #VY_001_002
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

Testing - #VY_001_002
    ## ----------------------------------------    Searching for a products:
    Input Text    ${input_search}    Proaqua
    Wait Until Element Is Visible    //div[@class='search-whisperer active']

    ## ----------------------------------------    Getting count of found products:
    ${product_count}=    Get Element Count    //li[contains(@data-testid, 'productItem') or contains(@class, 'last-product')]
    Log    Product count: ${product_count}
    Run Keyword If    ${product_count} == 0    Fail    Searched products weren't found!

    ## ----------------------------------------    Getting products and checking their names:
    @{products_found}=    Get Webelements    //ul[@class='search-whisperer-products']/li
    FOR    ${product}    IN    @{products_found}
        ${product_name}=    Get Text    (//ul[@class='search-whisperer-products']/li)[${product_count}]
        Log    Product's name: ${product_name}

        ## ----------------------------------------    Expected result:
        Should Contain   ${product_name}    Proaqua    msg=Product name doesn't contain word "Proaqua"!
        ${product_count}=    Evaluate    ${product_count} - 1
    END

Post-condition - #VY_001_002
    Close Browser
