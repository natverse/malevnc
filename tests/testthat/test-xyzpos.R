test_that("manc_xyz2bodyid works", {
  skip_if_not(nzchar(Sys.which('curl')))
  expect_equal(manc_xyz2bodyid(c(24581, 35523, 62688)), 10000L)
})
