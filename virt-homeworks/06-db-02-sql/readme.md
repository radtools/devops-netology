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
