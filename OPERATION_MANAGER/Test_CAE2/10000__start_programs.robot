*** Settings ***
Documentation    Start the programs
Resource    ../../Global_Vars.robot
Library    SSHLibrary

*** Test Cases ***
Start SAL Event Logger 2
    [Documentation]    Run sal_event_logger program.
    [Tags]    functional
    Switch Connection    SALEventLogger
    Comment    Move to working directory.
    Write    cd ${TMAWorkDir}
    Comment    Start SAL Event Logger.
    Write    ./sal_event_logger
    ${output}=    Read Until    === [EventLog] Ready ...
    Log    ${output}
    Should Contain    ${output}     === [EventLog] Ready ...
    [Teardown]    Run Keyword If Test Failed    Log Shell Output    SALEventLogger

Start Operation Manager 2
    [Documentation]    Run operation_manager program (init in EnabledWaitingForCommand state).
    [Tags]    functional
    Switch Connection    OperationManager
    Comment    Move to working directory.
    Write    cd ${TMAWorkDir}
    Comment    Start Operation Manager.
    Write    ./operation_manager -s EnabledWaitingForCommand
    ${output}=    Read Until    Waiting for EUI client to establish connection...
    Log    ${output}
    Should Contain    ${output}     Waiting for EUI client to establish connection...
    [Teardown]    Run Keyword If Test Failed    Log Shell Output    OperationManager

Start Netcat 2
    [Documentation]    Run netcat program.
    [Tags]    functional
    Switch Connection    Netcat
    Comment    Start Netcat.
    Write    nc -l 60006

Start Eui Commander 2
    [Documentation]    Run send_eui_command program.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Move to working directory.
    Write    cd ${TMAWorkDir}
    Comment    Start Eui Commander.
    Write    ./send_eui_command
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Log    ${output}
    Should Contain    ${output}     Please enter a command id (or -1 to exit):
    [Teardown]    Run Keyword If Test Failed    Log Shell Output    Eui

Start SAL Commander 2
    [Documentation]    Run send_sal_command program.
    [Tags]    functional
    Switch Connection    SAL
    Comment    Move to working directory.
    Write    cd ${TMAWorkDir}
    Comment    Start SAL Commander.
    Write    ./send_sal_command
    ${output}=    Read Until    Please select an option :
    Log    ${output}
    Should Contain    ${output}     Please select an option :
    [Teardown]    Run Keyword If Test Failed    Log Shell Output    Eui

Start Pxi Simulator 2
    [Documentation]    Run pxi_simulator program.
    [Tags]    functional
    Switch Connection    Pxi
    Comment    Move to working directory.
    Write    cd ${TMAWorkDir}
    Comment    Start Pxi Simulator.
    Write    ./pxi_simulator
    ${output}=    Read Until    Operation Manager successfully connected.
    Log    ${output}
    Should Contain    ${output}     Operation Manager successfully connected.
    [Teardown]    Run Keyword If Test Failed    Log Shell Output    OperationManager

Verify EnabledWaitingForCommand State
    [Documentation]    Verify that Operation Manager enters EnabledWaitingForCommand state.
    [Tags]    functional
    Switch Connection    Netcat
    ${output}=    Read Until    EnabledWaitingForCommand
    Log    ${output}
    Should Contain    ${output}    EnabledWaitingForCommand
    [Teardown]    Run Keyword If Test Failed    Log Shell Output    OperationManager
