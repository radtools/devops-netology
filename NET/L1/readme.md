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


**6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?**
**7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`**
**8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`**
