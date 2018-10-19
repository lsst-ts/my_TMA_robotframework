*** Settings ***
Documentation    Close all ssh connections
Library    SSHLibrary
Force Tags    connections

*** Test Cases ***
Close SAL Event Logger Session 2
    [Documentation]    Close SAL Event Logger SSH connection.
    [Tags]    smoke
    Switch Connection    SALEventLogger
    Close Connection

Close Operation Manager Session 2
    [Documentation]    Close Operation Manager SSH connection.
    [Tags]    smoke
    Switch Connection    OperationManager
    Close Connection

Close Netcat Session 2
    [Documentation]    Close Netcat SSH connection.
    [Tags]    smoke
    Switch Connection    Netcat
    Close Connection

Close Pxi Simulator Session 2
    [Documentation]    Close Pxi Simulator SSH connection.
    [Tags]    smoke
    Switch Connection    Pxi
    Close Connection

Close Eui Commander Session 2
    [Documentation]    Close Eui Commander SSH connection.
    [Tags]    smoke
    Switch Connection    Eui
    Close Connection

Close SAL Commander Session 2
    [Documentation]    Close SAL Commander SSH connection.
    [Tags]    smoke
    Switch Connection    SAL
    Close Connection
