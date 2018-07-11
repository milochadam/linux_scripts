#!/bin/bash
set -e
# set -x

mkdir -p ~/my-backup

backupDir=$1

requiredDiskSpace=$(tar -czP $backupDir | wc -c)
echo "Required disk space: ${requiredDiskSpace}B"

availableDiskSpace=$(df -k ~/my-backup/ | tail -1 | awk '{print $4}')
echo "Available disk space: ${availableDiskSpace}B"

if [ $availableDiskSpace > $requiredDiskSpace ]
then
  echo "Making backup..."
  tar -czPf ~/my-backup/my-backup-$(date +%Y-%m-%d-%H.%M.%S).tar.gz $backupDir
  echo "Removing old backups..."
  ls -t ~/my-backup/ | tail -n +8 | awk -v HOME="$HOME" '{print HOME "/my-backup/"$1}' | xargs rm
else
  echo "No available disk space..."
fi
