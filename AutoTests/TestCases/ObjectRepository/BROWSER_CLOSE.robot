*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Close browser if opened
    ${browser_open}=    Run Keyword And Return Status    Get Window Titles
    Run Keyword If    ${browser_open}    Close All Browsers