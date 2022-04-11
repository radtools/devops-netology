```
version: "3.9"  
services:  
  postgres:  
    image: postgres:13.3  
    environment:  
      POSTGRES_DB: "pgdb"  
      POSTGRES_USER: "pguser"  
      POSTGRES_PASSWORD: "pgpwd"  
      PGDATA: "/var/lib/postgresql/data/pgdata"  
    volumes:  
      - ../2. Init Database:/docker-entrypoint-initdb.d  
      - data-vol:/var/lib/postgresql/data/  
      - backup-vol:/backups  
    ports:  
      - "5432:5432"  
volumes:  
  data-vol: {}  
  backup-vol: {}  
```


```bash
#!/bin/bash
#!/bin/sh

dbname="test_db"
username="test-admin-user"
psql $dbname $username << EOF
SELECT * FROM test;
EOF
#проверим есть ли бд test_db. Если ее нет - создадим.  
sudo -u postgres psql -c "SELECT 1 FROM pg_database WHERE datname = 'test_db'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE test_db" 

#sudo -u postgres psql -c "CREATE USER "test-admin-user" WITH PASSWORD "qwerty";"
#sudo -u postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'test_db'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE test_db"


#sudo -u postgres bash -c "psql -c \"CREATE USER test-admin-user WITH PASSWORD 'qwerty';\""
