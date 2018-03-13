#!/bin/bash

# set -x
set -e

while test $# -gt 0; do
	[[ $1 =~ ^-r|--random$ ]] && { random="$2"; shift 2; continue; };
	[[ $1 =~ ^-b|--boot$ ]] && { bootip="$2"; shift 2; continue; };
  [[ $1 =~ ^-m|--master$ ]] && { masterip="$2"; shift 2; continue; };
  [[ $1 =~ ^-p|--proxy$ ]] && { proxyip="$2"; shift 2; continue; };
  [[ $1 =~ ^-w|--worker$ ]] && { workerip="$2"; shift 2; continue; };
  [[ $1 =~ ^-v|--va$ ]] && { vaip="$2"; shift 2; continue; };
	shift
done

IFS=',' read -a mybootarray <<< "${bootip}"
IFS=',' read -a mymasterarray <<< "${masterip}"
IFS=',' read -a myproxyarray <<< "${proxyip}"
IFS=',' read -a myworkerarray <<< "${workerip}"
IFS=',' read -a myvaarray <<< "${vaip}"

export NUM_BOOT=${#mybootarray[@]}
export NUM_MASTER=${#mymasterarray[@]}
export NUM_PROXY=${#myproxyarray[@]}
export NUM_WORKER=${#myworkerarray[@]}
export NUM_VA=${#myvaarray[@]}

echo "$NUM_MASTER"

# Create Endpoint Based on Gluster Cluster IPs

KUB_CMDS="kubelet_extra_args='[\"--eviction-hard=memory.available<100Mi,nodefs.available<2Gi,nodefs.inodesFree<5\"]',\"--image-gc-high-threshold=100\",\"--image-gc-low-threshold=100\""

icp_hosts_txt=$(
  echo '[management]'
  for ((i=0; i < ${NUM_BOOT}; i++)); do
    echo "${mybootarray[i]} ${KUB_CMDS}"
  done
  echo "[master]"
  for ((i=0; i < ${NUM_MASTER}; i++)); do
    echo "${mymasterarray[i]} ${KUB_CMDS}"
  done
  echo "[proxy]"
  for ((i=0; i < ${NUM_PROXY}; i++)); do
    echo "${myproxyarray[i]} ${KUB_CMDS}"
  done
  echo "[worker]"
  for ((i=0; i < ${NUM_WORKER}; i++)); do
    echo "${myworkerarray[i]}"
  done
  echo "[va]"
  for ((i=0; i < ${NUM_VA}; i++)); do
    echo "${myvaarray[i]}"
  done
)

echo "/tmp/${random}/icp_hosts"

echo "${icp_hosts_txt}" > /tmp/${random}/icp_hosts