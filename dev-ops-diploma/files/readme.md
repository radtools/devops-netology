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
cd s3/ || return
terraform init && terraform plan && terraform apply --auto-approve
```

![image](https://user-images.githubusercontent.com/93760545/190083980-c8c57590-c4b7-4a8d-9f44-6501fd79731f.png)

Проверка репликации БД   
![изображение](https://user-images.githubusercontent.com/93760545/192254061-7dcef200-a1af-43d4-9fd4-c1aa4d73b316.png)


