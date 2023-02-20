#!/bin/sh

# create backup filename
BACKUP_FILE="Bitwardenrs_$(date "+%F-%H%M%S")"
BACKUP_FILE1="Adguard_Home_$(date "+%F-%H%M%S")"
BACKUP_FILE2="Portainer_$(date "+%F-%H%M%S")"
BACKUP_FILE3="Nginx_Proxy_Manager_$(date "+%F-%H%M%S")"



#Sauvegarde bitwarden
sqlite3 /data/vaultwarden/db.sqlite3 ".backup '/tmp/db.sqlite3'"
tar -czf - /tmp/db.sqlite3 /data/vaultwarden/attachments | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE}.tar.gz
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE}.tar.gz /${BACKUP_FILE}.tar.gz
echo "sauvegarde bitwarden terminée"

#Sauvegarde NPM
tar -czf - /data/npm | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE3}.tar.gz
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE3}.tar.gz /${BACKUP_FILE3}.tar.gz
echo "sauvegarde nginx proxy manager terminée"

#Sauvegarde Portainer
node /src/index.js backup

tar -czf - /portainer | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE2}.tar.gz
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE2}.tar.gz /${BACKUP_FILE2}.tar.gz
echo "sauvegarde portainer termimnée"

#Sauvegarde Adguard Home
tar -czf - /data/adguardhome | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE1}.tar.gz
/dropbox_uploader.sh -f /config/.dropbox_uploader upload /tmp/${BACKUP_FILE1}.tar.gz /${BACKUP_FILE1}.tar.gz
echo "sauvegarde adguard home terminée"



# cleanup tmp folder
rm -rf /tmp/*
rm -rf /portainer/*

# delete older backups if variable is set & greater than 0
if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]; then
  /deleteold.sh
fi
