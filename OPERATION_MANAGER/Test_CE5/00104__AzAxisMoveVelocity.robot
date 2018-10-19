*** Settings ***
Documentation    Execute AZ_AXIS_MOVE_VELOCITY command and get Ack/Done responses.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CE5

*** Test Cases ***
Send Command
    [Documentation]    Send the AZ_AXIS_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    104
    ${output}=    Read Until    Enter speed set point:
    Write    1.653273
    ${output}=    Read Until    Enter acceleration:
    Write    1.522875
    ${output}=    Read Until    Enter jerk:
    Write    25.625476
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the AZ_AXIS_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 104, id: [0-9]*, source: 2,
    Log    ${output}

Verify PXI Message
    [Documentation]    Verify that message received by PXI contains same sent data.
    [Tags]    functional
    Switch Connection    Pxi
    ${output}=    Read Until Regexp    Received message:\\s[0-9][0-9]*\\\\n[0-9][0-9]*\\\\n104\\\\n.*\\n
    Log    ${output}
    ${output}=    Replace String    ${output}    \\n    -
    Should Match Regexp    ${output}    [1-9][0-9]*-[1-9][0-9]*-104-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{6}-1\\.653273-1\\.522875-25\\.625476

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

Send New Command
    [Documentation]    Send the AZ_AXIS_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    104
    ${output}=    Read Until    Enter speed set point:
    Write    3.202453
    ${output}=    Read Until    Enter acceleration:
    Write    5.116548
    ${output}=    Read Until    Enter jerk:
    Write    19.879176
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Command Rejected
    [Documentation]    Verify that Operation Manager rejects the command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Command execution not allowed in current state
    Log    ${output}
    Should Contain    ${output}    Command execution not allowed in current state

Send Stop Command
    [Documentation]    Send stop for the AZ_AXIS_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    102
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify PublishOnlyWaitingForCommand State
    [Documentation]    Verify that Operation Manager enters PublishOnlyWaitingForCommand state.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    PublishOnlyWaitingForCommand init
    Log    ${output}
    Should Contain    ${output}    PublishOnlyWaitingForCommand init

