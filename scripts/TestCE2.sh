#!/bin/bash
#  Shellscript to create test suites for Test CE2 (Commanding Engineering 2).
#  Check all possible commands with Ack-Error response. Verify the correct reception of all the data associated to the 
#  command and responses and the correct execution of the Engineering state machine.
#
#  author: Ander Ansuategi
#  email:  ander.ansuategi@tekniker.es


#############
# Variables #
#############

# The working directory
workDir=$HOME/LSST/robotframework_TMA/OPERATION_MANAGER/Test_CE2

# Array with command names
declare -a commandArray=(hmi_move_to_target hmi_stop az_axis_power az_axis_stop az_axis_move \
az_axis_move_velocity az_axis_home az_axis_reset_alarm az_drive_reset az_drive_enable \
az_cw_power az_cw_stop az_cw_move az_cw_move_velocity az_cw_track_azimuth az_cw_reset_alarm az_cw_drive_reset \
az_cw_drive_enable el_axis_power el_axis_stop el_axis_move el_axis_move_velocity el_axis_home \
el_axis_reset_alarm el_drive_reset el_drive_enable mps_power mps_reset_alarm eib_reset eib_reset_error \
eib_clear_position_error oss_power oss_power_cooling oss_power_oil oss_power_main_pump oss_reset_alarm mc_power \
mc_stop mc_move mc_move_velocity mc_open mc_close mc_reset_alarm cam_cw_power cam_cw_stop cam_cw_move \
cam_cw_track_camera cam_cw_reset_alarm cam_cw_drive_enable cam_cw_drive_reset cam_cw_move_velocity bal_power \
bal_stop bal_move bal_reset_alarm tec_power tec_track_ambient tec_reset_alarm dp_power dp_stop dp_move_velocity \
dp_reset_alarm cabinet_track_ambient cabinet_reset_alarm lp_power lp_stop lp_move lp_move_velocity lp_reset_alarm \
mcl_power mcl_stop mcl_move mcl_reset_alarm az_thermal_power az_thermal_track_ambient az_thermal_reset_alarm \
el_thermal_power el_thermal_track_ambient el_thermal_reset_alarm safety_reset read_parameters write_parameters \
ask_for_command)

# Array with command ids
declare -a commandIdArray=(30 32 101 102 103 104 106 107 201 202 301 302 303 304 305 306 307 308 401 402 403 \
404 406 407 501 502 601 602 701 702 703 801 802 803 804 805 901 902 903 904 905 906 907 1001 1002 1003 1004 1005 1006 \
1007 1008 1101 1102 1103 1104 2201 2202 2203 1201 1202 1204 1205 1301 1302 1401 1402 1403 1404 1405 1501 1502 1503 \
1504 1601 1602 1603 1701 1702 1703 1801 1901 1902 2101)

# Array of command groups. Commands in the same group have same parameters. 
declare -a commandGroup1=(hmi_move_to_target)

declare -a commandGroup2=(hmi_track_target)

declare -a commandGroup3=(az_axis_power az_cw_power az_cw_track_azimuth el_axis_power mps_power oss_power \
oss_power_cooling oss_power_oil oss_power_main_pump cam_cw_power cam_cw_track_camera tec_power)

declare -a commandGroup4=(az_axis_move az_cw_move el_axis_move cam_cw_move)

declare -a commandGroup5=(az_axis_move_velocity az_cw_move_velocity el_axis_move_velocity cam_cw_move_velocity)

declare -a commandGroup6=(az_axis_tracking el_axis_tracking)

declare -a commandGroup7=(az_drive_reset az_cw_drive_reset el_drive_reset mc_stop cam_cw_drive_reset bal_stop \
dp_stop lp_stop mcl_stop az_thermal_reset_alarm el_thermal_reset_alarm lp_reset_alarm mcl_reset_alarm \
bal_reset_alarm dp_reset_alarm mc_reset_alarm)

declare -a commandGroup8=(az_drive_enable az_cw_drive_enable el_drive_enable mc_power cam_cw_drive_enable bal_power dp_power\
az_thermal_power el_thermal_power lp_power mcl_power)

declare -a commandGroup9=(mc_move bal_move lp_move mcl_move)

declare -a commandGroup10=(mc_move_velocity dp_move_velocity lp_move_velocity)

declare -a commandGroup11=(safety_reset read_parameters write_parameters)

declare -a commandGroup12=(ask_for_command)

declare -a commandGroup13=(cabinet_track_ambient tec_track_ambient)

declare -a commandGroup14=(az_thermal_track_ambient el_thermal_track_ambient)

# Command parameters
angle=0.0
vel=0.0
acc=0.0
jerk=0.0
cableWrapOrientation=0
time=0
on=0
ident=0
temperature=0

#############
# Functions #
#############

function getRandomFloatingNumber() {
  awk -v min=$1 -v max=$2 -v "seed=$[(RANDOM & 32767) + 32768 * (RANDOM & 32767)]" \
'BEGIN { srand(seed); printf("%.6f\n", min + rand() * (max - min)) }'
}

function getRandomZeroOrOne() {
  BINARY=2
  T=1
  number=$RANDOM
  let "number >>= 14"
  if [ "$number" -eq $T ]; then
    echo 1
  else
    echo 0
  fi
}

function getAngle() {
  angle=$(getRandomFloatingNumber -270.00 270.00)
}

function getVel() {
  vel=$(getRandomFloatingNumber 0.00 10.50)
}

function getAcc() {
  acc=$(getRandomFloatingNumber 0.00 10.50)
}

function getJerk() {
  jerk=$(getRandomFloatingNumber 0.00 42.00)
}

function getTime() {
  time=`date +%s`
}

function getOn() {
  on=$(getRandomZeroOrOne)
}

function getTemperature() {
  temperature=$(getRandomFloatingNumber 20.00 70.00)
}

function getCableWrapOrientation() {
  cableWrapOrientation=$(getRandomZeroOrOne)
}

function getIdent() {
  min=1
  max=4
  ident=$((RANDOM%(max- min + 1) + min))
}

function getIndex() {
  for i in "${!commandArray[@]}"; do
    if [[ "${commandArray[$i]}" = "$1" ]]; then
      commandUpId="${i}"
      break
    fi
  done
}

function clearTestSuite() {
  if [ -f $testSuite ]; then
      echo $testSuite exists.  Deleting it before creating a new one.
      rm -rf $testSuite
  fi
}

function getFileName() {
  commandName=${command//_/ }
  commandNameArray=( $commandName )
  commandName=${commandNameArray[@]^}
  commandName=${commandName// /}
  getIndex ${command}
  idStr=$(printf "%05d\n" ${commandIdArray[$commandUpId]}) 
  echo $workDir/${idStr}__${commandName}.robot 
}

function createSettings() {
  echo "*** Settings ***" >> $testSuite
  echo "Documentation    Execute ${command^^} command and get Ack/Error responses." >> $testSuite
  echo "Library    SSHLibrary" >> $testSuite
  echo "Library    String" >> $testSuite
  echo "Resource    ../../Global_Vars.robot" >> $testSuite
  echo "Force Tags    Test_CE2" >> $testSuite
	echo "" >> $testSuite
}

function sendCommand() {
  echo "Send Command" >> $testSuite
  echo "    [Documentation]    Send the ${command^^} command." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    Eui" >> $testSuite
  echo "    Comment    Enter command id" >> $testSuite
  getIndex ${command}
  echo "    Write    ${commandIdArray[$commandUpId]}" >> $testSuite
  # Depending on the command, insert the corresponding parameters
  if [[ ${commandGroup1[*]} =~ $command ]]; then
    getAngle
    getVel
    getCableWrapOrientation
    echo "    \${output}=    Read Until    Enter azimuth angle:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter elevation angle:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter azimuth velocity:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter elevation velocity:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter cable wrap orientation (0 or 1):" >> $testSuite
    echo "    Write    $cableWrapOrientation" >> $testSuite
  elif [[ ${commandGroup2[*]} =~ $command ]]; then
    getAngle
    getVel
    getCableWrapOrientation
    getTime
    echo "    \${output}=    Read Until    Enter azimuth angle:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter elevation angle:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter azimuth velocity:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter elevation velocity:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter cable wrap orientation (0 or 1):" >> $testSuite
    echo "    Write    $cableWrapOrientation" >> $testSuite
    echo "    \${output}=    Read Until    Enter time:" >> $testSuite
    echo "    Write    $time" >> $testSuite
  elif [[ ${commandGroup3[*]} =~ $command ]]; then
    getOn
    echo "    \${output}=    Read Until    Enter on (0 or 1):" >> $testSuite
    echo "    Write    $on" >> $testSuite
  elif [[ ${commandGroup4[*]} =~ $command ]]; then
    getAngle
    getVel
    getAcc
    getJerk
    echo "    \${output}=    Read Until    Enter position set point:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter speed:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter acceleration:" >> $testSuite
    echo "    Write    $acc" >> $testSuite
    echo "    \${output}=    Read Until    Enter jerk:" >> $testSuite
    echo "    Write    $jerk" >> $testSuite
  elif [[ ${commandGroup5[*]} =~ $command ]]; then
    getVel
    getAcc
    getJerk
    echo "    \${output}=    Read Until    Enter speed set point:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter acceleration:" >> $testSuite
    echo "    Write    $acc" >> $testSuite
    echo "    \${output}=    Read Until    Enter jerk:" >> $testSuite
    echo "    Write    $jerk" >> $testSuite
  elif [[ ${commandGroup6[*]} =~ $command ]]; then
    getAngle
    getVel
    echo "    \${output}=    Read Until    Enter position set point:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter speed set point:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
  elif [[ ${commandGroup7[*]} =~ $command ]]; then
    getIdent
    echo "    \${output}=    Read Until    Enter drive ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
  elif [[ ${commandGroup8[*]} =~ $command ]]; then
    getIdent
    getOn
    echo "    \${output}=    Read Until    Enter drive ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
    echo "    \${output}=    Read Until    Enter on (0 or 1):" >> $testSuite
    echo "    Write    $on" >> $testSuite
  elif [[ ${commandGroup9[*]} =~ $command ]]; then
    getIdent
    getAngle
    getVel
    getAcc
    getJerk
    echo "    \${output}=    Read Until    Enter ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
    echo "    \${output}=    Read Until    Enter position set point:" >> $testSuite
    echo "    Write    $angle" >> $testSuite
    echo "    \${output}=    Read Until    Enter speed:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter acceleration:" >> $testSuite
    echo "    Write    $acc" >> $testSuite
    echo "    \${output}=    Read Until    Enter jerk:" >> $testSuite
    echo "    Write    $jerk" >> $testSuite
  elif [[ ${commandGroup10[*]} =~ $command ]]; then
    getIdent
    getVel
    getAcc
    getJerk
    echo "    \${output}=    Read Until    Enter ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
    echo "    \${output}=    Read Until    Enter speed set point:" >> $testSuite
    echo "    Write    $vel" >> $testSuite
    echo "    \${output}=    Read Until    Enter acceleration:" >> $testSuite
    echo "    Write    $acc" >> $testSuite
    echo "    \${output}=    Read Until    Enter jerk:" >> $testSuite
    echo "    Write    $jerk" >> $testSuite
  elif [[ ${commandGroup11[*]} =~ $command ]]; then
    getIdent
    echo "    \${output}=    Read Until    Enter ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
  elif [[ ${commandGroup12[*]} =~ $command ]]; then
    getIdent
    echo "    \${output}=    Read Until    Enter command ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
  elif [[ ${commandGroup13[*]} =~ $command ]]; then
    getOn
    getTemperature
    echo "    \${output}=    Read Until    Enter on (0 or 1):" >> $testSuite
    echo "    Write    $on" >> $testSuite
    echo "    \${output}=    Read Until    Enter temperature:" >> $testSuite
    echo "    Write    $temperature" >> $testSuite
  elif [[ ${commandGroup14[*]} =~ $command ]]; then
    getIdent
    getOn
    getTemperature
    echo "    \${output}=    Read Until    Enter drive ident:" >> $testSuite
    echo "    Write    $ident" >> $testSuite
    echo "    \${output}=    Read Until    Enter on (0 or 1):" >> $testSuite
    echo "    Write    $on" >> $testSuite
    echo "    \${output}=    Read Until    Enter temperature:" >> $testSuite
    echo "    Write    $temperature" >> $testSuite
  fi
  
  echo "    \${output}=    Read Until    Please enter a command id (or -1 to exit):" >> $testSuite
  echo "    Should Contain    \${output}    Message sent!" >> $testSuite
  echo "" >> $testSuite
}

function verifyOperationManagerDispatchesCommand() {
  echo "Verify Operation Manager Dispatches Command" >> $testSuite
  echo "    [Documentation]    Verify that Operation Manager dispatches the ${command^^} command." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    OperationManager" >> $testSuite
  echo "    \${output}=    Read Until Regexp    Dispatching command: Command\[type: ${commandIdArray[$commandUpId]}, id: [0-9]*, source: 2," >> $testSuite
  echo "    Log    \${output}" >> $testSuite
  echo "" >> $testSuite
}

function verifyPXIMessage() {
  echo "Verify PXI Message" >> $testSuite
  echo "    [Documentation]    Verify that message received by PXI contains same sent data." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    Pxi" >> $testSuite
  
  # Special commands treatment: hmi_move_to_target and hmi_stop.
  # They send two low-level commands
  if [ "$command" == "hmi_move_to_target" ]; then
    echo "    \${output}=    Read Until Regexp    Received message:\\\\s[0-9][0-9]*\\\\\\\\n[0-9][0-9]*\\\\\\\\n103\\\\\\\\n.*\\\\n" >> $testSuite
    echo "    Log    \${output}" >> $testSuite
    echo "    \${output}=    Replace String    \${output}    \\\\n    -" >> $testSuite
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-103-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${angle//./\\\\.}-${vel//./\\\\.}-0\\\\.000000-0\\\\.000000" >> $testSuite
    echo "    \${output}=    Read Until Regexp    Received message:\\\\s[0-9][0-9]*\\\\\\\\n[0-9][0-9]*\\\\\\\\n403\\\\\\\\n.*\\\\n" >> $testSuite
    echo "    Log    \${output}" >> $testSuite
    echo "    \${output}=    Replace String    \${output}    \\\\n    -" >> $testSuite
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-403-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${angle//./\\\\.}-${vel//./\\\\.}-0\\\\.000000-0\\\\.000000" >> $testSuite
    echo "" >> $testSuite
    return 0
  fi
  if [ "$command" == "hmi_stop" ]; then
    echo "    \${output}=    Read Until Regexp    Received message:\\\\s[0-9][0-9]*\\\\\\\\n[0-9][0-9]*\\\\\\\\n102\\\\\\\\n.*\\\\n" >> $testSuite
    echo "    Log    \${output}" >> $testSuite
    echo "    \${output}=    Replace String    \${output}    \\\\n    -" >> $testSuite
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-102-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}" >> $testSuite
    echo "    \${output}=    Read Until Regexp    Received message:\\\\s[0-9][0-9]*\\\\\\\\n[0-9][0-9]*\\\\\\\\n402\\\\\\\\n.*\\\\n" >> $testSuite
    echo "    Log    \${output}" >> $testSuite
    echo "    \${output}=    Replace String    \${output}    \\\\n    -" >> $testSuite
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-402-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}" >> $testSuite
    echo "" >> $testSuite
    return 0
  fi
  echo "    \${output}=    Read Until Regexp    Received message:\\\\s[0-9][0-9]*\\\\\\\\n[0-9][0-9]*\\\\\\\\n${commandIdArray[$commandUpId]}\\\\\\\\n.*\\\\n" >> $testSuite
  echo "    Log    \${output}" >> $testSuite
  echo "    \${output}=    Replace String    \${output}    \\\\n    -" >> $testSuite
  if [[ ${commandGroup1[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${angle//./\\\\.}-${angle//./\\\\.}-${vel//./\\\\.}-${vel//./\\\\.}-${cableWrapOrientation}" >> $testSuite
  elif [[ ${commandGroup2[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${angle//./\\\\.}-${angle//./\\\\.}-${vel//./\\\\.}-${vel//./\\\\.}-${cableWrapOrientation}-${time}" >> $testSuite
  elif [[ ${commandGroup3[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${on}" >> $testSuite
  elif [[ ${commandGroup4[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${angle//./\\\\.}-${vel//./\\\\.}-${acc//./\\\\.}-${jerk//./\\\\.}" >> $testSuite
  elif [[ ${commandGroup5[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${vel//./\\\\.}-${acc//./\\\\.}-${jerk//./\\\\.}" >> $testSuite
  elif [[ ${commandGroup6[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${angle//./\\\\.}-${vel//./\\\\.}" >> $testSuite
  elif [[ ${commandGroup7[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}" >> $testSuite
  elif [[ ${commandGroup8[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}-${on}" >> $testSuite
  elif [[ ${commandGroup9[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}-${angle//./\\\\.}-${vel//./\\\\.}-${acc//./\\\\.}-${jerk//./\\\\.}" >> $testSuite
  elif [[ ${commandGroup10[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}-${vel//./\\\\.}-${acc//./\\\\.}-${jerk//./\\\\.}" >> $testSuite
  elif [[ ${commandGroup11[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}" >> $testSuite
  elif [[ ${commandGroup12[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}" >> $testSuite
  elif [[ ${commandGroup13[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${on}-${temperature}" >> $testSuite
  elif [[ ${commandGroup14[*]} =~ $command ]]; then
    echo "    Should Match Regexp    \${output}    [1-9][0-9]*-[1-9][0-9]*-${commandIdArray[$commandUpId]}-2-[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]{6}-${ident}-${on}-${temperature}" >> $testSuite
  fi
  echo "" >> $testSuite
}

function readAck() {
  echo "Read Ack" >> $testSuite
  echo "    [Documentation]    Verify that EUI receives Ack message sent from PXI." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    Netcat" >> $testSuite
  echo "    \${output}=    Read Until Regexp    (?m)^0\\\\s+[1-9][0-9]*\\\\s+2\\\\s+[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}\\\\.[0-9]{6}" >> $testSuite
  echo "    Log    \${output}" >> $testSuite
  echo "" >> $testSuite
}

function verifyExecutingCommandState() {
  if [[ "$command" == "mc_open" || "$command" == "mc_close" ]]; then
    echo "Verify ExecutingSequence State" >> $testSuite
    echo "    [Documentation]    Verify that Operation Manager enters ExecutingSequence state." >> $testSuite
    echo "    [Tags]    functional" >> $testSuite
    echo "    Switch Connection    OperationManager" >> $testSuite
    echo "    \${output}=    Read Until    ExecutingSequence init" >> $testSuite
    echo "    Log    \${output}" >> $testSuite
    echo "    Should Contain    \${output}    ExecutingSequence init" >> $testSuite
  else
    echo "Verify ExecutingCommand State" >> $testSuite
    echo "    [Documentation]    Verify that Operation Manager enters ExecutingCommand state." >> $testSuite
    echo "    [Tags]    functional" >> $testSuite
    echo "    Switch Connection    OperationManager" >> $testSuite
    echo "    \${output}=    Read Until    ExecutingCommand init" >> $testSuite
    echo "    Log    \${output}" >> $testSuite
    echo "    Should Contain    \${output}    ExecutingCommand init" >> $testSuite
  fi
  echo "" >> $testSuite
}

function sendErrorEvent() {
  echo "Send Error Event" >> $testSuite
  echo "    [Documentation]    Generate an error event." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    Pxi" >> $testSuite
  getIndex ${command}
  echo "    Write    e ${commandIdArray[$commandUpId]}" >> $testSuite
  echo "    \${output}=    Read Until    Simulator generated error event" >> $testSuite
  echo "    Log    \${output}" >> $testSuite
  echo "    Should Contain    \${output}    Simulator generated error event" >> $testSuite
  echo "" >> $testSuite
}

function verifyEUIReceivesErrorEvent() {
  echo "Verify EUI Receives Error Event" >> $testSuite
  echo "    [Documentation]    Check that EUI receives Error event." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    Netcat" >> $testSuite
  echo "    \${output}=    Read Until    Simulator generated error event" >> $testSuite
  echo "    Log    \${output}" >> $testSuite
  echo "    Should Contain    \${output}    Simulator generated error event" >> $testSuite
  echo "" >> $testSuite
}

function verifyPublishOnlyWaitingForCommandState() {
  echo "Verify PublishOnlyWaitingForCommand State" >> $testSuite
  echo "    [Documentation]    Verify that Operation Manager enters PublishOnlyWaitingForCommand state." >> $testSuite
  echo "    [Tags]    functional" >> $testSuite
  echo "    Switch Connection    OperationManager" >> $testSuite
  echo "    \${output}=    Read Until    PublishOnlyWaitingForCommand init" >> $testSuite
  echo "    Log    \${output}" >> $testSuite
  echo "    Should Contain    \${output}    PublishOnlyWaitingForCommand init" >> $testSuite
  echo "" >> $testSuite
}

function createTestSuite() {
  command=$1

  # Define test suite name
  testSuite=$(getFileName)
  clearTestSuite
  # Create test suite.
  echo Creating $testSuite
  createSettings
  echo "*** Test Cases ***" >> $testSuite
  sendCommand
  verifyOperationManagerDispatchesCommand
  verifyPXIMessage
  readAck
  verifyExecutingCommandState
  sendErrorEvent
  verifyEUIReceivesErrorEvent
  verifyPublishOnlyWaitingForCommandState
  # Indicate completion of the test suite.
  echo Done with test suite.
}

##########
#  Main  #
##########

if [ $# -ne 1 ]; then
  echo USAGE - Argument must be one of: ${commandArray[*]} OR all.
  exit 1
fi

if [ "$1" == "all" ]; then
  for i in "${commandArray[@]}"; do
    command=$i
    createTestSuite $command 
  done
  echo COMPLETED ALL test suites for ALL EUI commands.
elif [[ ${commandArray[*]} =~ $1 ]]; then
  command=$1
  createTestSuite $command
else
	echo USAGE - Argument must be one of: ${commandArray[*]} OR all.
  exit 1
fi
