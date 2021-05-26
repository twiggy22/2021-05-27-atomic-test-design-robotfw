*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     Collections

Resource    Common.robot

*** Test Cases ***
Create New Card Test
    [Setup]     Open Browser    ${BOARD URL}    ${BROWSER}
    [Teardown]  Run keywords    Close Browser   AND     Archive Card via API    ${card name}
    Mock Login
    ${card name} =  Generate Unique Card Name
    Add New Card    ${card name}
    Verify Card Is Displayed    ${card name}

*** Keywords ***
Add New Card
    [Arguments]     ${card name}
    Wait Until Element Is Visible    class=open-card-composer
    Click Element    class=open-card-composer
    Input Text      class=list-card-composer-textarea    ${card name}
    Wait Until Element Is Enabled    class=confirm
    Click Element    class=confirm

Verify Card Is Displayed
    [Arguments]     ${card name}
    Wait Until Element Is Visible   xpath=//*[contains(@class,"list-card-title")]\[text()="${card name}"]
    Page Should Contain Element     xpath=//*[contains(@class,"list-card-title")]\[text()="${card name}"]     limit=1  # should be displayed just once

Archive Card via API
    [Arguments]     ${card name}
    # first, get the list of cards
    Create Session    trello    ${HOST URL}
    ${resp}=  Get On Session    trello    url=${HOST URL}/1/lists/${LIST ID}/cards?fields=name&key=${API KEY}&token=${API TOKEN}
    ${api response}=    set variable    ${resp.json()}
    # search for the card by name
    FOR    ${card}     IN      @{api response}
        ${name}=    Get From Dictionary   ${card}     name
        IF  "${name}"=="${card name}"
            # delete the card
            ${resp}=  Delete On Session    trello    url=${HOST URL}/1/cards/${card['id']}?key=${API KEY}&token=${API TOKEN}
            Exit For Loop
        END
    END