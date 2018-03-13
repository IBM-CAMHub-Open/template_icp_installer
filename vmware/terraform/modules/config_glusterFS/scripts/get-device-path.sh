#!/bin/bash
#
# This will locate a set of iunformatted disks
#set -x
function find_disk()
{
  # Will return an unallocated disk, it will take a sorting order from largest to smallest, allowing a the caller to indicate which disk
  [[ -z "$1" ]] && whichdisk=1 || whichdisk=$1
  local readonly=`parted -l | egrep -i "Warning:" | tr ' ' '\n' | egrep "/dev/" | sort -u | xargs -i echo "{}|" | xargs echo "NONE|" | tr -d ' ' | rev | cut -c2- | rev`
  diskcount=`sudo parted -l 2>&1 | egrep -v "$readonly" | egrep -c -i 'ERROR: '`
  if [ "$diskcount" -lt "$whichdisk" ] ; then
        echo ""
  else
        # Find the disk name
        greplist=`sudo parted -l 2>&1 | egrep -v "$readonly" | egrep -i "ERROR:" |cut -f2 -d: | xargs -i echo "Disk.{}:|" | xargs echo | tr -d ' ' | rev | cut -c2- | rev`
        echo `sudo fdisk -l  | egrep "$greplist"  | sort -k5nr | head -n $whichdisk | tail -n1 | cut -f1 -d: | cut -f2 -d' '`
  fi
}
#
function find_link()
{
  # This will locate the link to the by-path
  local pathname=/dev/disk/by-path
  local by_path=""
  by_path=`ls -l $pathname | egrep "$1" | tr -s ' ' | cut -f9 -d' '`
  [[ -z "$by_path" ]] && echo ERROR: Could not find link : `ls -l $pathname` || echo link: $pathname/$by_path
}
function part1()
{
  # this is the main body of the function
  cat $1 | while read line
  do
  whattype=`echo $line | cut -f1 -d' '`
  user=`echo $line | cut -f2 -d' '`
  host=`echo $line| cut -f3 -d' '`
  # rawdisk=`ssh $user@$host  "bash -s" < $call_back find_disk | cut -f3 -d'/'`
  rawdisk=`find_disk | cut -f3 -d'/'`
  sed -i "/^$whattype / s/\$/ $rawdisk/" $1
  done
}
function part2()
{
  # This is the part which would go the remote system to get the sym link
  cat $1 | while read line
  do
  whattype=`echo $line | cut -f1 -d' '`
  user=`echo $line | cut -f2 -d' '`
  host=`echo $line| cut -f3 -d' '`
  whichdisk=`echo $line | cut -f4 -d' '`
  local by_path=`find_link $whichdisk | cut -f2- -d: | tr -d '[:space:]'`
  by_path_sed=$(echo "$by_path" | sed 's/\//\\\//g')
  cp /tmp/glusterfs.txt /tmp/glusterfs.txt.backup
  sed -i "s/@@glusterfs@@/$by_path_sed/g" /tmp/glusterfs.txt

  #echo $by_path
  done

}
call_back=$0
functionName=$1; shift
$functionName $@