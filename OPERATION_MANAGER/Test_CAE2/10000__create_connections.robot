*** Settings ***
Documentation    Create all ssh connections
Library    SSHLibrary
Resource    ../../ssh_connection.robot
Force Tags    connections

*** Variables ***
${timeout}    30 s

*** Test Cases ***
Create SAL Event Logger Session 2
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    SALEventLogger    ${timeout}

Create Operation Manager Session 2
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    OperationManager    ${timeout}

Create Netcat Session 2
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    Netcat    ${timeout}

Create Pxi Simulator Session 2
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    Pxi    ${timeout}

Create Eui Commander Session 2
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    Eui    ${timeout}

Create SAL Commander Session 2
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    SAL    ${timeout}
