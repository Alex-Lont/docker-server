## Email Verification

```
sudo docker exec -it mariadb /bin/bash

mariadb --user=${BW_DB_USERNAME} --password=${BW_DB_PASSWORD}

USE ${use bitwarden_vault};

SELECT Name, Email, EmailVerified FROM User;

Update User set EmailVerified = 1 WHERE User.Name="${USER}";
```
