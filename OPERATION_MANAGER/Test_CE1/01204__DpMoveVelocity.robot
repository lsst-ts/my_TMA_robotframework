*** Settings ***
Documentation    Execute DP_MOVE_VELOCITY command and get Ack/Done responses.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CE1

*** Test Cases ***
Send Command
    [Documentation]    Send the DP_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    1204
    ${output}=    Read Until    Enter ident:
    Write    1
    ${output}=    Read Until    Enter speed set point:
    Write    8.593507
    ${output}=    Read Until    Enter acceleration:
    Write    9.230355
    ${output}=    Read Until    Enter jerk:
    Write    1.782257
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the DP_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 1204, id: [0-9]*, source: 2,
    Log    ${output}

Verify PXI Message
    [Documentation]    Verify that message received by PXI contains same sent data.
    [Tags]    functional
    Switch Connection    Pxi
    ${output}=    Read Until Regexp    Received message:\\s[0-9][0-9]*\\\\n[0-9][0-9]*\\\\n1204\\\\n.*\\n
    Log    ${output}
    ${output}=    Replace String    ${output}    \\n    -
    Should Match Regexp    ${output}    [1-9][0-9]*-[1-9][0-9]*-1204-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{6}-1-8\\.593507-9\\.230355-1\\.782257

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

Send Stop Command
    [Documentation]    Send stop for the DP_MOVE_VELOCITY command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    1202
    ${output}=    Read Until    Enter drive ident:
    Write    1
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify PublishOnlyWaitingForCommand State
    [Documentation]    Verify that Operation Manager enters PublishOnlyWaitingForCommand state.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    PublishOnlyWaitingForCommand init
    Log    ${output}
    Should Contain    ${output}    PublishOnlyWaitingForCommand init

