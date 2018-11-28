# ============================================ #
# Сравнение независимых групп: пример анализа
# ============================================ #

# чтение файла формата XLS/XLSX
library(tidyverse)
# library(readxl)
# pr_st = "... /protein_stability.xlsx" %>%
#  read_excel()

# dput(pr_st)
pr_st = structure(list(Sample = c("-70", "-70", "-70", "-70", "-70", "-70", "+04", "+04", "+04", "+25", "+25", "+25", "+37", "+37", "+37", "+45", "+45", "+45", "-70", "-70", "-70", "-70", "-70", "-70", "+04", "+04", "+04", "+25", "+25", "+25", "+37", "+37", "+37", "+45", "+45", "+45", "-70", "-70", "-70", "-70", "-70", "-70", "+04", "+04", "+04", "+25", "+25", "+25", "+37", "+37", "+37", "+45", "+45", "+45"), ConcUndiluted = c(190.358383395431, 207.130335374233, 212.155084034968, 204.546226648717, 203.881376421319, 223.526873018626, 208.488843335262, 201.844495606319, 211.403404329595, 180.131250871951, 178.923586081235, 169.921036891728, 156.040991878615, 155.666216226061, 181.812066991222, 123.775327946985, 140.124431301898, 146.253177058455, 202.982324261341, 197.08723251418, 197.702589409372, 197.924373388864, 208.91580236029, 200.814383929538, 186.196513795441, 189.108922747877, 210.361337366157, 156.999494218928, 182.093850196572, 184.795647720755, 161.478700330871, 188.628841041798, 179.618386523493, 176.340675491564, 145.224124571716, 148.371343013506, 222.585263927023, 205.180841462771, 207.19048679163, 203.713637951335, 200.347314207726, 196.827449296974, 223.24536020279, 190.413156430691, 196.017824517897, 176.529856242399, 169.136274023754, 182.761804662899, 189.689454914748, 179.738502635609, 175.37642101145, 131.648318426537, 129.820482343488, 144.58244778513)), row.names = c(NA, -54L), class = c("tbl_df", "tbl", "data.frame"))

# смотрим глазами
pr_st
View(pr_st)
pr_st %>% View()
pr_st %>% View

# сколько наблюдений
table(pr_st$Sample)
pr_st %>% 
  pull(Sample) %>% 
  table()

# статистика
pr_st %>% 
  group_by(Sample) %>% 
  summarise_at(vars(ConcUndiluted), funs(n=length, mean=mean, sd=sd))

# считаем среднюю концентрацию в пробах на -70
calibr_mean = pr_st %>%
  filter(Sample == "-70")  %>% 
  pull(ConcUndiluted) %>%
  mean()

# переводим все цифры в проценты от средней концентрации белка на -70
library(magrittr)
pr_st %<>% # использование оператора %<>% равносильно написанию pr_st = pr_st %>% ...
  mutate(ConcUndilutedP=ConcUndiluted/calibr_mean*100)

# qq-plot
library(ggpubr)
# все распределение без разделения на группы
pr_st %>%
  ggqqplot("ConcUndilutedP")
# группируем
pr_st %>%
  ggqqplot("ConcUndilutedP") + facet_grid(~Sample)

# qq-plot после шкалирования
pr_st %>%
  group_by(Sample) %>% 
  mutate(ConcUndilutedScaled = scale(ConcUndilutedP)) %>%
  ggqqplot("ConcUndilutedScaled") + facet_grid(~Sample)

# histograms
pr_st %>%
  group_by(Sample) %>% 
  mutate(ConcUndilutedScaled = scale(ConcUndilutedP)) %>%
  gghistogram("ConcUndilutedScaled", "..count..",
               add = "mean", rug = TRUE, add_density = T,
   color = "Sample") + facet_grid(~Sample) + theme_bw()


# shapiro
shapiro_p.value = function(x) shapiro.test(x)$p.value
pr_st %>%
  group_by(Sample) %>%
  summarise_at(vars(ConcUndilutedP), funs(shapiro_p.value=shapiro_p.value))

# boxplot: ggplot step-by-step
library(ggforce)
pr_st %>% 
  ggplot(aes(Sample, ConcUndilutedP)) +
  geom_boxplot(outlier.shape = NA, col="gray") + 
  geom_sina(alpha=.5, size=2) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width=.1, col="blue", position = position_nudge(.1)) +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width=.1, col="blue", alpha=.4, position = position_nudge(.2)) +
  stat_summary(fun.y = mean, geom = "point", col="blue", position = position_nudge(.1)) +
  theme_classic()

# variance homogeneity
library(car)
leveneTest(ConcUndiluted~Sample, data = pr_st) # лучше переносит отклонения от нормальности, чем bartlett.test
pr_st %>% leveneTest(ConcUndiluted~Sample, data = .)

pr_st %>% 
  filter(Sample %in% c("-70", "+04")) %$% # оператор %$% "достает" колонки из таблицы, которые теперь как самостоятельные объекты
  t.test(ConcUndilutedP~Sample, var.equal=T) # t.test
  #wilcox.test(ConcUndilutedP~Sample, var.equal=T) # Mann Whitney/ Wilcoxon
# ks.test() # Kolmogorov Smirnov

# t.test дает достоверность различия, а величина эффекта - это иной параметр!
library(effsize)
pr_st %>% 
  filter(Sample %in% c("-70", "+04")) %>% 
  cohen.d(ConcUndilutedP~Sample, data=., var.equal=T)

# чем меньше величина эффекта, тем больше требуется размер выборки, чтобы его достоверно установить
# тест мощности позволяет это сделать
library(pwr)
pwr.t.test( d = 0.27, # величина наблюдаемого эффекта
            sig.level = 0.05, # вероятность ошибки I рода (достоверность, вероятность ошибочно отклонить гипотезу о равенстве средних)
            power = 0.95) # вероятность ошибки II рода (мощность, вероятность ошибочно не отклонить гипотезу о равенстве средних)

# boxplot + t.test
pr_st %>% 
  filter(Sample %in% c("-70", "+04")) %>% 
  ggboxplot('Sample', 'ConcUndilutedP',
          color = 'Sample', palette = "jco",
          add = "jitter") +
  stat_compare_means(method = "t.test", label.y.npc = "bottom") +
  stat_compare_means(method = "wilcox", label.x.npc = "center", label.y.npc = "bottom") 

# ============================================ #
# Сравнение независимых групп: пример анализа
# ============================================ #
# генерим пример данных
mice_w = data.frame(
  mice_id = 1:10,
  before = c(332.2, 345.5, 350.9, 352.7, 353.7, 356.9, 360.1, 365.2, 373, 381.4), # Weight of the mice before treatment
  after = c(345.1, 352.2, 360.3, 377.2, 382.9, 380, 373.9, 386, 402, 385.9)# Weight of the mice after treatment
)
mice_w$mice_id = factor(mice_w$mice_id)

# wide format
mice_w

# wide to long
mice_l = mice_w %>% 
  gather("variable", "value", -mice_id) %>% 
  mutate(variable = factor(variable, levels=c("before", "after"), ordered=T))

# long format
mice_l

t.test(value~variable, mice_l, paired = TRUE)
wilcox.test(value~variable, mice_l, paired = TRUE)

mice_l$variable
t.test(value~variable, mice_l, paired = TRUE, alternative="less")

with(mice_w, t.test(before, after, paired = TRUE, alternative="less"))

library(ggpubr)
mice_l %>% 
  ggpaired(x="variable", y="value",
         color = "variable", line.color = "gray", line.size = 0.4, point.size = 3,
         palette = "jco", label="value", repel = T, font.label = 9, alpha = .2) +
  stat_compare_means(paired = TRUE, method = "t.test", ) 
# stat_compare_means(paired = TRUE, method = "wilcox")
