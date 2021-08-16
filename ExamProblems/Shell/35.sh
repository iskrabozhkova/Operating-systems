#!/bin/bash

if [ $# -ne 2 ];then
    echo "Wrong number of parameters"
    exit 1
fi

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key"

files=$(find "$2" -type f -printf "%p\n")
echo "$files"
  while read line; do
     physical=$(cat "$line" | egrep "Maximum Physical Interfaces" | tr -s ' ' | tr -d ' ' | cut -d ":" -f2)
     vlans=$(cat "$line" | egrep "VLANs" | tr -s ' ' | tr -d ' ' | cut -d ":" -f2)
     #For the other values is the same
     echo "$physical,$vlans" >> "$1"
  done < <(echo "$files")