# Библиотеки: что для чего грузить

```r
c('ggplot2', 'scales', 'plotly', 'openxlsx', 'httr', 'rvest', 'ggpubr', 'lattice', 'reshape2', 'repr', 'car', 'sinaplot', 'cowplot', 'dplyr', 'curl', 'ggforce', 'gridExtra', 'knitr', 'multcomp', 'drc', 'RColorBrewer', 'rmarkdown', 'boot', 'nlme', 'caret', 'ipred', 'e1071', 'readxl', 'naniar', 'effsize', 'dunn.test', 'magrittr', 'officer', 'rvg', 'profvis', 'lubridate', 'remedy', 'glue', 'esquisse', 'ggalt', 'devtools', 'ggExtra', 'tidyverse', 'broom', 'gsheet', 'jtools', 'huxtable')
```


* пайплайны

```r
library(tidyverse)  # основа пайплайнов (%>%, select, mutate, summarise, group_by ...)
library(magrittr)   # дополнительные фишки (типа %<>%)
library(broom)      # упрощение вывода моделей и тестов (model %>% tidy())
library(purrr)      # mapping, nesting, операции над несколькими подмножествами данных
library(naniar)     # NA фильтрация
library(glue)       # склеивание вместе текста и переменных
library(rstatix)    # pipeline-friendly tests
```

* графики

```r
library(ggplot2)    # основа современных графиков
library(ggpubr)     # крутые готовые графики (ggboxplot etc.)
library(ggstatplot) # еще готовые графики ...

library(ggforce)    # geom_sina
library(ggalt)      # geom_* ...

library(patchwork)  # простая компоновка графиков, например (g1 + g2) / g3
library(cowplot)    # другой способ
library(gridExtra)  # другой способ
library(ggExtra)    # другой способ

library(rvg)        # векторная графика
library(officer)    # экспорт в pptx
```

* import

```r
library(readxl)     # xls, xlsx
library(httr)       # web
library(rvest)      # web
library(gsheet)     # google sheets
```

* analysis

```r
```
