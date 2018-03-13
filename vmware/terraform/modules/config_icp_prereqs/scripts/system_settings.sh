#!/bin/bash

MAX_MAP_COUNT="262144"
LOCAL_PORT_RANGE_MIN="10240"
LOCAL_PORT_RANGE_MAX="60999"

IP_CMD=`sysctl -n net.ipv4.ip_local_port_range`
OS_PORT_RANGE_MIN=`echo $IP_CMD | cut -d " " -f1`
OS_PORT_RANGE_MAX=`echo $IP_CMD | cut -d " " -f2`


if [ `sysctl -n vm.max_map_count` -lt $MAX_MAP_COUNT ];then
  echo "Setting new max map count"
  sysctl -q -w vm.max_map_count=$MAX_MAP_COUNT
  if [ `cat /etc/sysctl.conf | grep vm.max_map_count | wc -l` -gt 0 ];then
    echo "Commenting out and replacing with ICP setting for - vm.max_map_count"
    sed -i '/vm.max_map_count/s/^/#/g' /etc/sysctl.conf
    echo "vm.max_map_count=$MAX_MAP_COUNT" | tee -a /etc/sysctl.conf
  else
    echo "Inserting ICP Setting for - vm.max_map_count"
    echo "vm.max_map_count=$MAX_MAP_COUNT" | tee -a /etc/sysctl.conf
  fi
fi

if [ $OS_PORT_RANGE_MIN -gt $LOCAL_PORT_RANGE_MIN ];then
  echo "Setting new port range"
  sysctl -w net.ipv4.ip_local_port_range="$LOCAL_PORT_RANGE_MIN $LOCAL_PORT_RANGE_MAX"
  if [ `cat /etc/sysctl.conf | grep net.ipv4.ip_local_port_range | wc -l` -gt 0 ];then
    echo "Commenting out and replacing with ICP setting for - net.ipv4.ip_local_port_range"
    sed -i '/net.ipv4.ip_local_port_range/s/^/#/g' /etc/sysctl.conf
    echo "net.ipv4.ip_local_port_range=\"$LOCAL_PORT_RANGE_MIN $LOCAL_PORT_RANGE_MAX\"" | tee -a /etc/sysctl.conf
  else
    echo "Inserting ICP Setting for - net.ipv4.ip_local_port_range"
    echo "net.ipv4.ip_local_port_range=\"$LOCAL_PORT_RANGE_MIN $LOCAL_PORT_RANGE_MAX\"" | tee -a /etc/sysctl.conf
  fi
  
fi
