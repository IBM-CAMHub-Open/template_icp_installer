#!/bin/bash

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

UNAME=$(uname | tr "[:upper:]" "[:lower:]")
PLATFORM=""
if [ "$UNAME" == "linux" ]; then
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        PLATFORM=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'// | tr "[:upper:]" "[:lower:]" )
    else
        PLATFORM=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1 | tr "[:upper:]" "[:lower:]")
    fi
fi

string="[*] Checking installation of: python"
line="......................................................................."
if command_exists "python"; then
    printf "\033[32m%s %s [INSTALLED]\n\033[0m\n" "$string" "${line:${#string}}"
  else
    printf "\033[33m%s %s [MISSING]\n\033[0m\n" "$string" "${line:${#string}}"
  if [[ $PLATFORM == *"ubuntu"* ]]; then
    wait_apt_lock
    sudo apt-get update
    wait_apt_lock
    sudo apt-get install -y python
  else
    cd /usr/src
    wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
    tar xzf Python-2.7.10.tgz
    cd Python-2.7.10
    ./configure
    make altinstall
    easy_install pip
  fi
fi