*** Settings ***
Library     SeleniumLibrary
Library     DateTime

*** Variables ***
# TEST DATA
${HOST URL} =   https://trello.com
${BROWSER} =    chrome
${USERNAME} =   %{RF_USERNAME}     #stored in system environment variables
${PASSWORD} =   %{RF_PASSWORD}     #stored in system environment variables

# ELEMENT SELECTORS
${CARD ELEMENT} =      xpath=//*[contains(@class,"list-card-title")]

*** Test Cases ***
Create New Card in Trello
    [Setup]     Open Browser    ${HOST URL}/login      ${BROWSER}
    [Teardown]  Run Keywords    Archive Card    ${card name}    AND     Close Browser
    Login
    Open Board
    ${card name} =  Generate Unique Card Name
    Add New Card    ${card name}
    Verify Card Is Displayed    ${card name}

*** Keywords ***
Login
    Input Text      id=user    ${USERNAME}
    Click Element   id=login
    Wait Until Element Is Not Visible    id=login
    Wait Until Element Is Visible    id=password
    Input Text      id=password    ${PASSWORD}
    Wait Until Element Is Enabled    id=login-submit
    Click Element    id=login-submit
    
Generate Unique Card Name
    [Return]    ${card name}
    ${date} =	Get Current Date  # get current timestamp to use in card name so that it's unique
    Set Local Variable   ${card name}  RobotFW ${date}

Open Board
    Wait Until Element Is Visible    class=board-tile-details-name  10s
    Click Element    class=board-tile-details-name

Add New Card
    [Arguments]     ${card name}
    Wait Until Element Is Visible    class=open-card-composer
    Click Element    class=open-card-composer
    Input Text      class=list-card-composer-textarea    ${card name}
    Wait Until Element Is Enabled    class=confirm
    Click Element    class=confirm

Verify Card Is Displayed
    [Arguments]     ${card name}
    Wait Until Element Is Visible    ${CARD ELEMENT}\[text()="${card name}"]
    Page Should Contain Element    ${CARD ELEMENT}\[text()="${card name}"]     limit=1  # card should be displayed only once

Archive Card
    [Arguments]     ${card name}
    Open Context Menu    ${CARD ELEMENT}\[text()="${card name}"]
    Click Element    class=js-archive