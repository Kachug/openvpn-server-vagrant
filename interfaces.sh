#!/bin/bash

DEVICES=$(ip -br addr | grep -v "Iface\|lo\|tun0\|tunl0" | cut -d " " -f 1)
NUMDEVICES=$(ip -br addr | wc -l)
VPNDEVICE=""

# If we have an eth0 device, use that to maintain current functionality.
if ip -br addr | grep -q eth0
then
  export VPNDEVICE="eth0"

# If we hit newer systemd/hypervisor combination, it won't be eth0, but there
# will probably be only one obvious device to use: not the loop back, and not
# the tunnel. Use it instead.
elif [ $NUMDEVICES -eq 3 ] 
  then
  # no eth0 device, but only one option, use it.
  export VPNDEVICE=$(ip -br addr | tail -n 2 | cut -d " " -f 1 | grep -v "lo\|tun0\|tunl0")

# If we end up on a server that has multiple devices and no eth0, just ask.
# This is fairly common, Docker containers, wifi cards, dual nics, etc.
else
  echo "There are multiple network devices on this server:"
  echo ""
  ip -br addr | cut -d " " -f 1 | grep -v "Iface\|lo\|tun0\|tunl0"
  echo ""
  echo "Please type the name of the device you'd like to use"
  read VPNDEVICE

  # Catch bad user input  
  while ! echo $DEVICES | grep -q "${VPNDEVICE}"
  do
    echo "${VPNDEVICE} was not found in the list of devices. Please type the device name again"
    read VPNDEVICE
  done
  export $VPNDEVICE

fi
