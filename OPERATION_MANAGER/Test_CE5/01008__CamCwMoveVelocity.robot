*** Settings ***
Documentation    Execute CAM_CW_MOVE_VELOCITY command and get Ack/Done responses.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CE5

*** Test Cases ***
Send Command
    [Documentation]    Send the CAM_CW_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    1008
    ${output}=    Read Until    Enter speed set point:
    Write    8.301397
    ${output}=    Read Until    Enter acceleration:
    Write    4.160137
    ${output}=    Read Until    Enter jerk:
    Write    8.804722
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the CAM_CW_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 1008, id: [0-9]*, source: 2,
    Log    ${output}

Verify PXI Message
    [Documentation]    Verify that message received by PXI contains same sent data.
    [Tags]    functional
    Switch Connection    Pxi
    ${output}=    Read Until Regexp    Received message:\\s[0-9][0-9]*\\\\n[0-9][0-9]*\\\\n1008\\\\n.*\\n
    Log    ${output}
    ${output}=    Replace String    ${output}    \\n    -
    Should Match Regexp    ${output}    [1-9][0-9]*-[1-9][0-9]*-1008-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{6}-8\\.301397-4\\.160137-8\\.804722

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
    [Documentation]    Send the CAM_CW_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    1008
    ${output}=    Read Until    Enter speed set point:
    Write    10.296664
    ${output}=    Read Until    Enter acceleration:
    Write    7.583600
    ${output}=    Read Until    Enter jerk:
    Write    6.127539
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
    [Documentation]    Send stop for the CAM_CW_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    1002
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify PublishOnlyWaitingForCommand State
    [Documentation]    Verify that Operation Manager enters PublishOnlyWaitingForCommand state.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    PublishOnlyWaitingForCommand init
    Log    ${output}
    Should Contain    ${output}    PublishOnlyWaitingForCommand init

