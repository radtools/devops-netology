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

8)

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
