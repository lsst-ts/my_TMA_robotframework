*** Settings ***
Documentation    Execute AZ_AXIS_STOP command and get Ack/Error responses.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CE2

*** Test Cases ***
Send Command
    [Documentation]    Send the AZ_AXIS_STOP command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    102
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the AZ_AXIS_STOP command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 102, id: [0-9]*, source: 2,
    Log    ${output}

Verify PXI Message
    [Documentation]    Verify that message received by PXI contains same sent data.
    [Tags]    functional
    Switch Connection    Pxi
    ${output}=    Read Until Regexp    Received message:\\s[0-9][0-9]*\\\\n[0-9][0-9]*\\\\n102\\\\n.*\\n
    Log    ${output}
    ${output}=    Replace String    ${output}    \\n    -

Read Ack
    [Documentation]    Verify that EUI receives Ack message sent from PXI.
    [Tags]    functional
    Switch Connection    Netcat
    ${output}=    Read Until Regexp    (?m)^0\\s+[1-9][0-9]*\\s+2\\s+[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}
    Log    ${output}

Verify ExecutingCommand State
    [Documentation]    Verify that Operation Manager enters ExecutingCommand state.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    ExecutingCommand init
    Log    ${output}
    Should Contain    ${output}    ExecutingCommand init

Send Error Event
    [Documentation]    Generate an error event.
    [Tags]    functional
    Switch Connection    Pxi
    Write    e 102
    ${output}=    Read Until    Simulator generated error event
    Log    ${output}
    Should Contain    ${output}    Simulator generated error event

Verify EUI Receives Error Event
    [Documentation]    Check that EUI receives Error event.
    [Tags]    functional
    Switch Connection    Netcat
    ${output}=    Read Until    Simulator generated error event
    Log    ${output}
    Should Contain    ${output}    Simulator generated error event

Verify PublishOnlyWaitingForCommand State
    [Documentation]    Verify that Operation Manager enters PublishOnlyWaitingForCommand state.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    PublishOnlyWaitingForCommand init
    Log    ${output}
    Should Contain    ${output}    PublishOnlyWaitingForCommand init

