# Сравнение нескольких групп

Дисперсионный анализ (ANOVA), Kruskal test, множественные сравнения.

Чтобы у Вас все заработало, доустановите недостающие пакеты командой `source('https://tiny.cc/lpt_rpkgs')`.

## Дисперсионный анализ

```r
library(tidyverse)
library(magrittr)
library(ggpubr)
library(rstatix)

# генерируем данные
set.seed(1235)

my_data = data.frame(
  x = c( # значения - три группы по 100
    rnorm(100, 50, 10), # G1
    rnorm(100, 54, 10), # G2
    rnorm(100, 56, 10)  # G3
  ),
  g = c( # названия групп
    rep('G1', 100), 
    rep('G2', 100), 
    rep('G3', 100)
  )
)

# минимальный боксплот
my_data %>% ggboxplot('g', 'x')

# проверка нормальности
my_data %>% group_by(g) %>% summarise(normality = shapiro.test(x)$p.value > 0.05)
# проверка равномерности дисперсии
library(car)
my_data %>% leveneTest(x ~ g, data = .)

# дисперсионный анализ
# в его основе лежит линейная регрессия (см. ссылки)
m = my_data %>% lm(x ~ g, data = .) # так кодируется переменная g: my_data %>% mutate(g = as.factor(g)) %>% pluck('g') %>% unique() %>% contr.treatment()
m
m %>% summary()
# на основе модели линейной регрессии делаем дисперсионный анализ
m_aov = m %>% aov()
m_aov %>% summary()
# новая крутая библиотека rstatix для компактного вывода данных
my_data %>% anova_test(x ~ g)
my_data %>% tukey_hsd2(x ~ g) %>% add_significance('p.adj') # таблица результатов множественных сравнений Тьюки

# непараметрический анализ диспрерсионного анализа - тест Крускала-Уоллиса
my_data %>% kruskal_test(x~g)

# множественные попарные сравнения с различными поправками (компактный вид)
pairwise.test = my_data %>% 
  t_test(x ~ g) %>% 
  adjust_pvalue(method = 'bonferroni')
pairwise.test

# украшаем наш исходный боксплот ...
my_data %>% ggboxplot(
    'g',
    'x',
    col           = 'g',
    fill          = NA,
    add           = c('jitter', 'mean_ci'),
    error.plot    = 'errorbar',
    add.params    = list(size = 2, alpha = .5), 
    outlier.shape = NA,
    title         = 'Визуализация распределения значений по группам',
    xlab          = 'Группы',
    ylab          = 'Значения',
    caption       = 'Попарные сравнения с помощью t.test+bonferroni',
    ggtheme       = theme_classic()
) + 
  grids(axis = 'y', linetype = 'dashed') +
  stat_compare_means(method = 'anova', label.y = 20) +
  stat_pvalue_manual(
      pairwise.test, label = "p.adj.signif", 
      y.position = c(85, 95, 90), tip.length = .01
  )
```

О других возможных "украшательствах" графика можно почитать здесь:

* http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/79-plot-meansmedians-and-error-bars/
* http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/76-add-p-values-and-significance-levels-to-ggplots/

## Полезные ресурсы

* [разные пакеты, которые считают анову](https://www.r-statistics.com/2010/04/repeated-measures-anova-with-r-tutorials/)
* one-way anova - [как делать в `R`](http://www.sthda.com/english/wiki/one-way-anova-test-in-r), [как самому написать и использовать](https://habr.com/post/304528/), [использование и мн. сравнения](http://rcompanion.org/rcompanion/d_05.html)
* two-way anova - [как делать в `R`](http://www.sthda.com/english/wiki/two-way-anova-test-in-r), [ANOVA type I/II/III](http://md.psych.bio.uni-goettingen.de/mv/unit/lm_cat/lm_cat_unbal_ss_explained.html)
* Про регрессию, которая лежит в основе дисперсионного анализа
  * http://www.sthda.com/english/articles/39-regression-model-diagnostics/161-linear-regression-assumptions-and-diagnostics-in-r-essentials/
  * кодирование признаков https://rstudio-pubs-static.s3.amazonaws.com/65059_586f394d8eb84f84b1baaf56ffb6b47f.html
