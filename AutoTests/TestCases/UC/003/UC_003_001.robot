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
Pre-condition - #UC_003_001
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

Testing - #UC_003_001
    ## ----------------------------------------    Logging in:
    Click Element    ${e_button_login}
    Wait Until Element Is Visible    ${button_login_confirm}
    Input Text    //input[@type='email']    ${email}
    Input Text    //input[@type='password']    ${password}
    Click Button    ${button_login_confirm}
    
    ## ----------------------------------------    Checking if logged in successfully:
    Wait Until Location Is    https://www.lokni-shop.cz/klient/
    Wait Until Element Is Visible    ${l_button_account}

    ## ----------------------------------------    Changing account's name:
    Click Link    //a[@href='/klient/nastaveni/']
    Wait Until Location Is    https://www.lokni-shop.cz/klient/nastaveni/
    Input Text    //input[@id='billFullName']    ${name_1}
    Input Text    //input[@id='currentPassword']    ${password}
    Click Element    //input[@type='submit']

    ## ----------------------------------------    Expected result:
   Element Should Be Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]
    ${name_result}=    Get Element Attribute    //input[@id='billFullName']    value
    Should Be Equal    ${name_result}    Jakub Bandík
    
Post-condition - #UC_003_001
    ## ----------------------------------------    Changing account's name back:
    Wait Until Element Is Not Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]    8s
    Input Text    //input[@id='billFullName']    ${name_original}
    Input Text    //input[@id='currentPassword']    ${password}
    Click Element    //input[@type='submit']

    ## ----------------------------------------    Checking if account's name was changed successfully:
    Element Should Be Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]
    ${name_result}=    Get Element Attribute    //input[@id='billFullName']    value
    Should Be Equal    ${name_result}    Zdeněk Šembera

    Close Browser
