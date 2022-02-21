### Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

**1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.**

![image](https://user-images.githubusercontent.com/93760545/154917935-3b041282-49ca-41e2-a2ea-31208db52ed0.png)


**2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.**

![image](https://user-images.githubusercontent.com/93760545/154917997-2c42121a-b3ec-480a-808e-5799735ecf68.png)


**3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.**
Самоподписной сертификат, NGINX, default_web_page

![image](https://user-images.githubusercontent.com/93760545/154922647-0bab46f5-ecb0-4209-8c4c-bdcb084903e6.png)


**4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).**

Проверил сайт предприятия на хостинге.

```bash
./testssl.sh -U --sneaky https://XXXXX.ru/

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (7b38198 2022-02-17 09:04:23 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on test-pc:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2022-02-21 14:10:09        -->> 185.XXX.XXX.XXX:443 (XXXXXX.ru) <<--

 rDNS (185.105.109.63):  vmXXXXX.XXXXXX.ru.
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), timed out
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=1D99C7D247813E266072C9B9C6A616D74AE37E57FA318F72A64F0F849057A4B1 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-DES-CBC3-SHA AES256-SHA AES128-SHA DES-CBC3-SHA CAMELLIA256-SHA CAMELLIA128-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK) - CAMELLIA or ECDHE_RSA GCM ciphers found
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)

```

**5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.**

Генерация:

```bash
ssh-keygen
Generating public/private rsa key pair.
```

Копирование
```bash
ssh-copy-id -i .ssh/id_rsa root@192.168.31.149
...
Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.31.149'"
and check to make sure that only the key(s) you wanted were added.
```
Проверка
```
root@test-node1:~# ssh root@192.168.31.149
Enter passphrase for key '/root/.ssh/id_rsa': 
\\Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.11.22-5-pve x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Mon Feb 21 09:41:41 2022
root@test-node2:~# 
```

**6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.**

**7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.**
