*** Settings ***
Documentation    Contains user keyword to create a ssh session.
Library    SSHLibrary
Resource    ./Global_Vars.robot

*** Keywords ***
Open SSH Connection
    [Documentation]    Open SSH connection.
    [Arguments]    ${alias}    ${timeout}
    [Tags]    smoke
    Comment    Connect to host.
    Open Connection    host=${Host}    alias=${alias}    timeout=${timeout}    prompt=${Prompt}
    Comment    Login.
    #Login    ${UserName}    ${Password}
	Login With Public Key    ${UserName}    keyfile=${KeyFile}    password=${PassWord}
    Directory Should Exist    ${TMAWorkDir}
    
