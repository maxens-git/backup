#!/bin/sh

# create backup filename
BACKUP_FILE="Bitwardenrs_$(date "+%F-%H%M%S")"
BACKUP_FILE1="Adguard_Home_$(date "+%F-%H%M%S")"
BACKUP_FILE3="Nginx_Proxy_Manager_$(date "+%F-%H%M%S")"
#BACKUP_FILE4="Minecraft-spigot_$(date "+%F-%H%M%S")"


#Sauvegarde bitwarden
sqlite3 /docker/vaultwarden/db.sqlite3 ".backup '/tmp/db.sqlite3'"
tar -czf - /tmp/db.sqlite3 /docker/vaultwarden/attachments | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE}.tar.gz
rclone copy /tmp/${BACKUP_FILE}.tar.gz onedrive:Backups/vaultwarden
echo "sauvegarde bitwarden terminée"


#Sauvegarde Adguard Home
tar -czf - /docker/adguardhome | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE1}.tar.gz
rclone copy /tmp/${BACKUP_FILE1}.tar.gz onedrive:Backups/adguardhome
echo "sauvegarde adguard home terminée"



#Sauvegarde NPM
tar -czf - /docker/npm | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE3}.tar.gz
rclone copy /tmp/${BACKUP_FILE3}.tar.gz onedrive:Backups/npm
echo "sauvegarde nginx proxy manager terminée"




# cleanup tmp folder
rm -rf /tmp/*


# delete older backups if variable is set & greater than 0
if [ ! -z $DELETE_AFTER ] && [ $DELETE_AFTER -gt 0 ]; then
  /deleteold.sh
fi

