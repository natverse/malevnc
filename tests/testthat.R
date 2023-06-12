library(testthat)
library(malevnc)

# tests currently assume MALEVNC_DATASET=VNC
withr::with_envvar(new=c('MALEVNC_DATASET'="VNC"), test_check("malevnc"))
