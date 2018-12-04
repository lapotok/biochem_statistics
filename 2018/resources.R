# ============================================== #
#  Скачиваем нужные пакеты, если еще не скачаны
# ============================================== #

# update.packages()

# список пакетов базового репозитория
base.packages = c('ggplot2', 'scales', 'plotly', 'openxlsx', 'httr', 'rvest', 'ggpubr', 'lattice', 'reshape2', 'repr', 'car', 'sinaplot', 'cowplot', 'dplyr', 'curl', 'ggforce', 'gridExtra', 'knitr', 'multcomp', 'drc', 'RColorBrewer', 'rmarkdown', 'boot', 'nlme', 'caret', 'ipred', 'e1071', 'readxl', 'naniar', 'effsize', 'dunn.test', 'magrittr', 'officer', 'rvg', 'profvis', 'lubridate', 'remedy', 'glue', 'esquisse', 'devtools')
# список пакетов из github
git.packages = list(`patchwork`='thomasp85/patchwork')

# составляем списки того, что надо поставить
installed = as.character(installed.packages()[,"Package"])
uninstalled = setdiff(c(base.packages, names(git.packages)), installed)

# ставим
if (length(uninstalled) == 0) {
  message('No packages need to be installed.')
} else {
  message(paste('Following packages (', length(uninstalled), ') need to be installed:', sep=""))
  for (p in uninstalled) message(paste('*', p))
  install.packages(intersect(uninstalled, base.packages), dependencies = TRUE)
  for (p in intersect(uninstalled, names(git.packages))) devtools::install_github(git.packages[[p]])
}

# составляем списки того, что осталось непоставленным
installed_upd = as.character(installed.packages()[,"Package"])
uninstalled_upd = setdiff(c(base.packages, names(git.packages)), installed_upd)

# пишем отчет
if(length(uninstalled_upd)>0) {
  message(paste('\n\nFollowing packages (', length(uninstalled_upd), ') are still missing:', sep=""))
  for (p in uninstalled_upd) message(paste('*',p))
} else {
  message("\n\nGREAT! All packages were successfully installed!")
}
