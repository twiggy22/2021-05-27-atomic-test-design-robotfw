*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     Collections

Resource    ../Common.robot

Suite Setup     Run Keywords    Open Browser    ${BOARD URL}    ${BROWSER}      AND     Mock Login
Suite Teardown  Close Browser

*** Test Cases ***
Board Switcher Display Test
    Element Text Should Be      css=button[data-test-id="board-views-switcher-button"]    ${BOARD SWITCHER TITLE}

Board Header Display Test
    Element Text Should Be      css=.board-header h1    ${BOARD HEADER TITLE}

Board Lists Count Test
    ${list items count}=  Get Length  ${BOARD LIST TITLES}
    Page Should Contain Element    class=list-header-name    limit=${list items count}

Board List Titles Display Test
    ${n}=  set variable  1
    FOR  ${list title}  IN  @{BOARD LIST TITLES}
        Run Keyword And Continue On Failure
        ...  Element Text Should Be    css=.list-wrapper:nth-child(${n}) .list-header-name    ${list title}
        ${n}=   evaluate  ${n}+1
    END

Add New List Option Count Test
    Page Should Contain Element     class=js-add-list       limit=1

Add New List Option Display Test
    Element Text Should Be          class=js-add-list       ${ADD NEW BOARD LIST TITLE}