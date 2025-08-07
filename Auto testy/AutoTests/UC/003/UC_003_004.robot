*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/INPUT_DATA.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #UC_003_004
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

Testing - #UC_003_004
    ## ----------------------------------------    Logging in:
    Click Element    ${e_button_login}
    Wait Until Element Is Visible    ${button_login_confirm}
    Input Text    //input[@type='email']    ${email}
    Input Text    //input[@type='password']    ${password}
    Click Button    ${button_login_confirm}
    
    ## ----------------------------------------    Checking if logged in successfully:
    Wait Until Location Is    https://www.lokni-shop.cz/klient/
    Wait Until Element Is Visible    ${l_button_account}

    ## ----------------------------------------    Changing account's billing address:
    Click Link    //a[@href='/klient/nastaveni/']
    Wait Until Location Is    https://www.lokni-shop.cz/klient/nastaveni/
    Input Text    //input[@id='billStreet']    ${street_and_house_1}
    Input Text    //input[@id='billCity']    ${city_1}
    Input Text    //input[@id='billZip']    ${zip_1}
    Click Element    //select[@id='billCountryId']
    Wait Until Element Is Visible    //option[@data-code='SK']
    Click Element    //option[@data-code='SK']
    Input Text    //input[@id='currentPassword']    ${password}
    Click Element    //input[@type='submit']

    ## ----------------------------------------    Expected result:
    Element Should Be Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]
    ${street_and_house_result}=    Get Element Attribute    //input[@id='billStreet']    value
    ${city_result}=    Get Element Attribute    //input[@id='billCity']    value
    ${zip_result}=    Get Element Attribute    //input[@id='billZip']    value
    ${country_result}    Get Element Attribute    //option[@data-code='SK']    selected
    Should Be Equal    ${street_and_house_result}    ${street_and_house_1}
    Should Be Equal    ${city_result}    ${city_1}
    Should Be Equal    ${zip_result}    ${zip_1}
    Should Be Equal    ${country_result}    true

Post-condition - #UC_003_004
    ## ----------------------------------------    Changing account's billing address back:
    Wait Until Element Is Not Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]    10s
    Input Text    //input[@id='billStreet']    ${street_and_house_original}
    Input Text    //input[@id='billCity']    ${city_original}
    Input Text    //input[@id='billZip']    ${zip_original}
    Click Element    //select[@id='billCountryId']
    Wait Until Element Is Visible    //option[@data-code='CZ']
    Click Element    //option[@data-code='CZ']
    Input Text    //input[@id='currentPassword']    ${password}
    Click Element    //input[@type='submit']

    ## ----------------------------------------    Checking if account's billing address was changed successfully:
    Element Should Be Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]
    ${street_and_house_result}=    Get Element Attribute    //input[@id='billStreet']    value
    ${city_result}=    Get Element Attribute    //input[@id='billCity']    value
    ${zip_result}=    Get Element Attribute    //input[@id='billZip']    value
    ${country_result}    Get Element Attribute    //option[@data-code='CZ']    selected
    Should Be Equal    ${street_and_house_result}    ${street_and_house_original}
    Should Be Equal    ${city_result}    ${city_original}
    Should Be Equal    ${zip_result}    ${zip_original}
    Should Be Equal    ${country_result}    true

    Close Browser