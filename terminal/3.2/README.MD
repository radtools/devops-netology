1) Вызов `type cd` возвращает `cd is a shell builtin` что указывает что команда встроеная в `bash` для навигации по файловой системе.
Встроенная она по тому как логичнее менять указатель работая внутри сессии терминала.

2) Альтернатива команде `grep <some_string> <some_file> | wc -l` без использования pipe это grep с параметром -c
```ruby
grep -c <some_string> <some_file>
```
3) Процесс с PID 1 это `systemd`- systemd — подсистема инициализации и управления службами в Linux

4) Выясним ID нашего псевдотерминала через `tty`
```ruby
tty
/dev/pts/0
```
вывод из 1й сессии во 2ю можно сделать следующим образом:
```ruby
ls -l \something 2>/dev/pts/1
```
Вывод будет во второй сессии терминала `/dev/pts/1`

5) Решение
```ruby
vagrant@node1:~$ nano test.file
vagrant@node1:~$ cat test.file
test
netology
dev-ops
vagrant@node1:~$ tee < test.file > test.file2
vagrant@node1:~$ cat test.file2
test
netology
dev-ops
```
6) Да, к примеру:
  `echo 'message' > /dev/tty1`

7) `bash 5>&1` - Создаст дескриптор с 5 и перенатправит его в stdout
   `echo netology > /proc/$$/fd/5` выведет в терминал слово "netology"
    если запустить `echo netology > /proc/$$/fd/5` в новой сесcии, получим ошибку, так как такого дескриптора нет на данный момент в текущей(новой) сесcии

8) `echo new_line{1..25} 3>&2 2>&1 1>&3 3>&-`
```ruby
(3) new_descr > (2) stderr
(2) stderr    > (1) stdout
(2) stdout    > (3) new_desc
(3) new_desc  > (-) close_new_desc
```
вывод команды: <br>
`new_line1 new_line2 new_line3 new_line4 new_line5 new_line6 new_line7 new_line8 new_line9 new_line10 new_line11 new_line12 new_line13 new_line14 new_line15 new_line16 new_line17 new_line18 new_line19 new_line20 new_line21 new_line22 new_line23 new_line24 new_line25` 

9) `cat /proc/$$/environ` выведет переменные окружения
можно получить тоже самое (только с разделением по переменным по строкам)через:
`printenv`
`env`
10) `/proc/<PID>/cmdline` выведет команду, к которой относится, со всеми агрументами
    /proc/<PID>/exe это симлинк на полный путь к исполняемому файлоу, из которого вызвана программа с этим пидом

11) С помощью команды `cat /proc/cpuinfo | grep -o sse[0-9_]* | sort -h`
SSE 4.2

12) при попытке выполнить команду `tty` удаленно через `SSH`, например `ssh localhost 'tty'`, для удаленного сеанса по умолчанию не выделяется TTY, для принудительного выделения tty необходимо использовать ключ `-t` в таком случае псевдотерминал выделится принудительно, даже если у текущего SSH его нет
```ruby
vagrant@node1:~$ ssh -t localhost 'tty'
vagrant@localhost's password: 
/dev/pts/2
Connection to localhost closed.
 
```
13) `sudo reptyr -T` по `readme` от сюда `https://github.com/nelhage/reptyr#readme`
  
14) `tee' читает из 'input` и пишет в `output` и в файл. Работает потому что команда `tee` не встроенная в `shell` и с `sudo` запускается с повышенными правами, в отдичии от `echo`, которая встроенна в `shell` запускается с правами пользователя и `sudo` там не работает.
