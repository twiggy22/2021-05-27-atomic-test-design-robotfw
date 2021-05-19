*** Settings ***
Library     SeleniumLibrary
Library     DateTime
Library     RequestsLibrary
Library     Collections

*** Variables ***
# TEST DATA
${HOST URL} =       https://trello.com
${BROWSER} =        chrome
${COOKIE TOKEN} =   %{RF_COOKIE_TOKEN}  #stored in system environment variables
${API KEY} =        %{RF_API_KEY}       #stored in system environment variables
${API TOKEN} =      %{RF_API_TOKEN}     #stored in system environment variables
${BOARD URL} =      ${HOST URL}/b/6IEzTDjp/první-nástěnka
${LIST ID} =        60887724faebbf4938c6588d

*** Test Cases ***
Create New Card in Trello
    [Setup]     Open Browser    ${BOARD URL}      ${BROWSER}
    [Teardown]  Close Browser
    Mock Login
    ${date} =	Get Current Date  # get current timestamp to use in card name so that it's unique
    Set Local Variable   ${card title}  Nová karta ${date}
    # create new card
    Add New Card    ${card title}
    # verify new card is present
    Verify Card Is Displayed    ${card title}
    # cleanup after test - archive created card
    Archive Card via API    ${card title}

*** Keywords ***
Mock Login
    Add Cookie    token     ${COOKIE TOKEN}
    Add Cookie    loggedIn  1

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
    Wait Until Element Is Visible   xpath=//*[contains(@class,"list-card-title")]\[text()="${card title}"]
    Page Should Contain Element     xpath=//*[contains(@class,"list-card-title")]\[text()="${card title}"]     limit=1  # should be displayed just once

Archive Card via API
    [Arguments]     ${card title}
    # first, get the list of cards
    Create Session    trello    ${HOST URL}
    ${resp}=  Get On Session    trello    url=${HOST URL}/1/lists/${LIST ID}/cards?fields=name&key=${API KEY}&token=${API TOKEN}
    ${api response}=    set variable    ${resp.json()}
    # search for the card by name
    FOR    ${card}     IN      @{api response}
        ${name}=    Get From Dictionary   ${card}     name
        IF  "${name}"=="${card title}"
            # delete the card
            ${resp}=  Delete On Session    trello    url=${HOST URL}/1/cards/${card['id']}?key=${API KEY}&token=${API TOKEN}
            Exit For Loop
        END
    END