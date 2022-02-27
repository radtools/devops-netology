## Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"
 
**1. Есть скрипт:**  
```bash
a=1  
b=2  
c=a+b  
d=$a+$b  
e=$(($a+$b)) 
```
Какие значения переменным c,d,e будут присвоены?
Почему?

- c=a+b вернёт текст `a+b` т.к. `a` и `b` указаны без символа $, не воспринимается как обращение к переменной, а символ + воспринимается как оператор только в арифметических операциях  
- d=$a+$b вернёт `1+2`, т.к. a и b указаны с символом $ и будут восприняты как обращения к переменным и будет отработан как текст  
- e=$(($a+$b)) вернёт `3`, т.к. конструкция `((..))` служит для арифметических операций  (Пробовал так же с `[..]` работает)

**2.На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:**  
Скрипт  
```bash
while ((1==1)
do
curl https://localhost:4757
if (($? != 0))
then
date >> curl.log
fi
done
```
Fixed  

```bash
while ((1==1))
do
curl -ss http://localhost:4757
if (($? != 0))
then
date >> curl.log
else 
break
fi
done
```

Тут `while ((1==1)` Пропущена скобочка `)`  
Нехватает условия выхода "else break"когда сервис поднимется  

**3.Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.**

```bash
declare -i check_count=1 #Обьявляем переменную check_count равную единице
while (($chek_count<=5)) #Устанавливаем условие (количество проверок =5)
do
    for host in 192.168.0.1 173.194.222.113 87.250.250.242; # указываем IP адреса для проверки
        do 
        nc -zw1 $host 80 # Вызываем netcat с ключами -z Сканировать на наличие слушающих демонов, без посылки им данных и -w1 - таймаут 1 секунда на порт 80 хостов из host
        echo $? $host `date` >> host_chk.log # пишем в лог 
    done
check_count+=1 # Прибавляем к текущему значениию check_count
sleep 1 # Приостанавливаем выполнение следующей команды на 1 сек
done
```


**4.Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается**


```bash
declare -i check_count=1 #Обьявляем переменную check_count равную единице
while (($chek_count<=5)) #Устанавливаем условие (количество проверок =5)
do
    for host in 192.168.0.1 173.194.222.113 87.250.250.242; # указываем IP адреса для проверки
        do 
        nc -zw1 $host 80 # Вызываем netcat с ключами -z Сканировать на наличие слушающих демонов, без посылки им данных и -w1 - таймаут 1 секунда на порт 80 хостов из host
        if (($?==0))
        then 
            echo $? $host `date` >> host_chk.log # пишем в лог
        else 
            echo $host >> error.log # пишем в лог недоступности хоста
            check_count=0 
        fi
    done
sleep 1 # Приостанавливаем выполнение следующей команды на 1 сек
done
```