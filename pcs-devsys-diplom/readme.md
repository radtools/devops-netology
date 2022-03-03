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

Объединил п2 и п3.

3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).

Объединил п2 и п3 в один скрипт.

```
#!/bin/bash
sudo ufw allow in on eth0 to any port 443 proto tcp
sudo ufw allow in on eth0 to any port 22 proto tcp
sudo ufw allow in on lo
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault
```

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
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens
```

4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).

Merge 4+5


5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.

Скрипт

```bash 
#!/bin/bash
sudo apt install jq -y
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
tee admin-policy.hcl <<EOF
# Enable secrets engine
path "sys/mounts/*" {
 capabilities = [ "create", "read", "update", "delete", "list" ]
}

# List enabled secrets engine
path "sys/mounts" {
 capabilities = [ "read", "list" ]
}

# Work with pki secrets engine
path "pki*" {
 capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOF

# enable policy

vault policy write admin admin-policy.hcl

#Generating root CA

#enable pki

vault secrets enable pki

#tune pki ttl to 87600 hours

vault secrets tune -max-lease-ttl=87600h pki

#gen&save root cert in CA_cert.crt to domain zs-fond.online

vault write -field=certificate pki/root/generate/internal \
     common_name="zs-fond.online" \
     ttl=87600h > CA_cert.crt

#Configure the CA and CRL URLs

vault write pki/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

#Generate intermediate CA

#enable pki secrets at pki_int path.

vault secrets enable -path=pki_int pki

#tune pki_int TTL to 43800 hrs

vault secrets tune -max-lease-ttl=43800h pki_int

#generate an intermediate and save the CSR as pki_intermediate.csr

vault write -format=json pki_int/intermediate/generate/internal \
     common_name="zs-fond.online Intermediate Authority" \
     | jq -r '.data.csr' > pki_intermediate.csr


#Sign the intermediate certificate with the root CA private key,
#and save the generated certificate as intermediate.cert.pem

vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem

#importing cert back to vault

vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

#creating a role

#Create a role named zs-fond which allows subdomains.

vault write pki_int/roles/zs-fond \
     allowed_domains="zs-fond.online" \
     allow_subdomains=true \
     max_ttl="720h"

#Request certificates

json_crt=`vault write -format=json pki_int/issue/zs-fond common_name="test.zs-fond.online" ttl="720h"`

#export crt
echo $json_crt|jq -r '.data.certificate'>test.zs-fond.online.crt
#export key
echo $json_crt|jq -r '.data.private_key'>test.zs-fond.online.key

#install ROOT CA
sudo cp CA_cert.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

6. Установите nginx.

7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;

8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.

9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.

10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

## Результат

Результатом курсовой работы должны быть снимки экрана или текст:

- Процесс установки и настройки ufw
- Процесс установки и выпуска сертификата с помощью hashicorp vault
- Процесс установки и настройки сервера nginx
- Страница сервера nginx в браузере хоста не содержит предупреждений 
- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")
- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)
