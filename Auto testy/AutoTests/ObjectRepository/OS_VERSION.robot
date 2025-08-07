*** Settings ***
Library    OperatingSystem

*** Variables ***
${MIN_WINDOWS_VERSION}    11

*** Keywords ***
Get Windows Version Info
    ${output}=    Run    systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
    RETURN    ${output}

Verify Windows Version
    ${version_info}=    Get Windows Version Info
    Should Contain    ${version_info}    Windows ${MIN_WINDOWS_VERSION}    msg=Need Windows ${MIN_WINDOWS_VERSION} or newer!