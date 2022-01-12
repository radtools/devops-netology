
1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

    Ответ:
    системный вызов команды `CD -> chdir("/tmp")`. 

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
    
Ответ:
    `openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3`
    
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).  

первое что попробовал - писать лог пинга до 8.8.8.8 `ping 8.8.8.8 > ping.log`,  потом удалил лог `rm ping.log`
дальше через `ps` узнал PID процесса `ping`
далее через "LiSt of Open Files" нашел искомый файл ` sudo lsof -p 2135 | grep deleted`
вывод `ping    2135 radtools    1w   REG    8,5   119145  407067 /home/radtools/ping_log (deleted)`  
"обнулить" можно через: `: > "/proc/$pid/fd/$fd"`
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

     Зомби не занимают памяти, но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
```    
radtools@test:~$ dpkg -L bpfcc-tools | grep sbin/opensnoop  
/usr/sbin/opensnoop-bpfcc  
radtools@test:~$ sudo -i  
root@test:~# /usr/sbin/opensnoop-bpfcc  
PID    COMM               FD ERR PATH  
4989   cron                6   0 /tmp  
4989   cron                7   0 /etc/pam.d/cron  
4989   cron                8   0 /etc/pam.d/common-auth  
4989   cron                9   0 /lib/x86_64-linux-gnu/security/pam_unix.so  
4989   cron                9   0 /etc/ld.so.cache  
4989   cron                9   0 /lib/x86_64-linux-gnu/libcrypt.so.1  
4989   cron                9   0 /lib/x86_64-linux-gnu/libnsl.so.1  
4989   cron                9   0 /lib/x86_64-linux-gnu/security/pam_deny.so  
4989   cron                9   0 /lib/x86_64-linux-gnu/security/pam_permit.so  
4989   cron               -1   2 /lib/x86_64-linux-gnu/security/pam_ecryptfs.so  
4989   cron                9   0 /lib/security/pam_ecryptfs.so  
4989   cron                9   0 /etc/ld.so.cache  
4989   cron                9   0 /lib/libecryptfs.so.1  
4989   cron                9   0 /lib/x86_64-linux-gnu/libnss3.so  
4989   cron                9   0 /lib/x86_64-linux-gnu/libkeyutils.so.1  
4989   cron                9   0 /lib/x86_64-linux-gnu/libnssutil3.so  
4989   cron                9   0 /lib/x86_64-linux-gnu/libplc4.so  
4989   cron                9   0 /lib/x86_64-linux-gnu/libplds4.so  
4989   cron                9   0 /lib/x86_64-linux-gnu/libnspr4.so  
4989   cron                9   0 /lib/x86_64-linux-gnu/security/pam_cap.so  
```
    
    
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
Ответ: 
      системный вызов uname()
     ```
     Part of the utsname information is also accessible via  
     /proc/sys/kernel/{ostype, hostname, osrelease, version,domainname}.
     ```


7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`? 
Ответ:
   `&&` -  условный оператор <br>
    а `;`  - разделитель последовательных команд <br>
    `test -d /tmp/some_dir && echo Hi` - в данном случае `echo`  отработает только при успешном заверщении команды test <br>
    `set -e` - прерывает сессию при любом ненулевом значении исполняемых команд в конвеере кроме последней. <br>
     в случае `&&`  вместе с `set -e` - вероятно не имеет смысла, потому как при ошибке выполнение команд прекратиться. 
    
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?<br>
Ответ:<br>
-e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности<br>
-x вывод трейса простых команд<br>
-u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова<br>
-o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.<br>
Это повышает детализацию вывода ошибок(логирования)и завершит сценарий при наличии ошибок, на любом этапе выполнения сценария, кроме последней завершающей команды
9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
 
`S*(S,S+,Ss,Ssl,Ss+)` - Процессы ожидающие завершения (спящие с прерыванием "сна")

`I*(I,I<)` - фоновые(бездействующие) процессы ядра

доп символы это доп характеристики, например приоритет.


