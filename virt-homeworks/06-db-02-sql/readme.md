
# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Подготовительные работы, поскольку хост fresh&clean, ставим все что нужно вытягиваем образ и запускаем его с примонтированными томами и попадаем в bash:

```bash

#!/bin/bash

vol1="data-vol"                    #укажем в переменной наименование тома vol1
vol2="backup-vol"                  #укажем в переменной наименование тома vol2

sudo apt install docker -y         #установим docker (если он не установлен)
sudo docker pull postgres:12       #забираем образ Postgesql12 с docker HUB
sudo docker volume create "$vol1"  #создадим vol для data
sudo docker volume create "$vol2"  #создадим vol для backup
sudo docker run --rm --name psql-docker -d -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v "$vol1":/var/lib/postgresql/data -v "$vol2":/var/lib/postgresql postgres:12
sudo docker exec -it psql-docker bash #запустим bash в контейнере docker

```




## Задача 2

<details>
  <summary>Условия</summary>
В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db
</details>
	
Для начала запустим psql примерно так  
``root@1490454abb7c:/#psql -U postgres -d postgres``

Далее скормим psql SQL скрипт:

```SQL
CREATE DATABASE test_db;   --создадим БД с названием test_db
CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;  /*создадим пользователя с админскими 
правами и именем test-admin-user*/

CREATE TABLE orders  --создадим таблицу заказов "orders"  
(
         orders_id integer PRIMARY KEY, --создадим столбец и зададим как первичный ключ (одновременно UNIQUE и NOT NULL)
         наименование varchar(128) NOT NULL, --создадим столбец "наименование" и укажем что колонке нельзя присваивать значение NULL
         цена integer NOT NULL --создадим столбец "цена" и укажем что колонке нельзя присваивать значение NULL
);

CREATE TABLE clients 
(
	clients_id integer PRIMARY KEY, --создадим столбец и зададим как первичный ключ (одновременно UNIQUE и NOT NULL)
	ФИО varchar(64) NOT NULL, --создадим столбец "ФИО" и укажем что колонке нельзя присваивать значение NULL
	"страна проживания" varchar(64)NOT NULL, /*создадим столбец "страна проживания" и укажем что колонке 
	нельзя присваивать значение NULL*/
	заказ integer, --создадим столбец "заказ"
	FOREIGN KEY (заказ) REFERENCES orders (orders_id)  /*создадим "внешний ключ" для связи между таблицами
	с указанием на имя связанной таблицы "orders"*/
);

CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN; --создадим пользователя test-simple-user
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE public.clients TO "test-simple-user"; --дадим права test-simple-user на таблицу clients
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE public.orders TO "test-simple-user";  --дадим права test-simple-user на таблицу orders
```
```SQL
INSERT INTO orders --добавим данных в таблицу orders
VALUES 
(1, 'Шоколад', 10),
(2, 'Принтер', 3000),
(3, 'Книга', 500),
(4, 'Монитор', 7000),
(5, 'Гитара', 4000);

INSERT INTO clients  --добавим данных в таблицу clients
VALUES 
(1, 'Иванов Иван Иванович', 'USA'),
(2, 'Петров Петр Петрович', 'Canada'),
(3, 'Иоганн Себастьян Бах', 'Japan'),
(4, 'Ронни Джеймс Дио', 'Russia'),
(5, 'Ritchie Blackmore', 'Russia');
```
psql -U postgres -d postgres


update  clients set заказ = 3 where clients_id = 1;  
update  clients set заказ = 4 where clients_id = 2;  
update  clients set заказ = 5 where clients_id = 3;  




