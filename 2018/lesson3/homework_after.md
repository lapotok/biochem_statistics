# Полезные дополнения

Для работы с пайплайнами и графиками загрузите следующие библиотеки

 ```r
library(tidyverse)
library(ggpubr)
library(magrittr)
library(readxl)
library(car)
```

## Пайплайны

* Операторы для пайплайнов
  - `%>%` для направления данных справа налево, от вывода одной функции на ввод другой (вместо вложенных функций)
  - `%$%` для экстрагирования из таблиц колонок или списков элементов списка, например `iris %$% leveneTest(Petal.Length, Species)` (вместо `leveneTest(iris$Petal.Length, iris$Species)`)
  - `%<>%` для укороченной записи действия `A = A %>% ...` (будет записано как `A %<>% ...`)
  - `.` для указания на передаваемый через 
* Функции для использования в пайплайнах
  - `slice()` для выбора строк таблицы по номерам, например `iris %>% slice(c(1,3,4))`
  - `filter()` для выбора строк таблицы по критерию, например `iris %>% filter(Species == 'setosa' & Petal.Length > 1.6)`
  - `pluck()` для работы с определенной колоной таблицы (также см. `pull()`) или определенным элементом списка, например, `iris %>% pluck('Species') %>% unique()`
  - `select()` для выбора несколькиx колонок в таблице, например, `iris %>% select(Species, Petal.Length))`
  - ````[`()``` для выбора одновременно и строк и столбцов (как в классическом синтаксисе, там тоже используется ), например ```iris %>% `[`(1:10,1:2)``` или `iris %>% .[1:10,1:2]`
  - `na.omit()` для удаления из таблицы строк с пропущенными данными, например `airquality %>% na.omit()`
  - `replace_with_na_at()`(библиотека `naniar`) для замены на `NA` заданных значений из заданных колонок
  - `mutate()` для изменения старых или создания новых колонок, например `iris %>% mutate(scaled_pl = scale(Petal.Length)) %>% ggqqplot("scaled_pl", facet.by = "Species", ylab = "Scaled petal length")`
  - `gather()` для перевода таблицы из "широкого" формата в "длинный", например `iris %>% gather("var", "val", -Species)`
  - `spread()` для перевода таблицы из "длинного" формата в "широкий"
  - `summarise_at` для расчета выбранных статистик по выбранным колонкам, например, `iris %>% summarise_at(vars(Petal.Length, Sepal.Width), funs(overall.mean = mean, overall.sd = sd))`
  - `group_by()` + `ungroup()` - для создания групп с целью расчета внутригрупповых статистик или изменений (см. далее примеры)
  
**Пример 1**  на создание групп: среднее и стандартное отклонение для каждой из групп
    
```r
iris %>% 
 group_by(Species) %>% 
 summarise_at(vars(Petal.Length, Sepal.Width), funs(group.mean = mean, group.sd = sd))`
```
 **Пример 2** на создание групп: внутри каждой группы делаем z-трансформацию переменной, т.е. <img src="https://latex.codecogs.com/gif.latex?\fn_cm&space;\frac{x_i-mean(x)}{sd(x)}" title="\frac{x_i-mean(x)}{sd(x)}" />
    
```r
iris %>% 
 group_by(Species) %>% 
 mutate(scaled_pl = scale(Petal.Length)) %>% 
 ggqqplot("scaled_pl", facet.by = "Species", ylab = "Scaled within groups petal length")`
``` 

 **Замечание.** Если группировка данных больше не нужна, то лучше ее отменить после использования. Например,

```r
my_new_iris_table = iris %>% 
  group_by(Species) %>% 
  mutate(Petal.Length.GroupwiseScaled = scale(Petal.Length)) %>%
  ungroup()
```

# Задания

* 


# Идеи

* Упражнения на функции пайплайнов
* Упражнения на операторы пайплайнов
* Упражнения на фильтрацию и преобразования колонок (общие и по группам)
* Тестовые данные: выбрать тест, построить боксплот
* Собрать график по кускам
