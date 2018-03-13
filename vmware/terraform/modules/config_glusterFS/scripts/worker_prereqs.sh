#!/bin/bash

# set -x


# Check if a command exists
function package_exists() {
  if [[ $PLATFORM == *"ubuntu"* ]]; then
    sudo dpkg -l |grep $2 &> /dev/null;
  else
    sudo rpm -qa |grep $3 &> /dev/null;
  fi
}

function command_exists() {
  type "$1" &> /dev/null;
}
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
function check_command_and_install() {
	command=$1
  string="[*] Checking installation of: $command"
  line="......................................................................."
  if package_exists $command; then
    # printf "%s %s [INSTALLED]\n" "$string" "${line:${#string}}"
    printf "\033[32m%s %s [INSTALLED]\n\033[0m\n" "$string" "${line:${#string}}"
  else
    # printf "%s %s [MISSING]\n" "$string" "${line:${#string}}"
    printf "\033[33m%s %s [MISSING]\n\033[0m\n" "$string" "${line:${#string}}"
    if [ $# == 3 ]; then # If the package name is provided
      if [[ $PLATFORM == *"ubuntu"* ]]; then
        wait_apt_lock
        sudo apt-get update
        wait_apt_lock
        sudo apt-get install -y $2
        printf "\033[32m%s %s [INSTALLED]\n\033[0m\n" "$string" "${line:${#string}}"
      else
        sudo yum install -y $3
        printf "\033[32m%s %s [INSTALLED]\n\033[0m\n" "$string" "${line:${#string}}"
      fi
    else # If a function name is provided
      eval $2
    fi
    if [ $? -ne "0" ]; then
      # echo "[ERROR] Failed while installing $command"
      printf "\033[31m[ERROR] Failed while installing $command\033[0m\n"
      exit 1
    fi
  fi
}


# Identify the platform and version using Python
if command_exists python; then
  PLATFORM=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
  PLATFORM_VERSION=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
else
  if command_exists python3; then
    PLATFORM=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
    PLATFORM_VERSION=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
  fi
fi
if [[ $PLATFORM == *"redhat"* ]]; then
  PLATFORM="rhel"
fi

check_command_and_install glusterfs-client glusterfs-client glusterfs-client
if [ `lsmod | grep dm_thin_pool | wc -l` -gt 0 ];then
  printf "\033[32m%s [MODULE_CONFIGURED]\n\033[0m\n" "dm_thin_pool"
else
  printf "\033[32m%s [CONFIGURING_MODULE]\n\033[0m\n" "dm_thin_pool"
  echo "Commenting out and replacing with ICP setting for - dm_thin_pool"
  sed -i '/dm_thin_pool/s/^/#/g' /etc/modules
  echo dm_thin_pool | sudo tee -a /etc/modules
  sudo modprobe dm_thin_pool
fi