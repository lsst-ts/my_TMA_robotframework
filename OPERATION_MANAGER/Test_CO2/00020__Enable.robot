*** Settings ***
Documentation    Execute ENABLE command and check command rejection in transitory states.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO2

*** Test Cases ***
Send ENABLE Command
    [Documentation]    Send the ENABLE command.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Enter command id
    Write    3
    ${output}=    Read Until    === command enable issued =

Verify Operation Manager Dispatches ENABLE Command
    [Documentation]    Verify that Operation Manager dispatches the ENABLE command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 10, id: [0-9]*, source: 1,
    Log    ${output}

Verify PoweringOnElevationAndAzimuth State
    [Documentation]    Verify that Operation Manager transition to PoweringOnElevationAndAzimuth state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = PoweringOnElevationAndAzimuth
    Log    ${output}

Send Command in PoweringOnElevationAndAzimuth State
    [Documentation]    Send the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    30
    ${output}=    Read Until    Enter azimuth angle:
    Write    105.218741
    ${output}=    Read Until    Enter elevation angle:
    Write    105.218741
    ${output}=    Read Until    Enter azimuth velocity:
    Write    2.660344
    ${output}=    Read Until    Enter elevation velocity:
    Write    2.660344
    ${output}=    Read Until    Enter cable wrap orientation (0 or 1):
    Write    0
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Command Rejection in PoweringOnElevationAndAzimuth State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
    
Verify Homing State
    [Documentation]    Verify that Operation Manager transition to Homing state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Homing
    Log    ${output}

Send Command in Homing State
    [Documentation]    Send the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    30
    ${output}=    Read Until    Enter azimuth angle:
    Write    105.218741
    ${output}=    Read Until    Enter elevation angle:
    Write    105.218741
    ${output}=    Read Until    Enter azimuth velocity:
    Write    2.660344
    ${output}=    Read Until    Enter elevation velocity:
    Write    2.660344
    ${output}=    Read Until    Enter cable wrap orientation (0 or 1):
    Write    0
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Command Rejection in Homing State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
    
Verify EnabledWaitingForCommand State
    [Documentation]    Verify that Operation Manager transition to EnabledWaitingForCommand state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = EnabledWaitingForCommand
    Log    ${output}
