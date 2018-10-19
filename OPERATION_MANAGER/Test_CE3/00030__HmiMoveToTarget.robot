*** Settings ***
Documentation    Execute HMI_MOVE_TO_TARGET command and get NoAck response.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CE3

*** Test Cases ***
Send Command
    [Documentation]    Send the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    Eui
    Comment    Enter command id
    Write    30
    ${output}=    Read Until    Enter azimuth angle:
    Write    89.050914
    ${output}=    Read Until    Enter elevation angle:
    Write    89.050914
    ${output}=    Read Until    Enter azimuth velocity:
    Write    1.466674
    ${output}=    Read Until    Enter elevation velocity:
    Write    1.466674
    ${output}=    Read Until    Enter cable wrap orientation (0 or 1):
    Write    0
    ${output}=    Read Until    Please enter a command id (or -1 to exit):
    Should Contain    ${output}    Message sent!

Verify Operation Manager Dispatches Command
    [Documentation]    Verify that Operation Manager dispatches the HMI_MOVE_TO_TARGET command.
    [Tags]    functional
    Switch Connection    OperationManager
    ${output}=    Read Until Regexp    Dispatching command: Command\[type: 30, id: [0-9]*, source: 2,
    Log    ${output}

Verify PXI Message
    [Documentation]    Verify that message received by PXI contains same sent data.
    [Tags]    functional
    Switch Connection    Pxi
    ${output}=    Read Until Regexp    Received message:\\s[0-9][0-9]*\\\\n[0-9][0-9]*\\\\n103\\\\n.*\\n
    Log    ${output}
    ${output}=    Replace String    ${output}    \\n    -
    Should Match Regexp    ${output}    [1-9][0-9]*-[1-9][0-9]*-103-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{6}-89\\.050914-1\\.466674-0\\.000000-0\\.000000

Read NoAck
    [Documentation]    Verify that EUI receives NoAck message sent from PXI.
    [Tags]    functional
    Switch Connection    Netcat
    ${output}=    Read Until Regexp    (?m)^1\\s+[1-9][0-9]*\\s+2\\s+[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}
    Log    ${output}

