*** Settings ***
Documentation    Check state transitions.
Library    SSHLibrary
Library    String
Resource    ../../Global_Vars.robot
Force Tags    Test_CO8

*** Test Cases ***
Verify State Transitions
    [Documentation]    Verify that Operation Manager transition to all expected states.
    [Tags]    functional
    Switch Connection    SALEventLogger
    ${output}=    Read Until    === message = Fault
    Log    ${output}
    ${output}=    Read Until    === message = StoppingAllElements
    Log    ${output}
    ${output}=    Read Until    === message = WaitingForClear
    Log    ${output}
