## code to prepare `DATASET` dataset goes here

library(nat)

JRCFIBVNC2020MNP.surf <- read.hxsurf('data-raw/VNC_tbars_scale-5.resampled.500k.bin.surf')

usethis::use_data(JRCFIBVNC2020MNP.surf, overwrite = TRUE)

# alias - easiest way just to make a copy sadly
MANC.surf <- JRCFIBVNC2020MNP.surf
usethis::use_data(MANC.surf, overwrite = TRUE)
