#!/bin/bash

# set -x

# Get script parameters
while test $# -gt 0; do
  [[ $1 =~ ^-d|--docker ]] && { PARAM_DOCKER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-v|--version ]] && { PARAM_ICP_VERSION="${2}"; shift 2; continue; };
  [[ $1 =~ ^-u|--user ]] && { PARAM_AUTH_USER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-p|--password ]] && { PARAM_AUTH_PASSWORD="${2}"; shift 2; continue; };
  break;
done

# Check if a command exists
function command_exists() {
  type "$1" &> /dev/null;
}


# download_file name url file-name
function download_file() {
# set -x
  rm -rf *.prg
  if [[ !  -z  ${4}  ]] && [[ !  -z  ${5}  ]]; then
    printf "\033[33m [Secure Repo Download]\n\033[0m\n"
    curl -k -u $4:$5 -o $3 -L --retry 5 --progress-bar $2 2> $3.prg &
  else
    printf "\033[33m [Non-Secure Repo Download]\n\033[0m\n"
    curl -k -o $3 -L --retry 5 --progress-bar $2 2> $3.prg &
  fi 
  CURL_PID=$!
  string="[*] Downloading: $1"
  line="......................................................."
  LAST_PROGRESS='0.0'

  while kill -0 $CURL_PID > /dev/null 2>&1
  do
    sleep 10
    PROGRESS=`grep -o -a "..0..%" $3.prg | tail -n1`
    if [ "$PROGRESS%" != "$LAST_PROGRESS%" ]; then
      LAST_PROGRESS=$PROGRESS
      if [ -n "${PROGRESS/[ ]*\n/}" ]; then
        printf "\033[32m %s %s [$PROGRESS%]\n\033[0m\n" "$string" "${line:${#string}}"
      fi
    fi
  done
  rm -rf $3.prg
  printf "\033[32m %s %s [$COMPLETE]\n\033[0m\n" "$string" "${line:${#string}}"
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
  if command_exists $command; then
    # printf "%s %s [INSTALLED]\n" "$string" "${line:${#string}}"
    printf "\033[32m%s %s [INSTALLED]\n\033[0m\n" "$string" "${line:${#string}}"
  else
    # printf "%s %s [MISSING]\n" "$string" "${line:${#string}}"
    printf "\033[33m%s %s [MISSING]\n\033[0m\n" "$string" "${line:${#string}}"
    if [ $# == 3 ]; then # If the package name is provided
      if [[ $PLATFORM == *"ubuntu"* ]]; then
        wait_apt_lock
        sudo apt-get update -y
        wait_apt_lock
        sudo apt-get install -y $2
      else
        sudo yum install -y $3
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

# Get chef's URL from parameter
URL_REGEX='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [ -n $PARAM_DOCKER ]; then
  # echo "PARAM_DOCKER: ${PARAM_DOCKER}"
  if [[ $PARAM_DOCKER =~ $URL_REGEX ]]; then
    if [[ -e "/root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin" ]]; then
      # echo "[*] Previous Downloaded successful of /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin"
      printf "\033[32m[*] Previous Downloaded successful of /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin\033[0m\n"
    else
      # echo "[*] Docker Binary URL was provided: $PARAM_DOCKER"
      printf "\033[32m[*] Docker Binary URL was provided: $PARAM_DOCKER\033[0m\n"
      DOCKER_URL=$PARAM_DOCKER
      check_command_and_install curl curl curl
      download_file 'Docker ICP Binary' $DOCKER_URL /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin ${PARAM_AUTH_USER} ${PARAM_AUTH_PASSWORD}
      [[ -e "/root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin" ]] && printf "\033[32m[*] Previous Downloaded successful of /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin\033[0m\n" || { printf "\033[31m[ERROR] Previous Downloaded FAILED of /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin from ${DOCKER_URL}\033[0m\n" ; exit 1; }
      chmod +x /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin
      sudo /root/ibm-cloud-private-x86_64-${PARAM_ICP_VERSION}/icp-docker.bin --install
      sudo systemctl start docker
    fi

  else
      # echo "[ERROR] Docker Binary URL is not Valid, check $PARAM_DOCKER"
      printf "\033[31m[ERROR] Docker Binary URL is not Valid, check $PARAM_DOCKER\033[0m\n"
      exit 1
  fi
fi