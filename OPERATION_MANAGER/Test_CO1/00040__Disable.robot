*** Settings ***
Documentation    Execute DISABLE command and check state transitions.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO1

*** Test Cases ***
Send Command
    [Documentation]    Send the DISABLE command.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Enter command id
    Write    4
    ${output}=    Read Until    === command disable issued =

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the DISABLE command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 11, id: [0-9]*, source: 1,
    Log    ${output}

Verify State Transitions
    [Documentation]    Verify that Operation Manager transition to all expected states.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Disabled
    Log    ${output}
    ${output}=    Read Until    === message = StoppingElevationAndAzimuth
    Log    ${output}
    ${output}=    Read Until    === message = StoppingMirrorCover
    Log    ${output}
    ${output}=    Read Until    === message = StoppingCameraCableWrap
    Log    ${output}
    ${output}=    Read Until    === message = DisabledPoweringOffElevationAndAzimuth
    Log    ${output}
    ${output}=    Read Until    === message = DisabledMirrorCoverPoweringOff
    Log    ${output}
    ${output}=    Read Until    === message = DisabledCameraCableWrapPoweringOff
    Log    ${output}
    ${output}=    Read Until    === message = DisabledWaitingForCommand
    Log    ${output}
