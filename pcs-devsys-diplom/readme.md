# Курсовая работа по итогам модуля "DevOps и системное администрирование"

Курсовая работа необходима для проверки практических навыков, полученных в ходе прохождения курса "DevOps и системное администрирование".

Мы создадим и настроим виртуальное рабочее место. Позже вы сможете использовать эту систему для выполнения домашних заданий по курсу

## Задание

1. Создайте виртуальную машину Linux.  
```
root@tests:~# uname -a
Linux tests 4.15.0-169-generic #177-Ubuntu SMP Thu Feb 3 10:50:38 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

```

2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.  

Merge 2+3

3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).

script

```bash
#!/bin/bash

#stage1. настраиваем ufw (задаем интерфейс для настройки соеденений на SSH и HTTPS 
#порты по TCP, разрешаем все на интерфейсе loopback) и устанавливаем VAULT, jq, mc и nginx

if="eth0"
ssh="22"
https="443"

sudo ufw allow in on "$if" to any port "$https" proto tcp
sudo ufw allow in on "$if" to any port "$ssh" proto tcp
sudo ufw allow in on lo
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install vault jq mc nginx -y
sudo mkdir /etc/nginx/ssl

echo "Now we have installed NGINX, JQ, MC and hashicorp VAULT. Did us? "
```  
result 

```bash 
ubuntu@test:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp on eth0             ALLOW       Anywhere
443/tcp on eth0            ALLOW       Anywhere
Anywhere on lo             ALLOW       Anywhere
22/tcp (v6) on eth0        ALLOW       Anywhere (v6)
443/tcp (v6) on eth0       ALLOW       Anywhere (v6)
Anywhere (v6) on lo        ALLOW       Anywhere (v6)
```
```bash 
ubuntu@test:~$ vault
Usage: vault <command> [args]
Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
...
```

отредактируем файл конфигурации `/etc/vault.d/vault.hcl`  

```
# HTTP listener
listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}
```

Включим и запустим сервис
`systemctl enable vault --now` , `sudo systemctl start vault` и `export VAULT_ADDR=http://127.0.0.1:8200` 

Чтобы данная системная переменная создавалась каждый раз при входе пользователя в систему, редактируем файл: `/etc/environment`  
добавим   
`VAULT_ADDR=http://127.0.0.1:8200`

Получаем ключи распечатки и начальный токен root  `vault operator init` 
```bash
vault operator init
Unseal Key 1: Le+FRdmRnftm1D23KXXyllHYNTznY5ooed90U6w9wf97
Unseal Key 2: nVcBktOzqlsGHO7WhuLhouzxQRAVC+Yhdg8RgFVfdcR+
Unseal Key 3: u2BfTG5tadiwEPSINPd6jJ0/swtQoTlxsVcClsXA6rvK
Unseal Key 4: YKL7RC4iQa1lO9JibkzLq80T0GDSyZg+uHBAfqkEa5nN
Unseal Key 5: nwY5IRnpJZ+aaBSH6/YWUT2SMSH62AiX8ZbjFJjeHsMD

Initial Root Token: s.FJQLbRVNzCp8GcsqfryFvglP
...
```

Vault сейчас запечатан (sealed) надо его распечатать

Для этого создадим скипт

```bash
#!/bin/bash
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

sleep 10
vault operator unseal Le+FRdmRnftm1D23KXXyllHYNTznY5ooed90U6w9wf97
vault operator unseal nVcBktOzqlsGHO7WhuLhouzxQRAVC+Yhdg8RgFVfdcR+
vault operator unseal YKL7RC4iQa1lO9JibkzLq80T0GDSyZg+uHBAfqkEa5nN

```

4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).


Скрипт

```bash 
#!/bin/bash

VAULT_TOKEN="root"
VAULT_ADDR="http://127.0.0.1:8200"
domain="zs-fond.online"
sub="test"
ssl_dir="/home/ubuntu"

vault secrets enable pki

vault secrets tune -max-lease-ttl=87600h pki

vault write -field=certificate pki/root/generate/internal common_name="$domain" ttl=87600h > CA.crt


vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

vault secrets enable -path=pki_int pki

vault secrets tune -max-lease-ttl=43800h pki_int

vault write -format=json pki_int/intermediate/generate/internal common_name="$domain Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr

vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem

vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

vault write pki_int/roles/"$domain"-role allowed_domains="$domain" allow_subdomains=true max_ttl="744h"

vault write -format=json pki_int/issue/"$domain"-role common_name="$sub.$domain" ttl="744h" > cert.json

cat cert.json | jq -r '.data.private_key' > key.pem

cat cert.json | jq -r '.data.certificate' > cert.pem

cat cert.json | jq -r '.data.issuing_ca' >> cert.pem

sudo mkdir /etc/nginx/ssl
sudo ln -s "$ssl_dir"/key.pem /etc/nginx/ssl
sudo ln -s "$ssl_dir"/cert.pem /etc/nginx/ssl

```
5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.

Добавил  
![image](https://user-images.githubusercontent.com/93760545/156750860-29f32e33-7118-4443-b285-af007199bceb.png)


6. Установите nginx.

Установлен в пп 3

7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
```
server {
       listen       443 ssl http2 default_server;
       server_name  test.zs-fond.online;
       root         /var/www/html;

       ssl_certificate "/etc/nginx/ssl/cert.pem";
       ssl_certificate_key "/etc/nginx/ssl/key.pem";
```

Добавил CA ([скачать сертификат CA](https://github.com/radtools/devops-netology/blob/main/pcs-devsys-diplom/CA.crt)) в список доверенных корневых центров сертификации  

8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.

![image](https://user-images.githubusercontent.com/93760545/156738081-a9aaabb1-0f88-4583-ba04-68ca610b0835.png)
![image](https://user-images.githubusercontent.com/93760545/156738193-5887f6b3-3c47-44c2-ae2a-19c64c9245fa.png)


9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.

```
#!/bin/bash

VAULT_TOKEN="s.FJQLbRVNzCp8GcsqfryFvglP"
VAULT_ADDR="http://127.0.0.1:8200"
domain="zs-fond.online"
sub="test"

vault write -format=json pki_int/issue/"$domain"-role common_name="$sub.$domain" ttl="744h" > cert.json

cat cert.json | jq -r '.data.private_key' > key.pem

cat cert.json | jq -r '.data.certificate' > cert.pem

cat cert.json | jq -r '.data.issuing_ca' >> cert.pem

systemctl restart nginx
```
вызов скрипта выдает ошибку: 

```
sudo /scripts/renew_site1.sh
Error writing data to pki_int/issue/zs-fond.online-role: Error making API request.

URL: PUT http://127.0.0.1:8200/v1/pki_int/issue/zs-fond.online-role
Code: 503. Errors:

* Vault is sealed
Job for nginx.service failed because the control process exited with error code.
See "systemctl status nginx.service" and "journalctl -xe" for details.
```
Vault запечатан, нужно его сначала распечатать  
Нужно его распечатать сначала.

по этому добавим в начало скрипта вызов скрипта unseal.sh  

![image](https://user-images.githubusercontent.com/93760545/156764720-9a43cd9d-a111-4d4e-96e1-4435a6452eb5.png)
  

`/bin/bash /scripts/unseal.sh`


10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

`0 0 15 * * /scripts/renew_site1.sh`

## Результат

Результатом курсовой работы должны быть снимки экрана или текст:

- Процесс установки и настройки ufw
- Процесс установки и выпуска сертификата с помощью hashicorp vault
- Процесс установки и настройки сервера nginx
- Страница сервера nginx в браузере хоста не содержит предупреждений 
- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")
- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)
