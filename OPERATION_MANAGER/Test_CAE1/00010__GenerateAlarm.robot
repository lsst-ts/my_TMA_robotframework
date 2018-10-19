*** Settings ***
Documentation    Generate an alarm event and check the correct reception.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CAE1

*** Test Cases ***
Generate Error event
    [Documentation]    Generate an error event.
    [Tags]    functional
    Switch Connection    Pxi
    Write    e 100
    ${output}=    Read Until    Simulator generated error event

Verify Alarm Reception
    [Documentation]    Verify that EUI receives the alarm with the same data.
    [Tags]    functional
    Switch Connection    Netcat
    ${output}=    Read Until Regexp    (?m)^3\\s+1\\s+1\\s+100\\s+100\\.pxi_simulator\\s+[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}\\s+Simulator generated error event
    Log    ${output}
