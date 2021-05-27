*** Settings ***
Library     SeleniumLibrary
Library     DateTime

*** Variables ***
# TEST DATA
${HOST URL} =       https://trello.com
${LOGIN URL} =      ${HOST URL}/login
${BOARD URL} =      ${HOST URL}/b/6IEzTDjp/první-nástěnka
${BROWSER} =        chrome
${USERNAME} =       %{RF_USERNAME}     #stored in system environment variables
${PASSWORD} =       %{RF_PASSWORD}     #stored in system environment variables
${COOKIE TOKEN} =   %{RF_COOKIE_TOKEN}  #stored in system environment variables
${API KEY} =        %{RF_API_KEY}       #stored in system environment variables
${API TOKEN} =      %{RF_API_TOKEN}     #stored in system environment variables
${LIST ID} =        60887724faebbf4938c6588d
${BOARD SWITCHER TITLE}=    Nástěnka
${BOARD HEADER TITLE}=      První nástěnka
@{BOARD LIST TITLES}=       Udělat      Probíhá     Hotovo
${ADD NEW BOARD LIST TITLE}=      Přidej další sloupec

# ELEMENT SELECTORS
${CARD ELEMENT} =      xpath=//*[contains(@class,"list-card-title")]

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

Mock Login
    Add Cookie    token     ${COOKIE TOKEN}
    Add Cookie    loggedIn  1
    wait until element is visible       css=button[data-test-id="header-member-menu-button"]  # member menu button indicates successful login

Generate Unique Card Name
    [Return]    ${card name}
    ${date} =	Get Current Date  # get current timestamp to use in card name so that it's unique
    Set Local Variable   ${card name}  RobotFW ${date}