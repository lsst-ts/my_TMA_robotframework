*** Settings ***
Documentation    Execute CLEAR_ERROR command and check state transitions.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO8

*** Test Cases ***
Send Command
    [Documentation]    Send the CLEAR_ERROR command.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Enter command id
    Write    14
    ${output}=    Read Until    === command clearerror issued =

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the CLEAR_ERROR command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 13, id: [0-9]*, source: 1,
    Log    ${output}

Verify State Transitions
    [Documentation]    Verify that Operation Manager transition to all expected states.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = StartClock
    Log    ${output}
    ${output}=    Read Until    === message = Offline
    Log    ${output}
    ${output}=    Read Until    === message = PublishOnly
    Log    ${output}
    ${output}=    Read Until    === message = PublishOnlyWaitingForCommand
    Log    ${output}
