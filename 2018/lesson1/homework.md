# Домашнее задание №1

## `R` как калькулятор
<!-- \frac{log_{10}{123}+1.34}{(4\cdot5+3)^{1.5}}\cdot\sqrt{\frac{1}{(1+10^{15})}} -->
<a href="https://www.codecogs.com/eqnedit.php?latex=\dpi{120}&space;\frac{log_{10}{123}&plus;1.34}{(4\cdot5&plus;3)^{1.5}}\cdot\sqrt{\frac{1}{(1&plus;10^{15})}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\dpi{120}&space;\frac{log_{10}{123}&plus;1.34}{(4\cdot5&plus;3)^{1.5}}\cdot\sqrt{\frac{1}{(1&plus;10^{15})}}" title="\frac{log_{10}{123}+1.34}{(4\cdot5+3)^{1.5}}\cdot\sqrt{\frac{1}{(1+10^{15})}}" /></a>

<!-- (log(123, b=10)+1.34)/((4*5+3)^(1.5))*sqrt(1/(1+10^15)) -->

## 1. Напишите результат вычисления выражения (см. выше) *
## 2. Напишите код, использованный для расчета *
## 3. Работа с таблицей и shapiro.test() *

Напишите значения `p-value` (от `shapiro.test()`) для всех признаков для _Iris setosa_ и выводы, является ли распределение нормальным. 

Например:

```
Sepal.Length: 0.010 - TRUE; Sepal.Width: 0.225 - TRUE; Petal.Length: 0.955 - TRUE; Petal.Width: 0.123 - FALSE
```

<!--
Проверить нормальность распределения Petal.Length каждого из видов ирисов

```{r, echo=F, eval=F}
library(lattice)
library(reshape2)
iris_l = melt(iris, id.vars = c("Species"))
qqmath(~ value | variable*Species, data = iris_l,
       prepanel = prepanel.qqmathline,
       panel = function(x, ...) {
          panel.qqmathline(x, ...)
          panel.qqmath(x, ...)
       })
Nsp = length(unique(iris$Species))
Nvar = ncol(iris)-1
shap_m = matrix(rep(0, Nsp*Nvar), nrow=Nsp, ncol = Nvar, dimnames = list(unique(iris$Species), colnames(iris)[1:4]))
for (rn in rownames(shap_m)){
  for(cn in colnames(shap_m)){
    shap_m[rn, cn] = shapiro.test(iris[iris$Species == rn, cn])$p.value
  }
}
round(shap_m, 3)
shap_m > 0.05 # is normal?
```
-->
## 4. Расчет стандартных отклонений *

Напишите значения стандартного отклонения для признака _Petal.Length_ для видов ириса _I. setosa_, _I. versicolor_, _I. virginica_. 

Например: `1, 2, 3`

## Открыть файл Excel

Скачать файл по [ссылке](https://drive.google.com/open?id=1oCvunUF1ajetOnyvxgfZVPlIrVeCEi6s). Открыть в Excel, скопировать таблицу в буфер обмена. Использовать команду `read.table()` с соответствующими опциями, чтобы распознать заголовки, десятичные разделители и разделители значений таблицы.

## 5. Найти ошибки в таблице таблицы *

Перечислите ошибки, которые Вы видите в таблице, которые мешают его нормально обрабатывать.

## 6. Какие уровни принимает переменная-фактор 'Пол'? *

Приведите в первой строке все уникальные значения этой переменной, и их число. А в следующих - код которыми их список и это самое число могут быть получены.

## 7. Функция CV для расчета коэффициента вариации *

Напишите код функции

<!-- \operatorname{CV}(X) = \frac{SD\ (x)}{\overline{x}}\cdot100\% -->

<a href="https://www.codecogs.com/eqnedit.php?latex=\dpi{120}&space;\operatorname{CV}(X)&space;=&space;\frac{SD\&space;(x)}{\overline{x}}\cdot100\%" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\dpi{120}&space;\operatorname{CV}(X)&space;=&space;\frac{SD\&space;(x)}{\overline{x}}\cdot100\%" title="\operatorname{CV}(X) = \frac{SD\ (x)}{\overline{x}}\cdot100\%" /></a>

<!--
```{r, echo=F, eval=F}
CV = function(x) sd(x)/mean(x)*100
}
CV(vers)
```
-->

## 8. Функция Var для расчета дисперсии *

Напишите код функции

<!-- \operatorname{Var}(X) = \frac{\sum_{i=1}^n (x_i - \overline{x})^2}{n-1} -->

<a href="https://www.codecogs.com/eqnedit.php?latex=\dpi{120}&space;\operatorname{Var}(X)&space;=&space;\frac{\sum_{i=1}^n&space;(x_i&space;-&space;\overline{x})^2}{n-1}&space;$$" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\dpi{120}&space;\operatorname{Var}(X)&space;=&space;\frac{\sum_{i=1}^n&space;(x_i&space;-&space;\overline{x})^2}{n-1}&space;$$" title="\operatorname{Var}(X) = \frac{\sum_{i=1}^n (x_i - \overline{x})^2}{n-1} $$" /></a>

<!--
```{r, echo=F, eval=F}
Var = function(x){
  squares = (x-mean(x))^2
  sum_squares = sum(squares)/(length(x)-1)
  return(sum_squares)
}
var(vers)
```
-->
