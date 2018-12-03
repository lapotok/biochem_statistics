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
  - vector (factor, matrix)
  - list -> data.frame -> tibble
* Tidy data, reshaping
* Pipelines
* gglot/qplot + ggpubr -> pptx
* Анализ данных
  - str
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

## map-конструкции
