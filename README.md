# backup

openssl enc -d -aes256 -salt -pbkdf2 -in MYBACKUP.tar.gz | tar xz --strip-components=1 -C my-folder
