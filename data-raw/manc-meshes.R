# see
# https://flyconnectome.slack.com/archives/C01AETN5W15/p1675441690566929
u2="https://clio-ng.janelia.org/#!gs://flyem-user-links/short/2023-08-01.060515.json"
nsc=fafbseg::ngl_decode_scene(flyem_expand_url(u2))
nsc$layers$`nerves-202301`

neuprintr::neuprint_ROI_mesh("PrN(L)", conn=manc_neuprint())
neuprintr::neuprint_ROI_hierarchy(conn = manc_neuprint())

nsc$layers$`nerves-202301` %>% dput

rois=neuprintr::neuprint_ROIs(conn = manc_neuprint())
nerve.rois=grep("N[1-4]{0,1}(T|[(LR)]{0,})$", rois, value = T)

library(nat)
nerve.meshes=nlapply(nerve.rois, neuprintr::neuprint_ROI_mesh, conn=manc_neuprint())
names(nerve.meshes)=nerve.rois

# test but not used in the end
nerve.meshes.simp <- nlapply(nerve.meshes, function(x) {
 nrvmesh.simp <- Rvcg::vcgQEdecim(x, percent = 0.2)
 nrvmesh.simp = addNormals(nrvmesh.simp)
 nrvmesh.simp
})

# MANC.nerves=do.call(c, mapply(as.hxsurf, nerve.meshes,region=nerve.rois, SIMPLIFY = F))*8/1000

cols=readr::read_table(file="
Region Colour
AbN1(L)   #7300FF
AbN1(R)   #9900FF
AbN2(L)   #00FF73
AbN2(R)   #00FFB3
AbN3(L)   #00B3A2
AbN3(R)   #009980
AbN4(L)   #FF6300
AbN4(R)   #FF9400
AbNT      #D600FF
ADMN(L)   #00CC60
ADMN(R)   #009933
CvN(L)    #FF00A0
CvN(R)    #FF0080
DMetaN(L) #FF4500
DMetaN(R) #FF2200
DProN(L)  #a7faf7
DProN(R)  #bff5f3
MesoAN(L) #0084ff
MesoAN(R) #0095ff
MesoLN(L) #52FF00
MesoLN(R) #21FF00
MetaLN(L) #faed05
MetaLN(R) #fff830
PDMN(L)   #FFBB00
PDMN(R)   #FFDD00
PrN(L)    #0e0114
PrN(R)    #09020d
ProAN(L)  #BBAA00
ProAN(R)  #998800
ProCN(L)  #f788f2
ProCN(R)  #f274ec
ProLN(L)  #FF0000
ProLN(R)  #CC0000
VProN(L)  #10FF00
VProN(R)  #00CC00")

MANC.nerves=do.call(c, mapply(as.hxsurf, nerve.meshes[cols$Region],region=cols$Region,col=cols$Colour, SIMPLIFY = F))*8/1000
usethis::use_data(MANC.nerves, internal = F, version = 2, overwrite = T)
