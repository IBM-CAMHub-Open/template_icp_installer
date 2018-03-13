#!/usr/bin/env bash

set -e


echo "Arg1 : $1"
echo "Arg2 : ${*:2}"
IPS=${*:2}
export GLUSTER_IPS=(${IPS})
export NUM_GLUSTER_BRICKS=${#GLUSTER_IPS[@]}

echo "$GLUSTER_IPS"
echo "$NUM_GLUSTER_BRICKS"

# for ((i=0; i < $NUM_GLUSTER_BRICKS; i++)); do
#   echo "          - ip: ${GLUSTER_IPS[i]}"
#   echo "            device: @@glusterfs@@"
# done
# Create Endpoint Based on Gluster Cluster IPs
glusterfs_txt=$(
  echo "glusterfs: true"
  echo "storage:"
  echo "  - kind: glusterfs"
  echo "    nodes:"
  for ((i=0; i < $NUM_GLUSTER_BRICKS; i++)); do
    echo "      - ip: ${GLUSTER_IPS[i]}"
    echo "        device: @@glusterfs@@"
  done
  echo "    storage_class:"
  echo "      default: true"
  echo "      name: glusterfs-storage"
)

echo "${glusterfs_txt}" > /tmp/$1/glusterfs.txt