*** Settings ***
Documentation    Create all ssh connections
Library    SSHLibrary
Library    OperatingSystem
Resource    ../../ssh_connection.robot
Force Tags    connections

*** Variables ***
${timeout}    30 s

*** Test Cases ***
Create SAL Event Logger Session
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    SALEventLogger    ${timeout}

Testing stuff
	[Tags]    smoke
	${output}=    Run    pwd
	${output}=    Run    ls

Create Operation Manager Session
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    OperationManager    ${timeout}

Create Netcat Session
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    Netcat    ${timeout}

Create Pxi Simulator Session
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    Pxi    ${timeout}

Create Eui Commander Session
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    Eui    ${timeout}

Create SAL Commander Session
    [Documentation]    Connect to the TMA host.
    [Tags]    smoke
    Open SSH Connection    SAL    ${timeout}
