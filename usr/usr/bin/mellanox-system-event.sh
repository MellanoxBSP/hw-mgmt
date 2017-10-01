#!/bin/bash

########################################################################
# Copyright (c) 2017 Mellanox Technologies.
# Copyright (c) 2017 Vadim Pasternak <nataliyay@mellanox.com>
#
# Licensed under the GNU General Public License Version 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# echo $1 and $2 and $3 and $4 and $5 >> /root/msg.txt
if [ "$1" == "add" ]; then
  if [ ! -d /bsp/thermal ]; then
      mkdir -p /bsp/thermal/
  fi
  if [ ! -d /bsp/thermal_zone ]; then
      mkdir -p /bsp/thermal_zone/
  fi
  if [ ! -d /bsp/environment ]; then
      mkdir -p /bsp/environment/
  fi
  if [ ! -d /bsp/fan ]; then
      mkdir -p /bsp/fan/
  fi
  if [ ! -d /bsp/fru ]; then
      mkdir -p /bsp/fru/
  fi
  if [ ! -d /bsp/leds ]; then
      mkdir -p /bsp/leds/
  fi
  if [ ! -d /bsp/qsfp ]; then
      mkdir -p /bsp/qsfp
  fi
  if [ "$2" == "amb_carrier" ] || [ "$2" == "amb_switch" ]; then
    ln -sf $3$4/temp1_input /bsp/thermal/$2_temp
    ln -sf $3$4/temp1_max /bsp/thermal/$2_temp_max
    ln -sf $3$4/temp1_max_hyst /bsp/thermal/$2_temp_hyst
  fi
  if [ "$2" == "psu1" ] || [ "$2" == "psu2" ]; then
    ln -sf $5$3/temp1_input /bsp/thermal/$2_temp
    ln -sf $5$3/temp1_max /bsp/thermal/$2_temp_max
    ln -sf $5$3/temp1_max_alarm /bsp/thermal/$2_temp_alarm
    ln -sf $5$3/in1_input /bsp/environment/$2_vin
    ln -sf $5$3/in2_input /bsp/environment/$2_vout
    ln -sf $5$3/power1_input /bsp/environment/$2_pin
    ln -sf $5$3/power2_input /bsp/environment/$2_pout
    ln -sf $5$3/curr1_input /bsp/environment/$2_iin
    ln -sf $5$3/curr2_input /bsp/environment/$2_iout
    ln -sf $5$3/fan1_input /bsp/fan/$2_fan_input

    #FAN speed set
    busdir=`echo $5$3 |xargs dirname |xargs dirname`
    busfolder=`basename $busdir`
    bus="${busfolder:0:${#busfolder}-5}"
    if [ "$2" == "psu1" ]; then
      i2cset -f -y $bus 0x59 0x3b 0x3c 0x00 0xbc i
    else
      i2cset -f -y $bus 0x58 0x3b 0x3c 0x00 0x90 i
    fi
  fi
  if [ "$2" == "a2d" ]; then
    ln -sf $3$4/in_voltage-voltage_scale /bsp/environment/$2_voltage_scale
    ln -sf $3$4/in_voltage6_raw /bsp/environment/$2_1_8v
    ln -sf $3$4/in_voltage5_raw /bsp/environment/$2_1_2v
    ln -sf $3$4/in_voltage4_raw /bsp/environment/$2_vcore
    ln -sf $3$4/in_voltage3_raw /bsp/environment/$2_swb_12v
    ln -sf $3$4/in_voltage2_raw /bsp/environment/$2_swb_3_3v_aux
    ln -sf $3$4/in_voltage1_raw /bsp/environment/$2_swb_3_3v_sen
  fi
  if [ "$2" == "voltmon1" ] || [ "$2" == "voltmon2" ]; then
    ln -sf $3$4/in1_input /bsp/environment/$2_in1_input
    ln -sf $3$4/in2_input /bsp/environment/$2_in2_input
    ln -sf $3$4/curr2_input /bsp/environment/$2_curr2_input
    ln -sf $3$4/power2_input /bsp/environment/$2_power2_input
    ln -sf $3$4/in3_input /bsp/environment/$2_in2_input
    ln -sf $3$4/curr3_input /bsp/environment/$2_curr3_input
    ln -sf $3$4/power3_input /bsp/environment/$2_power3_input
  fi
  if [ "$2" == "asic" ]; then
    ln -sf $3$4/temp1_input /bsp/thermal/$2_temp
    ln -sf $3$4/temp1_highest /bsp/thermal/$2_temp_highest
  fi
  if [ "$2" == "fan" ]; then
    # Take time for adding infrastructure
    sleep 3
    for i in {1..12}; do
        if [ -f $3$4/fan"$i"_input ]; then
            ln -sf $3$4/fan"$i"_input /bsp/fan/fan"$i"_speed_get
            ln -sf $3$4/pwm1 /bsp/fan/fan"$i"_speed_set
        fi
    done
  fi
  if [ "$2" == "qsfp" ]; then
    # Take time for adding infrastructure
    sleep 5
    for i in {1..64}; do
        if [ -f $3$4/qsfp$i ]; then
            ln -sf $3$4/qsfp$i /bsp/qsfp/qsfp"$i"
            ln -sf $3$4/qsfp"$i"_status /bsp/qsfp/qsfp"$i"_status
        fi
    done
  fi
  if [ "$2" == "eeprom_vpd" ]; then
    ln -sf $3$4/eeprom /bsp/fru/vpd_info
  fi
  if [ "$2" == "eeprom_cpu" ]; then
    ln -sf $3$4/eeprom /bsp/fru/cpu_info
  fi
  if [ "$2" == "eeprom_psu1" ]; then
    ln -sf $3$4/eeprom /bsp/fru/psu1_eeprom
  fi
  if [ "$2" == "eeprom_psu2" ]; then
    ln -sf $3$4/eeprom /bsp/fru/psu2_eeprom
  fi
  if [ "$2" == "eeprom_fan1" ]; then
    ln -sf $3$4/eeprom /bsp/fru/fan1_eeprom
  fi
  if [ "$2" == "eeprom_fan2" ]; then
    ln -sf $3$4/eeprom /bsp/fru/fan2_eeprom
  fi
  if [ "$2" == "eeprom_fan3" ]; then
    ln -sf $3$4/eeprom /bsp/fru/fan3_eeprom
  fi
  if [ "$2" == "eeprom_fan4" ]; then
    ln -sf $3$4/eeprom /bsp/fru/fan4_eeprom
  fi
  if [ "$2" == "led" ]; then
	name=`echo $5 | cut -d':' -f2`
	color=`echo $5 | cut -d':' -f3`
	ln -sf $3$4/brightness /bsp/leds/led_"$name"_"$color"
        echo timer > $3$4/trigger
        ln -sf $3$4/delay_on  /bsp/leds/led_"$name"_"$color"_delay_on
        ln -sf $3$4/delay_off /bsp/leds/led_"$name"_"$color"_delay_off
  fi
  if [ "$2" == "thermal_zone" ]; then
    busfolder=`basename $3$4`
    zonetype=`cat $3$4/type`
    if [ "$zonetype" == "mlxsw" ]; then
      # Disable thermal algorithm
      echo disabled > $3$4/mode
      # Set default fan speed
      echo 6 > $3$4/cdev0/cur_state
      mkdir -p /bsp/thermal_zone/$zonetype
      zone=$zonetype
    else
      zonename=`echo $5 | tail -c +9`
      zone=$zonename-$zonetype
    fi
    mkdir -p /bsp/thermal_zone/$zone
    ln -sf $3$4/mode /bsp/thermal_zone/$zone/mode
    for i in {0..11}; do
      if [ -f $3$4/trip_point_"$i"_temp ]; then
        ln -sf $3$4/trip_point_"$i"_temp /bsp/thermal_zone/$zone/trip_point_$i
      fi
      if [ -d $3$4/cdev"$i" ]; then
        ln -sf $3$4/cdev"$i"/cur_state /bsp/thermal_zone/$zone/cooling"$i"_current_state
      fi
    done
  fi
  if [ "$2" == "cputemp" ]; then
    for i in {1..9}; do
      if [ -f $3$4/temp"$i"_input ]; then
        if [ $i -eq 1 ]; then
           name="cpu"
        else
           id=$(($i-1))
           name="core$id"
        fi
        ln -sf $3$4/temp"$i"_input /bsp/thermal/${name}_temp"$i"_input
        ln -sf $3$4/temp"$i"_crit /bsp/thermal/${name}_temp"$i"_crit
        ln -sf $3$4/temp"$i"_crit_alarm /bsp/thermal/${name}_temp"$i"_crit_alarm
        ln -sf $3$4/temp"$i"_max /bsp/thermal/${name}_temp"$i"_max
      fi
    done
  fi
elif [ "$1" == "change" ]; then
    echo "Do nothing on change"
else
  if [ "$2" == "amb_carrier" ] || [ "$2" == "amb_switch" ]; then
    unlink /bsp/thermal/$2_temp
    unlink /bsp/thermal/$2_temp_max
    unlink /bsp/thermal/$2_temp_hyst
  fi
  if [ "$2" == "psu1" ] || [ "$2" == "psu2" ]; then
    unlink /bsp/thermal/$2_temp
    unlink /bsp/thermal/$2_temp_max
    unlink /bsp/thermal/$2_temp_alarm
    unlink /bsp/environment/$2_vin
    unlink /bsp/environment/$2_vout
    unlink /bsp/environment/$2_pin
    unlink /bsp/environment/$2_pout
    unlink /bsp/environment/$2_iin
    unlink /bsp/environment/$2_iout
    unlink /bsp/fan/$2_fan_input
  fi
  if [ "$2" == "a2d" ]; then
    unlink /bsp/environment/$2_voltage_scale
    unlink /bsp/environment/$2_1_8v
    unlink /bsp/environment/$2_1_2v
    unlink /bsp/environment/$2_vcore
    unlink /bsp/environment/$2_swb_12v
    unlink /bsp/environment/$2_swb_3_3v_aux
    unlink /bsp/environment/$2_swb_3_3v_sen
  fi
  if [ "$2" == "voltmon1" ] || [ "$2" == "voltmon2" ]; then
    unlink /bsp/environment/$2_in1_input
    unlink /bsp/environment/$2_in2_input
    unlink /bsp/environment/$2_curr2_input
    unlink /bsp/environment/$2_power2_input
    unlink $3$4/in3_input /bsp/environment/$2_in2_input
    unlink $3$4/curr3_input /bsp/environment/$2_curr3_input
    unlink $3$4/power3_input /bsp/environment/$2_power3_input
  fi
  if [ "$2" == "asic" ]; then
    unlink /bsp/thermal/$2_temp
    unlink /bsp/thermal/$2_temp_highest
  fi
  if [ "$2" == "fan" ]; then
    for i in $3$4/fan[1-12]
    do
	if [ -f $3$4/fan$i ]; then
            unlink /bsp/fan/fan"$i"_speed_get
            unlink $3$4/pwm /bsp/fan/fan"$i"_speed_set
        fi
    done
  fi
  if [ "$2" == "qsfp" ]; then
    for i in $3$4/qsfp[1-64]; do
        if [ -f $3$4/fan$i ]; then
            unlink /bsp/qsfp/qsfp"$i"
            unlink /bsp/qsfp/qsfp"$i"_status
        fi
    done
  fi
  if [ "$2" == "eeprom_psu1" ]; then
    unlink /bsp/fru/psu1_eeprom
  fi
  if [ "$2" == "eeprom_psu2" ]; then
    unlink /bsp/fru/psu2_eeprom
  fi
  if [ "$2" == "eeprom_fan1" ]; then
    unlink /bsp/fru/fan1_eeprom
  fi
  if [ "$2" == "eeprom_fan2" ]; then
    unlink /bsp/fru/fan2_eeprom
  fi
  if [ "$2" == "eeprom_fan3" ]; then
    unlink /bsp/fru/fan3_eeprom
  fi
  if [ "$2" == "eeprom_fan4" ]; then
    unlink /bsp/fru/fan4_eeprom
  fi
  if [ "$2" == "led" ]; then
    name=`echo $5 | cut -d':' -f2`
    color=`echo $5 | cut -d':' -f3`
    unlink /bsp/leds/led_"$name"_"$color"
    unlink /bsp/leds/led_"$name"_"$color"_delay_on
    unlink /bsp/leds/led_"$name"_"$color"_delay_off
  fi
  if [ "$2" == "thermal_zone[0-5]" ]; then
    busfolder=`basename $3$4`
    zonetype=`cat $3$4/type`
    if [ "$zonetype" == "mlxsw" ]; then
      # Disable thermal algorithm
      echo disabled > $3$4/mode
      # Set default fan speed
      echo 6 > $3$4/cdev0/cur_state
      mkdir -p /bsp/thermal_zone/$zonetype
      zone=$zonetype
    else
      zonename=`echo $5 | tail -c +9`
      zone=$zonename-$zonetype
    fi
    unlink /bsp/thermal_zone/$zone/mode
    unlink /bsp/thermal_zone/$zone/*
  fi
  if [ "$2" == "cputemp" ]; then
    unlink /bsp/thermal/cpu_temp1_input
    unlink /bsp/thermal/cpu_temp1_crit
    unlink /bsp/thermal/cpu_crit_alarm
    unlink /bsp/thermal/cpu_temp1_max
    for i in {1..8}; do
      if [ -f /bsp/thermal/core"$i"_temp1_input ]; then
        unlink /bsp/thermal/core"$i"_temp1_input
        unlink /bsp/thermal/core"$i"_temp1_crit
        unlink /bsp/thermal/core"$i"_crit_alarm
        unlink /bsp/thermal/core"$i"_temp1_max
      fi
    done
  fi
fi
