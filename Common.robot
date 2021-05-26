*** Settings ***
Library     SeleniumLibrary
Library     DateTime

*** Variables ***
${HOST URL} =       https://trello.com
${BROWSER} =        chrome
${COOKIE TOKEN} =   %{RF_COOKIE_TOKEN}  #stored in system environment variables
${API KEY} =        %{RF_API_KEY}       #stored in system environment variables
${API TOKEN} =      %{RF_API_TOKEN}     #stored in system environment variables
${BOARD URL} =      ${HOST URL}/b/6IEzTDjp/první-nástěnka
${LIST ID} =        60887724faebbf4938c6588d

*** Keywords ***
Mock Login
    Add Cookie    token     ${COOKIE TOKEN}
    Add Cookie    loggedIn  1
    wait until element is visible       css=button[data-test-id="header-member-menu-button"]  # member menu button indicates successful login

Generate Unique Card Name
    [Return]    ${card name}
    ${date} =	Get Current Date  # get current timestamp to use in card name so that it's unique
    Set Local Variable   ${card name}  RobotFW ${date}