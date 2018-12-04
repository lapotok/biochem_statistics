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
  ggboxplot("Species", "Petal.Length", col="Species", add="jitter", title="Использован ggboxplot()", legend="right")
g1 # "распечатываем" график

# готовый график (y_log)
g1l = iris %>%
  ggboxplot("Species", "Petal.Length", col="Species", add="jitter", title="Использован ggboxplot(log)", legend="right", yscale="log10")
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
  gghistogram("Petal.Length", y = "..density..", alpha=.3, col=NA, fill="Species", add_density = T, legend="right")
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


# ======================================================= #
# anova, kruskal.test, tukeyHSD, multiple comparisons
# ======================================================= #

# данные - файл "protein_stability.xlsx"
library(readxl)
library(tidyverse)
library(magrittr)
# pr_st = structure(list(Sample = c("-70", "-70", "-70", "-70", "-70", "-70", "+04", "+04", "+04", "+25", "+25", "+25", "+37", "+37", "+37", "+45", "+45", "+45", "-70", "-70", "-70", "-70", "-70", "-70", "+04", "+04", "+04", "+25", "+25", "+25", "+37", "+37", "+37", "+45", "+45", "+45", "-70", "-70", "-70", "-70", "-70", "-70", "+04", "+04", "+04", "+25", "+25", "+25", "+37", "+37", "+37", "+45", "+45", "+45"), ConcUndiluted = c(190.358383395431, 207.130335374233, 212.155084034968, 204.546226648717, 203.881376421319, 223.526873018626, 208.488843335262, 201.844495606319, 211.403404329595, 180.131250871951, 178.923586081235, 169.921036891728, 156.040991878615, 155.666216226061, 181.812066991222, 123.775327946985, 140.124431301898, 146.253177058455, 202.982324261341, 197.08723251418, 197.702589409372, 197.924373388864, 208.91580236029, 200.814383929538, 186.196513795441, 189.108922747877, 210.361337366157, 156.999494218928, 182.093850196572, 184.795647720755, 161.478700330871, 188.628841041798, 179.618386523493, 176.340675491564, 145.224124571716, 148.371343013506, 222.585263927023, 205.180841462771, 207.19048679163, 203.713637951335, 200.347314207726, 196.827449296974, 223.24536020279, 190.413156430691, 196.017824517897, 176.529856242399, 169.136274023754, 182.761804662899, 189.689454914748, 179.738502635609, 175.37642101145, 131.648318426537, 129.820482343488, 144.58244778513)), row.names = c(NA, -54L), class = c("tbl_df", "tbl", "data.frame"))
calibr_mean = pr_st %>% filter(Sample == "-70") %>% pull(ConcUndiluted) %>% mean()
pr_st %<>% mutate(ConcUndilutedP=ConcUndiluted/calibr_mean*100)

library(ggpubr)
library(patchwork)
means = pr_st %>% group_by(Sample) %>% summarise(CPmeans = mean(ConcUndilutedP))
g1 = pr_st %>% ggboxplot("Sample", "ConcUndilutedP", col="Sample", add="jitter", legend="right")
g2 = pr_st %>% ggplot() + 
  aes(as.numeric(Sample), ConcUndilutedP, col=Sample) +
  geom_boxplot() + 
  geom_jitter(width = .7) + 
  theme_classic() #+ 
#geom_smooth(data=means, aes(as.numeric(Sample), CPmeans, color="black"), method="lm", formula = y ~ poly(x, 2)) +
#coord_cartesian(ylim=c(60,110))
g1 / g2

# lm & ANOVA
pr_st_lm = pr_st %>% lm(ConcUndilutedP ~ Sample, data = .)
pr_st_lm %>% summary
pr_st_lm %>% confint
pr_st_aov = pr_st_lm %>% aov
pr_st %>% aov(ConcUndilutedP ~ Sample, data = .)
pr_st_aov %>% summary
pr_st_aov %>% TukeyHSD
pr_st_aov %>% 
  TukeyHSD %>% 
  pluck('Sample') %>% 
  as.data.frame %>% 
  rownames_to_column %>% 
  mutate(diff=`p adj` %>% cut(breaks = c(-1, 0.0001, 0.001, 0.01, 0.5, 0.1, 1), labels = c('****', '***', '**', '*', '.', ' '))) %>% # `p adj`>0.05 
  select(rowname, diff) %>% 
  separate(rowname, sep="-", into=c('N1', 'N2'), extra="merge") %>% 
  unite('N1 x N2', c('N1', 'N2'), sep = ' x ')

pr_st %>% mutate(Sample = as.factor(Sample))%>% kruskal.test(ConcUndilutedP ~ Sample, data = .)

# NB: multiple factors -> Type I, II, III ANOVA

# ======================================================= #
# friedman
# ======================================================= #

# RoundingTimes = structure(c(5.4, 5.85, 5.2, 5.55, 5.9, 5.45, 5.4, 5.45, 5.25,  5.85, 5.25, 5.65, 5.6, 5.05, 5.5, 5.45, 5.55, 5.45, 5.5, 5.65,  5.7, 6.3, 5.5, 5.7, 5.6, 5.5, 5.85, 5.55, 5.4, 5.5, 5.15, 5.8,  5.2, 5.55, 5.35, 5, 5.5, 5.55, 5.55, 5.5, 5.45, 5.6, 5.65, 6.3,  5.55, 5.75, 5.5, 5.4, 5.7, 5.6, 5.35, 5.35, 5, 5.7, 5.1, 5.45,  5.45, 4.95, 5.4, 5.5, 5.35, 5.55, 5.25, 5.4, 5.55, 6.25), .Dim = c(22L,  3L), .Dimnames = list(c("1", "2", "3", "4", "5", "6", "7", "8",  "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",  "20", "21", "22"), c("Round Out", "Narrow Angle", "Wide Angle" )))
rtl = RoundingTimes %>% as.tibble %>% mutate(n=row_number()) %>% gather("var", "val", -n) 

friedman.test(RoundingTimes)
rtl %>% friedman.test(val ~ var |n, data=.)

# Repeated measures Anova
rtl = RoundingTimes %>% as.tibble %>% mutate(n=row_number()) %>% gather("var", "val", -n) 
rtl %>% aov(val ~ var + Error(n/var), data=.) %>% summary

library(magrittr)
library(tidyverse)
library(ggplot2)
library(ggpubr)
library(ggrepel)

ggplot(rtl, aes(x=var, y=val, col=var)) +
  geom_boxplot() +
  geom_point() + 
  map(1:nrow(RoundingTimes), function(i) geom_line(data=data.frame(x=as.factor(colnames(RoundingTimes)), y=RoundingTimes[i,]), aes(x=as.numeric(x), y=y), col="black", alpha=.3)) +
  theme_bw() +
  theme(legend.position = "none")

# chisq, fischer

# transformations и разные распределения
# glue, expressions
