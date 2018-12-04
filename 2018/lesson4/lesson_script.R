# ============================================ #
# Повторение pipelines
# ============================================ #

library(tidyverse)
library(magrittr)

sqrt(log10(abs(as.numeric("-10000"))))
"-10000" %>% as.numeric %>% abs %>% log10 %>% sqrt


# ============================================ #
# Повторение ggplot & ggpubr
# ============================================ #

library(ggplot2)
library(ggpubr)
library(patchwork)
library(rvg)
library(officer)

# готовый график (можем сохранять в объект)
g1 = iris %>%
  ggboxplot("Species", "Petal.Length", col="Species", add="jitter", title="Использован ggboxplot()") %>%
  ggpar(legend="right") # меняем параметры!
g1 # "распечатываем" график

# готовый график (y_log)
g1l = iris %>%
  ggboxplot("Species", "Petal.Length", col="Species", add="jitter", title="Использован ggboxplot(log)") %>%
  ggpar(legend="right", yscale="log10")
g1l # "распечатываем" график


# делаем такой же график сами
g2 = iris %>%
  ggplot(aes(Species, Petal.Length, col=Species)) +
  geom_boxplot() +
  geom_jitter() +
  theme_pubr() + 
  theme(legend.position = "right") +
  ggtitle('Использован ggplot()')
g2

# располагаем несколько графиков рядом (библиотека patchwork, а также cowplot и gridExtra)
g1 + g1l
g1 + g2

g3 = iris %>% 
  gghistogram("Petal.Length", y = "..density..", alpha=.3, col=NA, fill="Species", add_density = T) %>%
  ggpar(legend="right")
g3

ggg = (g1 + g2) / g3

# сохраним в pptx
library(rvg)
library(officer)
doc <- read_pptx() %>% # создаем презентацию
  add_slide(layout = "Title and Content", master = "Office Theme") %>% # добавляем слайд 1
  ph_with_vg(code = print(ggg), type = "body") %>% # вставляем график
  print(target = "demo.pptx") # задаем имя файла
  
# отличная возможность оптимизации - написать функцию ggplot_to_pptx
ggplot_to_pptx = function(g, filename){
  require(rvg)
  require(officer)
  doc <- read_pptx() %>% # создаем презентацию
    add_slide(layout = "Title and Content", master = "Office Theme") %>% # добавляем слайд 1
    ph_with_vg(code = print(g), type = "body") %>% # вставляем график
    print(target = filename) # задаем имя файла
}

ggplot_to_pptx(ggg, "demo.pptx")

# glue, expressions
# transformations и разные распределения
# anova, kruskal.test, tukeyHSD
# friedman
# chisq, fischer
