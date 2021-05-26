*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     Collections

Resource    Common.robot

Suite Setup     Run Keywords    Open Browser    ${BOARD URL}    ${BROWSER}      AND     Mock Login
Suite Teardown  Run keywords    Close Browser

*** Test Cases ***
Verify Board Switcher Text
    Element Should Be Visible   css=button[data-test-id="board-views-switcher-button"]
    Element Text Should Be      css=button[data-test-id="board-views-switcher-button"]    Nástěnka

Verify Board Header Text
    Element Should Be Visible   css=.board-header h1
    Element Text Should Be      css=.board-header h1    První nástěnka

Verify Number of Board Lists
    Page Should Contain Element    class=list-header-name    limit=3     # there should be 3 lists displayed

Verify Board List Titles
    Element Text Should Be    css=.list-wrapper:nth-child(1) .list-header-name    Udělat
    Element Text Should Be    css=.list-wrapper:nth-child(2) .list-header-name    Probíhá
    Element Text Should Be    css=.list-wrapper:nth-child(3) .list-header-name    Hotovo

Verify Add New List Option
    Page Should Contain Element     class=js-add-list       limit=1
    Element Text Should Be          class=js-add-list       Přidej další sloupec