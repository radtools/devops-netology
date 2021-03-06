
# Домашнее задание к занятию "6.2. SQL"

## Задача 1
<details>
<summary>Условия</summary>
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
</details>
Подготовительные работы, поскольку хост fresh&clean, ставим все что нужно вытягиваем образ и запускаем его с примонтированными томами и попадаем в bash:
  
<br>
 <br>
  <br>
  
  
```BASH

#!/bin/bash

vol1="data-vol"                    #укажем в переменной наименование тома vol1
vol2="backup-vol"                  #укажем в переменной наименование тома vol2

sudo apt install docker -y         #установим docker (если он не установлен)
sudo docker pull postgres:12       #забираем образ Postgesql12 с docker HUB
sudo docker volume create "$vol1"  #создадим vol для data
sudo docker volume create "$vol2"  #создадим vol для backup
sudo docker run --rm --name pg-docker -d -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v "$vol1":/var/lib/postgresql/data -v "$vol2":/var/lib/backup postgres:12
sudo docker exec -it pg-docker bash #запустим bash в контейнере docker

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
         наименование varchar(128) NOT NULL, /*создадим столбец "наименование" и укажем что колонке 
	 нельзя присваивать значение NULL*/
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
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE public.clients TO "test-simple-user"; /*дадим права test-simple-user на 
таблицу clients*/
GRANT UPDATE, SELECT, INSERT, DELETE ON TABLE public.orders TO "test-simple-user";  /*дадим права test-simple-user на 
таблицу orders*/
```

Результат

Список таблиц
```BASH
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
Список пользователей
```BASH
test_db=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser, No inheritance                                  | {}
 test-simple-user | No inheritance                                             | {}
```
Описание таблиц
```BASH
test_db=# \d clients
                           Table "public.clients"
      Column       |         Type          | Collation | Nullable | Default
-------------------+-----------------------+-----------+----------+---------
 clients_id        | integer               |           | not null |
 ФИО               | character varying(64) |           | not null |
 страна проживания | character varying(64) |           | not null |
 заказ             | integer               |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (clients_id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(orders_id)

test_db=# \d orders
                         Table "public.orders"
    Column    |          Type          | Collation | Nullable | Default
--------------+------------------------+-----------+----------+---------
 orders_id    | integer                |           | not null |
 наименование | character varying(128) |           | not null |
 цена         | integer                |           | not null |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (orders_id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(orders_id)
```
  
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db  
  
```SQL
SELECT 
    grantee, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 
    1,2,3;
```
```BASH
grantee           | table_name | privilege_type
------------------+------------+----------------
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | TRIGGER
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | TRIGGER
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | UPDATE
 test-simple-user | clients    | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
```


## Задача 3

<details>
  <summary>Условия</summary>
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
</details>
  
SQL скрипт для добавления данных в таблицу

```SQL
INSERT INTO orders --добавим данных в таблицу orders
VALUES 
(1, 'Шоколад', 10), --строка 1, данные:столбец1,столбец2,столбец3
(2, 'Принтер', 3000), --строка 2
(3, 'Книга', 500), --строка 3
(4, 'Монитор', 7000), --строка 4
(5, 'Гитара', 4000); --строка 5

INSERT INTO clients  --добавим данных в таблицу clients
VALUES 
(1, 'Иванов Иван Иванович', 'USA'), --строка 1, данные:столбец1,столбец2,столбец3
(2, 'Петров Петр Петрович', 'Canada'), --строка 2
(3, 'Иоганн Себастьян Бах', 'Japan'), --строка 3
(4, 'Ронни Джеймс Дио', 'Russia'), --строка 4
(5, 'Ritchie Blackmore', 'Russia'); --строка 5
```
Результат:
```SQL
test_db=# select * from orders;

 orders_id | наименование | цена
-----------+--------------+------
         1 | Шоколад      |   10
         2 | Принтер      | 3000
         3 | Книга        |  500
         4 | Монитор      | 7000
         5 | Гитара       | 4000
(5 rows)

test_db=# select * from clients;
 clients_id |         ФИО          | страна проживания | заказ
------------+----------------------+-------------------+-------
          4 | Ронни Джеймс Дио     | Russia            |
          5 | Ritchie Blackmore    | Russia            |
          1 | Иванов Иван Иванович | USA               |     
          2 | Петров Петр Петрович | Canada            |    
          3 | Иоганн Себастьян Бах | Japan             |     
(5 rows)

```
Вычислите количество записей для каждой таблицы, приведите в ответе: запросы, результаты их выполнения.
```SQL
test_db=# select count(*) from orders;
 count
-------
     5
(1 row)

test_db=# select count(*) from clients;
 count
-------
     5
(1 row)
```
## Задача 4
<details>
  <summary>Условия</summary>
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.
</details>

Приведите SQL-запросы для выполнения данных операций.
```SQL
update  clients set заказ = 3 where clients_id = 1;  
update  clients set заказ = 4 where clients_id = 2;  
update  clients set заказ = 5 where clients_id = 3;  
```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.  
``select * from clients where заказ is not null`` - проверим и выведем непустые значения по "заказам" клиентов  

```SQL
test_db=# select * from clients where заказ is not null;
 clients_id |         ФИО          | страна проживания | заказ
------------+----------------------+-------------------+-------
          1 | Иванов Иван Иванович | USA               |     3
          2 | Петров Петр Петрович | Canada            |     4
          3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```SQL
test_db=# explain select * from clients where заказ is not null;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..12.40 rows=239 width=300)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```
 ``Seq Scan`` - последовательное чтоение блок за блоком  
 ``cost`` -затратность операции. первое значение (0.00) -затраты на получение первой строки, второе (12.40) - затраты на получение всех строк.   
 ``rows`` - примерное кол-во возвращаемых строк при ``Seq Scan``, ``width`` — средний размер одной строки в байтах.

## Задача 6
<details>
  <summary>Условия</summary>
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 
</details>

Создадим дамп БД через pgdump  
``pg_dump -U postgres test_db -f /var/lib/postgresql/dump_test.sql``  
Остановим контейнер  
``docker stop 3e89a4b99833``   
Запустим новый контейнер с примонтированными docker volumes и выполним восстановление из дампа
psql -U pguser -W test_db < /var/lib/backup/test_db.dump


