### Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"
**1.Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP**

```shell
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

```shell
route-views>show ip route 109.195.XXX.XXX
Routing entry for 109.195.XXX.0/20
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 1d09h ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 1d09h ago
      Route metric is 0, traffic share count is 1
      AS Hops 6
      Route tag 6939
      MPLS label: none
```

```shell
route-views>show bgp 109.195.XXX.XXX
BGP routing table entry for 109.195.XXX.0/20, version 311629458
Paths: (23 available, best #7, table default)
  Not advertised to any peer
  Refresh Epoch 1
  1351 6939 9049 51604 51604 51604 51604
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE12671A798 RPKI State not found
      rx pathid: 0, tx pathid: 0
...
 Refresh Epoch 1
  6939 9049 51604 51604 51604 51604
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external, best
      path 7FE10A042D38 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  701 1299 9049 9049 51604 51604 51604 51604
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin incomplete, localpref 100, valid, external
      path 7FE16DB42A90 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 9002 9002 9002 9002 9002 9049 51604 51604 51604 51604
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840
      path 7FE0E6A06CD8 RPKI State not found

```

**2.Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.**

1. Создание интерфейса
```shell
# echo "dummy" > /etc/modules-load.d/dummy.conf
# echo "options dummy numdummies=1" > /etc/modprobe.d/dummy.conf
```
2. Настройка

```shell
root@test-srv:~#cat << "EOF" >> /etc/systemd/network/0-dummy0.netdev
[NetDev]
Name=dummy0
Kind=dummy
EOF
```
```shell
root@test-srv:~#cat << "EOF" >> /etc/systemd/network/1-dummy0.network
[Match]
Name=dummy0

[Network]
Address=10.0.8.1/24
EOF
```
3. Проверка

```shell
root@test-srv:~#ip link list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:58:5f:ce brd ff:ff:ff:ff:ff:ff
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 1a:e7:ee:dc:39:b1 brd ff:ff:ff:ff:ff:ff

```
4. добавление статического маршрута через конфигурацию `netplan`
```shell
 routes:
 - to: 176.18.0.0/24
 via: 10.23.0.100
```
5. Проверка статических маршрутов `ip r | grep static`

```shell
176.18.0.0/24 via 10.23.0.100 dev enp0s3 proto static
```

**3.Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.**

```shell
 #ss -tnlp
State      Recv-Q Send-Q Local Address:Port               Peer Address:Port     
LISTEN     0      128          *:22                       *:*                   users:(("sshd",pid=1313,fd=3))
LISTEN     0      128         :::22                      :::*                   users:(("sshd",pid=1313,fd=4))
```
На этой машине открыто 2 терминальные сессии ssh. _и все_

**4.Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?**

```shell
#ss -unap
State      Recv-Q Send-Q Local Address:Port               Peer Address:Port     
UNCONN     0      0            *:68                       *:*                   users:(("dhclient",pid=885,fd=6))
```
Клиент DHCP обменивается данными через UDP-порт 68 с сервером DHCP.

**5.Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.**
![Network](https://user-images.githubusercontent.com/93760545/154792518-bd5a4367-a848-4f7a-9ddb-03f508d3510b.png)


