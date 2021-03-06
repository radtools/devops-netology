
# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

**Полная (нативная) виртуализация**  
В случае применения этого метода часть аппаратного обеспечения, достаточная для изолированного запуска виртуальной машины (ВМ), виртуализуется. Так как виртуализируется не все «железо», такой подход позволяет запускать только операционные системы, разработанные для той же архитектуры, что и у физического сервера (хоста). Этот вид виртуализации позволяет существенно увеличить быстродействие гостевых систем по сравнению с полной эмуляцией (в которой виртуализируются все аппаратные ресурсы) и, пожалуй, наиболее широко используется в настоящее время. В основе данного метода лежит специальная «прослойка» между гостевой операционной системой и оборудованием – так называемый «гипервизор» или «монитор виртуальных машин». Гипервизор обеспечивает возможность обращения гостевой операционной системы к ресурсам аппаратного обеспечения. Данный метод обеспечивает хорошую производительность и низкие накладные расходы на виртуализацию. Недостатком полной виртуализации является зависимость  виртуальных машин от архитектуры аппаратной платформы, однако, влияние этого ограничения невелико.  
**Паравиртуализация**  
В отличие от полной виртуализации, гипервизор паравиртуализации не скрывает себя от гостевых операционных систем. Но в этом случае они должны быть подготовлены к работе с этой системой. В результате, применение паравиртуализации требует модификации кода гостевой ОС на уровне ядра, что позволяет ей общаться с гипервизором на более высоком уровне, обеспечивая более высокое быстродействие. Гипервизор предоставляет гостевой ОС специальный программный интерфейс (API), исключающий необходимость прямого обращения  к таким ресурсам, как, например, таблицы страниц памяти.  
**Виртуализация уровня операционной системы**  
Виртуализация ресурсов на уровне ОС обеспечивает разделение одного физического сервера на несколько защищенных виртуализированных частей (контейнеров например LXC), каждая из которых представляется для владельца как один сервер. Виртуальная машина представляет собой окружение для приложений, запускаемых изолированно. При этом виртуальные контейнеры, работающие на уровне ядра ОС, крайне мало теряют в быстродействии  по сравнению с производительностью «реального» сервера, что позволяет запускать в рамках одного физического хоста десятки и сотни виртуальных контейнеров. Однако существуют определенные ограничения по запуску виртуальных машин с разными версиями ядра ОС.

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

Условия использования | Организация серверов | ПЧМУ?
--- | --- | ---
Высоконагруженная база данных, чувствительная к отказу. | `Кластер из физических серверов + SAN` | Сбоеустойчивость, MPIO, Высокий IOPS, HA, Failover 
Различные web-приложения|`Виртуализация уровня ОС (LXC)` | Требуется меньше ресурсов, выше скорость масштабирования при необходимости расширения, меньше ресурсов на администрирование
Windows системы для использования бухгалтерским отделом | `Паравиртуализация` | эффективнее делать бэкаприрование - клонирование всей вирт. машины, возможность расширения ресурсов на уровне VM. Нет критичных требований к доступу к аппаратной составляющей сервера. Возможность экономии места при использовании dedup (при наличии множества однотипных VM)
Системы, выполняющие высокопроизводительные расчеты на GPU| `Физический сервер` | вероятно для аппаратных расчетов требуется максимальный доступ к аппаратным ресурсам, без прослоек в виде Гипервизоров


## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.  
Вероятно Hyper-V? Как наиболее интегрированное решение в AD (вероятно оно там есть уже) и наиболее лояльное решение к компетенциям windows admins

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.  

Вероятно KVM (возможно в реализации ProxMox)

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.

Hyper-V

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

VirtualBox - как наиболее быстрое решение. 

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

Использование гетерогенной среды виртуализации повлечет за собой возможную несовместимость этих сред и как следствие трудности при миграции VM из одной в другую (мотивов такого рода экзерсисов может быть предостаточно, как то снижение производительности одной среды, истощение физических ресурсов, обслуживание (плановое\экстренное) e.t.c), так же важным моментом будет вероятность того, что нужно будет содержать 2-х и более специалистов для своих сред виртуализации и необязательно что они могут быть взаимозаменяемы.

Если бы у меня был выбор - я вероятнее всего остановился на единой системе виртуализации, избегая при этом повышенных накладных расходов на дополнительные кадры и их обучение.

