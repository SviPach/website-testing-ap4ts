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
Pre-condition - #UC_003_007
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

Testing - #UC_003_007
    ## ----------------------------------------    Logging in:
    Click Element    ${e_button_login}
    Wait Until Element Is Visible    ${button_login_confirm}
    Input Text    //input[@type='email']    ${email}
    Input Text    //input[@type='password']    ${password}
    Click Button    ${button_login_confirm}
    
    ## ----------------------------------------    Checking if logged in successfully:
    Wait Until Location Is    https://www.lokni-shop.cz/klient/
    Wait Until Element Is Visible    ${l_button_account}

    ## ----------------------------------------    Checking if any other delivery address is added:
    Click Link    //a[@href='/klient/nastaveni/']
    Wait Until Location Is    https://www.lokni-shop.cz/klient/nastaveni/
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    Should Be Equal    ${count}    0    msg=Any other delivery address must not be added!

    ## ----------------------------------------    Adding first delivery address:
    Click Link    //a[@title='Přidat novou adresu']
    Input Text    //input[@id='deliveryFullName']    XXXXX
    Click Element    //input[@type='submit']
    Wait Until Location Is    https://www.lokni-shop.cz/klient/nastaveni/

    ## ----------------------------------------    Checking if first delivery address is added:
    Wait Until Element Is Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    Should Be Equal    ${count}    1    msg=Has to be 1!
    ${name_result}=    Get Text    (//tbody/tr/td)[1]
    Should Be Equal    ${name_result}    XXXXX

    ## ----------------------------------------    Adding second delivery address:
    Click Link    //a[@title='Přidat novou adresu']
    Input Text    //input[@id='deliveryFullName']    ${name_2}
    Input Text    //input[@id='deliveryStreet']    ${street_and_house_2}
    Input Text    //input[@id='deliveryCity']    ${city_2}
    Input Text    //input[@id='deliveryZip']    ${zip_2}
    Click Element    //select[@id='deliveryCountryId']
    Wait Until Element Is Visible    //option[@data-code='SK']
    Click Element    //option[@data-code='SK']
    Wait Until Element Is Not Visible    //div[@data-type='validatorZipCode']
    Click Element    //input[@type='submit']
    Wait Until Location Is    https://www.lokni-shop.cz/klient/nastaveni/

    ## ----------------------------------------    Checking if second delivery address is added:
    Wait Until Element Is Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl v pořádku uložen.')]
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    Should Be Equal    ${count}    2    msg=Has to be 2!
    ${name_result}=    Get Text    (//tbody/tr/td)[9]
    ${street_and_house_result}=    Get Text    (//tbody/tr/td)[10]
    ${city_result}=    Get Text    (//tbody/tr/td)[11]
    ${zip_result}=    Get Text    (//tbody/tr/td)[12]
    ${country_result}    Get Text    (//tbody/tr/td)[13]
    Should Be Equal    ${name_result}    ${name_2}
    Should Be Equal    ${street_and_house_result}    ${street_and_house_2}
    Should Be Equal    ${city_result}    ${city_2}
    Should Be Equal    ${zip_result}    ${zip_2}
    Should Be Equal    ${country_result}    Slovensko

    ## ----------------------------------------    Setting the second delivery address as default:
    Click Element    (//tbody/tr/td)[14]/a

    ## ----------------------------------------    Expected result:
    Element Should Be Visible    (//tbody/tr/td)[6]/span[@class='default-shipping-address icon-tick']
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    Should Be Equal    ${count}    2    msg=Has to be 2!
    ${name_result}=    Get Text    (//tbody/tr/td)[1]
    ${street_and_house_result}=    Get Text    (//tbody/tr/td)[2]
    ${city_result}=    Get Text    (//tbody/tr/td)[3]
    ${zip_result}=    Get Text    (//tbody/tr/td)[4]
    ${country_result}    Get Text    (//tbody/tr/td)[5]
    Should Be Equal    ${name_result}    ${name_2}
    Should Be Equal    ${street_and_house_result}    ${street_and_house_2}
    Should Be Equal    ${city_result}    ${city_2}
    Should Be Equal    ${zip_result}    ${zip_2}
    Should Be Equal    ${country_result}    Slovensko

Post-condition - #UC_003_007
    ## ----------------------------------------    Deleting the second delivery address:
    Click Link    (//tbody/tr/td)[8]/a[@data-testid='buttonUniversalConfirm']
    Alert Should Be Present    Jste si jistí, že chcete smazat vybranou položku?    action=ACCEPT
    
    ## ----------------------------------------    Checking if the second address is deleted:
    Wait Until Element Is Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl úspěšně odstraněn.')]
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    Should Be Equal    ${count}    1    msg=Has to be 1!

    ## ----------------------------------------    Deleting the first delivery address:
    Click Link    (//tbody/tr/td)[8]/a[@data-testid='buttonUniversalConfirm']
    Alert Should Be Present    Jste si jistí, že chcete smazat vybranou položku?    action=ACCEPT

    ## ----------------------------------------    Checking if the first address is deleted:
    Element Should Be Visible
    ...    //span[@data-testid='notifierMessage' and contains(text(), 'Záznam byl úspěšně odstraněn.')]
    ${count}=    Get Element Count    //tbody/tr
    ${count}=    Convert To String    ${count}
    Log    Amount of delivery addresses: ${count}
    Should Be Equal    ${count}    0    msg=Has to be 0!
    
    Close Browser