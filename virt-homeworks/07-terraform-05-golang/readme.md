# Домашнее задание к занятию "7.5. Основы golang"

<details>

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

</details>

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.

    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
<details>
	
```
	package main

import "fmt"

func Convert(meters float64) (result float64) {
	result = meters * 0.3048
	return result
}

func main() {
	fmt.Print("Введите растояние в метрах: ")
	var input float64
	fmt.Scanf("%f", &input)
	fmt.Printf("Введенное растояние в метрах равно %v в футах", Convert(input))
}
```
</details>

 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```

<details>
	
```
package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	current := 0
	fmt.Println("List of values : ", x)
	for i, value := range x {
		if i == 0 {
			current = value
		} else {
			if value < current {
				current = value
			}
		}
	}
	fmt.Println("Minimal Value : ", current)
}
```
   
result  
```
List of values :  [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
Minimal Value :  9

Program exited.  
```  					  
</details>  
   
3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.
	
<details> 
	
code  	
```
package main

import (
	"fmt"
)

func main() {
	for i := 1; i <= 100; i++ {
		if i%3 == 0 {
			fmt.Println(i)
		}
	}
}
```
			    
result  
			    
```
3
6
9
12
15
18
21
24
27
30
33
36
39
42
45
48
51
54
57
60
63
66
69
72
75
78
81
84
87
90			    
93
96
99

Program exited.
			    
```
</details>
	
В виде решения ссылку на код или сам код. 

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 
