#### Домашнее задание к занятию "3.5. Файловые системы"

1. **Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.**

Разреженным файлом называют файл, внутри которого имеется одна или несколько областей, незанятые данными. _Можно было бы вставить картинку из Википедии, но зачем? :)_

2. **Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?**

Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.

_И... Экперемент._

```
vagrant@vagrant:~$ mkdir test
vagrant@vagrant:~$ cd test
vagrant@vagrant:~/test$ touch test_file
vagrant@vagrant:~/test$ ln test_file test_file_link
vagrant@vagrant:~/test$ ls -ilh
total 0
1048599 -rw-rw-r-- 2 vagrant vagrant 0 Feb 16 09:25 test_file
1048599 -rw-rw-r-- 2 vagrant vagrant 0 Feb 16 09:25 test_file_link
vagrant@vagrant:~/test$ chmod 0755 test_file
vagrant@vagrant:~/test$ ls -ilh
total 0
1048599 -rwxr-xr-x 2 vagrant vagrant 0 Feb 16 09:25 test_file
1048599 -rwxr-xr-x 2 vagrant vagrant 0 Feb 16 09:25 test_file_link

```

3. **Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:**

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
    
```
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
loop2                       7:2    0 32.3M  1 loop /snap/snapd/12704
loop3                       7:3    0 55.5M  1 loop /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop /snap/snapd/14978
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
└─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk
```

4. **Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.**

```
vagrant@vagrant:~$sudo fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xd081bd53

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```

5. **Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.**
```
vagrant@vagrant:~$sudo sfdisk -d /dev/sdb|sudo sfdisk --force /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0xd081bd53.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0xd081bd53

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
и в итоге видно вот что:
```
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
```

6. **Соберите `mdadm` RAID1 на паре разделов 2 Гб.**

`mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b1,c1}`

где

`/dev/md0` - устройство RAID, которое появится после сборки;

`-l 1` — уровень RAID; 

`-n 2` — количество дисков, из которых собирается массив; 

`/dev/sd{b1,c1}` — сборка выполняется из дисков sdb1 и sdc1.


7. **Соберите `mdadm` RAID0 на второй паре маленьких разделов.**

`mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b2,c2}`
где

`/dev/md1` - устройство RAID, которое появится после сборки;

`-l 0` — уровень RAID; 

`-n 2` — количество дисков, из которых собирается массив; 

`/dev/sd{b2,c2}` — сборка выполняется из дисков sdb1 и sdc1.

и кусок вывода lsblk:
```
root@vagrant:~# lsblk
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
```

8. **Создайте 2 независимых PV на получившихся md-устройствах.**

```
root@vagrant:~# pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
```

10. **Создайте общую volume-group на этих двух PV.**

```
root@vagrant:~# vgcreate VG0 /dev/md0 /dev/md1
  Volume group "VG0" successfully created
root@vagrant:~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  VG0         2   0   0 wz--n-  <2.99g  <2.99g
```

10. **Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.**

```
root@vagrant:~# lvcreate -L 100M VG0 /dev/md0
  Logical volume "lvol0" created.
root@vagrant:~# lvs
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0     VG0       -wi-a----- 100.00m
```

11. **Создайте `mkfs.ext4` ФС на получившемся LV.**

```
root@vagrant:~# mkfs.ext4 /dev/VG0/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12. **Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.**

```
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/VG0/lvol0 /tmp/new
```

13. **Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.**

_выполнено, не знаю что сюда написать_

14. **Прикрепите вывод `lsblk`.**

```
root@vagrant:/tmp/new# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─VG0-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─VG0-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
```

15. **Протестируйте целостность файла:**

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
выполнено 

16. **Используя pvmove, переместите содержимое PV с RAID0 на RAID1.**

`root@vagrant:~# pvmove /dev/md0`


17. **Сделайте `--fail` на устройство в вашем RAID1 md.**

```
root@vagrant:~# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Feb 16 10:05:47 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Wed Feb 16 12:10:36 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:0  (local to host vagrant)
              UUID : 8194bd8b:7a3034ce:eea01e5e:7aad9358
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1
```

18. **Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.**

```
root@vagrant:~# dmesg |grep md0
[ 1651.519754] md/raid1:md0: not clean -- starting background reconstruction
[ 1651.519756] md/raid1:md0: active with 2 out of 2 mirrors
[ 1651.519779] md0: detected capacity change from 0 to 2144337920
[ 1651.520804] md: resync of RAID array md0
[ 1662.185921] md: md0: resync done.
[ 9138.979513] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```

19. **Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:**

```
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0
```


20. **Погасите тестовый хост, `vagrant destroy`.**

Done
