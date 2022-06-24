# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать.  

ДОКУМЕНТАЦИЯ БОЛЕЕ НЕДОСТУПНА НА ТЕРРИТОРИИ РФ

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя

```yml
db.currentOp(  # Returns a document that contains information on in-progress operations for the database instance.
   { 
     "active" : true, # Active operations only
     "secs_running" : { "$gt" : 180 } # returns information on all active operations for database that have been running longer than 120 seconds
   } 
)
```
Вывод запроса примерно такой
```yaml
{
    "inprog" : [ #status of operation
        {
            //...
            "opid" : XXXX, #ID of operation
            "secs_running" : NumberLong(YYYY) # The duration of the operation in seconds
            //...
        }
    ]
}
```


```yaml
db.killOp(XXXX) #Terminates an operation as specified by the operation ID
```

- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB  

Использовать `maxTimeMS()`    
The maxTimeMS() method sets a time limit for an operation. When the operation reaches the specified time limit, MongoDB interrupts the operation at the next interrupt point.  
Пример ограничения операции 30-ю мс: 

```yaml
db.location.find( { "town": { "$regex": "(Pine Lumber)",
                              "$options": 'i' } } ).maxTimeMS(30)
```                              
Так же нужно построить/перестроить соответствующий индекс.


## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

## Как вы думаете, в чем может быть проблема?
Вероятно превышен лимит памяти `maxmemory`  
Так же стоит убедиться что достаточна пропускная способность сети, поскольку есть еще механизм `Allow writes only with N attached replicas`. И не исключено что при дублировании записей на все реплики мы превышаем ширину канала  


## Задача 3

Перед выполнением задания познакомьтесь с документацией по [Common Mysql errors](https://dev.mysql.com/doc/refman/8.0/en/common-errors.html).

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

**Как вы думаете, почему это начало происходить и как локализовать проблему?**

Возможные причины:  
1) недостаточное значение параметра таймаута `connection_timeout` => увеличить значение  
2) Слишком большие запросы => увеличить параметр `net_read_timeout`  
3) Размер запроса превышает размер буфера => увеличит размер в `max_allowed_packet`  

**Какие пути решения данной проблемы вы можете предложить?**  
Решение вероятно будет таким:  
   1. Увеличить значение параметров : `wait_timeout`, `max_allowed_packet`, `net_write_timeout` и `net_read_timeout`  
   2. Создать индексы для оптимизации  и ускорения запросов (определить по плану запросов)  
   3. Добавить ресурсов на машине (если есть из чего)  
## Задача 4

Перед выполнением задания ознакомтесь со статьей [Common PostgreSQL errors](https://www.percona.com/blog/2020/06/05/10-common-postgresql-errors/) из блога Percona.

Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

**Как вы думаете, что происходит?**  

PostgreSQL желает утилизировать всю память хоста. Но Out-Of-Memory Killer не согласен с этим и прибивает процесс PostgreSQL

**Как бы вы решили данную проблему?**  
Вероятно настройкой перевыделения памяти:  
`vm.overcommit_memory = 2` - ядро не будет резервировать больше памяти, чем указано в параметре overcommit_ratio  
`vm.overcommit_ratio` = % выделяемой на резервирование памяти
`vm.swappiness` = использование swap как памяти

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
