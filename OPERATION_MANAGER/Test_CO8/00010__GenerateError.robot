*** Settings ***
Documentation    Generate an error event.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO8

*** Test Cases ***
Generate Error event
    [Documentation]    Generate an error event.
    [Tags]    functional
    Switch Connection    Pxi
    Write    e 100
    ${output}=    Read Until    Simulator generated error event

Verify TCS Receives Error Event
    [Documentation]    Verify that TCS receives error event
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Simulator generated error event
    Log    ${output}
