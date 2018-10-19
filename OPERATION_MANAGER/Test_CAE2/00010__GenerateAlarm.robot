*** Settings ***
Documentation    Generate an alarm event.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CAE1

*** Test Cases ***
Generate Alarm event
    [Documentation]    Generate an alarm event.
    [Tags]    functional
    Switch Connection    Pxi
    Write    e 100
    ${output}=    Read Until    Simulator generated error event

Verify TCS Receives Alarm Event
    [Documentation]    Verify that TCS receives alarm event
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Simulator generated error event
    Log    ${output}
