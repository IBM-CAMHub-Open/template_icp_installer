#!/bin/bash
set -x

while test $# -gt 0; do
  [[ $1 =~ ^-s|--nfsserver ]] && { NFS_SERVER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-f|--nfsfolder ]] && { NFS_FOLDER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-m|--nfsmount ]]  && { MOUNT_POINT="${2}"; shift 2; continue; };
  [[ $1 =~ ^-l|--dynamic ]]   && { FOLDERS="${2}"; shift 2; continue; };
  break;
done

IFS=',' read -a myfolderarray <<< "${FOLDERS}"

# NFS_SERVER=$1
# NFS_FOLDER=$2
# MOUNT_POINT=$3
# Check if a command exists
function command_exists() {
  type "$1" &> /dev/null;
}


function check_command_and_install() {
	command=$1
  string="[*] Checking installation of: $command"
  line="......................................................................."
  if command_exists $command; then
    printf "%s %s [INSTALLED]\n" "$string" "${line:${#string}}"
  else
    printf "%s %s [MISSING]\n" "$string" "${line:${#string}}"
      if [ $# == 3 ]; then # If the package name is provided
        if [[ $PLATFORM == *"ubuntu"* ]]; then
          sudo apt-get update -y
          sudo apt-get install -y $2
        else
          sudo yum install -y $3
        fi
      else # If a function name is provided
        eval $2
      fi
      if [ $? -ne "0" ]; then
        echo "[ERROR] Failed while installing $command"
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
# # Check if the executing platform is supported
# if [[ $PLATFORM == *"ubuntu"* ]] || [[ $PLATFORM == *"redhat"* ]] || [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
#   echo "[*] Platform identified as: $PLATFORM $PLATFORM_VERSION"
# else
#   echo "[ERROR] Platform $PLATFORM not supported"
#   exit 1
# fi
# Change the string 'redhat' to 'rhel'
if [[ $PLATFORM == *"redhat"* ]]; then
  PLATFORM="rhel"
fi


# Install requirements
check_command_and_install nfs-common nfs-common nfs-common
# sudo apt-get update -y
# sudo apt-get install -y nfs-common



# Create mount point
echo "Creating mount point: $MOUNT_POINT"
sudo mkdir -p $MOUNT_POINT
if [ $? != 0 ]; then
  echo "[ERROR] There was an error creating the mount point folder: '$MOUNT_POINT'"
  exit 1
fi
echo "Adding NFS server to fstab"
echo "$NFS_SERVER:$NFS_FOLDER $MOUNT_POINT  nfs4 rsize=1048576,hard,timeo=600,retrans=2,rw 0 0" >> /etc/fstab
echo "Mounting NFS Server"
mount $NFS_SERVER:$NFS_FOLDER $MOUNT_POINT
if [ $? != 0 ]; then
  echo "[ERROR] There was an error mounting the NFS server: '$NFS_SERVER'"
  exit 1
fi
mount -alias
if [ $? != 0 ]; then
  echo "[ERROR] There was an error mounting the NFS server: '$NFS_SERVER'"
  exit 1
fi
sleep 15
echo "Testing NFS Server"
touch $MOUNT_POINT/nfs_test > /dev/null
if [ $? == 0 ]; then
  echo "NFS Server mounted successfully"
  rm -rf $MOUNT_POINT/nfs_test
else
  echo "There was an error mounting the NFS server"
  exit 1
fi
echo "Creating ICP folders"

# Create mount point
echo "Creating mount point: $MOUNT_POINT"
sudo mkdir -p $MOUNT_POINT
if [ $? != 0 ]; then
  echo "[ERROR] There was an error creating the mount point folder: '$MOUNT_POINT'"
  exit 1
fi

echo "Creating ICP folders"
export NUM_FOLDERS=${#myfolderarray[@]}

for ((i=0; i < ${NUM_FOLDERS}; i++)); do
  last_folder=`echo ${myfolderarray[i]} | awk -F/ '{print $NF}'`
  other_folder=`echo ${myfolderarray[i]} | rev | cut -d"/" -f2-  | rev`
  echo $last_folder
  if [ ! -d "$MOUNT_POINT/$last_folder" ]; then
    echo "$MOUNT_POINT/$last_folder doesn't exist, creating..."
    mkdir -p "$MOUNT_POINT/$last_folder"
  fi
  if [ ! -d "${myfolderarray[i]}" ]; then
    echo "${myfolderarray[i]} doesn't exist, creating..."
    mkdir -p ${myfolderarray[i]}
  fi

  mount --bind ${myfolderarray[i]} $MOUNT_POINT/$last_folder
  echo "${myfolderarray[i]} $MOUNT_POINT/$last_folder  none bind 0 0" >> /etc/fstab

done
