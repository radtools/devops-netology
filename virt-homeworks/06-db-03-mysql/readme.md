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
sudo docker pull postgres:12       #забираем образ Postgesql12 с docker HUB
sudo docker volume create "$vol1"  #создадим vol для MySQL
sudo docker run --rm --name mysql-docker -e MYSQL_ROOT_PASSWORD=mysql -ti -p 3306:3306 -v "$vol1":/etc/mysql/ mysql:8.0
sudo docker exec -it mysql-docker bash #запустим bash в контейнере docker
```
Статус БД




