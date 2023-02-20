#!/bin/sh

# create backup filename
BACKUP_FILE="bitwardenrs_$(date "+%F-%H%M%S")"
BACKUP_FILE1="Adguard_Home_$(date "+%F-%H%M%S")"
BACKUP_FILE2="Portainer_$(date "+%F-%H%M%S")"
BACKUP_FILE3="Nginx_Proxy_Manager_$(date "+%F-%H%M%S")"



if [ ${SAVEBITWARDEN} == "yes" ]; then
  sqlite3 /data/vaultwarden/db.sqlite3 ".backup '/tmp/db.sqlite3'"
  tar -czf - /tmp/db.sqlite3 /data/vaultwarden/attachments | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE}.tar.gz
  /dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE}.tar.gz /${BACKUP_FILE}.tar.gz
  echo "sauvegarde bitwarden terminée"
else
  echo "pas de souvegarde bitwarden"
fi

if [ ${SAVENPM} == "yes" ]; then
  tar -czf - /data/npm | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE3}.tar.gz
  /dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE3}.tar.gz /${BACKUP_FILE3}.tar.gz
  echo "sauvegarde nginx proxy manager terminée"
else
  echo "pas de sauvegarde nginx proxy manager"
fi

if [ ${SAVEPORTAINER} == "yes" ]; then
  tar -czf - /data/portainer | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE2}.tar.gz
  /dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE2}.tar.gz /${BACKUP_FILE2}.tar.gz
  echo "sauvegarde portainer termimnée"
else
  echo "pas de sauvegarde portainer"
fi

if [ ${SAVEADGUARDHOME} == "yes" ]; then
  tar -czf - /data/adguardhome | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE1}.tar.gz
  /dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE1}.tar.gz /${BACKUP_FILE1}.tar.gz
  echo "sauvegarde adguard home terminée"
else
  echo "pas de sauvegarde adguard home"
fi



# cleanup tmp folder
rm -rf /tmp/*

# delete older backups if variable is set & greater than 0
if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]; then
  /deleteold.sh
fi
