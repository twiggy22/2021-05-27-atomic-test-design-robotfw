*** Settings ***
Library     SeleniumLibrary
Library     DateTime

Resource    ../Common.robot

*** Test Cases ***
Add New Card Test
    [Setup]     Run keywords    Open Browser    ${LOGIN URL}    ${BROWSER}    AND     Login   AND     Open Board
    [Teardown]  Run Keywords    Archive Card    ${card name}    AND     Close Browser
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
    Wait Until Element Is Visible    ${CARD ELEMENT}\[text()="${card name}"]
    Page Should Contain Element    ${CARD ELEMENT}\[text()="${card name}"]     limit=1  # card should be displayed once only

Archive Card
    [Arguments]     ${card name}
    Open Context Menu    ${CARD ELEMENT}\[text()="${card name}"]
    Click Element    class=js-archive