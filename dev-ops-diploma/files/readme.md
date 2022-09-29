# Дипломный практикум в YandexCloud

### Регистрация доменного имени

   - Произведена регистрация нового домена radtools.ru у регистратора reg.ru.

   - Перенастроены резолверы для домена radtools.ru на DNS сервера YandexCloud.
      ns1.yandexcloud.net
      ns2.yandexcloud.net

### Создание инфраструктуры

   - Секреты для разворачивания инфраструктуры хранятся в 2-х файлах (key.json, backend.conf).

### Инициализируем бакет: 

```
terraform init && terraform plan && terraform apply --auto-approve
```

![image](https://user-images.githubusercontent.com/93760545/190083980-c8c57590-c4b7-4a8d-9f44-6501fd79731f.png)

Далее инициализируем терраформ и создаем воркспейс
```
terraform init -reconfigure -backend-config=./backend.conf

terraform workspace new stage
```
Далее применяем конфигурацию терраформ  
```
terraform init && terraform plan && terraform apply --auto-approve
```
Результат:  
![image](https://user-images.githubusercontent.com/93760545/192955702-0c15f9d3-bcc7-42fc-acf2-11edc2c5a976.png)
![image](https://user-images.githubusercontent.com/93760545/192955759-4df370e8-830f-4ca2-b0b8-165bde603105.png)
![image](https://user-images.githubusercontent.com/93760545/192955817-1e168a66-f68a-4d91-bac2-cc8dff31cb34.png)


Далее запускаем Ansible

```
ansible-playbook playbook.yml
```

Начинаем с NAT, NGINX и LetsEncrypt  

```YAML
- include_tasks: nat.yml
- include_tasks: proxy-server.yml
- include_tasks: letsencrypt.yml
```
Далее устанавливаем node-exporter на все хосты

`node_exporter/tasks/main.yml`

После устанавливаем MYSQL (Replicated - MASTER\SLAVE)  

Проверка репликации БД  
![image](https://user-images.githubusercontent.com/93760545/192269776-a4a1c522-2417-4c9e-8ce5-cfc6cef288ed.png)

И Mysql-Exporter  
`mysqld_exporter/tasks/main.yml`  

Далее ставим WP с БД на db01.radtools.ru    
 ![image](https://user-images.githubusercontent.com/93760545/192270571-dbadaa9d-0be4-4dc7-80c4-4ec7d3b73d0c.png)  
(Сразу после установки)  
![image](https://user-images.githubusercontent.com/93760545/192270932-e48bd816-f11d-4f42-b202-2c56c41cdfa6.png)  
![image](https://user-images.githubusercontent.com/93760545/192274757-b27bd065-fecf-4e0d-a3cf-00f3b4cb7223.png)



Далее идет установка Gitlab-CE и Gitlab-runner

![image](https://user-images.githubusercontent.com/93760545/192447531-524a4279-1e42-4a09-b7ad-c83ae66a5fbd.png)


![image](https://user-images.githubusercontent.com/93760545/192447467-97a0fa86-db15-4272-b422-8de0fb5dc95b.png)


И в заключение устанавливается стек мониторинга (Prometheus\Grafana\Alertmanager)  

Screenshots:    
![image](https://user-images.githubusercontent.com/93760545/192271455-ee84d291-0f39-4bcf-b957-3fe792626075.png)    

![image](https://user-images.githubusercontent.com/93760545/192275613-37e5e5b5-624c-4650-9bbd-9e15e5240275.png)    

![image](https://user-images.githubusercontent.com/93760545/192275729-5c3903e5-00af-4b03-a558-e12250db7e8d.png)  

Клонируем репозиторий в gitlab (New project - import project - repo by URL - https://github.com/wordpress/wordpress.git)  

![image](https://user-images.githubusercontent.com/93760545/192956428-0fca33fe-8002-42dc-939e-35bf06021510.png)  

добавляем файл .gitlab-ci.yml
```
```









