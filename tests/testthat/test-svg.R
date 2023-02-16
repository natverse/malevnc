test_that("multiplication works", {
  pal=c(`Tergopleural-Pleural-promotor` = "#2280B8", `Pleural-remotor-abductor` = "#7B2DBA",
       Tergotr. = "#EFE952", Sternotrochanter = "#CCF750", `Sternal-posterior-rotator` = "#AE22BA",
       `Sternal-anterior-rotator` = "#33C0D0", `Sternal-adductor` = "#145E67",
       `Tr-extensor` = "#FAA400", `Tr-flexor` = "#311EE2", `Fe-reductor` = "#F82401",
       `Ti-extensor` = "#FBC700", `Ti-flexor` = "#3456E2", LTM = "#F0EAA3",
       `Ti-acc.-flexor` = "#22944D", `Tr-reductor` = "#2CB54D", LTM1 = "#F0EAA3",
       `Ta-extensor` = "#397EE2", `Ta-flexor` = "#FCC87E")
  expect_equivalent(leg_muscle_palette(), pal)
  pal[]='white'
  pal['Fe-reductor']='red'
  tf <- tempfile('Fe-reductor', fileext = '.svg')
  on.exit(unlink(tf))
  expect_silent(colour_leg_muscles(f=tf, colpal=pal))
  skip_if_not_installed('digest')
  expect_equal(digest::digest(file = tf), 'c4ea382ca385c24f8e83c8ce27b3588b')
})
