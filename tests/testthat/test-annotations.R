context("annotations")

test_that("manc_meta", {
  res <- manc_meta('Giant Fiber')
  expect_true(is.data.frame(res))
  expect_true("dvid_group" %in% colnames(res))
  expect_true("hemilineage" %in% colnames(res))
})
