Это мои планы на преподавание курса в следующем году.

# <img src="https://raw.githubusercontent.com/lapotok/biochem_statistics/master/2019/img/outofbox.png" height="70"> На всем готовеньком 

## Введение

* Мотивирующие примеры
  - вычитание спектра + вычитание рассеяния + расчет концентрации
  - калибровки с расчетом + выкидывание аутлаеров
  - ...
* Переменные и операторы
  - имена и namespaces
  - арифметика
* Функции
  - аргументы: (не)обязательные, по умолчанию, (не)именные, ...
  - print или return (value/list)
* Типы данных
  - value (char, integer, numeric/double, boolean)
  - vector
    - factor (текст - не данные)
    - matrix
  - list -> data.frame -> tibble
* Tidy data, reshaping
* Pipelines
* gglot/qplot + ggpubr -> pptx
* Анализ данных
  - str, table/summarise, cut...
  - ggboxplot
  - ggqqplot
  - gghistogram
  - проверка на нормальность, гомогенность дисперсии
  - шкалирование и трансформации
  - t.test, wilcox.test, ks.test
  - aov, kruskal.test, tukeyHSD, pairwise.t.test, pairwise.wilcox.test
  - chisq, fischer
  - lm, drm
  - bootstrap

---

# <img src="https://raw.githubusercontent.com/lapotok/biochem_statistics/master/2019/img/doityourself.jpeg" height="60"> Сделай сам 


## Функции

* Нереализованные действия (CV)
* Симуляция
* Автоматизация и упрощения (gg_to_pptx)
* Изменение формата вывода/ввода (wrapplers, e.g. mean_sdl, t.test()$p.value, все тесты в одном формате, типа computestats)

# Полезные фишки для самостоятельного изучения 

<img src="https://raw.githubusercontent.com/lapotok/biochem_statistics/master/2019/img/selfeducate.png" height="60">

* импорт файлов HTML/XML (httr, rvest)
* вставка переменных в текст (glue)
* компоновка графиков (patchwork)
* map-конструкции
* nesting (nest, group_by, map)
* операции с датами (lubridate)
* markdown, remedy, Rpres
* ggplot visual builder (esquisse)
* profiling (profvis)
