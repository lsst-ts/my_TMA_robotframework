*** Settings ***
Documentation    Execute TEC_TRACK_AMBIENT command and get Ack/Done responses.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CE4

*** Test Cases ***
Send Command
    [Documentation]    Send the TEC_TRACK_AMBIENT command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    2202
    ${output}=    Read Until    Enter on (0 or 1):
    Write    0
    ${output}=    Read Until    Enter temperature:
    Write    35.352093
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the TEC_TRACK_AMBIENT command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 2202, id: [0-9]*, source: 2,
    Log    ${output}

Verify PXI Message
    [Documentation]    Verify that message received by PXI contains same sent data.
    [Tags]    functional
    Switch Connection    Pxi
    ${output}=    Read Until Regexp    Received message:\\s[0-9][0-9]*\\\\n[0-9][0-9]*\\\\n2202\\\\n.*\\n
    Log    ${output}
    ${output}=    Replace String    ${output}    \\n    -
    Should Match Regexp    ${output}    [1-9][0-9]*-[1-9][0-9]*-2202-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{6}-0-35.352093

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

Verify Timed Out
    [Documentation]    Verify that Operation Manager times out waiting for Done-Error response.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    Timed out waiting for Done response for command
    Log    ${output}
    Should Contain    ${output}    Timed out waiting for Done response for command

Verify PublishOnlyWaitingForCommand State
    [Documentation]    Verify that Operation Manager enters PublishOnlyWaitingForCommand state.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until    PublishOnlyWaitingForCommand init
    Log    ${output}
    Should Contain    ${output}    PublishOnlyWaitingForCommand init

