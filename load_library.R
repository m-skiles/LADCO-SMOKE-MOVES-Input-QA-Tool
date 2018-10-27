#mandatory packages to be installed: RMySQL, ggmap, ggplot2, gridExtra, plyr, codetools
#due to periodic updates of open source packages, exact package versions need to be installed from historical archives
rm(list=ls())
detachAllPackages <- function() {
  basic.packages <- c("package:stats","package:graphics","package:grDevices","package:utils","package:datasets","package:methods","package:base")
  package.list <- search()[ifelse(unlist(gregexpr("package:",search()))==1,TRUE,FALSE)]
  package.list <- setdiff(package.list,basic.packages)
  if (length(package.list)>0)  for (package in package.list) detach(package, character.only=TRUE)
}

detachAllPackages()

if (!require(DBI)) {
  packageurl<-"https://cran.rstudio.com/bin/windows/contrib/3.2/DBI_0.3.1.zip"
  install.packages(packageurl, repos=NULL, type="source")
  library(DBI)
}

if (!require(gridExtra)) {
  packageurl<-"http://cran.r-project.org/src/contrib/Archive/gridExtra/gridExtra_0.9.1.tar.gz"
  install.packages(packageurl, repos=NULL, type="source")
  library(gridExtra)
}


if (!require(RMySQL)) {
  packageurl="https://cran.rstudio.com/bin/windows/contrib/3.2/RMySQL_0.10.7.zip"
  install.packages(packageurl, repos=NULL, type="source")
  library(RMySQL)
}

if (!require(codetools)) {
  packageurl="https://cran.rstudio.com/bin/windows/contrib/3.2/codetools_0.2-14.zip"
  install.packages(packageurl, repos=NULL, type="source")
  library(codetools)
}

if (!require(ggmap)) {
  packageurl="https://cran.rstudio.com/bin/windows/contrib/3.2/ggmap_2.5.2.zip"
  install.packages(packageurl, repos=NULL, type="source")
  library(ggmap)
}


if (!require(ggplot2)) {
  packageurl="https://cran.rstudio.com/bin/windows/contrib/3.2/ggplot2_1.0.1.zip"
  install.packages(packageurl, repos=NULL, type="source")
  library(ggplot2)
}


if (!require(plyr)) {
  packageurl="https://cran.rstudio.com/bin/windows/contrib/3.2/plyr_1.8.3.zip"
  install.packages(packageurl, repos=NULL, type="source")
  library(plyr)
}



library("DBI", lib.loc="~/R/win-library/3.2")
library("RMySQL", lib.loc="~/R/win-library/3.2")
library("plyr", lib.loc="~/R/win-library/3.2")
library("gridExtra", lib.loc="~/R/win-library/3.2")
library("ggplot2", lib.loc="~/R/win-library/3.2")
library("ggmap", lib.loc="~/R/win-library/3.2")
library("codetools", lib.loc="~/R/win-library/3.2")



