*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     Collections

Resource    Common.robot

Suite Setup     Run Keywords    Open Browser    ${BOARD URL}    ${BROWSER}      AND     Mock Login
Suite Teardown  Run keywords    Close Browser

*** Variables ***
${BOARD HEADER TITLE}=  První nástěnka
@{BOARD LIST TITLES}=   Udělat      Probíhá     Hotovo

*** Test Cases ***
Verify Board Switcher Text
    Element Should Be Visible   css=button[data-test-id="board-views-switcher-button"]
    Element Text Should Be      css=button[data-test-id="board-views-switcher-button"]    Nástěnka

Verify Board Header Text
    Element Should Be Visible   css=.board-header h1
    Element Text Should Be      css=.board-header h1    ${BOARD HEADER TITLE}

Verify Number of Board Lists
    ${list items count}=  get length  ${BOARD LIST TITLES}
    Page Should Contain Element    class=list-header-name    limit=${list items count}     # there should be 3 lists displayed

Verify Board List Titles
    ${i}=  set variable  1
    FOR  ${list title}  IN  @{BOARD LIST TITLES}
        Run Keyword And Continue On Failure
        ...  Element Text Should Be    css=.list-wrapper:nth-child(${i}) .list-header-name    ${list title}
        ${i}=   evaluate  ${i}+1
    END

Verify Add New List Option
    Page Should Contain Element     class=js-add-list       limit=1
    Element Text Should Be          class=js-add-list       Přidej další sloupec