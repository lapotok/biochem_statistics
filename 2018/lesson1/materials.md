# Курс по статистике: практикум урок 1

2018-10-31

Альтшулер Евгений


> _Биофак МГУ, каф. биохимии_
>
> _Для магистров 2 года (Биофак МГУ, каф. биохимии)_

## Чем прекрасен R?

* бесплатный
* поддерживает Windows, Mac, Linux
* управление коммандами - проще следовать инструкциям из мануалов, причем удобно гуглить, начиная свой запрос со слов
    + r project
    + r language
    + r environment
    + https://rseek.org/
* язык программирования - значит можно автоматизировать действия
* [здесь](../Readme.md) я буду собирать полезные ссылки

## Работа с переменными, вычисления
* математические операторы и функции (+, -, ^, *, log, abs, mean)
* переменные и как их называть
```r
my_variable = 1
MyVariable = 1
my.variable = 1
```
* присвоение значений переменным
```r
a = 1
a=1
a <- 1
a = "kjfhs"
a = 'kjfhs'
```
## Импорт из других программ

* Ввод в текстовом виде

```r
weight_of_my_students = c(65, 54, NA, 67, 45, 78) # NA - Not Available
```

* Copy-paste из экселя 

```r
my_table = read.table(text="сюда	вставлять	таблицу") # далее пример
my_table = read.table(text="v1	v2
1	2
11	22
111	222
1.3	7
4	NA", header=TRUE, dec=".") # header=TRUE если есть названия переменных, dec="." устанавливает точку десятичным разделителем
# анализируем структуру открытой таблицы
str(my_table)
```

* Импорт из XLSX (пакет `openxlsx`, `read.xlsx()`)
* Импорт из TXT, CSV, DAT (`read.table()`, `read.csv()`...)
* Импорт из других форматов (HTML, XML, кастомные форматы выдачи приборов и т.п.) - можно найти пакеты/советы на форумах/написать самому

## Типы данных

```r
# number
my_number = 1

# character
my_char = "bla\tbla\nbla"
cat(my_char)

# boolean
my_bool1 = TRUE
my_bool2 = FALSE

# vector
my_vector1 = 1:20
# подмножество из вектора
my_vector1[2:4]
my_vector2 = c(1, 2, 30, 50, 100, 150)
# выполняем операцию сравнения
my_vector2 > 100
# выбираем значения, отвечающие критерию my_vector2 > 40
my_vector2[my_vector2 > 40]

# factor vs vector
# создаем вектор
age = c("young", "middle-aged", "old", "Old", "young", "middle-aged", "middle-aged")
age # просто перечень текстовых значений
# преобразуем в фактор (текстовые значения в коды, текст отображается лишь для простоты восприятия)
factor(age) # видим лишний уровень "Old", дублирующий "old"
age = c("young", "middle-aged", "old", "old", "young", "middle-aged", "middle-aged")
factor(age) # несортированный фактор
factor(age, levels=c("young", "middle-aged", "old"), ordered = TRUE) # levels задает возрастающий порядок уровней

# data.frame
head(iris) # iris - встроенный пример таблицы данных
```

### Таблица данных - учимся создавать подтаблицы

```r
# первая строка
iris[1,]
# первый столбец
iris[,1]

# пробуем доставать разные строки, столбцы и значения на основе разных критериев
iris[1:15,]
iris[,1:3]
iris[, c(1, 3, 5)]
iris[, c("Petal.Width", "Species")]
iris$Sepal.Length
iris$Sepal.Length[1:10]
iris$Species == "versicolor"
iris$Petal.Length[iris$Species == "versicolor"]
iris[iris$Species == "versicolor",]
iris$Sepal.Length > 7
iris[iris$Sepal.Length > 7,]
```

### Операции с векторами и таблицами

```r
# vectors
my_vector2 = 1:10
my_vector3 = (1:10)*10
1:10*10
(1:10)*10
my_vector2 + my_vector3
my_vector2 - 1
(my_vector2)^2
sum(my_vector2)
my_vector2 > 3

# tables
iris_subset = iris[1:10, 1:4]
apply(iris_subset, 1, sum) # суммируем построчно
apply(iris_subset, 2, sum) # суммируем поколоночно
iris_subset > 3.2
```

## Проверка нормальности распределения

Будем проверять распределение эмпирических данных (`vers`) и сгенерированных, соответствующих нормальному (`nd`) и ненормальному (`nnd`) распределению.

```r
vers = iris[iris$Species == "versicolor","Sepal.Length"]

# гистограмма
hist(vers)
?hist # справка
hist(vers, breaks = 20)

# кривая плотности вероятности распределения
density(vers)
plot(density(vers))
rug(vers)
stem(vers) # графический аналог описан тут http://www.dataanalytics.org.uk/Data%20Analysis/R%20Monographs/Dot%20Histogram.R

# пример нормального распределения
# для воспроизводимости генератора случайных чисел задаем "стартовое число"
set.seed(123)
nd = rnorm(100, mean=50, sd=5) # задаем желаемые параметры
hist(nd,breaks=20)
plot(density(nd))

# пример НЕнормального распределения
# для воспроизводимости генератора случайных чисел задаем "стартовое число"
set.seed(123)
nnd = rchisq(100, 20, 5) # задаем желаемые параметры
hist(nnd,breaks=20)
plot(density(nnd))

# критерий нормальности - shapiro.test
shapiro.test(vers)
st = shapiro.test(vers)
str(st)
st$p.value
st$p.value > 0.05 # TRUE => нормальное распределение
shapiro.test(nnd)$p.value # < 0.05 => ненормальное распределение

# визуальная оценка нормальности
qqnorm(vers) # нормально
qqline(vers)
qqnorm(nnd) # ненормально
qqline(nnd)
```

## Работаем с нормально распределенными данными

```r
# параметры нормального распределения
mean(vers)
sd(vers)

# z-трансформация
scale(vers)

# сами пишем функцию для проведения z-трансформации
# Версия 1 - длинная и поэтапная
z_transformation = function(x){
  step1 = mean(x)
  step2 = x - step1
  step3 = sd(x)
  step4 = step2/step3
  return(step4) # maybe just step4
}

# Версия 2 - лаконичная
z_transformation = function(x) (x-mean(x))/sd(x)
```

Кстати, нашел отличную [статью](https://www.mathsisfun.com/data/standard-deviation.html) про то, почему стандантартное отклонение не есть сумма отклонений и не сумма модулей, а именно корень из суммы квадратов. 

# Бонус: операции и векторами и таблицами

Эти команды могут пригодиться для выполнения ДЗ.

```r
# vectors
my_vector2 = 1:10
my_vector3 = (1:10)*10
(1:10)*10
1:(10*10)
my_vector2 + my_vector3
my_vector2 - 1
(my_vector2)^2
sum(my_vector2)
my_vector2 > 3
length(my_vector2)

# tables
iris_subset = iris[1:10, 1:4]
apply(iris_subset, 1, sum) # суммируем построчно
apply(iris_subset, 2, sum) # суммируем поколоночно
iris_subset > 3.2

ncol(iris)
nrow(iris)
colnames(iris)
rownames(iris)
```

# Домашнее задание
См. [здесь](https://goo.gl/forms/8uZnxIEixmRFCT7H3).
