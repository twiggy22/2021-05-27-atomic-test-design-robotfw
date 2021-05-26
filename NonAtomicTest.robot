*** Settings ***
Library     SeleniumLibrary
Library     DateTime

Resource    Common.robot

*** Variables ***
# TEST DATA
${HOST URL} =   https://trello.com
${BROWSER} =    chrome
${USERNAME} =   %{RF_USERNAME}     #stored in system environment variables
${PASSWORD} =   %{RF_PASSWORD}     #stored in system environment variables

# ELEMENT SELECTORS
${CARD ELEMENT} =      xpath=//*[contains(@class,"list-card-title")]

*** Test Cases ***
Create New Card Test
    [Setup]     Open Browser    ${HOST URL}/login      ${BROWSER}
    [Teardown]  Run Keywords    Archive Card    ${card name}    AND     Close Browser
    Login
    Open Board
    ${card name} =  Generate Unique Card Name
    Add New Card    ${card name}
    Verify Card Is Displayed    ${card name}

Board Display Test
    [Setup]     Open Browser    ${HOST URL}/login      ${BROWSER}
    [Teardown]  Run Keywords    Close Browser
    Login
    Open Board
    Verify Board Header
    Verify List Titles
    Verify Add New List Option

*** Keywords ***
Login
    Input Text      id=user    ${USERNAME}
    Click Element   id=login
    Wait Until Element Is Not Visible    id=login
    Wait Until Element Is Visible    id=password
    Input Text      id=password    ${PASSWORD}
    Wait Until Element Is Enabled    id=login-submit
    Click Element    id=login-submit

Open Board
    Wait Until Element Is Visible    class=board-tile-details-name  10s
    Click Element    class=board-tile-details-name
    Wait Until Element Is Not Visible    class=board-tile-details-name

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

Verify Board Header
    Element Should Be Visible   css=button[data-test-id="board-views-switcher-button"]
    Element Text Should Be      css=button[data-test-id="board-views-switcher-button"]    Nástěnka
    Element Should Be Visible   css=.board-header h1
    Element Text Should Be      css=.board-header h1    První nástěnka

Verify List Titles
    Page Should Contain Element    class=list-header-name    limit=3     # there should be 3 lists displayed
    Element Text Should Be    css=.list-wrapper:nth-child(1) .list-header-name    Udělat
    Element Text Should Be    css=.list-wrapper:nth-child(2) .list-header-name    Probíhá
    Element Text Should Be    css=.list-wrapper:nth-child(3) .list-header-name    Hotovo

Verify Add New List Option
    Page Should Contain Element     class=js-add-list       limit=1
    Element Text Should Be          class=js-add-list       Přidej další sloupec