*** Settings ***
Documentation    Execute STANDBY command and check state transitions.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO1

*** Test Cases ***
Send Command
    [Documentation]    Send the STANDBY command.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Enter command id
    Write    2
    ${output}=    Read Until    === command standby issued =

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the STANDBY command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 9, id: [0-9]*, source: 1,
    Log    ${output}

Verify State Transitions
    [Documentation]    Verify that Operation Manager transition to all expected states.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Standby
    Log    ${output}
