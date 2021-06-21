test_that("somapos works", {
  skip_if_offline()
  expect_silent(res <- manc_nearest_soma(cbind(20540, 18544, 1968), details = TRUE))
  expect_equal(res$bodyid, 23279)
  expect_equal(manc_somapos(ids = 23279, details = T), res)
})
