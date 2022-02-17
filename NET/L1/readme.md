# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

**1. Работа c HTTP через телнет.**
- Подключитесь утилитой телнет к сайту stackoverflow.com
- В ответе укажите полученный HTTP код, что он означает?
`telnet stackoverflow.com 80`
- отправьте HTTP запрос

```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 7a74c806-94dc-47db-a456-9c4ed9b4673a
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Thu, 17 Feb 2022 05:43:23 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hel1410031-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1645076603.057549,VS0,VE109
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=9665c643-c2ae-8951-35ef-7af730e791dc; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.

```
Получаем Permanent Redirect 301 с http на https (практически все хосты перешли на HyperText Transfer Protocol Secure благодаря чаяниям Google, радеющей за повсемесное внедрение TLS)

**2. Повторите задание 1 в браузере, используя консоль разработчика F12.**
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

![image](https://user-images.githubusercontent.com/93760545/154415568-5236e55e-8f68-4dc5-9f08-7b7c71e5364d.png)

В ответ получили код 307 (Temporary Redirect)
![image](https://user-images.githubusercontent.com/93760545/154415813-06405880-c7cc-44d8-a99f-08da1e9ce2f1.png)

2мс - редирикт, страничка загрузилась за 269 мс

**3. Какой IP адрес у вас в интернете?**

```
dig @resolver4.opendns.com myip.opendns.com +short
109.195.xxx.xxx
```

**4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`**

Какому провайдеру принадлежит ваш IP адрес?
```
whois 109.195.XXX.XXX | grep ^descr
descr:          TM DOM.RU, Yekaterinburg ISP
```
Какой автономной системе AS?

```
user@test-pc:~$ whois -h whois.radb.net 109.195.XXX.XXX | grep '^origin'
origin:         AS51604

```

**5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`**

```
radtools@test-pc:~$ traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.31.1 [*]  0.095 ms  0.087 ms  0.084 ms
 2  * * *
 3  109.195.104.30 [AS51604]  0.869 ms  0.786 ms  0.785 ms
 4  72.14.215.165 [AS15169]  19.588 ms  19.600 ms  19.558 ms
 5  72.14.215.166 [AS15169]  20.707 ms  20.673 ms  20.639 ms
 6  * * *
 7  108.170.226.164 [AS15169]  20.028 ms 108.170.250.33 [AS15169]  21.062 ms 108.170.225.44 [AS15169]  20.127 ms
 8  108.170.250.51 [AS15169]  20.450 ms * 108.170.250.113 [AS15169]  20.303 ms
 9  * * *
10  108.170.235.64 [AS15169]  33.754 ms 108.170.235.204 [AS15169]  30.478 ms 72.14.238.168 [AS15169]  29.642 ms
11  142.250.238.179 [AS15169]  34.434 ms 216.239.58.53 [AS15169]  30.946 ms 172.253.64.53 [AS15169]  34.405 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  32.369 ms  29.571 ms  31.889 ms
```
Список AS
```
grep org-name <(whois AS51604)
org-name:       JSC "ER-Telecom Holding"
grep OrgName <(whois AS15169)
OrgName:        Google LLC
```
**6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?**

```
user@test-pc:~$ mtr 8.8.8.8 -znrc 1
Start: 2022-02-17T11:41:36+0500
HOST: test-pc                     Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    192.168.xxx.xxx      0.0%     1    0.2   0.2   0.2   0.2   0.0
  2. AS???    10.12.255.253        0.0%     1    0.6   0.6   0.6   0.6   0.0
  3. AS51604  109.195.104.30       0.0%     1    0.8   0.8   0.8   0.8   0.0
  4. AS15169  72.14.215.165        0.0%     1   19.6  19.6  19.6  19.6   0.0
  5. AS15169  72.14.215.166        0.0%     1   20.5  20.5  20.5  20.5   0.0
  6. AS15169  108.170.250.33       0.0%     1   21.5  21.5  21.5  21.5   0.0
  7. AS15169  108.170.250.34       0.0%     1   26.3  26.3  26.3  26.3   0.0
  8. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
  9. AS15169  72.14.238.168        0.0%     1   29.6  29.6  29.6  29.6   0.0
 10. AS15169  142.250.209.161      0.0%     1   30.5  30.5  30.5  30.5   0.0
 11. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 12. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 13. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 14. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 15. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 16. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 17. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 18. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 19. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 20. AS15169  8.8.8.8              0.0%     1   29.4  29.4  29.4  29.4   0.0
```
Наибольшая задержка на 10 hop

**7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`**
Список NS`ов:

```
user@test-pc:~$ dig +short NS dns.google
ns1.zdns.google.
ns4.zdns.google.
ns3.zdns.google.
ns2.zdns.google.
```
А записи
```
radtools@test-pc:~$ dig +short A dns.google
8.8.8.8
8.8.4.4
```
**8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`**
```
user@test-pc:~$ for ip in `dig +short A dns.google`; do dig -x $ip | grep ^[0-9].*in-addr; done
4.4.8.8.in-addr.arpa.   17417   IN      PTR     dns.google.
8.8.8.8.in-addr.arpa.   228     IN      PTR     dns.google.
```
