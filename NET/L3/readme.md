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

1. запуск модуля
```shell
# echo "dummy" > /etc/modules-load.d/dummy.conf
# echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf
```
2. Настройка и запуск интерфейса

```shell
# cat << "EOF" >> /etc/systemd/network/10-dummy0.netdev
[NetDev]
Name=dummy0
Kind=dummy
EOF


# cat << "EOF" >> /etc/systemd/network/20-dummy0.network
[Match]
Name=dummy0

[Network]
Address=10.0.8.1/24
EOF

# systemctl restart systemd-networkd
```

3. Проверка интерфейса

```shell
root@test-pc:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether b0:6e:bf:d0:18:50 brd ff:ff:ff:ff:ff:ff
    inet 192.168.31.241/24 brd 192.168.31.255 scope global dynamic noprefixroute enp2s0
       valid_lft 22613sec preferred_lft 22613sec
    inet6 fe80::bcca:44c5:bd20:2784/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 9a:e6:1b:98:77:9c brd ff:ff:ff:ff:ff:ff
    inet 10.0.8.1/24 brd 10.0.8.255 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::98e6:1bff:fe98:779c/64 scope link
       valid_lft forever preferred_lft forever

```
**3.Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.**

**4.Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?**

**5.Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.**
