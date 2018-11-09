# Курс по статистике: практикум урок 2

2018-11-07

## План урока

* Разбор домашней работы
    - вопросы
    - обычные команды
    - варианты автоматизации (матрица значений, таблица рисунков)
* Т-тесты
* Боксплоты и их разновидности

## Новые структуры - матрица и список

```r
# matrix - таблица однотипных данных
matrix(1:50, nrow=5, ncol=10)
matrix(1:50, nrow=5, ncol=10, byrow = TRUE)
my_matrix = matrix(1:50, nrow=5, ncol=10, byrow = TRUE)
new_row = 1000:1009
rbind(my_matrix, new_row)
new_col = 100:104
cbind(my_matrix, new_col)

# list - коллекция разных типов данных
my_list = list()
my_list$number = 1
my_list$string = 'string example'
my_list$vector = 1:10
my_list$matrix = matrix(1:50, nrow=5, ncol=10)
my_list
my_list$vector
my_list$vector[4]
my_list[[3]]
my_list[[3]][4]
my_list$matrix
my_list$matrix[1:3,1:4]
```

## Автоматизация расчетов на примере `shapiro.test()`

Надо проверить нормальность распределения каждой из переменных (их 4) для каждого вида ирисов (их 3).

Если не автоматизировать, то надо написать 4*3=12 команд следующего вида (заменяя название вида и переменной)


```r
shapiro.test(iris[iris$Species == 'versicolor', 'Petal.Length'])$p.value
```

```
[1] 0.1584778
```

Основа автоматизации - циклы. Цикл `for` -  это когда для каждого элемента из набора производится какое-то действие. 

_Циклы необходимы тогда, когда нужны последовательные вычисления. Альтернативой являются функции для параллельного вычисления (apply/sapply/tapply/vapply/lapply). В последнем случае циклов желательно избегать._

Еще почитать про циклы

* https://www.r-bloggers.com/how-to-write-the-first-for-loop-in-r/
* https://habr.com/company/microsoft/blog/320232/


```r
# набор
numbers = 1:10
# действие - печать элемента
for (i in numbers){
  print(i)
}
# другое возможное действие - возведение в степень
for (i in numbers){
  print(i^2)
}
```

Теперь применим знание о циклах для нашей задачи. Распечатаем `shapiro.test(...)$p.value` для всех переменных одного вида.


```r
# переменные
colnames(iris)
```

```
[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
[5] "Species"     
```

```r
# переменная Species нам не нужна
colnames(iris)[1:4] # аналогичного эффекта можно добиться так: colnames(iris)[-5]
```

```
[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width" 
```

```r
my_vars = colnames(iris)[1:4]

for (var_i in my_vars){
  print(var_i)
  print(shapiro.test(iris[iris$Species == 'versicolor', var_i])$p.value)
}
```

```
[1] "Sepal.Length"
[1] 0.464737
[1] "Sepal.Width"
[1] 0.3379951
[1] "Petal.Length"
[1] 0.1584778
[1] "Petal.Width"
[1] 0.0272778
```

Чтобы два раза не печатать `print()`, а скомбинировать два значения (имя переменной и значение p-value), можно использовать функцию `paste()`. А еще можно использовать функцию `round()` для округления значений.


```r
my_var_name = "MyVariableName"
my_pvalue = 0.05235125413524
print(paste(my_var_name, round(my_pvalue, 3)))
```

```
[1] "MyVariableName 0.052"
```

Аналогично распечатаем `shapiro.test(...)$p.value` для одной переменной всех видов.


```r
# виды
iris$Species # перечень всех значений переменной
unique_species = unique(iris$Species) # найдите как достать уникальные значения вектора/фактора

for (sp_i in unique_species){
  rounded = round( shapiro.test(iris[iris$Species == sp_i, 'Petal.Length'])$p.value, 3 )
  print(paste(sp_i, rounded))
}
```

```r
for (sp_i in unique(iris$Species)) print(paste(sp_i, round( shapiro.test(iris[iris$Species == sp_i, 'Petal.Length'])$p.value, 3 )))
```

```
[1] "setosa 0.055"
[1] "versicolor 0.158"
[1] "virginica 0.11"
```

Теперь мы готовы оценить нормальность всех признаков для всех видов. Но сначала создадим матрицу размерностью в _ЧислоВидов\*ЧислоПеременных_, куда будем помещать значения.


```r
# считаем число видов
Nsp = length(unique(iris$Species))
# считаем число признаков
Nvar = ncol(iris)-1
# создаем пустую матрицу размерностью ЧислоВидов*ЧислоПеременных
my_matrix = matrix(data=NA, nrow=Nsp, ncol = Nvar) # строки-виды, колонки-признаки
# подписываем названия колонок и строк
colnames(my_matrix) = colnames(iris)[1:4] 
rownames(my_matrix) = unique(iris$Species)
```

Теперь в приготовленную матрицу закидываем значения, которые в цикле получим.


```r
for (sp_i in rownames(my_matrix)){
  for(var_i in colnames(my_matrix)){
    my_matrix[sp_i, var_i] = shapiro.test(iris[iris$Species == sp_i, var_i])$p.value
  }
}
# округляем
round(my_matrix, 3)
```

```
           Sepal.Length Sepal.Width Petal.Length Petal.Width
setosa            0.460       0.272        0.055       0.000
versicolor        0.465       0.338        0.158       0.027
virginica         0.258       0.181        0.110       0.087
```

```r
# выясняем, кто распределен нормально
my_matrix > 0.05
```

```
           Sepal.Length Sepal.Width Petal.Length Petal.Width
setosa             TRUE        TRUE         TRUE       FALSE
versicolor         TRUE        TRUE         TRUE       FALSE
virginica          TRUE        TRUE         TRUE        TRUE
```

Итак, вместо множества однообразных команд мы смогли написать программу, которая автоматически может проверить нормальность распределения любого количества признаков у любого количества видов. А потом эти данные можно наглядно визуализовать в виде `heatplot`.

![](https://raw.githubusercontent.com/lapotok/biochem_statistics/master/2018/lesson2/materials_files/figure_html/unnamed-chunk-10-1.png)<!-- -->

## T-test

Первым делом генерируем 3 нормально распределенных набора данных (выборки) по 30 элементов каждый

* А1 и А2 - элементы из одной генеральной совокупности (среднее 50, стандартное отклонение 5)
* B1 - элементы из другой генеральной совокупности (среднее 55, стандартное отклонение 5)


```r
set.seed(123) # задаем стартовое значения генератору случайных чисел
A1 = rnorm(30, m=50, 5)
A2 = rnorm(30, m=50, 5)
B1 = rnorm(30, m=55, 5)

# можно свести их в таблицу
tt_df = data.frame(A1 = A1, A2 = A2, B1 = B1)
head(tt_df)
```

```
        A1       A2       B1
1 47.19762 52.13232 56.89820
2 48.84911 48.52464 52.48838
3 57.79354 54.47563 53.33396
4 50.35254 54.39067 49.90712
5 50.64644 54.10791 49.64104
6 58.57532 53.44320 56.51764
```

Это была таблица в "широком" формате (столько столбцов, сколько групп/переменных). Для осуществления дальнейших манипуляций надо ее перевести в "длинный" формат (один столбец с названием групп, другой - со всеми значениями). Для этого можно использовать функцию `melt()` из пакета `reshape2`. Параметр `id.vars` будучи пустым говорит о том, что все колонки надо "сливать в одну".


```r
library(reshape2)
tt_df_long = melt(tt_df, id.vars = c())
```
```
   variable    value
1        A1 47.19762
2        A1 48.84911
3        A1 57.79354
...
31       A2 52.13232
32       A2 48.52464
33       A2 54.47563
...
61       B1 56.89820
62       B1 52.48838
63       B1 53.33396
```

Первым делом хотелось бы посмотреть на данные глазами. Посмотрим на 2 типа графика: точечный график и боксплот в разных вариантах.

![](https://raw.githubusercontent.com/lapotok/biochem_statistics/master/2018/lesson2/materials_files/figure_html/unnamed-chunk-13-1.png)

Боксплот - наиболее распространенный тип графика, но точки понятнее. Вот как строить эти графики.


```r
stripchart(value~variable, tt_df_long, v=T, main="Stripchart")
stripchart(value~variable, tt_df_long, v=T, method="jitter", main="Stripchart+jitter")
install.packages('sinaplot')
sinaplot(value~variable, tt_df_long, main="Sinaplot")
boxplot(value~variable, tt_df_long, main="Boxplot")
```

Но наиболее понятен был бы график, где есть и точки, и боксплот, и среднее со стандартным отклонением, и доверительный интервал. Для этого надо наслоить эти графики друг на друга.


```r
boxplot(value~variable, tt_df_long, main="Boxplot+sinaplot+mean+sd+ci")
sinaplot(value~variable, tt_df_long, pch=21, col=alpha("black",0.1), bg=alpha("black",0.2), cex=.8, add=T)
means = aggregate(value~variable,tt_df_long, "mean")$value
sds = aggregate(value~variable,tt_df_long, "sd")$value
ci = aggregate(value~variable,tt_df_long, FUN=function(x) t.test(x)$conf.int)
ci_lower = ci$value[,1]
ci_upper = ci$value[,2]
vars = ci$variable
points(as.numeric(vars)+0.1, means, col="blue", pch=16)
arrows(as.numeric(vars)+0.1, means+sds, as.numeric(vars)+0.1, means-sds, code=3, angle=90, col="blue", lwd=1.5, len=0.1)
arrows(as.numeric(vars)+0.2, ci_lower, as.numeric(vars)+0.2, ci_upper, code=3, angle=90, col="green", lwd=1.5, len=0.07)
abline(h=50, col="red", lty="dashed", lwd=0.5)
```

![](https://raw.githubusercontent.com/lapotok/biochem_statistics/master/2018/lesson2/materials_files/figure_html/unnamed-chunk-15-1.png)<!-- -->

Теперь мы представляем, как выглядит наше тестовое распределение, с которым мы будем работать. Перейдем к t-тесту, чтобы ответить, отличаются ли группы (могли ли они быть взяты из одной генеральной совокупности). Критерий Стьюдента можно применять только проверив нормальность (`shapiro.test()`) и гомогенность дисперсий (`bartlett.test()` или `leveneTest()` из пакета `car`).


```r
# критерий Стьюдента: нормальное распределение, одинаковые дисперсии
t.test(A1, B1, var.equal = T)
```

```

	Two Sample t-test

data:  A1 and B1
t = -3.714, df = 98, p-value = 0.0003392
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -5.459853 -1.657107
sample estimates:
mean of x mean of y 
 50.17202  53.73050 
```

```r
# критерий Уэлча: нормальное распределение, может быть разные дисперсии
t.test(A1, B1)
```

```

	Welch Two Sample t-test

data:  A1 and B1
t = -3.714, df = 97.572, p-value = 0.0003399
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -5.459957 -1.657003
sample estimates:
mean of x mean of y 
 50.17202  53.73050 
```

```r
# критерий Вилкоксона: любое распределение, любые дисперсии (еще не проходили)
wilcox.test(A1, B1)
```

```

	Wilcoxon rank sum test with continuity correction

data:  A1 and B1
W = 769, p-value = 0.0009247
alternative hypothesis: true location shift is not equal to 0
```

Другие модификации t-test (на следующий урок):

* одновыборочный
* односторонний vs двусторонний
* парный
