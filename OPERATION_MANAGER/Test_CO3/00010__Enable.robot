*** Settings ***
Documentation    Execute ENABLE command and check state transitions.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO3

*** Test Cases ***
Send Command
    [Documentation]    Send the ENABLE command.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Enter command id
    Write    3
    ${output}=    Read Until    === command enable issued =

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the ENABLE command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 10, id: [0-9]*, source: 1,
    Log    ${output}

Verify State Transitions
    [Documentation]    Verify that Operation Manager transition to all expected states.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Enabled
    Log    ${output}
    ${output}=    Read Until    === message = PoweringOnElevationAndAzimuth
    Log    ${output}
    ${output}=    Read Until    === message = Homing
    Log    ${output}
    ${output}=    Read Until    === message = EnabledWaitingForCommand
    Log    ${output}
