
# backup

docker-compose.yml

```docker
version: '3.2'
services:
  Backup-Portainer:
    container_name: Backup
    image: ghcr.io/maxens-git/backup:latest
    hostname: portainer-backup
    restart: unless-stopped
    command: schedule
    environment:
      BACKUP_ENCRYPTION_KEY: "Mot de passe du fichier de sauvegarde"
      TZ: Europe/Paris #https://manpages.ubuntu.com/manpages/bionic/man3/DateTime::TimeZone::Catalog.3pm.html
      PORTAINER_BACKUP_URL: "https://portainer.monserveur.com"
      PORTAINER_BACKUP_TOKEN: "token portainer"
      PORTAINER_BACKUP_SCHEDULE: "0 0 * * *"
    volumes:
      - /docker/npm:/data/npm
      - /docker/vaultwarden:/data/vaultwarden
      - /docker/adguardhome:/data/adguardhome
      - ./config:/config  
```

```
sudo docker-compose up -d
```

### Déchiffrer le fichier de sauvegarde
```
openssl enc -d -aes256 -salt -pbkdf2 -in MYBACKUP.tar.gz | tar xz --strip-components=1 -C my-folder
```
