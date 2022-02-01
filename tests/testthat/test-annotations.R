context("annotations")

test_that("manc_meta", {
  skip_if(inherits(try(clio_token(), silent = T), 'try-error'),
          message = "no clio token available")
  res <- manc_meta('Giant Fiber')
  expect_true(is.data.frame(res))
  expect_true("dvid_group" %in% colnames(res))
  expect_true("hemilineage" %in% colnames(res))

  expect_true(is.data.frame(res2 <- manc_meta(2200014)))
  expect_true(is.na(res2$dvid_status))
})
