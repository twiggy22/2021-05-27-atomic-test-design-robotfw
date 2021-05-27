*** Settings ***
Library     SeleniumLibrary
Library     DateTime

Resource    ../Common.robot

*** Test Cases ***
Board Display Test
    [Setup]     Run keywords    Open Browser    ${LOGIN URL}      ${BROWSER}    AND     Login   AND     Open Board
    [Teardown]  Close Browser
    # Verify Board Switcher Title
    Element Text Should Be      css=button[data-test-id="board-views-switcher-button"]    ${BOARD SWITCHER TITLE}

    # Verify Board Header Title
    Element Text Should Be      css=.board-header h1    ${BOARD HEADER TITLE}

    # Verify List Titles
    ${list items count}=  Get Length  ${BOARD LIST TITLES}
    Page Should Contain Element    class=list-header-name    limit=${list items count}
    ${i}=  set variable  1
    FOR  ${list title}  IN  @{BOARD LIST TITLES}
        Run Keyword And Continue On Failure
        ...  Element Text Should Be    css=.list-wrapper:nth-child(${i}) .list-header-name    ${list title}
        ${i}=   evaluate  ${i}+1
    END

    # Verify Add New List Option
    Page Should Contain Element     class=js-add-list       limit=1
    Element Text Should Be          class=js-add-list       ${ADD NEW BOARD LIST TITLE}