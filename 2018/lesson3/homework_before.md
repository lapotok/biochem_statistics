# Домашнее задание к занятию 3 (сделать до!)

### Даже если Вы не сделали другие ДЗ, сделайте это в первую очередь!!!

Не бойтесь, это **совсем простое** домашнее задание, чистое повторение!
  
  Это задание надо **ОБЯЗАТЕЛЬНО** сделать, т.к. многое уже забылось с предыдущего занятия.

## Как делать

* Читать команду, предсказывать что она делает
* Исполнять команду, проверять себя
  - Если все получилось - переходить к следующей
  - Если нет - читать справку, разбивать сложные команды на простые и добиваться понимания
* Фиксировать, какие команды оказались новыми и непредсказуемыми
* Отправить ДЗ [здесь](https://docs.google.com/forms/d/e/1FAIpQLSeN9Iw5TsEcuYZZL68uQ9ZN0NZwVqSQQrSmJ3QoXPvcRTiJIg/viewform?usp=sf_link)

# Что делать

## 1. Скачать необходимые пакеты для следующего занятия

Скопируйте [отсюда](https://github.com/lapotok/biochem_statistics/blob/master/2018/resources.R) код для установки. Там есть список пакетов. Сначала проводится проверка есть ли у Вас данный пакет, затем, если нет, он устанавливается.

Есть основных 4 способа уставки пакетов

* командой `install.packages()``
* в `RStudio` **Tools -> Install packages**
* установка из github
* установка из Bioconductor

... но пока это Вам не надо ;)

**Если у Вас не устанавливается что-то - обязательно напишите мне об этом! Я помогу устранить ошибку.**
  
## 2. Задания для повторения

Комманд много, но это быстро - не надо самим набирать, только прочитать и исполнить!
  
### Расчеты, операции с данными (арифметика)
  
  ```r
1 + 1
2 * 3
(4 + 5) * 6
2 ^ 3
2 ^ 0.5
sqrt(2)
log10(100)
log2(16)
log(9, base = 3)
abs(-4)
```

### Переменные

* Переменные: имена, присвоения, использование
* присвоение значений переменным

```r
my_variable = 1
MyVariable = 1
my.variable = 1
```

```r
a = 1
a=1
a <- 1
a = "kjfhs"
a = 'kjfhs'
```

### Типы данных

Простые типы данных (числовые и строковые константы, векторы, факторы)

```r
# number
my_number = 1

# character
my_char = "bla\tbla\nbla"
cat(my_char)

# boolean
my_bool1 = TRUE
my_bool2 = FALSE

if(my_bool1) {
  print("TRUE")
} else {
  print("FALSE")
}

ifelse(my_bool1, "TRUE", "FALSE")

2<1
ifelse(2<1, "TRUE", "FALSE")
my_bool3 = 2<1 
ifelse(my_bool3, "TRUE", "FALSE")

# vector набор данных одного типа (одни единицы измерения)
my_vector1 = 1:20
my_vector1.1 = rep(9, 30) # последовательность из 9 длиной 30
length(my_vector1.1)
# подмножество из вектора
my_vector1[2:4]
my_vector2 = c(169, 180, 157, 165, 190, NA, 185, 164, 171) # NA = Not Available = пропущенные данные
# выполняем операцию сравнения
my_vector2 > 170
# выбираем значения, отвечающие критерию my_vector2 > 40
my_vector2[my_vector2 > 170]
186 %in% my_vector2
190 %in% my_vector2
my_vector2 == 190

# factor vs vector
# создаем вектор
age = c("young", "middle-aged", "old", "Old", "young", "middle-aged", "middle-aged")
age # просто перечень текстовых значений
# преобразуем в фактор (текстовые значения в коды, текст отображается лишь для простоты восприятия)
factor(age) # видим лишний уровень "Old", дублирующий "old"
age = c("young", "middle-aged", "old", "old", "young", "middle-aged", "middle-aged")
factor(age) # несортированный фактор
factor(age, levels=c("young", "middle-aged", "old"), ordered = TRUE) # levels задает возрастающий порядок уровней
```

Сложные типы данных (матрицы, списки, таблицы данных)

```r
# matrix - двухмерный набор значений одного типа (например, каких-то измерений)
# создаем одномерный вектор
rnorm(8*12, mean=5000, sd=2000) # команда для создания 8*12 случайных чисел с заданным средним и стандартным отклонением
# помещаем его значения в матрицу
my_matrix1 = matrix(rnorm(8*12, 5000, 2000), nrow=8, ncol=12) # пример матрицы 8х12 со случайными значениями
my_matrix1
colnames(my_matrix1) = as.character(1:12) # задаем название столбцов (становятся текстом!)
library(tidyverse) # много всего полезного, в т.ч. работа со строками
str_split("ABCDEFGH", "", simplify = T) # генерим вектор из букв
rownames(my_matrix1) = str_split("ABCDEFGH", "", simplify = T) # задаем название строк
my_matrix1 # выглядит знакомо ;)
str(my_matrix1)
my_matrix1[1,] # первая строка (номер строки)
my_matrix1[1,] = 1:12 # так можно модифицировать данные, замена должна соответствовать размеру ...
my_matrix1[2,] = NA # ... или можно заменять все позиции матрицы на одно значение
my_matrix1["A",] # первая строка (название строки)
my_matrix1[c(1,3),] # первая и третья строка (номера строк)
my_matrix1[c("A","C"),] # первая и третья строка (названия строк)
my_matrix1[, 1] # первая колонка (номер)
my_matrix1[, "1"] # первая колонка (название, поэтому в кавычках, это текст)
my_matrix1[3, 11]
my_matrix1[8, 12] = 100500
my_matrix1*1000
my_matrix1
ncol(my_matrix1)
nrow(my_matrix1)
t(my_matrix1) # транспонировать матрицу, т.е. превратить колонки в строки

# Если надо сложить одну переменную много разных типов данных - это список
my_list1 = list(a=c(1,2,4), b=c("one", "two", "three"), c=3, d=age) # сразу задаем значения
my_list1 
str(my_list1)
my_list1$a # обращаемся к элементу
my_list1[["a"]] # обращаемся к элементу - второй способ
b_element = my_list1[["a"]]
b_element
b_element[2]
my_list1[["a"]][2] # выбираем второй элемент вектора b из списка my_list1 
my_list1$e = "создаем новый элемент"
my_list1[["last_one"]] = c("и", "последний", "элемент")
str(my_list1)

# пример использования списка
my_list2 = list()
my_list2$description = "Плашка FIA"
my_list2$date = Sys.time() # эта команда выводит текущее время
my_list2$plate = my_matrix1
my_list2$session = sessionInfo() # эта команда выводит данные о версии R и загруженных библиотеках (пригодится для воспроизводимости!)

# а еще многие функции выводят списки
t.test_result = t.test(rnorm(8*12, mean=5000, sd=2000), mu = 4500)
str(t.test_result)
t.test_result$p.value # из объекта типа лист можно доставать нужное значение
t.test(rnorm(8*12, mean=5000, sd=2000), mu = 4500)$p.value # или даже так

# самый используемый тип данных - таблица данных (data.frame и ее расширения типа tibble, data.table)
# такая таблица технически это список из разных типов колонок-векторов (численные, текстовые, факторные) одной длины
my_df1 = data.frame(a=c(1,2,4), b=c("a", "b", "d"))
my_df1
str(my_df1)
# с таблицей данных можно обращаться как со списком, а можно как с матрицей
# почти все данные, которые придется обрабатывать, будут в формате таблиц данных
```

Арифметические операции с векторами, матрицами, таблицами

```r
my_vector1 = 1:20
my_vector3 = 101:120
my_vector1 + 5
my_vector1 * 5
my_vector1 + my_vector2
my_vector4 = 1:21
my_vector1 + my_vector3 # ошибка
my_vector1 ^ 2
log10(my_vector1)
max(my_vector1)
min(my_vector1)
my_vector2 = c(169, 180, 157, 165, 190, NA, 185, 164, 171)
max(my_vector2) # что-то пошло не так...
na.omit(my_vector2)
max(na.omit(my_vector2))
```

[Дополнительная информация](https://adv-r.hadley.nz/subsetting.html) про экстракцию подтаблиц и частей векторов, сортировку и т.п.

### Использование функций

```r
# использование одной функции
?rnorm
rnorm(96) # аргументы по умолчанию: mean=0, sd=1
rnorm(8*12)
rnorm(8*12, mean=5000, sd=2000) # явно указанные аргументы
rnorm(8*12, sd=2000, mean=5000) # явно указанные аргументы в другом порядке - не важно!
rnorm(8*12, 5000, 2000) # аргументы указания названий в стандартном порядке (см. справку)
rnorm(8*12, s=2000, m=5000) # сокращенные названия аргументов - первые буквы должны однозначно указывать

# некоторые функции принимают аргументы в виде формул вида value ~ grouping1 + grouping2 ...
my_data = data.frame(my_values = c(1, 2, 3, 1, 4, 3),
                     my_grouping = as.factor(c(1, 1, 1, 2, 2, 2)))
library(car)
leveneTest(my_data$my_values, my_data$my_grouping)
with(my_data, leveneTest(my_values, my_grouping)) # чтобы не писать my_data$ перед каждой переменной
leveneTest(my_values ~ my_grouping, data = my_data) # пример формулы

# использование нескольких функций: среднее полученного распределения
my_distr1 = rnorm(8*12, sd=2000, mean=5000) # вывод функции можно сохранять в переменную
mean(my_distr1)

# можно вкладывать функции друг в друга, направляя вывод одной функции на вход (аргумент) другой
mean(rnorm(8*12, sd=2000, mean=5000))

# можно создавать pipelines (об этом далее будет более подробно)
8*12 %>% # это значение будет первым аргументом следующей (rnorm)
  rnorm(sd=2000, mean=5000) %>% # вывод этой функции будет первым аргументом следующей (mean)
  mean() %>% # это значение будет первым аргументом следующей (round)
  round(0)
```

### Собственная функция

<a href="https://www.codecogs.com/eqnedit.php?latex=\dpi{120}&space;\operatorname{CV}(X)&space;=&space;\frac{SD\&space;(x)}{\overline{x}}\cdot100\%" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\dpi{120}&space;\operatorname{CV}(X)&space;=&space;\frac{SD\&space;(x)}{\overline{x}}\cdot100\%" title="\operatorname{CV}(X) = \frac{SD\ (x)}{\overline{x}}\cdot100\%" /></a>

```r
# пишем функцию для коэффициента вариации
CV = function(x) sd(x)/mean(x)*100 # возвращает результат преобразования
my_vector6 = rnorm(30, 50, 5)
CV(my_vector6)
```

<a href="https://www.codecogs.com/eqnedit.php?latex=\dpi{120}&space;\operatorname{Var}(X)&space;=&space;\frac{\sum_{i=1}^n&space;(x_i&space;-&space;\overline{x})^2}{n-1}&space;$$" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\dpi{120}&space;\operatorname{Var}(X)&space;=&space;\frac{\sum_{i=1}^n&space;(x_i&space;-&space;\overline{x})^2}{n-1}&space;$$" title="\operatorname{Var}(X) = \frac{\sum_{i=1}^n (x_i - \overline{x})^2}{n-1} $$" /></a>

```r
# пишем функцию для вычисления дисперсии, которая нам выдаст несколько значений
Var = function(x) {
  result = list()
  result$data = x
  result$sum_sq = sum((x-mean(x))^2)
  result$n = length(x)
  result$value = result$sum_sq/(result$n - 1)
  return(result) # задаем объект, который будет выводить функция (здесь это список)
}
```
