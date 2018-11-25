# Скачиваем нужные пакеты, если еще не скачаны

list.of.packages <- c('ggplot2', 'scales', 'plotly', 'openxlsx', 'httr', 'rvest', 'ggpubr', 'lattice', 'reshape2', 'repr', 'car', 'sinaplot', 'cowplot', 'dplyr', 'curl', 'dunn.test', 'ggforce', 'gridExtra', 'knitr', 'multcomp', 'drc', 'RColorBrewer', 'rmarkdown', 'boot', 'nlme', 'caret', 'ipred', 'e1071', 'readxl', 'naniar', 'effsize')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
if (!("Biobase" %in% installed.packages()[,"Package"])) BiocManager::install("Biobase", version = "3.8")

if (length(new.packages) == 0) {
  message('No packages need to be installed.')
} else {
  message(paste(length(new.packages), 'packages need to be installed.'))
  install.packages(new.packages)
}
