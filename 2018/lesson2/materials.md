# Курс по статистике: практикум урок 1

2018-11-07

Альтшулер Евгений

> _Биофак МГУ, каф. биохимии_
>
> _Для магистров 2 года (Биофак МГУ, каф. биохимии)_

## План урока

* Разбор домашней работы
    - вопросы
    - обычные команды
    - варианты автоматизации (матрица значений, таблица рисунков)
* Т-тесты
* Боксплоты и их разновидности

## Новые структуры - матрица и список

Матрица - таблица однотипных данных (все 

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

Если не автоматизировать, то надо написать 3x4=12 команд следующего вида (заменяя название вида и переменной)

```r
shapiro.test(iris[iris$Species == 'versicolor', 'Petal.Length'])$p.value
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

Распечатаем `shapiro.test(...)$p.value` для всех переменных одного вида.

```r
# переменные
colnames(iris)
# переменная Species нам не нужна
colnames(iris)[1:4]
colnames(iris)[-5]
my_vars = colnames(iris)[1:4]

for (current_var in my_vars){
  print(current_var)
  print(shapiro.test(iris[iris$Species == 'versicolor', current_var])$p.value)
}
```

Чтобы два раза не печатать `print()`, а скомбинировать два значения (имя переменной и значение p-value), можно использовать функцию `paste()`.

```{r eval=T)
my_var_name = "MyVariableName"
my_pvalue = 0.05
print(paste(my_ 
```

Аналогично распечатаем `shapiro.test` для одной переменной всех видов

```r
# виды
iris$Species # перечень всех значений переменной
unique_species = unique(iris$Species) # найдите как достать уникальные значения вектора/фактора

for (current_sp in unique_species){
  print(unique_species)
  print(shapiro.test(iris[iris$Species == unique_species, 'Petal.Length'])$p.value)
}
```

Теперь используя вложенные циклы `for` (см. ниже) посчитаем `shapiro.test` для всех видов и всех признаков

```r
for(current_var in my_vars){
  for(current_sp in unique_species){
     print(
  }
}
```

## T-test

```r
set.seed(123)
pop_1.1 = rnorm(30, m=50, 5)
mean(pop_1.1)
sd(pop_1.1)
pop_1.2 = rnorm(30, m=50, 5)
mean(pop_1.2)
sd(pop_1.2)
pop_2.1 = rnorm(30, m=55, 5)
mean(pop_2.1)
sd(pop_2.1)

df = data.frame(
  val=c(pop_1.1,pop_1.2, pop_2.1), 
  group=c(rep(1,30),rep(2,30), rep(3,30))
)

boxplot(val~group, df, outline=F, )
stripchart(val~group, df, add=T, v=T, m="jitter", pch=21, col="black", bg="gray")
means = c(mean(pop_1.1), mean(pop_1.2), mean(pop_2.1))
sds = c(sd(pop_1.1), sd(pop_1.2), sd(pop_2.1))
points(1:3+0.1, means, col="blue", pch=16)
arrows(1:3+0.1, means+sds, 1:3+0.1, means-sds, code=3, angle=90, col="blue", lwd=1.5)

abline(h=50, col="red", lty="dashed", lwd=2)

t.test(pop_1.1, pop_1.2, var.equal = T)
t.test(pop_1.1, pop_2.1, var.equal = T)
t.test(pop_1.1, mu=50)
t.test(pop_2.1, mu=50)
```

Влияние дисперсии на различия

```r
set.seed(123)
par(mfrow=c(1,2))

df = data.frame(
  val=c(rnorm(30, m=50, 5),rnorm(30, m=50, 5), rnorm(30, m=50, 5)), 
  group=c(rep(1,30),rep(2,30), rep(3,30))
)

boxplot(val~group, df, outline=F, main="Mean=50, SD=5", ylim=c(30,70))
stripchart(val~group, df, add=T, v=T, m="jitter", pch=21, col="black", bg="gray")
means = c(mean(pop_1.1), mean(pop_1.2), mean(pop_2.1))
sds = c(sd(pop_1.1), sd(pop_1.2), sd(pop_2.1))
points(1:3+0.1, means, col="blue", pch=16)
arrows(1:3+0.1, means+sds, 1:3+0.1, means-sds, code=3, angle=90, col="blue", lwd=1.5)

df = data.frame(
  val=c(rnorm(30, m=50, 5),rnorm(30, m=50, 5), rnorm(30, m=50, 5)), 
  group=c(rep(1,30),rep(2,30), rep(3,30))
)

boxplot(val~group, df, outline=F, main="Mean=50, SD=20", ylim=c(30,70))
stripchart(val~group, df, add=T, v=T, m="jitter", pch=21, col="black", bg="gray")
means = c(mean(pop_1.1), mean(pop_1.2), mean(pop_2.1))
sds = c(sd(pop_1.1), sd(pop_1.2), sd(pop_2.1))
points(1:3+0.1, means, col="blue", pch=16)
arrows(1:3+0.1, means+sds, 1:3+0.1, means-sds, code=3, angle=90, col="blue", lwd=1.5)
```
