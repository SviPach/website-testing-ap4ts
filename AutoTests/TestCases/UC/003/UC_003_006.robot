*** Settings ***
Library    SeleniumLibrary    run_on_failure=Nothing
Library    OperatingSystem
Library    Process
Resource    ObjectRepository/URL.robot
Resource    ObjectRepository/ELEMENTS.robot
Resource    ObjectRepository/INPUT_DATA.robot
Resource    ObjectRepository/OS_VERSION.robot
Resource    ObjectRepository/WIFI_STATUS.robot
Resource    ObjectRepository/BROWSER_CLOSE.robot


*** Test Cases ***
Pre-condition - #UC_003_006
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

Testing - #UC_003_006
    ## ----------------------------------------    Logging in:
    Click Element    ${e_button_login}
    Wait Until Element Is Visible    ${button_login_confirm}
    Input Text    //input[@type='email']    ${email}
    Input Text    //input[@type='password']    ${password}
    Click Button    ${button_login_confirm}

    ## ----------------------------------------    Checking if logged in successfully:
    Wait Until Location Is    https://www.lokni-shop.cz/klient/
    Wait Until Element Is Visible    ${l_button_account}


    Click Link    //a[@href='/klient/nastaveni/']
    Wait Until Location Is    https://www.lokni-shop.cz/klient/nastaveni/
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    ## ----------------------------------------    Checking if UC_003_005 is done:
    IF    ${count} != 1
        ## ----------------------------------------    Running UC_003_005:
        Log    UC_003_005 is not done yet!
        ${result}=    Run Process    robot    -d    results    UC/003/UC_003_005.robot
        Should Be Equal As Integers    ${result.rc}    0    Test UC_003_005 ended with error!

        ## ----------------------------------------    Deleting the delivery address:
        Reload Page
        Wait Until Element Is Visible    (//tbody/tr/td)[8]/a[@data-testid='buttonUniversalConfirm']
        Click Link    (//tbody/tr/td)[8]/a[@data-testid='buttonUniversalConfirm']
        Alert Should Be Present    Jste si jistí, že chcete smazat vybranou položku?    action=ACCEPT

        ## ----------------------------------------    Expected result:
        Wait Until Element Is Visible
        ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl úspěšně odstraněn.')]
        ${count}=    Get Element Count    //tbody/tr
        ${count}=    Convert To String    ${count}
        Log    Amount of delivery addresses: ${count}
        Should Be Equal    ${count}    0    msg=Has to be 0!
    ELSE
        ## ----------------------------------------    Deleting the delivery address:
        Click Link    (//tbody/tr/td)[8]/a[@data-testid='buttonUniversalConfirm']
        Alert Should Be Present    Jste si jistí, že chcete smazat vybranou položku?    action=ACCEPT
        
        ## ----------------------------------------    Expected result:
        Element Should Be Visible
        ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl úspěšně odstraněn.')]
        ${count}=    Get Element Count    //tbody/tr
        ${count}=    Convert To String    ${count}
        Log    Amount of delivery addresses: ${count}
        Should Be Equal    ${count}    0    msg=Has to be 0!
    END

Post-condition - #UC_003_006
    Close Browser