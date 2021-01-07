## code to prepare `DATASET` dataset goes here

library(nat)

JRCFIBVNC2020MNP.surf <- read.hxsurf('data-raw/VNC_tbars_scale-5.resampled.500k.bin.surf')

usethis::use_data(DATASET, overwrite = TRUE)
