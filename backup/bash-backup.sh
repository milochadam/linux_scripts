#!/bin/bash

set -e
#set -x

if [[  $1 == "-v"  ]]
then
  echo "bash-backup 1.0.0"
  exit
fi

exec 3>&1;

backupDir=$(dialog --title "Wybór katalogu" --inputbox "Podaj katalog, którego powinna zostać wykonana kopia zapasowa" 8 40 2>&1 1>&3)

backupFreq=$(dialog --menu "Jak często chcesz wykonywać kopię zapasową ?" 15 50 4 \
		1 "Co minutę." \
		2 "Co godzinę." \
		3 "Codziennie o północy." 2>&1 1>&3);

crontab -l | grep "^do-backup" | cat > backup-cron
if [ $backupFreq = 1 ] 
then
  echo "*/1 * * * * $(pwd)/do-backup.sh ${backupDir} >> $(pwd)/bash-backup.log 2>&1" >> backup-cron
elif [ $backupFreq = 2 ]
then
  echo "0 */1 * * * $(pwd)/do-backup.sh ${backupDir} >> $(pwd)/bash-backup.log 2>&1" >> backup-cron
elif [ $backupFreq = 3 ]
then
  echo "0 0 */1 * * $(pwd)/do-backup.sh ${backupDir} >> $(pwd)/bash-backup.log 2>&1" >> backup-cron
fi

crontab backup-cron
