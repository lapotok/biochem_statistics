# ============================================== #
#  Возможные проблемы
# ============================================== #

# 1. Русские имена в пути установки, решение - поставить в папку C:/R
# 2. Locale
# echo "export LANG=en_US.UTF-8" >> ~/.bashrc && echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc && source ~/.bashrc
# 3. Жалуется на отсутствие gfortran, решение
#     MacOS
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# brew install gcc # (gcc49, если старый mac)
# или тут https://cran.r-project.org/bin/macosx/tools/


# ============================================== #
#  Скачиваем нужные пакеты, если еще не скачаны
# ============================================== #

# список пакетов базового репозитория
base.packages = c('ggplot2', 'scales', 'plotly', 'openxlsx', 'httr', 'rvest', 'ggpubr', 'lattice', 'reshape2', 'repr', 'car', 'sinaplot', 'cowplot', 'dplyr', 'curl', 'ggforce', 'gridExtra', 'knitr', 'multcomp', 'drc', 'RColorBrewer', 'rmarkdown', 'boot', 'nlme', 'caret', 'ipred', 'e1071', 'readxl', 'naniar', 'effsize', 'dunn.test', 'magrittr', 'officer', 'rvg', 'profvis', 'lubridate', 'remedy', 'glue', 'esquisse', 'ggalt', 'devtools', 'ggExtra', 'tidyverse', 'broom', 'gsheet', 'jtools', 'huxtable')
# список пакетов из github
git.packages = list(`patchwork`='thomasp85/patchwork', `crayon`='r-lib/crayon', `rstatix`='kassambara/rstatix')

# составляем списки того, что надо поставить
installed = as.character(installed.packages()[,"Package"])
uninstalled = setdiff(c(base.packages, names(git.packages)), installed)

# ставим
if (length(uninstalled)>0) {
  install.packages(intersect(uninstalled, base.packages), dependencies = TRUE)
  for (p in intersect(uninstalled, names(git.packages))) devtools::install_github(git.packages[[p]])
}

# составляем списки того, что осталось непоставленным
installed_upd = as.character(installed.packages()[,"Package"])
uninstalled_upd = setdiff(c(base.packages, names(git.packages)), installed_upd)

# пишем отчет
cat(crayon::bold$underline('\nPackage installation report\n'))
if (length(uninstalled) == 0) {
  cat(paste0(' ', crayon::green(clisymbols::symbol$tick), " No packages need to be installed.\n")) 
} else {
  cat(paste0('Following packages (', length(uninstalled), ') needed to be installed:\n'))
  for (p in uninstalled) cat(' ', paste0(crayon::yellow(clisymbols::symbol$star), ' ' , crayon::style(p, 'gray'), '\n'))
}
if(length(setdiff(uninstalled, uninstalled_upd))>0){
  cat(paste0('Following packages (', length(setdiff(uninstalled, uninstalled_upd)), ') were succesfully installed:\n'))
  for (p in setdiff(uninstalled, uninstalled_upd)) cat(paste(' ', crayon::green(clisymbols::symbol$tick), crayon::style(p, 'gray'), '\n'))
}
if(length(uninstalled_upd)>0) {
  cat(paste0(crayon::red('Following packages (', length(uninstalled_upd), ') are still missing:\n')))
  for (p in uninstalled_upd) cat(' ', paste(crayon::red(clisymbols::symbol$cross), crayon::style(p, 'gray'), '\n'))
}

# update.packages()
