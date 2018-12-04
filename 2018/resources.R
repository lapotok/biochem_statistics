# Скачиваем нужные пакеты, если еще не скачаны

# update.packages()
list.of.packages <- c('ggplot2', 'scales', 'plotly', 'openxlsx', 'httr', 'rvest', 'ggpubr', 'lattice', 'reshape2', 'repr', 'car', 'sinaplot', 'cowplot', 'dplyr', 'curl', 'ggforce', 'gridExtra', 'knitr', 'multcomp', 'drc', 'RColorBrewer', 'rmarkdown', 'boot', 'nlme', 'caret', 'ipred', 'e1071', 'readxl', 'naniar', 'effsize', 'dunn.test', 'magrittr', 'officer', 'rvg', 'profvis', 'lubridate', 'remedy', 'glue', 'patchwork', 'esquisse')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if (length(new.packages) == 0) {
  message('No packages need to be installed.')
} else {
  message(paste('Following packages (', length(new.packages), ') need to be installed:', sep=""))
  for (p in new.packages) message(paste('*', p))
  install.packages(new.packages, dependencies = TRUE)
}

installed = as.character(installed.packages()[,"Package"])
diff = setdiff(list.of.packages, installed)
if(length(diff)>0) {
  message(paste('Following packages (', length(new.packages), ') are still missing:', sep=""))
  for (p in diff) message(paste('*',p))
} else {
  message("All packages were successfully installed!")
}
