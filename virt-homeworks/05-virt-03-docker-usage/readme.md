# Домашнее задание к занятию "5.3. Контейнеризация на примере Docker"

## Задача 1 

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование докера? Или лучше подойдет виртуальная машина, физическая машина? Или возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение; 
- Go-микросервис для генерации отчетов;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- База данных postgresql используемая, как кэш;
- Шина данных на базе Apache Kafka;
- Очередь для Logstash на базе Redis;
- Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе prometheus и grafana;
- Mongodb, как основное хранилище данных для java-приложения;
- Jenkins-сервер.

Сценарий | Организация серверов | ПЧМУ?
--- | --- | ---
Высоконагруженное монолитное java веб-приложение | `Физический хост` |  отстутствие накладных расходов на виртуализацию. монолитность приложения дает возможность разворачивать приложение на другом физическом хосте 
Go-микросервис для генерации отчетов |`Docker` |  Экономия дискового пространства и легковесность
Nodejs веб-приложение | `Docker` | Более простое воспроизведение зависимостей в рабочих средах 
Мобильное приложение c версиями для Android и iOS| `VM` | Размещение на одном физическом хосте, проще тестировать   
База данных postgresql используемая, как кэш | `VM` | Вероятно доступ к кэшу нужен из разных систем и кэш нужно сохранять между сессиями прикладного ПО    
Шина данных на базе Apache Kafka | `Docker` | Скорость разворачивания (есть готовые образы), изолированность.    
Очередь для Logstash на базе Redis| `Физический хост` |  В описании указана необходимость высокой производительности  
Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana| `Docker ` |  Скорость разворачивания (есть готовые образы), хотя для прода вроде как рекомендуют VM
Мониторинг-стек на базе prometheus и grafana| `Docker` |  Есть готовые образы, скорость разворачивания, возможность масштабирования для различных задач
Mongodb, как основное хранилище данных для java-приложения| `VM` | хранилище и в условиях не указано "высоконагруженное". Для физического хоста вероятно будет весьма расточительно  
Jenkins-сервер| `Docker` |  Есть готовые образы, скорость разворачивания, возможность масштабирования для различных задач
## Задача 2 

Сценарий выполения задачи:

- создайте свой репозиторий на докерхаб; 
- выберете любой образ, который содержит апач веб-сервер;
- создайте свой форк образа;
- реализуйте функциональность: 
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже: 
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m kinda DevOps now</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на докерхаб-репо.

создадим рабочую директорию mkdir homework_docker  
скачаем образ докер `docker pull httpd` (The Apache HTTP Server Project)  
создадим dockerfile  
```bash
cat << EOF > dockerfile.txt
FROM httpd
RUN echo '<html><head>Hey, Netology</head><body><h1>I am kinda DevOps now!</h1></body></html>' > /usr/local/apache2/htdocs/index.html
EOF
```

Запустим наш docker  
`docker run -d -p 8080:80 radtools/netology:0.1_apache`  
Проверим в браузере:  
![image](https://user-images.githubusercontent.com/93760545/158119154-b9242649-37aa-41d4-a984-2d6aa7fa8d19.png)

Ура, оно работает...  

Логинимся в hub.docker.com  
`docker login -u radtools`

И пушим свое чудо в репу  

`docker push radtools/netology:0.1_apache`  

[link to docker](https://hub.docker.com/layers/radtools/netology/0.1_apache/images/sha256-a6f915d4b90dac60a4239486421fc8fb93a425dc826f591e645ea86de8222f48?context=explore)  

## Задача 3 

- Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /share/info контейнера;
- Запустите второй контейнер из образа debian:latest в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /info контейнера;
- Подключитесь к первому контейнеру с помощью exec и создайте текстовый файл любого содержания в /share/info ;
- Добавьте еще один файл в папку info на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /info контейнера.

---
Для начала нужно получить эти образы  
`docker pull centos && docker pull debian:latest`  
затем на хостовой машине создадим папку "info"  
`mkdir info`  
запустим контейнер Centos с примонтированным каталогом info в share/info:  
`docker run -v /root/homework_docker/info:/share/info --name centos-container -d -t centos`  
подключимся к контейнеру:  
`docker exec -i -t 56cb9546bb63  bash`  
создадим текстовый файл
```bash
cat << EOF > /share/info/test_file_1.txt
Creating text file from centos container
More testing, more success, more fame.
EOF
```
Запустим второй контейнер debian с примонтированным каталогом info в info:   
`docker run -v /root/homework_docker/info:/info --name debian-container -d -t debian`  
Создадим файл на хостовой машине:

```bash
cat << EOF > /root//homework_docker/info/test_file_2.txt
Aquila non captat muscas
Linux is fun!
EOF
```

Посмотрим запущенные контейнеры:  
```bash
docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
c8e3696b5f01   debian    "bash"        56 seconds ago       Up 55 seconds                 debian-container
56cb9546bb63   centos    "/bin/bash"   About a minute ago   Up About a minute             centos-container
```
Подключимся к debian (c8e3696b5f01)  
`docker exec -i -t c8e3696b5f01  bash`
И взглянем на содержимое директории info:  
```bash
root@c8e3696b5f01:/info# ls -la
total 16
drwxr-xr-x 2 root root 4096 Mar 14 08:23 .
drwxr-xr-x 1 root root 4096 Mar 14 08:14 ..
-rw-r--r-- 1 root root   80 Mar 14 08:22 test_file_1.txt
-rw-r--r-- 1 root root   39 Mar 14 08:27 test_file_2.txt
```
и еще 
```bash
root@c8e3696b5f01:/info# cat test_file_1.txt
Creating text file from centos container
More testing, more success, more fame.
root@c8e3696b5f01:/info# cat test_file_2.txt
Aquila non captat muscas
Linux is fun!
```


### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
