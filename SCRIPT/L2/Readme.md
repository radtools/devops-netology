**Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"**

Обязательные задания  

**1.Есть скрипт:**

```bash
#!/usr/bin/env python3  
a = 1  
b = '2'  
c = a + b
```

Какое значение будет присвоено переменной c? 

`TypeError: unsupported operand type(s) for +: 'int' and 'str'` : Python не понимает, что мы ожидаем от сложения строки и числа.

Как получить для переменной c значение 12?  

`c = str(a)+b`

Как получить для переменной c значение 3? 

`c = a+int(b)`



**2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?**

```bash
#/usr/bin/env python3

import os

bash_command = ["cd ~/GIT/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(prepare_result)
```
![image](https://user-images.githubusercontent.com/93760545/155877490-20cba269-1586-400a-bb81-3a2ac0152b98.png)



**4. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.** 

```bash
#!/usr/bin/env python3

import os
import sys

cmd = os.getcwd()

if len(sys.argv)>=2:
    cmd = sys.argv[1]
bash_command = ["cd "+cmd, "git status 2>&1"]

print('\033[31m')
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print('\033[31m Каталог \033[1m '+cmd+'\033[0m\033[31m не является GIT репозиторием\033[0m')    
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено: ', '')
        prepare_result = prepare_result.replace(' ', '') 
        print(cmd+prepare_result)
#        break
print('\033[0m')
```
![image](https://user-images.githubusercontent.com/93760545/155877290-776cc096-feb7-4715-b2a4-94704d748bf6.png)
![image](https://user-images.githubusercontent.com/93760545/155877318-ff27df4c-dafe-4045-b05f-b5d6b107eb84.png)



**5. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.**

```bash
#!/usr/bin/env python3

import socket
from string import whitespace

hosts = ["drive.google.com", "mail.google.com", "google.com"]
fileList = []

with open('host_test.log') as file:
    for f in file:
        fileList.append(f)

with open('host_test.log', 'w+') as file:
    for i in hosts:
        result = socket.gethostbyname(i)
        added = 0
        for y in fileList:
            inList = y.find(" {}".format(i))
            if inList != -1:
                ipstr = y.replace('\n', '').split("  ")[1].translate({None: whitespace})
                if ipstr == result:
                    print(" {}  {}\n".format(i, result))
                    file.write(" {}  {}\n".format(i, result))
                    added = 1
                    break
                else:
                    print("[ERROR] {} IP mismatch: {}  {}\n".format(i, ipstr, result))
                    file.write("[ERROR] {} IP mismatch: {}  {}\n".format(i, ipstr, result))
                    added = 1
                    break
        if added == 0:
            print(" {}  {}\n".format(i, result))
            file.write(" {}  {}\n".format(i, result))
```

![image](https://user-images.githubusercontent.com/93760545/155877739-bf6cb927-4f39-43e4-a5b7-5f528b4dcf33.png)

![image](https://user-images.githubusercontent.com/93760545/155877841-d79f383a-db19-4fc0-8b7f-f68591bf0895.png)


