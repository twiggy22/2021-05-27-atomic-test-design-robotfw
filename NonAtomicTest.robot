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
    [Teardown]  Close Browser
    Login
    Open Board
    ${date} =	Get Current Date  # get current timestamp to use in card name so that it's unique
    Set Local Variable   ${card title}  Nová karta ${date}
    # create new card
    Add New Card    ${card title}
    # verify new card is present
    Verify Card Is Displayed    ${card title}
    # cleanup after test - archive created card
    Archive Card    ${card title}

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

Add New Card
    [Arguments]     ${card title}
    Wait Until Element Is Visible    class=open-card-composer
    Click Element    class=open-card-composer
    Input Text      class=list-card-composer-textarea    ${card title}
    Wait Until Element Is Enabled    class=confirm
    Click Element    class=confirm

Verify Card Is Displayed
    [Arguments]     ${card title}
    Wait Until Element Is Visible    ${CARD ELEMENT}\[text()="${card title}"]
    Page Should Contain Element    ${CARD ELEMENT}\[text()="${card title}"]     limit=1  # card should be displayed only once

Archive Card
    [Arguments]     ${card title}
    Open Context Menu    ${CARD ELEMENT}\[text()="${card title}"]
    Click Element    class=js-archive