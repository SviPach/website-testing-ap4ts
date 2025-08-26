*** Settings ***
Library    OperatingSystem

*** Keywords ***
Check WI-FI status
    ${wifi_status}=    Run    netsh interface show interface "Wi-Fi"
    Should Contain    ${wifi_status}    Connected    msg=Wi-Fi is OFF!
    RETURN    ${wifi_status}