#!/bin/bash

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" > "$1"

files=$(find "$2" -type f 2>/dev/null)

while read file; do
    phy=0
    vlans=0
    hosts=0
    failover=0
    VPN=0
    peers=0
    VLAN=0
    license=0
    SN=0
    key=0
    cur_file=$(cat "$file")
    while read line; do
        if $(echo "$line" | grep -q "Maximum Physical Interfaces");then
            phy=$(echo "$line" |  tr -s " "| tr -d " " |cut -d ":" -f2 )
        elif $(echo -n "$line" | grep -q "VLANs");then
            vlans=$(echo -n "$line" | tr -s " "|  cut -d ":" -f2)
        elif $(echo "$line" | grep -q "Inside Hosts");then
            hosts=$(echo -n "$line" |  tr -s " "| tr -d " "|cut -d ":" -f2)
        fi
    done < <(echo "$cur_file")

    filename=$(basename "$file" |cut -d "." -f1)
    echo -n ""$filename","$phy","$vlans","$hosts"" >> "$1"

done < <(echo "$files")