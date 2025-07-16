# Nextcloud setup

```bash
sudo nano /etc/fstab
```

```txt
10.0.14.14:/mnt/Zpool/Nextcloud /mnt/nextcloud nfs rw,mfsymlinks,seal,uid=33,gid=0,file_mode=0770,dir_mode=0770 0 0
```