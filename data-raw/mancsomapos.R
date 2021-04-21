mancsomapos.orig=read.csv('data-raw/dd51_sphere_annotations_21-02-12.csv')

mancsomapos=mancsomapos.orig[c("X", "kind", "from", "to", "comment")]
colnames(mancsomapos)[1]="n"
mancsomapos[,c("X","Y","Z")] <- xyzmatrix(mancsomapos.orig$mid_point)

mancsomapos=mancsomapos[c("n", "X",'Y', 'Z', "kind", "from", "to", "comment")]
usethis::use_data(mancsomapos, overwrite = T)
