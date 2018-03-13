#!/bin/bash

function wait_apt_lock()
{
    sleepC=5
    while [[ -f /var/lib/dpkg/lock  || -f /var/lib/apt/lists/lock ]]
    do
      sleep $sleepC
      echo "    Checking lock file /var/lib/dpkg/lock or /var/lib/apt/lists/lock"
      [[ `sudo lsof 2>/dev/null | egrep 'var.lib.dpkg.lock|var.lib.apt.lists.lock'` ]] || break
      let 'sleepC++'
      if [ "$sleepC" -gt "50" ] ; then
 	lockfile=`sudo lsof 2>/dev/null | egrep 'var.lib.dpkg.lock|var.lib.apt.lists.lock'|rev|cut -f1 -d' '|rev`
        echo "Lock $lockfile still exists, waited long enough, attempt apt-get. If failure occurs, you will need to cleanup $lockfile"
        continue
      fi
    done
}


DRIVE=$1
MOUNT_POINT="/var/nfs"
# format and mount a drive to /mnt
echo "Formatting drive $DRIVE"
mkfs -t ext3 $DRIVE
echo "Creating folder for mount point: $MOUNT_POINT"
mkdir -p $MOUNT_POINT
echo "Adding $DRIVE to /etc/fstab"
echo "$DRIVE  $MOUNT_POINT ext3  defaults 1 3" | tee -a /etc/fstab
echo ""
echo "Setting mount point permissions and mounting"
sudo chown nobody:nogroup $MOUNT_POINT
mount $MOUNT_POINT
echo "Installing nfs-kernel-server"
wait_apt_lock
sudo apt-get update -y
wait_apt_lock
sudo apt-get install -y nfs-kernel-server
echo "$MOUNT_POINT  *(rw,sync,no_subtree_check,no_root_squash)" | tee -a /etc/exports
sudo systemctl restart nfs-kernel-server
