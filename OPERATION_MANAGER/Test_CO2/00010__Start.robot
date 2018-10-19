*** Settings ***
Documentation    Execute START command and check command rejection in transitory states.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO2

*** Test Cases ***
Send START Command
    [Documentation]    Send the START command.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Enter command id
    Write    1
    ${output}=    Read Until    === command start issued =

Verify Operation Manager Dispatches START Command
    [Documentation]    Verify that Operation Manager dispatches the START command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 8, id: [0-9]*, source: 1,
    Log    ${output}

Verify StoppingElevationAndAzimuth State
    [Documentation]    Verify that Operation Manager transition to StoppingElevationAndAzimuth state.
    [Tags]    functional
    Switch Connection    SALEventLogger   
    ${output}=    Read Until    === message = StoppingElevationAndAzimuth
    Log    ${output}

Send Command in StoppingElevationAndAzimuth State
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

Verify Command Rejection in StoppingElevationAndAzimuth State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
    
Verify StoppingMirrorCover State
    [Documentation]    Verify that Operation Manager transition to StoppingMirrorCover state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = StoppingMirrorCover
    Log    ${output}

Send Command in StoppingMirrorCover State
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

Verify Command Rejection in StoppingMirrorCover State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
    
Verify StoppingCameraCableWrap State
    [Documentation]    Verify that Operation Manager transition to StoppingCameraCableWrap state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = StoppingCameraCableWrap
    Log    ${output}
    
Send Command in StoppingCameraCableWrap State
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

Verify Command Rejection in StoppingCameraCableWrap State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
    
Verify DisabledPoweringOffElevationAndAzimuth State
    [Documentation]    Verify that Operation Manager transition to DisabledPoweringOffElevationAndAzimuth state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = DisabledPoweringOffElevationAndAzimuth
    Log    ${output}

Send Command in DisabledPoweringOffElevationAndAzimuth State
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

Verify Command Rejection in DisabledPoweringOffElevationAndAzimuth State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
        
Verify DisabledMirrorCoverPoweringOff State
    [Documentation]    Verify that Operation Manager transition to DisabledMirrorCoverPoweringOff state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = DisabledMirrorCoverPoweringOff
    Log    ${output}

Send Command in DisabledMirrorCoverPoweringOff State
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

Verify Command Rejection in DisabledMirrorCoverPoweringOff State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
    
Verify DisabledCameraCableWrapPoweringOff State
    [Documentation]    Verify that Operation Manager transition to DisabledCameraCableWrapPoweringOff state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = DisabledCameraCableWrapPoweringOff
    Log    ${output}

Send Command in DisabledCameraCableWrapPoweringOff State
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

Verify Command Rejection in DisabledCameraCableWrapPoweringOff State
    [Documentation]    Verify that Operation Manager rejects the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Operation manager is already executing a previous command.
    Log    ${output}
       
Verify DisabledWaitingForCommand State
    [Documentation]    Verify that Operation Manager transition to DisabledWaitingForCommand state.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = DisabledWaitingForCommand
    Log    ${output}
