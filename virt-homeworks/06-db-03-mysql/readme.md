# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1
<details>
    <summary><b>условие</b> (<i>нажмите, что бы развернуть</i>)</summary>
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.
</details>

Поскольку машина у нас чистая сделаем подготовительные работы:

```BASH
#!/bin/bash

vol1="data-vol"                    #укажем в переменной наименование тома vol1

sudo apt install docker -y         #установим docker (если он не установлен)
sudo docker pull mysql             #забираем образ mysql с docker HUB
sudo docker volume create "$vol1"  #создадим vol для MySQL
sudo docker run --rm --name mysql-docker -e MYSQL_ROOT_PASSWORD=mysql -ti -p 3306:3306 -v "$vol1":/etc/mysql/ mysql:8.0
sudo docker exec -it mysql-docker bash #запустим bash в контейнере docker
```
Восстановим БД из бекапа
```BASH
root@6a6f611abd1f:/# cd home #перейдем в каталог HOME
root@6a6f611abd1f:/home# wget https://raw.githubusercontent.com/netology-code/virt-homeworks/master/06-db-03-mysql/test_data/test_dump.sql #скачаем дамп БД
root@6a6f611abd1f:/home# mysql -uroot -p #запустим mysql cli
mysql> CREATE DATABASE test DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci; #создадим пустую БД
root@6a6f611abd1f:/home# mysql -v -u root -p   test < /home/test_dump.sql  #восстановим БД из бекапа в пустую БД
```

Статус БД
```SQL
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          18
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.29 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 1 hour 7 min 51 sec

Threads: 2  Questions: 49  Slow queries: 0  Opens: 476  Flush tables: 5  Open tables: 22  Queries per second avg: 0.012
--------------

```
Приведите в ответе количество записей с price > 300.

```SQL
mysql>  use test;
Database changed
mysql> select count(*) from orders where price >300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

  ## Задача 2
<details>
    <summary><b>условие</b> (<i>нажмите, что бы развернуть</i>)</summary>
 Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
</details>

```SQL
mysql> mysql> CREATE USER IF NOT EXISTS 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_CONNECTIONS_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    -> ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
```

